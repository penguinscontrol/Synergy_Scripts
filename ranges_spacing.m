function [ranges, spacing] = ranges_spacing(parameter)
    ranges = (-0.1:0.1:0.1).*max(parameter,1);
    spacing = 0.1.*max(parameter,1);
end