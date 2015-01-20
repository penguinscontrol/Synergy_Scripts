function [ out ] = gaussian_synergies( varargin )
% gaussian_synergies returns N, nargin{1}, test synergies

% returns a set of test synergies to construct training data from.
% nargin{1} is N, the number of synergies to construct, nargin{2} is M,  the
% number of muscles in each synergy, nargin{3} is the length T of time
% steps in each synergy. All arguments should be integers. out is an Nx1 cell aray containing the MxT
% synergies

N = varargin{1};
M = varargin{2};
T = varargin{3};

out = cell(N,1);
for a = 1:N % a indexes the synergies
    out{a} = cell(M,1);
    for b = 1:M % b indexes the muscles
        sigma = (T./6).*rand(1);
        mu = 2*sigma+(T-4*sigma).*rand(1);
        out{a}{b} = normpdf(0:T-1,mu,sigma);
        %optional: scale all of them to the same amplitude
        maxval = max(out{a}{b,:});
        out{a}{b,:} = out{a}{b,:}./maxval;
    end
end

end
