function  out = syn2act( varargin )
%syn2act.m constructs muscle activation episodes from synergies and scaling
%coefficients
%varargin{1} is the cell array containing the muscle synergies that wil be
%used as the basis to construct muscle activation episodes.
%varargin{2} will be the vector C of scaling coefficients for each synergy,
%for each episode
%varargin{3} will be the vector T_d of time coefficients for each synergy,
%for each episode

syns = varargin{1}; % cell array containing the synergies
nsyn = length(syns); % number of synergies
M = size(syns{1},1); % # of muscles in a synergy
%tsyn = size(syns{1}{1},2); % length in time of a synergy

C = varargin{2};
    
N = size(C,1); % number of rows in C is the number of episodes to be constructed
out = cell(N,1); % one cell array for each episode

T_d = varargin{3}; % time delays for each synergy (columns) for each episode (rows)

for a = 1:N % for each episode
    out{a} = cell(M,1);
    % each episode is a cell array of muscle activations, and we'll
    % remember what the shift of that episode is.
    for b = 1:M % for each muscle
        % preallocate the muscle contributions
        contributions = cell(nsyn,1);
        for c = 1:nsyn % add the contribution of each synergy to that muscle
            if T_d(a,c) >= 0
                convwith = conv_term(C(a,c), T_d(a,c)); % get the term to convolve with
                % The contribution of synergy c to muscle b in this episode is
                % scaled by C(a,c) and convoluted with the delay vector
                contributions{c} = conv(convwith,syns{c}{b});
            else
                try
                contributions{c} = C(a,c).*syns{c}{b}((-T_d(a,c)+1):end);
                catch
                contributions{c} = 0.*syns{c}{b};    
                end
            end
        end
        % next we need to pad all contributions to the same length
        c_len = cellfun(@length, contributions); % how long is each contribution
        c_len = abs(c_len-max(c_len)); % how much zero padding each contribution needs
        for d = 1:nsyn
            if c_len(d) ~= 0
                contributions{d} = [contributions{d}, zeros(1, c_len(d))];
            end
        end
        cont_array = cell2mat(contributions); % concatenate results
        out{a}{b,1} = sum(cont_array);
    end
end

end
