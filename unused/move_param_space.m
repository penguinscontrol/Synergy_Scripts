function out = move_param_space( synergies, coordinate)
%move_param_space Changes the T's element of each synergy to the new value
%in the parameter space
N = length(synergies);
M = length(synergies{1});
T = length(synergies{1}{1});
out = synergies;
count = 1;
for ii = 1:N
    for b = 1:M
        for t = 1:T
        out{ii}{b}(t) = coordinate(count);
        count = count+1;
        end
    end
end

end