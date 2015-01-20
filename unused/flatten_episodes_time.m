function out = flatten_episodes_time( episodes, t, c_sca, t_del, param_space )
% flatten_episodes_time.m finds the values of the episodes at times
% affected by each synergy, and scales it down by c_sca
N_eps = length(episodes);
M = length(episodes{1});
N = size(c_sca, 2);
out = zeros(N_eps, N*M);

for s = 1:N_eps
    count = 1;
    for ii = 1:N
        for b = 1:M
            try
                % Normally, here's the target
                out(s,count) = episodes{s}{b}(t_del(s,ii)+t);
            catch
                % if we fall out of bounds, this parameter doesn't matter.
                % Make its contribution to the error be zero.
                out(s,count) = param_space(count).*c_sca(s,ii);
            end
            count = count+1;
        end
    end
end

end