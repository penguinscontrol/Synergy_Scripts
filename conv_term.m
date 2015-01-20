function tdelay = conv_term( c,t )
%conv_term.m term to convolve with for scaling and shifting

if t == 0
    tdelay = [c];
else
    tdelay = [zeros(1,t),c];
end

end