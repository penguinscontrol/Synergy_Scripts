function handle = plot_synergy( synergy )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
N = length(synergy);
M = length(synergy{1});
T = length(synergy{1}{1});
handle = rfig(); % bigger default axes;
x = 0:T-1; % basis for the x axis

ColOrd = get(gca,'ColorOrder');
% Determine the number of colors in
% the matrix
[col_r,~] = size(ColOrd);
for a = 1:N % a counts synergies
    % Determine which row to use in the
    % Color Order Matrix
    ColRow = rem(a,col_r)+1;
    if ColRow == 0
      ColRow = col_r;
    end
    % Get the color
    Col = ColOrd(ColRow,:);
    for b = 1:M % b counts muscles
        plot_coord = b*N-rem(a, N); % go down the column
        subplot(M,N,plot_coord); % b'th muscle
        plot(x,synergy{a}{b},'Color',Col);
    end
    
end

end

