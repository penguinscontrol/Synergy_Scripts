function rec_err = re_at_time4(ranges, which_mus, eps, which_t, ...
                curr_rec_err, ...
                curr_reconstruction,c_sca, t_del)

    N_eps = size(t_del,1);
    N_elem = length(ranges);
    delta_reconstruction = c_sca*ranges;
    affected_times = t_del+which_t;
    rec_err = ones(1,N_elem).*curr_rec_err.^2;
    for s = 1:N_eps
        try
        cur_target = eps{s}{which_mus}(affected_times(s));
        cur_reconstruction_at_t = ...
            curr_reconstruction{s}{which_mus}(affected_times(s));
        old_error = (cur_target - cur_reconstruction_at_t).^2;
        new_error = (delta_reconstruction(s,:) - cur_reconstruction_at_t ...
            + cur_target ).^2;
        rec_err = rec_err + new_error - old_error;
        catch
            %disp('Fell out of bounds.');
        end
    end
    rec_err = sqrt(rec_err);
end