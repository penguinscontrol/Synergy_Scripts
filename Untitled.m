close all;
EMG = Array.Trials(5).EMG(2);
plot(EMG.rawtime, EMG.rawdata);
hold on;

g = Array.Trials(5).Gait;
% t = Trials.EMG(1).Cyclic_Data;
% for a = 1:size(t,1)
%     for b = 1:size(t,2)
%         if isnan(t(a,b))
%             t(a,b) = 0;
%         end
%     end
% end
% plot(t(:,1), t(:,1).^0, 'ro');
plot(g(1,:), g(1,:).^0, 'ro');
plot(g(2,:), g(2,:).^0, 'bo');

figure();
plot(EMG.Data)