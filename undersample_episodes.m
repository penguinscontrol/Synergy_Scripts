function [ subsampled ] = undersample_episodes( varargin )
%UNTITLED Summary of this function goes here

eps = varargin{1}; % set of observed episodes
dt = varargin{2};

N_eps = length(eps); % Number of episodes

M = size(eps{1},1);
% # of muscles in each synergy, must match # of muscle in each episode
subsampled = cell(N_eps,1);

for s = 1:N_eps
    subsampled{s} = cell(M,1);
    for b = 1:M
        subsampled{s}{b} = eps{s}{b}(1:dt:end);
    end
end

end

