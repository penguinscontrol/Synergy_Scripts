function flat = flatten_synergies_time( synergies , timepoint)
%flatten_synergies generates a 1D vector containing a list of all synergy
%content

N = length(synergies);
M = length(synergies{1});

flat = zeros(1,M,N);
count = 1;
for a = 1:N
    for b = 1:M
            flat(b,a) = synergies{a}{b}(timepoint);
            count = count+1;
    end
end
end

