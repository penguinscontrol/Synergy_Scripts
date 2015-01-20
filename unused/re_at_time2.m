function out = re_at_time2(coordinate, target, participation, c_sca, synergies)
% re_at_time.m Reconstruction Error at time t. 
% finds the values of the episodes at times
% affected by each synergy, and scales it down by c_sca
out = 0;
N_eps = size(target, 1);
N = size(c_sca,2);
len = length(coordinate);
M = len/N;

rec_target = zeros(1, len);

for s = 1:N_eps
    c = 1;
    for ii = 1:N
        for b = 1:M
            rec_target(c) = sum_participants(...
                participation{s,ii}, b, synergies, coordinate, t, c_sca(s,:));
            % this is wrong. it needs to take all synergy contributions
            % into account
            c = c+1;
        end
    end
    out = out + norm(target(s,:)-rec_target);
end

end