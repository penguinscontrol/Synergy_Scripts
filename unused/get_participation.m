function participation = get_participation(t_del, T, N_eps, T_ep)
% returns the synergies that are part of the reconstruction for this.
participation = cell(N_eps, T_ep);
for s = 1:N_eps
    for b = 1:T_ep
        % b is the current time point into the episode
        % t_del(s,:) are the delays applied to each synergy for this
        % episode
        these_delays = t_del(s,:);
        mask1 = (these_delays-(b-1))<=0;
        mask2 = (these_delays-(b-1)+T)>0;
        participation{s,b} = find( mask1 & mask2);
    end
end
end