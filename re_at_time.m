function rec_err = re_at_time(ranges, which_mus, eps, which_t, ...
                curr_rec_err, ...
                curr_reconstruction,c_sca, t_del)
% Returns the reconstruction error if the amplitude of the selected
% synergy, at the specified muscle and time point, changes to any of the
% values in ranges.

    N_eps = size(t_del,1); % how many episodes in total?
    N_elem = length(ranges); % at how many points are we computing the new error
    delta_reconstruction = c_sca*ranges; % by how much is the reconstruction changing
    affected_times = t_del+which_t; % where in the episode will the effect 
    % of changing this timepoint of the synergy be seen
    
    %rec_err = ones(1,N_elem).*curr_rec_err.^2;
    rec_err = zeros(1,N_elem);
    
    for s = 1:N_eps
        try
        cur_target = eps{s}{which_mus}(affected_times(s));
        cur_reconstruction_at_t = ...
            curr_reconstruction{s}{which_mus}(affected_times(s));
        new_error = (delta_reconstruction(s,:) - cur_reconstruction_at_t ...
            + cur_target ).^2;
        rec_err = rec_err + new_error;
        catch
            %disp('Fell out of bounds.');
        end
    end
    rec_err = sqrt(rec_err - rec_err(floor(N_elem/2)+1) + curr_rec_err.^2);
end