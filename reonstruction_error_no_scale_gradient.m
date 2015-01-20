function Err = reonstruction_error_no_scale_gradient(varargin)
%reconstruction_error.m
% Err is the current error
% dErrdSca is the gradient of the error with respect to the scaling vector
% Rec is the reconstruction that gives you this error
episode = varargin{1};
synergies = varargin{2};
N = length(synergies);
M = length(synergies{1});
T = length(synergies{1}{1});
% minFunc wants columns of parameter, my scripts have rows... correct here
c_sca = varargin{3};
c_sca = c_sca';
t_del = varargin{4};

Err =  reconstruction_error(episode,...
            synergies, c_sca, t_del);
end