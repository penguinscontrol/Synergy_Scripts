function eps = getdata(file_loc, str)
% retrieves muscle episodes from file file_loc that match the type of
% movement in string str
plotting = 1;
load(file_loc);
%%
Type = {Array.Trials.Type}.';
N_eps = length(Array.Trials);
M = length(Array.Trials(1).EMG);

rawtime = {Array.Trials(1).EMG(1).rawtime}.';
rawtime = rawtime{:};
                
dt = mean(diff(rawtime));
%Fs = dt.^(-1);
%fc = 10;
Wn = 5e-4;
den = fir1(100,Wn, 'low');
num = 1;
%[den,num]=butter(5,Wn,'low');%butterworth Filter of 2 poles and Wn=0.1
count = 1;
durations = [];
for s = 1:N_eps
    if regexp(Type{s},str)
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
                        
                if plotting
                 figure();
                 subplot(2,1,1);
                 plot(rawdata); hold on;
                end
                % one way of filtering
                sq_rawdata = 2.*rawdata.*rawdata;
                y_sq = filter(den,num,sq_rawdata); %applying LPF
                y_sq = flipud(y_sq);
                y_sq = filter(den,num,y_sq); %applying LPF
                y_sq = flipud(y_sq);
                data{count}{b} = abs(sqrt(y_sq))';
% 
%                 % Another way of filtering
%                 data{count}{b} = filter(den,num,rawdata);

                data{count}{b} = data{count}{b}./max(data{count}{b}).*max(rawdata);
                if plotting
                plot(data{count}{b});
                subplot(2,1,2);
                plot(Array.Trials(s).EMG(b).Data);
                end
            end % end cycle muscles
            durations(count) = length(y_sq);
            count = count+1;
        end % end cycle swings in this trial
    end % end trial
end
%proc_eps = procdata;
longest = max(durations);
if longest % if there's at least one matching item
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
else
    eps = [];
end
end