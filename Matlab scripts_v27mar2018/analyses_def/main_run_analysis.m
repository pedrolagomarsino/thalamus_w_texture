% analyses def
clear all;

%% create list with info on path, animals and acquisition day of each TS
%list of days of acquisitions
data_path = 'C:\Users\plagomarsino\work\Data\Endoscopic_imaging_Whisking_Without_texture';
%data_path = 'C:\Users\Pedro\for Pedro\example dataset';
save_path = 'C:\Users\plagomarsino\work\MLC\Monica analysis on old data';
%save_path = 'C:\Users\Pedro\for Pedro\example analyses\20180302\example';
curr_dir = pwd;
list_day = dir(data_path);
list_day = list_day(3:end);

num_TS = 1; %count num of TS
%for each day look in the folder of each animal
for id_day = 1:length(list_day)
    if isunix
        list_mouse = dir([list_day(id_day).folder '/' list_day(id_day).name]);
        list_mouse = list_mouse(3:end);
    elseif ismac
        list_mouse = dir([list_day(id_day).folder '\' list_day(id_day).name]);
        list_mouse = list_mouse(3:end);
    else
        list_mouse = dir([list_day(id_day).folder '\' list_day(id_day).name]);
        list_mouse = list_mouse(3:end);
    end
    
    %for each animal look at the single exps (TS) and save some params
    for id_mouse = 1:length(list_mouse)
        if isunix
            cd([list_mouse(id_mouse).folder '/' list_mouse(id_mouse).name]);
            list_TS = dir('TSeries*');
            cd(curr_dir);
        elseif ismac
            cd([list_mouse(id_mouse).folder '\' list_mouse(id_mouse).name]);
            list_TS = dir('TSeries*');
            cd(curr_dir);
        else
            cd([list_mouse(id_mouse).folder '\' list_mouse(id_mouse).name]);
            list_TS = dir('TSeries*');
            cd(curr_dir);   
        end
        
        %for each TS save the specifics to load it
        for id_TS = 1:length(list_TS)
            if isunix
                exp_list(num_TS).path = [list_TS(id_TS).folder '/' list_TS(id_TS).name];
                exp_list(num_TS).save_path = [save_path '/' list_day(id_day).name '/' list_mouse(id_mouse).name '/' list_TS(id_TS).name '/'];
            elseif ismac
                exp_list(num_TS).path = [list_TS(id_TS).folder '\' list_TS(id_TS).name];
                exp_list(num_TS).save_path = [save_path '\' list_day(id_day).name '\' list_mouse(id_mouse).name '\' list_TS(id_TS).name '\'];
            else
                exp_list(num_TS).path = [list_TS(id_TS).folder '\' list_TS(id_TS).name];
                exp_list(num_TS).save_path = [save_path '\' list_day(id_day).name '\' list_mouse(id_mouse).name '\' list_TS(id_TS).name '\'];
            end
            if ~isdir(exp_list(num_TS).save_path)
                mkdir(exp_list(num_TS).save_path)
            end
                
            exp_list(num_TS).mouse = list_mouse(id_mouse).name;
            exp_list(num_TS).TSname = list_TS(id_TS).name;
            exp_list(num_TS).exp_day = list_day(id_day).name;
            
            num_TS = num_TS+1;
        end
        
    end
    
end

%% load data state variables
% save state variables in the analyses folder of each TS

for id_TS = 1:length(exp_list)
    if isunix
        var_folder_new = [exp_list(id_TS).path '/Post_proc_2'];
        var_folder_old= [exp_list(id_TS).path '/Post_proc'];
    elseif ismac
        var_folder_new = [exp_list(id_TS).path '\Post_proc_2'];
        var_folder_old= [exp_list(id_TS).path '\Post_proc'];
    else
        var_folder_new = [exp_list(id_TS).path '\Post_proc_2'];
        var_folder_old= [exp_list(id_TS).path '\Post_proc'];
    end
    if contains(exp_list(id_TS).exp_day,'20180216') || contains(exp_list(id_TS).exp_day,'20180221') 
        folder = var_folder_old;
    else
        folder = var_folder_new;
%     else
%         disp('NO processed state variables available');
%         keyboard;
    end
    curr_dir = pwd;
    cd(folder);
    file_name = dir('*State_Variables.csv');
    cd(curr_dir);
    if isunix
        csv_path = [file_name.folder '/' file_name.name];
    elseif ismac
        csv_path = [file_name.folder '\' file_name.name];
    else
        csv_path = [file_name.folder '\' file_name.name];
    end
    raw_state_var = load_state_var_from_csv(csv_path);
    save([exp_list(id_TS).save_path 'raw_state_var.mat'], 'raw_state_var');
    
end

%% build tag for each exp
for id_TS = 1:length(exp_list)
    mouse_full = exp_list(id_TS).mouse;
    pos = strfind(mouse_full,'_');
    mouse = mouse_full(pos(end)+1:end);
    day = exp_list(id_TS).exp_day;
    TS_full = exp_list(id_TS).TSname;
    pos = strfind(TS_full,'-');
    TS = TS_full(pos(end)+1:end);
    
    exp_list(id_TS).tag = [day '_TS' TS '_' mouse];
end

% %% assign classification to each exp
% [tag_all,class_all] = import_exp_tags('/home/calcium/Monica/endoscopes_project/analyses/ver20180917/single_exp/exp_evaluation.txt');
% for id_TS = 1:length(exp_list)
%     tag_temp = exp_list(id_TS).tag;
%     id_class = find(strcmp(tag_temp,tag_all));
%     
%     if ~isempty(id_class)
%         exp_list(id_TS).classification = class_all(id_class);
%     else
%         error('No classification!');
%     end
% end

%% load data and downsample variables
% save downsampled data and some params in the analyses folder of each TS

for id_TS = 1:length(exp_list)
    load([exp_list(id_TS).save_path 'raw_state_var.mat']);
    if isunix
        var_folder_new = [exp_list(id_TS).path '/Post_proc_2'];
        var_folder_old= [exp_list(id_TS).path '/Post_proc'];
    elseif ismac
        var_folder_new = [exp_list(id_TS).path '\Post_proc_2'];
        var_folder_old= [exp_list(id_TS).path '\Post_proc'];
    else
        var_folder_new = [exp_list(id_TS).path '\Post_proc_2'];
        var_folder_old= [exp_list(id_TS).path '\Post_proc'];
    end
    if contains(exp_list(id_TS).exp_day,'20180216') || contains(exp_list(id_TS).exp_day,'20180221') 
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
    
    %import data from processed TSeries
    data_ca = data;
    clear data;
    data.time_ca = data_ca.frameTimes;
    data.A = data_ca.A;
    data.Fraw = data_ca.Fraw; %raw fluorescence
    data.rois_centers = data_ca.rois_centres; %centers of ROIs
    data.corr_projection = correlation_image(data_ca.movie_doc.movie_ruido',...
        8, data_ca.linesPerFrame, data_ca.pixels_per_line); %correlation projection
    data.C_df = data_ca.C_df; %demixed and denoised calcium activity
    peakData = zeros(size(data.C_df)); %find C_df peaks
    for i = 1:size(peakData,1)
        [pks,locs] = findpeaks(data.C_df(i,:));
        peakData(i,locs) = pks;
    end
    binPeakData = double(peakData>0);
    data.peaks = peakData; %peaks with amplitude
    clear peakData; clear pks; clear locs;
    data.peaks_bin = binPeakData; %binary peaks
    clear binPeakData;
    %import parameters from processed TSeries
    params.framePeriod = data_ca.framePeriod;
    params.numROIs = data_ca.numero_neuronas; %num ROIs
    params.pupil_px_mm = 44.7;  %set the size in mm of one pixel for the pupil tracking (number of pixels in one mm?)
    params.usePeaks = 1;
    if contains(exp_list(id_TS).exp_day,'20180216') %set the size in um of one pixel of the 2P data (stored wrongly in the metadata)
        params.mm_px = 2.194;
    else
        params.mm_px = 2.139;
    end
    if nansum(raw_state_var.stimulus)==0 %set a flag for exp with/without stimulation
        params.stimulus = 0;
    else
        params.stimulus = 1;
    end
    params.edges = [0 1 2 5 Inf]; %limits for W_Q and WL_Q ratio
    params.max_n_mod = params.numROIs; %max number of modules for NMF
    params.min_n_mod = 1; %min number of modules for NMF
    clear data_ca;

    %resample data
    draw_resample_data = 0;
    data.speed = resample_state_var(raw_state_var.time, raw_state_var.speed, ...
        data.time_ca, 0, draw_resample_data);
    data.pupil = resample_state_var(raw_state_var.time, raw_state_var.pupil,...
        data.time_ca, 0, draw_resample_data);
    data.pupil_norm = data.pupil/params.pupil_px_mm;
    data.whisk_angle = resample_state_var(raw_state_var.time, raw_state_var.whisk_angle,...
        data.time_ca, 0, draw_resample_data);
    data.locomotion = resample_state_var(raw_state_var.time, raw_state_var.locomotion,...
        data.time_ca, 1, draw_resample_data);
    data.whisking = resample_state_var(raw_state_var.time, raw_state_var.whisking, ...
        data.time_ca, 1, draw_resample_data);
    data.stimulus = resample_state_var(raw_state_var.time, raw_state_var.stimulus,...
        data.time_ca, 1, draw_resample_data);

    save([exp_list(id_TS).save_path 'processed_var.mat'], 'data');
    save([exp_list(id_TS).save_path 'params.mat'], 'params');
    
end

%% plot single exp state variables and calcium activity figure

for id_TS = 1:length(exp_list)
    load([exp_list(id_TS).save_path 'params.mat']);
    %if params.stimulus == 0
    load([exp_list(id_TS).save_path 'raw_state_var.mat']);
    load([exp_list(id_TS).save_path 'processed_var.mat']);
    figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
    plot_state_var_and_ca(raw_state_var,data,params);
    saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_state_var.fig']);
    saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_state_var.png']);
    close
    %end
end

%% plot correlation image and ROIs figure

for id_TS = 1:length(exp_list)
    load([exp_list(id_TS).save_path 'params.mat']);
    
    load([exp_list(id_TS).save_path 'raw_state_var.mat']);
    load([exp_list(id_TS).save_path 'processed_var.mat']);
    
    figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
    plot_FOV_and_ROIs(data,params);
    saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_FOV_ROIs.fig']);
    saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_FOV_ROIs.png']);
    close
    
end

%% compute behavioral state vector and cut L_only frames_TO RUN BEFORE OTHER ANALYSES

for id_TS = 1:length(exp_list)
    load([exp_list(id_TS).save_path 'params.mat']);
    if exist([exp_list(id_TS).save_path 'analyses.mat'],'file')
        load([exp_list(id_TS).save_path 'analyses.mat']);
    end
    
    if params.stimulus == 0
        load([exp_list(id_TS).save_path 'processed_var.mat']);
        
        %build behavioral state vector
        analyses.behavior = behavioral_state_vector(data,params);
        %compute ca activity across states
        analyses.single_cell = calcium_state_modulation(data,analyses,params);
        
        figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
        plot_states_pupil_ca(data,analyses,params);
        saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_states_pupil_ca.fig']);
        saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_states_pupil_ca.png']);
        close
        
        [data,analyses] = cut_L_only_frames(data,analyses);
    else
        load([exp_list(id_TS).save_path 'processed_var.mat']);
        
        %build behavioral state vector
        analyses.behavior = behavioral_state_vector(data,params);
        %compute ca activity across states
        analyses.single_cell = calcium_state_modulation(data,analyses,params);
        
        figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
        plot_states_pupil_ca(data,analyses,params);
        saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_states_pupil_ca.fig']);
        saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_states_pupil_ca.png']);
        close
        
        [data,analyses] = cut_L_only_frames(data,analyses);
    end
    
    save([exp_list(id_TS).save_path 'analyses.mat'], 'analyses');
    save([exp_list(id_TS).save_path 'data_noL.mat'], 'data');
end
%% compute mean duration of behavioural states

for id_TS = 1:length(exp_list)
    load([exp_list(id_TS).save_path 'params.mat']);
    if exist([exp_list(id_TS).save_path 'analyses.mat'],'file')
        load([exp_list(id_TS).save_path 'analyses.mat']);
    end
    
    if params.stimulus == 1        
        load([exp_list(id_TS).save_path 'raw_state_var.mat']);   
        analyses.behavior.duration = mean_state_dur(raw_state_var);
    end
    %cell for the boxplot
    behavioral_state_duration = {analyses.behavior.duration.Quite analyses.behavior.duration.locomotion analyses.behavior.duration.whisking analyses.behavior.duration.stimulus};

    col= @(x)reshape(x,numel(x),1);
    boxplot2=@(C,varargin)boxplot(cell2mat(cellfun(col,col(C),'uni',0)),cell2mat(arrayfun(@(I)I*ones(numel(C{I}),1),col(1:numel(C)),'uni',0)),varargin{:});
    
    figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
    boxplot2(behavioral_state_duration)
    title('Behavioral state duration')
    ylabel('Duration (s)','FontSize',14)
    xlabel('Behavioral states','FontSize',14)
    set(gca,'XTicklabels',{'Quiet' 'Locomotion' 'Whisking' 'Stimulus'})
        
    saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_behavioral_state_duration.fig']);
    saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_behavioral_state_duration.png']);
    close
    
    save([exp_list(id_TS).save_path 'analyses.mat'], 'analyses');
end

%% compute single ROI information theory

%addpath(genpath('/home/calcium/Monica/endoscopes_project/code/infotoolbox - v.1.1.0b3/'));
%Pedro mod
% for id_TS = 1:length(exp_list)
%     load([exp_list(id_TS).save_path 'params.mat']);
%     if exist([exp_list(id_TS).save_path 'analyses.mat'],'file')
%         load([exp_list(id_TS).save_path 'analyses.mat']);
%     
%         %run analyses only for data without stimulus
%         if params.stimulus == 0
%             load([exp_list(id_TS).save_path 'data_noL.mat']);
%             analyses = whisking_info_rois(data,analyses,params);
% %             analyses = locomotion_info_rois(data,analyses,params);
%             
%             figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
%             plot_info_map_single_exp(data,analyses,params);
%             saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_info_map.fig']);
%             saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_info_map.png']);
%             close
%             
%             figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
%             plot_info_distance_single_exp(data,analyses,params);
%             saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_info_distance.fig']);
%             saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_info_distance.png']);
%             close
%             
%             save([exp_list(id_TS).save_path 'analyses.mat'], 'analyses');
%         end
%     else
%         error('This dataset does not have behavioral analyses!')
%     end
% end
% 
% %% compute single ROI information theory for all states
% 
% for id_TS = 1:length(exp_list)
%     load([exp_list(id_TS).save_path 'params.mat']);
%     if exist([exp_list(id_TS).save_path 'analyses.mat'],'file')
%         load([exp_list(id_TS).save_path 'analyses.mat']);
%     
%         %run analyses only for data without stimulus
%         if params.stimulus == 0
%             load([exp_list(id_TS).save_path 'data_noL.mat']);
%             analyses = states_info_rois(data,analyses,params);
%             
%             figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
%             plot_info_states_hist(data,analyses,params);
%             saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_info_all_states.fig']);
%             saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_info_all_states.png']);
%             close
% 
% %             figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
% %             plot_info_states_map(data,analyses,params);
% %             saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_info_map_all_states.fig']);
% %             saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_info_map_all_states.png']);
% %             close
%             
%             figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
%             plot_info_map_W_and_WL(data,analyses,params);
%             saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_info_map_W_L_only.fig']);
%             saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_info_map_aW_L_only.png']);
%             close
% 
% 
%             save([exp_list(id_TS).save_path 'analyses.mat'], 'analyses');
%         end
%     else
%         error('This dataset does not have behavioral analyses!')
%     end
% end
% 
% %% fisher LDA decoder based on ROIs DF/F activity
% 
% for id_TS = 1:length(exp_list)
%     load([exp_list(id_TS).save_path 'params.mat']);
%     if exist([exp_list(id_TS).save_path 'analyses.mat'],'file')
%         load([exp_list(id_TS).save_path 'analyses.mat']);
%     
%         %run analyses only for data without stimulus
%         if params.stimulus == 0
%             load([exp_list(id_TS).save_path 'data_noL.mat']);
% 
%             analyses = whisking_lda_decoder(data, analyses, params);
%             analyses = Q_W_WL_lda_decoder(data, analyses, params);
%             
%             figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
%             plot_decoding_map_single_exp(data,analyses,params);
%             saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_decoding_map.fig']);
%             saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_decoding_map.png']);
%             close
%             
%             save([exp_list(id_TS).save_path 'analyses.mat'], 'analyses');
%         end
%     else
%         error('This dataset does not have behavioral analyses!')
%     end
% end
% 
%% correlation analyses

for id_TS = 1%:length(exp_list)
    load([exp_list(id_TS).save_path 'params.mat']);
    if exist([exp_list(id_TS).save_path 'analyses.mat'],'file')
        load([exp_list(id_TS).save_path 'analyses.mat']);
    
        %run analyses only for data without stimulus
        if params.stimulus == 0
            load([exp_list(id_TS).save_path 'data_noL.mat']);

            analyses = pairwise_correlations(data,analyses,params);
            [analyses, params] = correlations_distance_count(analyses,params);
            
            figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
            plot_correlations_2(analyses,params)
            saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_correlations_states.png']);
            saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_correlations_states.fig']);
            close
            
            figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
            plot_correlations_1(analyses,params)
            saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_correlations.png']);
            saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_correlations.fig']);
            close
            
            figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
            [analyses, params] = correlations_distance_count_2(analyses,params);
            saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_correlations_sign.png']);
            saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_correlations_sign.fig']);
            close
            
            figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
            summary_corr_plot(analyses,params);
            saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_correlations_summary.png']);
            saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_correlations_summary.fig']);
            close
            
            
            save([exp_list(id_TS).save_path 'analyses.mat'], 'analyses');
            save([exp_list(id_TS).save_path 'params.mat'], 'params');
        else
            load([exp_list(id_TS).save_path 'data_noL.mat']);

            analyses = pairwise_correlations(data,analyses,params);
            [analyses, params] = correlations_distance_count(analyses,params);
            
            figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
            plot_correlations_2(analyses,params)
            saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_correlations_states.png']);
            saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_correlations_states.fig']);
            %close
            
            figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
            plot_correlations_1(analyses,params)
            saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_correlations.png']);
            saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_correlations.fig']);
            %close
            
            figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
            [analyses, params] = correlations_distance_count_2(analyses,params);
            saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_correlations_sign.png']);
            saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_correlations_sign.fig']);
            %close
            
            figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
            summary_corr_plot(analyses,params);
            saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_correlations_summary.png']);
            saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_correlations_summary.fig']);
            %close
            
            
            %save([exp_list(id_TS).save_path 'analyses.mat'], 'analyses');
            %save([exp_list(id_TS).save_path 'params.mat'], 'params');
        end
    else
        error('This dataset does not have behavioral analyses!')
    end
end
