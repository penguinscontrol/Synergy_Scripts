function flat = flatten_synergies( synergies)
%flatten_synergies generates a 1D vector containing a list of all synergy
%content
N = length(synergies);
M = length(synergies{1});

flat = [];
for ii = 1:N
    for b = 1:M
            flat = [flat; synergies{ii}{b}'];
    end
end

end

