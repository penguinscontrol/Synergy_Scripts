function  [out, c_sca, t_del] = syn2act_rand( varargin )
%syn2act.m constructs example muscle activation episodes from synergies

%varargin{1} is the cell array containing the muscle synergies that wil be
%used as the basis to construct example muscle activation episodes.
%varargin{2} will be the length in time, T, of the muscle activation
%episodes. T should be longer than the length of a synergy. varargin{3} is
%N , the number of episodes to construct;

syns = varargin{1}; % cell array containing the synergies
nsyn = length(syns); % number of synergies

M = size(syns{1},1); % # of muscles in a synergy
tsyn = size(syns{1}{1},2); % length in time of a synergy

T = varargin{2}; % length of an episode
N = varargin{3}; % number of episodes to construct
while T < tsyn
    T = input(sprintf('Please input a time length longer than %d\n', tsyn));
end

c_sca = 10.*rand(N,nsyn); % scaling coefficients for each synergy
t_del = round(-tsyn./2+T.*rand(N,nsyn)); % time delay coefficients for each synergy
shift = min(t_del,[],2);
for a = 1:N % for each episode
    t_del(a,:) = t_del(a,:) - shift(a); % shift the delay to the minimal delay
end
out = syn2act(syns, c_sca, t_del);

end
