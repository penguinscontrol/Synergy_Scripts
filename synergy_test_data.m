clear;clc;close all;

%% Generate synergies

N = 2;
M = 3;
T = 20;
x = 0:T-1; % basis for the x axis
test_synergies = gaussian_synergies(N,M,T);

h = plot_synergy(test_synergies);
title('CG Synergies');
%% Generate test data

[test_data, c_sca, t_del] = syn2act_rand(test_synergies, 1.2*T, 50);

ep_to_plot = 1; % episode to be plotted

[h2 real_ep] = plot_episode(ep_to_plot, c_sca, t_del, test_synergies, test_data);
title('CG Episode');
%% Reconstruct synergies from test_data
fprintf('Entering compute synergies\n');pause;
N_comp_syn = 3; % Look for N_comp_syn synergies
[comp_syn, comp_c_sca, comp_t_del, save_gnorm] =...
    compute_synergies(test_data, N, T, 1000, 500);

h3 = plot_synergy(comp_syn);
title('RECONSTRUCTED Synergies');

reconstructed = syn2act(comp_syn, comp_c_sca, comp_t_del);
[h4, rec_ep] =...
    plot_episode(ep_to_plot, comp_c_sca, comp_t_del, comp_syn, reconstructed);
title('RECONSTRUCTED Episode');

figure;
semilogy(save_gnorm);
title('Reconstruction error');
xlabel('Iteration');
ylabel('RMS Error');

h5 = rfig();
for b = 1:M
    subplot(M,1,b);
    plot(real_ep{b}, 'k-','LineWidth', 3);
    hold on;
    plot(rec_ep{b}, 'r:','LineWidth', 3);
    legend('CG', 'RECONSTRUCTED');
end