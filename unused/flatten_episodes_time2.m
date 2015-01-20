function target = flatten_episodes_time2( episodes, t, c_sca, t_del, synergies, parameter_space, participation )
% flatten_episodes_time2.m finds the values of the episodes at times
% affected by each synergy.
N_eps = length(episodes);
M = length(episodes{1});
N = size(c_sca, 2);

offsets = t_del+t;
target = zeros(N_eps, N*M);
for s = 1:N_eps
    count = 1;
    for ii = 1:N % ii is the current synergy
        for b = 1:M % b is the current muscle
            try
                % Normally, here's the targets
                target(s,count) = episodes{s}{b}(offsets(s,ii));
            catch
                % if we fall out of bounds, this parameter doesn't matter.
                % Make its contribution to the error be zero.
                % target(s,count) = param_space(count).*c_sca(s,ii);
                target(s,count) = sum_participants(...
                    participation{s,ii}, b, synergies,...
                    parameter_space, t, c_sca(s,:));
            end
            count = count+1;
        end
    end
end


end