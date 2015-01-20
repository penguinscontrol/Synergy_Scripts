function eps = getdata(file_loc, str)

load(file_loc);
%%
Type = {Array.Trials.Type}.';
N_eps = length(Array.Trials);
M = length(Array.Trials(1).EMG);

%data = cell(N_eps,1);
%procdata = cell(N_eps,1);
rawtime = {Array.Trials(1).EMG(1).rawtime}.';
rawtime = rawtime{:};
                
dt = mean(diff(rawtime));
%Fs = dt.^(-1);
%fc = 10;
Wn = 1e-5;
den = fir1(100,Wn, 'low');
num = 1;
%[den,num]=butter(5,Wn,'low');%butterworth Filter of 2 poles and Wn=0.1
count = 1;
durations = [];
for s = 1:N_eps
    if strcmp(Type{s}(1:3),str)
        g = Array.Trials(s).Gait; % Gait points
        g = g(1,:);
        g = g(~isnan(g));
        for a = 1:length(g)-1
            data{count} = cell(M,1);
            for b = 1:M
                rawtime = {Array.Trials(s).EMG(b).rawtime}.';
                rawtime = rawtime{:};
                rawdata = {Array.Trials(s).EMG(b).rawdata}.';
                rawdata = rawdata{:};
                rawdata = rawdata(rawtime > g(a) & rawtime < g(a+1));
                                
                %figure();
                %plot(rawdata); hold on;
                rawdata = 2.*rawdata.*rawdata;
                y_sq = filter(den,num,rawdata); %applying LPF
                y_sq = flipud(y_sq);
                y_sq = filter(den,num,y_sq); %applying LPF
                y_sq = flipud(y_sq);
                data{count}{b} = abs(sqrt(y_sq))';
                %plot(data{count}{b});
            end % end cycle muscles
            durations(count) = length(y_sq);
            count = count+1;
        end % end cycle swings in this trial
    end % end trial
end
%proc_eps = procdata;
longest = max(durations);
longest = longest(1);
for s = 1:length(durations)
    for b = 1:M
        len_diff = longest-length(data{s}{b});
        if len_diff > 0
            data{s}{b} = [data{s}{b}, zeros(1,len_diff)];
        end
    end    
end
eps = data';
end