function total_error = tot_reconstruction_error( varargin )
%tot_reconstruction_error gives the total recosntruction error by summing
%reconstruction errors across episodes
episodes = varargin{1};
synergies = varargin{2};
c_sca = varargin{3};
t_del = varargin{4};

total_error = 0;

for s = 1:length(episodes)
    total_error = total_error + reconstruction_error(episodes{s},...
        synergies, c_sca(s,:), t_del(s,:));
end
end
