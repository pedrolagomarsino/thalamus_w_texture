function [data_masked,params_masked] = mask_FOV(data,params,path,saveFolder, tag)

%% import intensity profile
load('/home/calcium/Monica/endoscopes_project/analyses/Endoscopes Intensity Profiles/intensity_ratio.mat');

params.FOV_size = size(data.corr_projection);

aberration_mask = aberration_FOV(params.FOV_size,...
    Lens_RadialDistanceum, profile_ratio, params.mm_px);

filt_width_s = 2;
filt_width = round(filt_width_s/params.framePeriod);


data_full = import_analyzes_TS(path);

%estimate dark noise from edges and shot noise from other pixels
movie_3d = reshape(data_full.movie_doc.movie_ruido',...
    size(data_full.corr_projection,1),size(data_full.corr_projection,2),[]);
radius_endoscope = min(size(data_full.corr_projection,1))*params.mm_px/2;
dark_noise = estimate_dark_noise(movie_3d, radius_endoscope, params.mm_px);
shot_noise = estimate_shot_noise(movie_3d, radius_endoscope, params.mm_px,filt_width_s, 1/params.framePeriod);
%         %plot mean and std of each pixel activity (should be mean noise and
%         %std of noise
dark_noise_fig = figure;
subplot(1,3,1); histogram(dark_noise.mean); title('Dark noise mean');
subplot(1,3,2); histogram(dark_noise.std); title('Dark noise std');
subplot(1,3,3); scatter(dark_noise.mean,dark_noise.std);
xlabel('intensity'); ylabel('std');


alpha_estimate = shot_noise.slope;
%apply aberration mask to every frame
movie_non_corr = bsxfun(@rdivide, movie_3d, aberration_mask);



movie_final = adjust_noise_level(movie_non_corr, dark_noise, shot_noise, filt_width_s, 1/params.framePeriod);
movie_final_2d = reshape(movie_final,[],size(movie_final,3))';
dark_noise_2 = estimate_dark_noise(movie_final, radius_endoscope, params.mm_px);
figure(dark_noise_fig)
subplot(1,3,1); hold on; histogram(dark_noise_2.mean); title('Dark noise mean');
subplot(1,3,2); hold on; histogram(dark_noise_2.std); title('Dark noise std');
subplot(1,3,3); hold on; scatter(dark_noise_2.mean,dark_noise_2.std);
xlabel('intensity'); ylabel('std');

%plot some examples of shot noise
pixels_id = randperm(size(movie_final_2d,2),100);
shot_noise_fig = figure;
ax1 = subplot(1,2,1);
ax2 = subplot(1,2,2);
for id_px = 1:length(pixels_id)
    
    activity = data_full.movie_doc.movie_ruido(:, pixels_id(id_px))';
    activity_smooth = filtfilt(ones(1,filt_width)/filt_width,1,activity')';
    activity_smooth(activity_smooth<0)=0;
    [yupper,~] = envelope(activity-activity_smooth,10,'rms');
    subplot(ax1);
    hold on; scatter(ax1,sqrt(activity_smooth),yupper,'b');
    
    activity = movie_final_2d(:,pixels_id(id_px))';
    activity_smooth = filtfilt(ones(1,filt_width)/filt_width,1,activity')';
    activity_smooth(activity_smooth<0)=0;
    [yupper,~] = envelope(activity-activity_smooth,filt_width,'rms');
    %              ax2 = subplot(1,2,2);
    subplot(ax2);
    hold on; scatter(ax2,sqrt(activity_smooth),yupper,'r');
    
    %              activity = movie_non_corr_2d(:,pixels_id(id_px))';
    %             activity_smooth = filtfilt(ones(1,10)/10,1,activity')';
    %             [yupper,~] = envelope(activity-activity_smooth,10,'rms');
    %              ax3 = subplot(1,3,3);
    %              hold on; scatter(activity_smooth,yupper,'g');
    %              linkaxes([ax1,ax2, ax3],'xy');
end
xx = 0:1:30;
hold on; plot(ax2, xx, shot_noise.intercept + shot_noise.slope*xx,'k');
%         subplot(1,2,1);
subplot(ax1); hold on; plot(xx, shot_noise.intercept + shot_noise.slope*xx,'k');
linkaxes([ax1,ax2],'xy');

save_name = [saveFolder tag];

save_mat = [save_name '_masked.mat'];
data_old = data_full;
%import old ROIs and save new dataset
data_full = build_new_structure(data_old, movie_final_2d);
%         %plot raw activity
%         figure;
%         ax1 = subplot(2,1,1); imagesc(data_old.Fraw); colorbar;
%         ax2 = subplot(2,1,2); imagesc(data.Fraw); colorbar;
%         linkaxes([ax1 ax2],'xy');
%plot calcium activity
ca_activity = figure;
ax1 = subplot(2,1,1); imagesc(data_old.frameTimes,[], data_old.C_df); colorbar;
xlabel('time (s)'); ylabel('ROIs ID'); title('corrected FOV');
set(gca,'FontSize',16);
ax2 = subplot(2,1,2); imagesc( data_full.frameTimes,[],data_full.C_df); colorbar;
xlabel('time (s)'); ylabel('ROIs ID'); title('aberrated FOV');
set(gca,'FontSize',16);
linkaxes([ax1 ax2],'xy');
saveas(ca_activity,[save_name  '_C_df.png']);
close
saveas(dark_noise_fig,[save_name  '_dark_noise_stats.png']);
close(dark_noise_fig)
saveas(shot_noise_fig,[save_name  '_shot_noise_stats.png']);
close(shot_noise_fig)
save(save_mat,'data_full','-v7.3');

%compute SNR distribution of original data
snr_0 = zeros(1,size(data.C_df,1));
for ind_ROI = 1:size(data.C_df,1)
    lower_part = data.Fraw(ind_ROI,data.Fraw(ind_ROI,:)<median(data.Fraw(ind_ROI,:)));
    snr_0(ind_ROI) = max(data.Fraw(ind_ROI,:))/std(lower_part);
end
%update data changing fluorescence
data.Fraw = data_full.Fraw;
data.corr_projection = data_full.corr_projection;
data.C_df = data_full.C_df;


data_masked = data;
params_masked = params;
cut_rois = zeros(size(data.C_df,1),1);
for ind_ROI = 1:size(data.C_df,1)
    
    lower_part = data.Fraw(ind_ROI,data.Fraw(ind_ROI,:)<median(data.Fraw(ind_ROI,:)));
    snr_new = max(data.Fraw(ind_ROI,:))/std(lower_part);
    
    if snr_new < prctile(snr_0,5)
        cut_rois(ind_ROI) = 1;
    end
end

data_masked.rois_centers(find(cut_rois),:)=[];
data_masked.Fraw(find(cut_rois),:)=[];
data_masked.C_df(find(cut_rois),:)=[];
params_masked.numROIs = sum(cut_rois==0);
data_masked.A(:,find(cut_rois))=[];

params_masked.max_n_mod = params_masked.numROIs; %max number of modules for NMF
peakData = zeros(size(data_masked.C_df)); %find C_df peaks
for i = 1:size(peakData,1)
    [pks,locs] = findpeaks(data_masked.C_df(i,:));
    peakData(i,locs) = pks;
end
binPeakData = double(peakData>0);
data_masked.peaks = peakData; %peaks with amplitude
data_masked.peaks_bin = binPeakData; %binary peaks

end

function aberration_mask = aberration_FOV(frame_size, dist_um, intensity_prof, um_px)
% frame_size = size(frame);

size_FOV = frame_size*um_px;
radius = size_FOV/2;
dist_new = linspace(-radius(1),radius(1),length(dist_um))';

Ax = repmat((-(frame_size(2)-1)/2):1:(frame_size(2)-1)/2,frame_size(1),1)*um_px;
Ay = repmat([-(frame_size(1)-1)/2:1:(frame_size(1)-1)/2]',1,frame_size(2))*um_px;

% distance_um = sign(Ax).*sign(Ay).*sqrt(Ax.^2+Ay.^2);
distance_um = sqrt(Ax.^2+Ay.^2);

dist_1d = unique(distance_um);
intensity_1d = interp1(dist_new,intensity_prof,dist_1d);

[~,Locb] = ismember(distance_um,dist_1d);
aberration_mask = intensity_1d(Locb);
aberration_mask(isnan(aberration_mask))=1;
end

function data = import_analyzes_TS(path)
%load data structure

if isunix
    var_folder_new = [path '/Post_proc_2'];
    var_folder_old= [path '/Post_proc'];
elseif ismac
    var_folder_new = [path '\Post_proc_2'];
    var_folder_old= [path '\Post_proc'];
else
    var_folder_new = [path '\Post_proc_2'];
    var_folder_old= [path '\Post_proc'];
end
if contains(path,'20180216') || contains(path,'20180221')
    folder = var_folder_old;
else
    folder = var_folder_new;
end
curr_dir = pwd;
cd(folder);
file_name = dir('*no_stim_times.mat');
if isempty(file_name)
    file_name = dir('*rois_for_samples.mat');
end
cd(curr_dir);


try
    if isunix
        load([file_name.folder '/' file_name.name]);
    elseif ismac
        load([file_name.folder '\' file_name.name]);
    else
        load([file_name.folder '\' file_name.name]);
    end
catch
    disp([file_name.folder '\' file_name.name])
end
%set um per pixel
if ~isempty(strfind(path,'20180216\Mouse_2087'))
    data.params.um_px = 2.194;
else
    data.params.um_px = 2.139;
end
data.corr_projection = correlation_image(data.movie_doc.movie_ruido',...
    8, data.linesPerFrame, data.pixels_per_line);
data.params.FOV_size = size(data.corr_projection);
end

function dark_noise = estimate_dark_noise(movie, radius_endoscope, um_px)
%compute distance from center
frame_size = [size(movie,1) size(movie,2)];
Ax = repmat((-(frame_size(2)-1)/2):1:(frame_size(2)-1)/2,frame_size(1),1)*um_px;
Ay = repmat([-(frame_size(1)-1)/2:1:(frame_size(1)-1)/2]',1,frame_size(2))*um_px;
distance_um = sqrt(Ax.^2+Ay.^2);
%keep only pixels outside FOV
px_out = find(distance_um>radius_endoscope);
movie_2d = reshape(movie,[],size(movie,3));
dark_noise.noise = movie_2d(px_out,:);
dark_noise.mean = mean(dark_noise.noise,2);
dark_noise.std = std(dark_noise.noise,[],2);

end

function shot_noise = estimate_shot_noise(movie, radius_endoscope, um_px, filt_width_s, rate)
filt_width = round(filt_width_s*rate);
%compute distance from center
frame_size = [size(movie,1) size(movie,2)];
Ax = repmat((-(frame_size(2)-1)/2):1:(frame_size(2)-1)/2,frame_size(1),1)*um_px;
Ay = repmat([-(frame_size(1)-1)/2:1:(frame_size(1)-1)/2]',1,frame_size(2))*um_px;
distance_um = sqrt(Ax.^2+Ay.^2);
%keep only pixels within FOV
px_in = find(distance_um<=radius_endoscope);
movie_2d = reshape(movie,[],size(movie,3));
activity = movie_2d(px_in,:); %exctract fluorescence
activity_smooth = filtfilt(ones(1,filt_width)/filt_width,1,activity')'; %smooth in time
for i = 1:length(px_in) %compute rms envelope to estimate std of noise and linear fit with sqrt(F)
    [yupper,~] = envelope(activity(i,:)'-activity_smooth(i,:)',filt_width,'rms');
    activity_smooth(i,activity_smooth(i,:)<0)=0;
    linear_fit_coef(i,:) = polyfit(sqrt(activity_smooth(i,:))',yupper,1);
end
shot_noise.intercept = mean(linear_fit_coef(:,2));
shot_noise.slope = mean(linear_fit_coef(:,1));
end

function movie_corrected = adjust_noise_level(movie, dark_noise, shot_noise, filt_width_s, rate)

filt_width = round(filt_width_s*rate);

movie_corrected = zeros(size(movie));
intensity_min = mean(dark_noise.mean)+mean(dark_noise.std);

for i = 1:size(movie,1)
    for j = 1:size(movie,2)
        activity_px = squeeze(movie(i,j,:));
        activity_smooth = filtfilt(ones(1,filt_width)/filt_width,1,activity_px);
        
        activity_new = activity_smooth;
        %add gaussian noise if intensity lower than noise level
        %             activity_new(activity_smooth<=intensity_min)=...
        %                 activity_smooth(activity_smooth<=intensity_min)+...
        %                 mean(dark_noise.std)*randn(length(activity_smooth(activity_smooth<=intensity_min)),1);
        activity_new(activity_smooth<=intensity_min)=...
            mean(dark_noise.mean)*ones(length(activity_smooth(activity_smooth<=intensity_min)),1)+...
            mean(dark_noise.std)*randn(length(activity_smooth(activity_smooth<=intensity_min)),1);
        activity_new(activity_new<0)=0;
        %add poisson noise if intensity higher than noise level
        activity_new(activity_smooth>intensity_min)=...
            activity_smooth(activity_smooth>intensity_min)+...
            randn(length(activity_smooth(activity_smooth>intensity_min)),1).*...
            (sqrt(activity_smooth(activity_smooth>intensity_min))*shot_noise.slope+shot_noise.intercept);
        activity_new(activity_new<0)=0;
        %             activity_new(activity_smooth>intensity_min)=...
        %                 poissrnd(sqrt(activity_smooth(activity_smooth>intensity_min))*shot_noise.slope+shot_noise.intercept);
        %             activity_new(activity_new<0)=0;
        movie_corrected(i,j,:) = activity_new;
    end
end

end

function data = build_new_structure(data_old, movie_final_2d)
%remove not necessary fields
data = data_old;
if isfield(data,'avg_proj')
    data = rmfield(data,'avg_proj');
end
if isfield(data,'DR_proj')
    data = rmfield(data,'DR_proj');
end
if isfield(data,'large_proj')
    data = rmfield(data,'large_proj');
end
if isfield(data.movie_doc,'avg_proj')
    data.movie_doc = rmfield(data.movie_doc,'avg_proj');
end
if isfield(data.movie_doc,'DR_proj')
    data.movie_doc = rmfield(data.movie_doc,'DR_proj');
end
if isfield(data.movie_doc,'large_proj')
    data.movie_doc = rmfield(data.movie_doc,'large_proj');
end
if isfield(data.movie_doc,'movie_stack')
    data.movie_doc = rmfield(data.movie_doc,'movie_stack');
end

addpath(genpath('C:\Users\neural\ETIC'));
%change movie and corr projection
data.movie_doc.movie_ruido = movie_final_2d;
data.CNimage = correlation_image(data.movie_doc.movie_ruido',...
    8, data.linesPerFrame, data.pixels_per_line);
%extract activity from new movie and save fields
data.noOrder = 1;
new_data = onlyTemporal_correctFOV(data, movie_final_2d);
data.Fraw = new_data.Fraw; %Fraw
data.A = new_data.A; %ROI space
data.C_df = new_data.C_df; %C_df
data.peaks = new_data.peaks; %peaks with values
if ~isfield(new_data,'b')
    data.b  = new_data.b; %background space
end
data.f = new_data.f; %background time
data.S = new_data.S; %spike inference
data.P = new_data.P; %order model C_df
data.opt = new_data.opt;    %some options for deconvolution
data.activities_original = data.Fraw; %Fraw (it is a copy, NOT NECESSARY)
data.activities_Paninski = data.C_df; %C_df (it is a copy, NOT NECESSARY)
for ind_n=1:data.numero_neuronas %DF/F using median baseline
    roi_activity = data.activities_original(ind_n,:);
    baseline = mean(roi_activity(roi_activity<median(roi_activity)));
    df0_activity = (roi_activity-baseline)./baseline;
    data.activities(ind_n,:) = df0_activity;
end
end