% Collect data into a cell array that we can run extract synergies on;
clear; clc;
types = {'BACK11';'BACK16';'BACK32';'BACK48';'BIP11';'BIP16';'BIP24';'BIP32';...
    'BIP40';'BIP48';'CORR';'CURV';'CURV_B';'LADE';'LADH';'TRM16';...
    'TRM24';'TRM32';'TRM40';'TRM48';'TRM64'}; % All types of trial to get data from

% filenames = {'C:\Users\Radu\Google Drive\CSP\Array Data\Array_Q19_20131126.mat';...
%     'C:\Users\Radu\Google Drive\CSP\Array Data\Array_Q19_20131124.mat'};
filenames = {'C:\Users\Radu\Google Drive\CSP\Array Data\Array_Q19_20131126.mat'};
% Files to get data from

alldata = {[] []};
for a = 1:length(filenames)
    for b = 1:length(types)
        data = getdata(filenames{a},types{b});
        labels = repmat(types(b), [length(data), 1]);
        data_and_labels = [data labels];
        alldata = [alldata; data_and_labels];
    end
end

alldata(1,:) = [];

eps = alldata(:,1)';