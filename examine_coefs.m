function [ output_args ] = examine_coefs( solution )
%examine_coefs.m visualizes solution
%   Detailed explanation goes here

if nargin == 0
    solution = '20150203_Q21_ALL_3SYN';
end

% Load solution .mat file
load(solution);

ha = rfig();
hb = rfig();
for a = 1:size(comp_c_sca,2)
    figure(ha);
    subplot(size(comp_c_sca,2), 1, a);
    histogram(comp_c_sca(:,a),100);
    xlabel(sprintf('Scale for synergy %d', a));
    ylabel('count');
    
    figure(hb);
    subplot(size(comp_c_sca,2), 1, a);
    histogram(comp_t_del(:,a),100);
    xlabel(sprintf('Delay for synergy %d', a));
    ylabel('count');
    
end
end