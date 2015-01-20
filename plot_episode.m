function [handle, episode] = plot_episode(ep_to_plot, c_sca, t_del, synergies, data)
handle = rfig();
N = length(synergies);
M = length(synergies{1});
ColOrd = get(gca,'ColorOrder');
% Determine the number of colors in
% the matrixf
[col_r,~] = size(ColOrd);
for a = 1:M % counts muscles
        subplot(M,1,a);
        p_vector = data{ep_to_plot}{a,1}; %muscle activiy profile
        x_axis = 0:length(p_vector)-1; % all profiles aligned by assumption
        
        plot(x_axis,p_vector, 'LineWidth', 3);
        strings = cell(N+1,1);
        strings{1} = 'EMG';
        hold all;
        for b = 1:N % plot each synergy's contribution
            p_vector = c_sca(ep_to_plot,b).*synergies{b}{a};  
            x_axis = t_del(ep_to_plot,b):(t_del(ep_to_plot,b)+length(synergies{b}{a})-1);
            
            
            % Determine which row to use in the
            % Color Order Matrix
            ColRow = rem(b+1,col_r);
            if ColRow == 0
                ColRow = col_r;
            end
            % Get the color
            Col = ColOrd(ColRow,:);
            
            plot(x_axis,p_vector,'Color',Col, 'LineWidth', 1.5);
            
            strings{b+1} = sprintf('synergy %d',b);
        end
        legend(strings);
end
episode = data{ep_to_plot};
end