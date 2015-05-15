function [ out] = rfig
% nice figure routine from NMPK

out = figure;
screenSize = get(0, 'ScreenSize');
set(out, 'position', [screenSize(3:4).*[1.7, 1]*0.1 screenSize(3:4).*[1, 1.3]*0.6]);
set(out, 'PaperPositionMode', 'auto')
end

