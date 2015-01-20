function [ranges, spacing] = ranges_spacing(parameter)
    minstep = -0.0005;
    ranges = (-minstep:minstep:minstep).*max(parameter,1);
    spacing = minstep.*max(parameter,1);
end