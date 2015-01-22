function [out, comp_c_sca, comp_t_del, save_err] = compute_synergies_matrix( varargin )
%compute_synergies.m given a set of observed episodes eps = varargin{1},
%computes the N = varargin{2} time varying synergies of length
%T = varargin{3} that best explain the observations based on an
%iterative gradient descent algorithm.
%
eps = varargin{1}; % set of observed episodes
N_eps = length(eps); % Number of episodes
T_eps = size(eps{1}{1},2); % Length (# of samples) per episode

N = varargin{2}; % # of synergies to look for
T = varargin{3}; % length of a synergy
M = size(eps{1},1);
% # of muscles in each synergy, must match # of muscle in each episode

maxFunEvals = varargin{4};
maxIter = varargin{5};
%% Preallocate synergies, delays and scaling coefficients with random
% nummbers

out = cell(N,1);
for ii = 1:N % create each synergy
    out{ii} = cell(M,1);
    for b = 1:M % fill out each muscle in the synergy
        out{ii}{b} = rand(1,T);
    end
end

c_sca = rand(N_eps,N); % scaling coefficients for each synergy
t_del = round(-T_eps./2+T_eps.*rand(N_eps,N)); % time delay coefficients for each synergy

%% Cast as matrices for the algorithm described in D'Avella 2003

M_s = cell(N_eps,1); % Episodes
M_all = [];
ep_lengths = zeros(N_eps,1);
for s = 1:N_eps
    ep_lengths(s) = length(eps{s}{1});
    M_s{s} = zeros(M,ep_lengths(s));
    for b = 1:M
        M_s{s}(b,:) = eps{s}{b};
    end
    M_all = [M_all M_s{s}];
end

W_mat = zeros(M, N*T); % Synergies
for ii = 1:N
    for b = 1:M
        W_mat(b,(ii-1)*T+1:(ii*T)) = out{ii}{b};
    end
end
%% Gradient descent algorithm

% termination tolerance
err_tol = inf;
% if error less than err_tol, stop;
derr_tol = 1e-4;
% if error not changing by more than derr_tol, stop.
% maximum number of allowed iterations
maxiterations = 40000;
miniterations = 100;
% Get first error estimate
    curr_rec_err = 0;
    for s = 1:N_eps
    [this_rec_err, ~] = ...
        reconstruction_error(eps{s}, out, c_sca(s,:), t_del(s,:));
    curr_rec_err = curr_rec_err+this_rec_err;
    end
    save_err = sqrt(curr_rec_err)./(N*M*T); % the total reconstruction error at the current point


% initialize gradient norm, optimization vector, iteration counter, perturbation
niter = 1; new_err = inf; derr = inf;
alpha = 1;
while (new_err>=err_tol && niter <= maxiterations...
        && abs(derr) > derr_tol || niter <= miniterations) 
    % continue iterating until done
    tic
    for s = 1:N_eps
        % for each episode, find good delays given synergies and scaling
        % coefficients
        this_ep = eps{s};
        for ii = 1:N
            % for each synergy
            % compute the sum of the scalar products between the s-th data
            % episode and the ii-th synergy time shifted by t.
            [phi, lags] = synergy_xcorr(this_ep, out{ii}, ep_lengths(s));
            % select the synergy and the delay that maximize cross
            maxlag = lags(phi == max(phi));
            t_del(s,ii) = maxlag(1);
            % scale and time shift the synergy, subtract it from the data
            for b = 1:M
                tdelay = conv_term(c_sca(s,ii),t_del(s,ii));
                to_subtract = conv(tdelay,out{ii}{b}); % scaled and time shifted synergy
                to_subtract = match_to(to_subtract, this_ep{b});
                this_ep{b} = this_ep{b} - to_subtract;
            end
        end
    end
    fprintf('Updated delays for iteration %d\n', niter);
    
    H_all = []; 
    for s = 1:N_eps
        
        this_h = h_mat(c_sca(s,:), t_del(s,:), N, T, ep_lengths(s));
     
        for ii = 1:N
            this_theta = theta_mat(ii, t_del(s,ii), N, T, ep_lengths(s));
            c_sca(s,ii) = alpha * c_sca(s,ii)...
                *trace( (M_s{s}') * W_mat * this_theta)...
                /trace( (this_h') *(W_mat') * W_mat * this_theta);
        end
        
        % Change H_s to reflect new scaling coeffs
        this_h = h_mat(c_sca(s,:), t_del(s,:), N, T, ep_lengths(s));

        H_all = [H_all this_h];
    end % end cycle episodes
    
    fprintf('Updated scales for iteration %d\n', niter);
    
    %% update the synergy elements by gradient descent, one value at a time
    new_W_mat = alpha *  W_mat .* ( (M_all * (H_all') ) ./ (W_mat * H_all * (H_all') ));
    
    new_out = cell(N,1);
    for ii = 1:N
        new_out{ii} = cell(M,1);
        for b = 1:M
            new_out{ii}{b} = new_W_mat(b,(ii-1)*T+1:(ii*T));
        end
    end
    
    curr_rec_err = 0;
    for s = 1:N_eps
    [this_rec_err, ~] = ...
        reconstruction_error(eps{s}, new_out, c_sca(s,:), t_del(s,:));
    curr_rec_err = curr_rec_err+this_rec_err;
    end
    new_err = sqrt(curr_rec_err)./(N*M*T); % the total reconstruction error at the current point

    
    if niter > 1
        if new_err < save_err(end) % Update if new synergies are better
            out = new_out;
            W_mat = new_W_mat;
            alpha = 1;
        % update termination metrics
        else
            fprintf('              WARNING:       new error more than old.\n');
            %out = new_out;
            %W_mat = new_W_mat;
            alpha = 1.1 * alpha;
        end
        
            derr = save_err(end) - save_err(end-1);
            
        fprintf('Error is: %4.4f\n',new_err);
        fprintf('delta error is: %4.4f\n',derr);
    else
        % First time around, you don't have an old error to compare to, nor
        % do you know what error tolerance to expect. This runs only once,
        % during the first iteration.
        out = new_out;
        W_mat = new_W_mat;
        
        err_tol = new_err;
        fprintf('Initial error is: %4.4f\n',err_tol);
        err_tol = 0.05.*err_tol;
        derr_tol = 0.001.*err_tol;
    end
    
    fprintf('Finished iteration %d\n', niter);
    
        % update error log
        save_err = [save_err new_err];
        
    niter = niter + 1;
    toc
end
comp_c_sca = c_sca;
comp_t_del = t_del;
end