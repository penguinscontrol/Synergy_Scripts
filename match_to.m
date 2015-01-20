function out = match_to( in, comp )
%match_to Summary of this function goes here
%   Detailed explanation goes here
len_diff = length(in) - length(comp);
                % do we need to resize either vector?
                if len_diff > 0
                    out = in(1:length(comp));
                elseif len_diff < 0
                    out = [in, zeros(1, abs(len_diff))];
                else
                    out = in;
                end
end