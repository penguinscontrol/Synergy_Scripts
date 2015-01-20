function [err_s, rec_out] = reconstruction_error( varargin )
%reconstruction_error.m
episode = varargin{1};
synergies = varargin{2};
c_sca = varargin{3};
t_del = varargin{4};

if nargout == 2
    getting_reconstructions = 1;
else
    getting_reconstructions = 0;
end

err_s = 0;
reconstructed = syn2act( synergies, c_sca, t_del);
reconstructed = reconstructed{1};

if getting_reconstructions
    rec_out = reconstructed;
else
    rec_out = 0;
end

for b = 1:length(episode) % counts muscles
    reconstructed{b} = match_to(reconstructed{b}, episode{b});
    err_s = err_s + norm(episode{b}-reconstructed{b}); % two-norm of difference
end
end