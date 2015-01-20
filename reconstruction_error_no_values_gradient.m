function Err = reconstruction_error_no_values_gradient( varargin )
eps = varargin{1}; % The episodes we are optimizing fo
% The current set of synergies
c_sca = varargin{3}; % the current set of scaling coefficients
t_del = varargin{4}; % the current set of time delays
T = varargin{5}; % the length of a synergy

N_eps = length(eps);
N = size(c_sca,2);
M = length(eps{1});


synergies = unflatten_synergies(varargin{2}, M, N, T); 


curr_rec_err = 0;

for s = 1:N_eps
    [this_rec_err, ~] = reconstruction_error...
        (eps{s}, synergies, c_sca(s,:), t_del(s,:));
    
    curr_rec_err = curr_rec_err+this_rec_err;
end
Err = curr_rec_err;
end

