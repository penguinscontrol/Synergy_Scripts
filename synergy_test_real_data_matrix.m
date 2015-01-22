clear;clc;close all;
load('real_data_4.mat');
M = length(all{1});
N_comp_syn = 3; % Look for N_comp_syn synergies
ep_to_plot = 5;
T = 30;
to_proc = undersample_episodes(all, 60);
[comp_syn, comp_c_sca, comp_t_del, save_gnorm]...
    = compute_synergies_matrix(to_proc, N_comp_syn, T, 1000, 500);


%%
diary(date);
h3 = plot_synergy(comp_syn);
title('RECONSTRUCTED Synergies');

reconstructed = syn2act(comp_syn, comp_c_sca, comp_t_del);
[h4, rec_ep] = ...
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
    plot(to_proc{ep_to_plot}{b}, 'k-','LineWidth', 3);
    hold on;
    plot(rec_ep{b}, 'r:','LineWidth', 3);
    legend('CG', 'RECONSTRUCTED');
end
diary off;