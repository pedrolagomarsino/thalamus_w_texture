%%% Analysis to see if we find bursting and/or tonic like activity in
%%% calcium data 
% Tommaso idea
% Measure for each cell (DF/F)
    % a) Peak amplitud
    % b) Rise time
    % c) Decay time
    % d) AUC ?
% search for clusters in this four dimensional space
load('C:\Users\plagomarsino\work\Thalamus_proyect\Whisking on Texture\Data\20180412\Mouse_2314\TSeries-04122018-0853-1003\Post_proc_2\TS1003_C_no_stim_times.mat');
df = df_over_f(data);
peaks = find_peaks(df);

figure
hold all
plot(df(2,:))
plot(peaks(2,2),peaks(2,1),'*')

%% Example traces
time = 1:length(df(1,:));
time = time*data.framePeriod;
cells = 15:20;
figure()
for i =1:length(cells)
subplot(length(cells),1,i)
hold on
xlim([time(1) time(end)])
ylim([min(df(cells(i),:)) max(df(cells(i),:))])
plot(time,df(cells(i),:))
plot(time,data.C_df(cells(i),:))
end
%% find peaks and valleys to define a with of event
neuron = 17;
figure
subplot(2,1,1)
hold on
xlim([time(1) time(end)])
ylim([min(data.C_df(neuron,:)) max(data.C_df(neuron,:))])
plot(time,data.C_df(neuron,:))
subplot(2,1,2)
hold on
xlim([time(1) time(end)])
%ylim([min(diff(data.C_df(neuron,:))) max(diff(data.C_df(neuron,:)))])
%plot(time,[0 diff(data.C_df(neuron,:))])
% findpeaks
[peaks,indx] = findpeaks(data.C_df(neuron,:));
peaksbig = peaks(peaks>std(data.C_df(neuron,:)));
indxbig = indx(peaks>std(data.C_df(neuron,:)));
% find valleys
[valley,indxval] = findpeaks(-data.C_df(neuron,:));
rise_valley_indx = [];
decay_valley_indx = [];
for i = 1:length(peaksbig)
    rise_valley_indx = [rise_valley_indx , find(indxval<indxbig(i),1,'last')];
    decay_indx = find(indxval>indxval(rise_valley_indx(end)) & -valley<=(peaksbig(i)-.5*(peaksbig(i)+valley(rise_valley_indx(end)))),1);
    decay_valley_indx = [decay_valley_indx ,decay_indx ];
end

subplot(212)
ylim([min(data.C_df(neuron,:)) max(data.C_df(neuron,:))])
plot(time,data.C_df(neuron,:))
plot(indxbig*data.framePeriod,peaksbig, '*')
plot(indxval(rise_valley_indx)*data.framePeriod,-valley(rise_valley_indx), '*')
plot(indxval(decay_valley_indx)*data.framePeriod,-valley(decay_valley_indx), '*')

subplot(211)
plot(indx*data.framePeriod,peaks, '*')
plot(indxbig*data.framePeriod,peaksbig, '*')
plot(indxval*data.framePeriod,-valley,'*')
plot([time(1) time(end)], [std(data.C_df(neuron,:)) std(data.C_df(neuron,:))])

%%
function df_f = df_over_f(data)
% This function calculates DF/F as done in Monica's code for the Paninski
% analysis from the raw data. 
Fraw = data.Fraw;
df_f = zeros(size(Fraw));
for i = 1:data.numero_neuronas
    roi_activity = Fraw(i,:);
    baseline = mean(roi_activity(roi_activity<median(roi_activity))); %use median to compute df/f
    df0_activity = (roi_activity-baseline)./baseline;
    df_f(i,:) = df0_activity;
end
end

function peaks = find_peaks(data)
[neurons_max,peak_time] = max(data,[],2);
peaks = [neurons_max,peak_time];
end


    