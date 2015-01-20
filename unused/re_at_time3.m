function rec_err = re_at_time3(coordinate, synergies, participation,...
    episodes, t, c_sca, t_del)
    N = size(t_del,2);
    N_eps = size(t_del,1);
    M = length(episodes{1});
    T_eps = length(episodes{1}{1});
    rec_err = 0;
    
    affected_times = t_del + t;
    mask = affected_times < (T_eps+1); % do any synergies fall off map?
    
    for s = 1:N_eps
        these_times = affected_times(s,:);
        rec_target = zeros(M,N);
        rec = zeros(M,N);
        for ii = 1:N
            participants = participation{s,these_times(ii)};
            other_participants = participants(~(participants == ii));
            rec_point = zeros(M,1);
            for b = 1:M
                try
                    rec_target(b,ii) = episodes{s}{b}(these_times(ii));
                    rec_point(b) = c_sca(s,ii).*coordinate(b,ii);
                catch
                    rec_target(b,ii) = c_sca(s,ii).*coordinate(b,ii);
                    rec_point(b) = c_sca(s,ii).*coordinate(b,ii);
                end
                if ~isempty(other_participants)
                    for a = 1:length(other_participants)
                        try
                        where_this_synergy = these_times(ii)-...
                            t_del(s,other_participants(a))+1;
                        % double check the +1 above
                        
                        rec_point(b) = rec_point(b)+...
                            synergies{other_participants(a)}{b}...
                            (where_this_synergy)...
                            .*c_sca(s,other_participants(a));
                        catch
                            
                        end
                    end                    
                end
            end
            rec(:,ii) = rec_point;
        end
        rec_err = rec_err + norm(rec-rec_target);
    end
end