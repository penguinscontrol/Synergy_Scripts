function [out, comp_c_sca, comp_t_del, save_new_err] = compute_synergies( varargin )
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

c_sca = 10.*rand(N_eps,N); % scaling coefficients for each synergy
t_del = round(-T_eps./2+T_eps.*rand(N_eps,N)); % time delay coefficients for each synergy

%% Gradient descent algorithm

% termination tolerance
err_tol = inf;
% if error less than err_tol, stop;
derr_tol = 1e-4;
% if error not changing by more than derr_tol, stop.
% maximum number of allowed iterations
maxiterations = 500;
save_new_err = zeros(1, maxiterations);

% initialize gradient norm, optimization vector, iteration counter, perturbation
niter = 1; new_err = inf; derr = inf;
while (new_err>=err_tol && niter <= maxiterations && abs(derr) > derr_tol) 
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
            [phi, lags] = synergy_xcorr(this_ep, out{ii}, T_eps);
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
    
    for s = 1:N_eps
        % Max 25 gradient descents per episode for scaling coeffs
        
        options = [];
        options.display = 'none';
        options.maxFunEvals = maxFunEvals;
        options.maxIter = maxIter;
        options.numDiff = 0; % Compute the gradient inside minfunc
        options.Method = 'csd';
        %options.Display = 'full';
        %options.optTol = optTol;
        
         ftomin = @(coordinate) reconstruction_error_and_scale_gradient(...
             eps{s}, out, coordinate, t_del(s,:));
        coordinate = c_sca(s,:)';
        %new_c_sca = minFunc(ftomin,coordinate,options);
        
        % ALTERNATIVE TO minFunc
        options = optimoptions('fminunc');
        options.DerivativeCheck = 'on';
        options.GradObj = 'on';
        new_c_sca = fminunc(ftomin,coordinate,options);
        
        new_c_sca(new_c_sca < 0) = 0;        % clear the negative values
        c_sca(s,:) = new_c_sca';
    end
    fprintf('Updated scales for iteration %d\n', niter);
    %% update the synergy elements by gradient descent, one value at a time
    
    options = [];
    options.display = 'none';
    options.maxFunEvals = maxFunEvals;
    options.maxIter = maxIter;
    options.numDiff = 2;
    options.Method = 'csd';
    options.Display = 'full';
    %options.optTol = optTol;
        
    coordinate = flatten_synergies(out);
     ftomin = @(coordinate) reconstruction_error_and_values_gradient(...
         eps, coordinate, c_sca, t_del, T);
    %[new_out, new_err] = minFunc(ftomin,coordinate,options);
    
        % ALTERNATIVE TO minFunc
        options = optimoptions('fminunc');
        options.DerivativeCheck = 'on';
        options.GradObj = 'on';
        options.FinDiffType = 'central';
    [new_out, new_err] = fminunc(ftomin,coordinate,options);
    new_out(new_out < 0) = 0;
    
    % update termination metrics
    save_new_err(niter) = new_err;
    if niter > 1
        if new_err < save_new_err(niter - 1) % Update if new synergies are better
            out = unflatten_synergies(new_out, M, N, T);
        else
            fprintf('WARNING: new error more than old. Skipping assignment.\n')
        end
        derr = save_new_err(niter) - save_new_err(niter-1);
        fprintf('Error is: %4.4f\n',new_err);
        fprintf('delta error is: %4.4f\n',derr);
    else
        % First time around, you don't have an old error to compare to, nor
        % do you know what error tolerance to expect. This runs only once,
        % during the first iteration.
        out = unflatten_synergies(new_out, M, N, T);
        err_tol = new_err;
        fprintf('Initial error is: %4.4f\n',err_tol);
        err_tol = 0.1.*err_tol;
        derr_tol = 0.001.*err_tol;
    end
    
    fprintf('Finished iteration %d\n', niter);
    niter = niter + 1;
    toc
end
comp_c_sca = c_sca;
comp_t_del = t_del;
end