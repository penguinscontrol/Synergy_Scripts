function out = sum_participants(participation,...
    which_muscle, synergies, parameter_space, t, c_sca)
% sum_participants.m the param_space is a list of values from all
% synergies, all muscles, at a particular timepoint, t. Each of these
% numbers gets multiplied by the scaling factor applied to the synergy, and
% contributes to the EMG amplitude at t+t_del, where t_del is the delay
% applied to that synergy. In the rare case where two or more synergies are
% aligned, i.e. have the same t_del, two or more values in the param_space participate in creating
% the same EMG amplitude. This returns the total contribution of all
% participating synergies.

% add the contributions from other synergies that participate, not just the
% one we are investigating.
locs = participation.*which_muscle;
% got the muscle we're interested in.
out = sum(param_space(locs).*c_sca(participation));
end