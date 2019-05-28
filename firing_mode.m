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
%% find event info to clusterize 
time = data.frameTimes;
period = data.framePeriod;
events_space = [];
for neuron = 1:data.numero_neuronas
    events = find_events(data.C_df(neuron,:),period);
    [peak_amp,rise_time,decay_time,AUC_event] = event_analysis(data.C_df(neuron,:),events,period);
    events_space = [events_space; peak_amp,rise_time,decay_time,AUC_event];
    clear peak_amp rise_time decay_time AUC_event events
end
%% find increase calcium intensity periods
All_inc = [];
All_inc_time = [];
for neuron = 1:data.numero_neuronas
    [increments_time,increments_value] = find_increments(data.C_df(neuron,:),period);
    All_inc = [All_inc ; increments_value];
    All_inc_time = [All_inc_time ; increments_time];
end

%% find EVERY peak info to cluster
peaks_space = [];
for neuron = 1:data.numero_neuronas
    events = find_events(data.C_df(neuron,:),period);
    [peak_amp,rise_time,decay_time,AUC_peak] = peak_analysis(data.C_df(neuron,:),events,period);
    peaks_space = [peaks_space ; peak_amp,rise_time,decay_time,AUC_peak];
end
%% Clustering
kmeans_analysis(peaks_space,2)
kmeans_analysis(events_space,3)
hierarchical_clustering(peaks_space,4)
hierarchical_clustering(events_space,4)

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
events.n_peaks = length(events.peaks.value);
end

function [peak_amp,rise_time,decay_time,AUC_event] = event_analysis(cal_trace,events,period)

n = events.n_events;
time = (0:length(cal_trace)-1)*period;
peak_amp = zeros(n,1);
rise_time = zeros(n,1);
decay_time = zeros(n,1);
AUC_event = zeros(n,1);

for i = 1:n
    init = round(events.valleys.time(events.event_init(i))/period);
    fin = round(events.valleys.time(events.event_end(i))/period);
    [peak_amp(i),idx] = max(cal_trace(init:fin));
    
    rise_time(i) = (idx-1)*period;
    
    decay_time(i) = (fin-init)*period - rise_time(i);
    
    AUC_event(i) = trapz(time(init:fin),cal_trace(init:fin));
end
end

function [peak_amp,rise_time,decay_time,AUC_peak] = peak_analysis(cal_trace,events,period)

n = events.n_peaks;
time = (0:length(cal_trace)-1)*period;
peak_amp = zeros(n,1);
rise_time = zeros(n,1);
decay_time = zeros(n,1);
AUC_peak = zeros(n,1);

for i = 1:n
    init_val = find(events.valleys.time < events.peaks.time(i),1,'last');
    end_val  = find(events.valleys.time > events.peaks.time(i),1);
    
    if ~isempty(init_val) && ~isempty(end_val)
        peak_amp(i) = events.peaks.value(i)-events.valleys.value(init_val);
        
        rise_time(i) = events.peaks.time(i)-events.valleys.time(init_val);
        
        decay_time(i) = events.valleys.time(end_val)-events.peaks.time(i);
        
        AUC_peak(i) = trapz(time(round(events.valleys.time(init_val)/period:events.valleys.time(end_val)/period)),cal_trace(round(events.valleys.time(init_val)/period:events.valleys.time(end_val)/period)));
    end
end
peak_amp(peak_amp==0)     = [];
rise_time(rise_time==0)   = [];
decay_time(decay_time==0) = [];
AUC_peak(AUC_peak==0)     = [];
end

function [increments_time,increments_value] = find_increments(trace,period)
% This function finds the increment in calcium signal for each period of
% increasing intensity.
delta_intensity = diff(trace);
increments_time = (find(delta_intensity>0)*period)';
increments_value = delta_intensity(delta_intensity>0)';

end

function [] = kmeans_analysis(data,k,plot_variables)
var_names = {'Peak amplitud','Rise Time', 'Decay Time','AUC'};
if exist('plot_variables','var')
    plot_idx = plot_variables;
else
    plot_idx = [1 2 3];
end
[idx,C_p,sumd] = kmeans(data,k);
figure()
hold on
for i = 1:k
    plot3(data(idx==i,plot_idx(1)),data(idx==i,plot_idx(2)),data(idx==i,plot_idx(3)),'.')
end
plot3(C_p(:,1),C_p(:,2),C_p(:,3),'ko');
plot3(C_p(:,1),C_p(:,2),C_p(:,3),'kx');
xlabel(var_names{plot_idx(1)});
ylabel(var_names{plot_idx(2)});
zlabel(var_names{plot_idx(3)});
view(-137,10);
grid on

figure()
[silh2,h] = silhouette(data,idx,'sqEuclidean');

sprintf(['Mean Silhouette coefficient','\n Group 1\t',num2str(mean(silh2(idx==1))),'\t n = ',num2str(sum(idx==1)),'\n Group 2\t',num2str(mean(silh2(idx==2))),...
    '\t n = ',num2str(sum(idx==2)),'\n Total \t',num2str(mean(silh2))])


end

function [] = hierarchical_clustering(data,ncut_clust,plot_variables)
var_names = {'Peak amplitud','Rise Time', 'Decay Time','AUC'};
if exist('plot_variables','var')
    plot_idx = plot_variables;
else
    plot_idx = [1 2 3];
end

clustTreeEuc = linkage(data,'average');
ptsymb = {'bs','r^','md','go','c+'};

figure()
if exist('ncut_clust','var')
    [h,nodes] = dendrogram(clustTreeEuc,ncut_clust);
else
    [h,nodes] = dendrogram(clustTreeEuc,0);
end
h_gca = gca;
h_gca.TickDir = 'out';
h_gca.TickLength = [.002 0];

cutoff = h_gca.YLim(1);

figure()
hidx = cluster(clustTreeEuc,'criterion','distance','cutoff',cutoff);
for i = 1:5
    clust = find(hidx==i);
    plot3(data(clust,plot_idx(1)),data(clust,plot_idx(2)),data(clust,plot_idx(3)),ptsymb{i});
    hold on
end
hold off
xlabel(var_names{plot_idx(1)});
ylabel(var_names{plot_idx(2)});
zlabel(var_names{plot_idx(3)});
view(-137,10);
grid on
end
    