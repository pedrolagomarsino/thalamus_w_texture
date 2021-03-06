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
%load('C:\Users\plagomarsino\work\Thalamus_proyect\Whisking on Texture\Data\20180920\Mouse_3430\TSeries-09202018-0956-1194\Post_proc_2\TS1194_C_no_stim_times.mat');
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
%% Clustering and plotting 

figure('units','normalized','outerposition',[0 0 1 1])
h1 = subplot(2,3,1);
h2 = subplot(2,3,2);    
h3 = subplot(2,3,3);
h4 = subplot(2,3,4);
h5 = subplot(2,3,5);
h6 = subplot(2,3,6);
kmeans_analysis(peaks_space,2,[],[h1,h2]);
kmeans_analysis(events_space,2,[],[h4,h5])
hierarchical_clustering(peaks_space,4,[],[],h3)
hierarchical_clustering(events_space,4,[],[],h6)

%%
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
%   event_init: array of valleys-indexes with starting valleys of events 
%   event_end: array of valleys-indexes with ending valleys of events
%   n_events: number of events detected
%   n_peaks: number of peaks above threshold
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
% Calculate the values that characterize the events
%--------------------------------------------------
% INPUTS
% cal_trace = 1 neuron calcium trace processed as paninski: data.C_df in
%           Monica's code. 
% events: structure containing events info (find_events output)
% period = period of sampling. data.framePeriod in Monica's code
%--------------------------------------------------
% OUTPUTS
% peak_amp = array with the value of the highest peak in each event
% rise_time = array with the time in seconds to reach the peak_amp
% decay_time = array with the time in seconds from the peak_amp to the end of the event
% AUC_event = area under the curve of the event (trapezoid integration of the signal for the duration of the event)


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
% Same as in event analysis but for each peak above 1 std. begining and end
% are defined as the previous and following valley for each peak

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
% Finds the increment in calcium signal for each period of increasing intensity.

delta_intensity = diff(trace);
increments_time = (find(delta_intensity>0)*period)';
increments_value = delta_intensity(delta_intensity>0)';

end

function [] = kmeans_analysis(data,k,plot_variables,handles)
% Cluster data into k cluster using kmeans.
% Then do a scatter plot with the clusters in different colors in a 3D
% space and a plot with the silhouette coefficients for each measurement in
% each kluster
% ----------------------------------------------------------------------
% INPUTS
% data = m x n array of m observations in n dimensions
% k = number of clusters
% plot_variables = 1x3 array with the index of 3 of the n dimensions to 
%                  perform the plots. Default is [1 2 3]
% handles = handles to the 2 axes where to plot the figures. Default is 2
%           new figures

var_names = {'Peak amplitud','Rise Time', 'Decay Time','AUC'};
data_name = inputname(1);
if length(handles)~=2
    disp('Error: handles for 2 figures are needed')
end
if ~isempty(plot_variables)
    plot_idx = plot_variables;
else
    plot_idx = [1 2 3];
end

[idx,C_p,sumd] = kmeans(data,k);
if exist('handles','var')
    subplot(handles(1))
else
    figure()
end
hold on
plot3(C_p(:,1),C_p(:,2),C_p(:,3),'ko');
plot3(C_p(:,1),C_p(:,2),C_p(:,3),'kx');
for i = 1:k
    plot3(data(idx==i,plot_idx(1)),data(idx==i,plot_idx(2)),data(idx==i,plot_idx(3)),'.')
end

xlabel(var_names{plot_idx(1)});
ylabel(var_names{plot_idx(2)});
zlabel(var_names{plot_idx(3)});
title(data_name)
view(-137,10);
grid on
if exist('handles','var')
    subplot(handles(2))
else
    figure()
end

[silh2,~] = silhouette(data,idx,'sqEuclidean');
title(data_name)

sprintf(['Mean Silhouette coefficient','\n Group 1\t',num2str(mean(silh2(idx==1))),'\t n = ',num2str(sum(idx==1)),'\n Group 2\t',num2str(mean(silh2(idx==2))),...
    '\t n = ',num2str(sum(idx==2)),'\n Total \t',num2str(mean(silh2))])


end

function [] = hierarchical_clustering(data,ncut_clust,plot_variables,show_hierachicalplot,handle)
% Cluster data into clusters using hierarchical clusterization with the 
% function 'linkage'.
% Then do a scatter plot with the clusters in different colors in a 3D
% space.
% ----------------------------------------------------------------------
% INPUTS
% data = m x n array of m observations in n dimensions
% ncut_clust =  number of clusters to represent in plots
% plot_variables = 1x3 array with the index of 3 of the n dimensions to 
%                  perform the plots. Default is [1 2 3]
% show_hierarchialplot = if 1 shows the dendrogram 
% handles = handle to the axis where to put the scatter plot. Default is a
%           new figure
var_names = {'Peak amplitud','Rise Time', 'Decay Time','AUC'};
data_name = inputname(1);

if ~isempty(show_hierachicalplot)
    showplot = show_hierachicalplot;
else
    showplot = 0;
end

if ~isempty(plot_variables)
    plot_idx = plot_variables;
else
    plot_idx = [1 2 3];
end
% cluster the data
clustTreeEuc = linkage(data,'average');
ptsymb = {'bs','r^','md','go','c+'};
% plot the dendrogram (U conectors into clusters)
if showplot 
    figure()
else
    f = figure('visible','off');
end
if exist('ncut_clust','var')
    [h,nodes] = dendrogram(clustTreeEuc,ncut_clust);
else
    [h,nodes] = dendrogram(clustTreeEuc,0);
end
h_gca = gca;
h_gca.TickDir = 'out';
h_gca.TickLength = [.002 0];
title(data_name)

cutoff = h_gca.YLim(1); % get the cutoff for the amount of clusters that we want to plot in the scatter plot

if ~showplot
    close(f)
end
% scatter plot with cutoff clusters represented in different colors
if ~isempty(handle)
    subplot(handle)
else
    figure()
end
hidx = cluster(clustTreeEuc,'criterion','distance','cutoff',cutoff);
for i = 1:5
    clust = find(hidx==i);
    plot3(data(clust,plot_idx(1)),data(clust,plot_idx(2)),data(clust,plot_idx(3)),ptsymb{i});
    hold on
end
xlabel(var_names{plot_idx(1)});
ylabel(var_names{plot_idx(2)});
zlabel(var_names{plot_idx(3)});
title(data_name)
view(-137,10);
grid on
end
