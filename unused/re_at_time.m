function out = re_at_time( params, target, c_sca)
% re_at_time.m Reconstruction Error at time t. 
% finds the values of the episodes at times
% affected by each synergy, and scales it down by c_sca
out = 0;
N_eps = size(target, 1);
N = size(c_sca,2);
len = length(params);
M = len/N;


scalings = [];
for s = 1:N_eps
    this_row = [];
    for ii = 1:N
        this_row = [this_row ones(1,M).*c_sca(s,ii)];
    end
    scalings = [scalings; this_row];
end

for s = 1:N_eps
    out = out + norm(target(s,:)-scalings(s,:).*params);
end

end