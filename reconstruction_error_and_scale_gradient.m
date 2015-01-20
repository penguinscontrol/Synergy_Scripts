function [Err, dErrdSca] = reconstruction_error_and_scale_gradient( varargin )
%reconstruction_error.m
% Err is the current error
% dErrdSca is the gradient of the error with respect to the scaling vector
% Rec is the reconstruction that gives you this error
episode = varargin{1};
synergies = varargin{2};
% minFunc wants columns of parameter, the scripts have rows... correct here
c_sca = varargin{3};
c_sca = c_sca';
t_del = varargin{4};

N = length(c_sca);
dErrdSca = zeros(1, length(c_sca));
for ii = 1:N % for each synergy
    [ranges, spacing] = ranges_spacing(c_sca(ii));
    Fx = zeros(1,length(ranges));
    for jj = 1:length(ranges)
        coordinate = c_sca;
        coordinate(ii) = coordinate(ii)+ranges(jj);
        [Fx(jj), ~] = reconstruction_error(episode,...
            synergies, coordinate, t_del);
    end
    Fx = sqrt(Fx);
    gr = gradient(Fx, spacing);
    dErrdSca(ii) = gr(2);
end
dErrdSca = dErrdSca';
Err = Fx(2);

end