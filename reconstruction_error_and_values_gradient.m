function [ Err, dErrdVals ] = reconstruction_error_and_values_gradient( varargin )
eps = varargin{1}; % The episodes we are optimizing for
% The current set of synergies
c_sca = varargin{3}; % the current set of scaling coefficients
t_del = varargin{4}; % the current set of time delays
T = varargin{5}; % the length of a synergy

N_eps = length(eps);
N = size(c_sca,2);
M = length(eps{1});

synergies = unflatten_synergies(varargin{2}, M, N, T); 


dErrdVals = zeros(1,M*N*T);
curr_rec_err = 0;
curr_reconstruction = cell(1, N_eps);

for s = 1:N_eps
    [this_rec_err, this_reconstruction] = ...
        reconstruction_error(eps{s}, synergies, c_sca(s,:), t_del(s,:));
    curr_reconstruction{s} = this_reconstruction;
    curr_rec_err = curr_rec_err+this_rec_err;
end
Err = sqrt(curr_rec_err); % the total reconstruction error at the current point

cnt = 1;
for ii = 1:N
    for b = 1:M
        for t = 1:T
            [ranges, spacing] = ranges_spacing(synergies{ii}{b}(t));
                        
            % calculate the error at 3 values of the current point in the
            % synergy
            Fx = re_at_time(ranges, b, eps, t, ...
                Err, ...
                curr_reconstruction,...
                c_sca(:,ii), t_del(:,ii));
            dFxdVal = gradient(Fx, spacing);
            dErrdVals(cnt) = dFxdVal(2);
            cnt = cnt + 1;
        end
    end
end

dErrdVals = dErrdVals';

end