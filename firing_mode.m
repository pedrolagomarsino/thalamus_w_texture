%%% Analysis to see if we find bursting and/or tonic like activity in
%%% calcium data 
% Tommaso idea
% Measure for each cell (DF/F)
    % a) Peak amplitud
    % b) Rise time
    % c) Decay time
    % d) AUC ?
% search for clusters in this four dimensional space
%load('C:\Users\plagomarsino\work\Thalamus_proyect\Whisking on Texture\Data\20180412\Mouse_2314\TSeries-04122018-0853-1003\Post_proc_2\TS1003_C_no_stim_times.mat');
%% find peaks and valleys to define a with of event
period = data.framePeriod;
events_space = [];
for neuron = 1:data.numero_neuronas
    events = find_events(data.C_df(neuron,:),period);
    [peak_amp,rise_time,decay_time,AUC_event] = event_analysis(data.C_df(neuron,:),events,period);
    events_space = [events_space; peak_amp,rise_time,decay_time,AUC_event];
end
    %% plot
% figure
% subplot(2,1,1)
% hold on
% xlim([time(1) time(end)])
% ylim([min(data.C_df(neuron,:)) max(data.C_df(neuron,:))])
% plot(time,data.C_df(neuron,:))
% subplot(2,1,2)
% hold on
% xlim([time(1) time(end)])
% 
% 
% subplot(212)
% ylim([min(data.C_df(neuron,:)) max(data.C_df(neuron,:))])
% plot(time,data.C_df(neuron,:))
% plot(events.peaks.time,events.peaks.value, '*')
% plot(events.valleys.time(events.event_init),events.valleys.value(events.event_init), '*','markersize',10)
% plot(events.valleys.time(events.event_end),events.valleys.value(events.event_end), '*')
% 
% subplot(211)
% plot(events.peaks.time,events.peaks.value, '*')
% plot(events.valleys.time,events.valleys.value,'*')
% plot([time(1) time(end)], [std(data.C_df(neuron,:)) std(data.C_df(neuron,:))])

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

function events = find_events(trace,period)
% Find events in paninski processed calcium traces.
% Events are defined as calcium activity between the first valley
% preceding a peak, and the next valley whos value (Df/F) is at most half
% the intensity difference between the peak and the valley. 
%
% Obs: whit this definition each event can contain several other peaks and
% valleys, and the half amplitud constrain is not necesary between the
% highest peak and the lowest valley in the event. 
%--------------------------------------------------------------------------
% INPUTS
% trace = 1 neuron calcium trace processed as paninski: data.C_df in
%           Monica's code. 
% period = period of sampling. data.framePeriod in Monica's code
%--------------------------------------------------------------------------
% OUTPUTS
% find_events returns "events" a struct array containing fields:
%   peaks: all peaks above one std of the trace
%       value: array of the DF/F value of peaks 
%       time: array of time in seconds of each peak in peaks
%   valleys: all valleys
%       value: array of the DF/F value of valleys 
%       time: array of time in seconds of each valley in valleys 
%    
%   rise_init: array of valleys-indexes with starting valleys of events 
%   decay_indx: array of valleys-indexes with ending valleys of events
%   n_events: number of events detected
events = struct();
% findpeaks
[peaks,indx] = findpeaks(trace);
peaksbig = peaks(peaks>std(trace));
indxbig = indx(peaks>std(trace));
% find valleys
[valley,indxval] = findpeaks(-trace);
rise_valley_indx = [];
decay_valley_indx = [];
for i = 1:length(peaksbig)
    rise_valley_indx = [rise_valley_indx , find(indxval<indxbig(i),1,'last')];
    if (isempty(decay_valley_indx) || indxbig(i)>=indxval(decay_valley_indx(end))) && ~isempty(rise_valley_indx)
        decay_indx = find(indxval>indxval(rise_valley_indx(end)) & -valley<=(peaksbig(i)-.5*(peaksbig(i)+valley(rise_valley_indx(end)))),1);
        decay_valley_indx = [decay_valley_indx ,decay_indx ];
    end
end

rise_events = rise_valley_indx(1);
for i = 2:length(decay_valley_indx)
    rise_events = [rise_events , rise_valley_indx(find(rise_valley_indx<decay_valley_indx(i) & rise_valley_indx>=decay_valley_indx(i-1),1)) ];
end

events.peaks.value = peaksbig;
events.peaks.time = indxbig*period;
events.valleys.value = -valley;
events.valleys.time = indxval*period;
events.event_init = rise_events;
events.event_end = decay_valley_indx;
events.n_events = length(events.event_init);
end

function [peak_amp,rise_time,decay_time,AUC_event] = event_analysis(trace,events,period)

n = events.n_events;
time = (1:length(trace))*period;
peak_amp = zeros(n,1);
rise_time = zeros(n,1);
decay_time = zeros(n,1);
AUC_event = zeros(n,1);

for i = 1:n
    init = round(events.valleys.time(events.event_init(i))/period);
    fin = round(events.valleys.time(events.event_end(i))/period);
    [peak_amp(i),idx] = max(trace(init:fin));
    
    rise_time(i) = (idx-1)*period;
    
    decay_time(i) = (fin-init)*period - rise_time(i);
    
    AUC_event(i) = trapz(time(init:fin),trace(init:fin));
end
end
    