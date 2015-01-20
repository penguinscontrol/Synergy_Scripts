function [ out ] = unflatten_synergies( flat, M, N, T )
out = cell(N,1);
count = 1;
for ii = 1:N % create each synergy
    out{ii} = cell(M,1);
    for b = 1:M % fill out each muscle in the synergy
        out{ii}{b} = flat(count:count+T-1)';
        count = count+T;
    end
end
end

