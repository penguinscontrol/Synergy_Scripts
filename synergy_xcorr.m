function [phi, lags] = synergy_xcorr( episode, synergy, max_delay)
%synergy_xcorr.m Compute the sum of the scalar products between the
% data episode and the synergy time-shifted by all values in the
% probe_delays vector, or scalar product cross-correlation at delay t,
% for all possible delays.

phi = zeros(1,2.*max_delay+1);

for b = 1:length(synergy) % count muscles
    [cor, lags] = xcorr(episode{b}, synergy{b}, max_delay);
    phi = phi+cor;
end

end