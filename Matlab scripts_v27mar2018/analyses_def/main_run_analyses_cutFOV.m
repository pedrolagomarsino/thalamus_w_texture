% analyses def
clear all;

%% create list with info on path, animals and acquisition day of each TS
%list of days of acquisitions
data_path = '/home/calcium/data/endoscopes_project/ver20180917';
save_path = '/home/calcium/Monica/endoscopes_project/analyses/ver20180917/single_exp';
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
                exp_list(num_TS).save_path_cut = [save_path '/' list_day(id_day).name '/' list_mouse(id_mouse).name '/' list_TS(id_TS).name '/cut/'];
                
                if ~isdir([exp_list(num_TS).save_path_cut])
                    mkdir([exp_list(num_TS).save_path_cut])
                end
            elseif ismac
                exp_list(num_TS).path = [list_TS(id_TS).folder '\' list_TS(id_TS).name];
                exp_list(num_TS).save_path = [save_path '\' list_day(id_day).name '\' list_mouse(id_mouse).name '\' list_TS(id_TS).name '\'];
                exp_list(num_TS).save_path_cut = [save_path '\' list_day(id_day).name '\' list_mouse(id_mouse).name '\' list_TS(id_TS).name '\cut\'];

                if ~isdir([exp_list(num_TS).save_path_cut])
                    mkdir([exp_list(num_TS).save_path_cut])
                end
            else
                exp_list(num_TS).path = [list_TS(id_TS).folder '\' list_TS(id_TS).name];
                exp_list(num_TS).save_path = [save_path '\' list_day(id_day).name '\' list_mouse(id_mouse).name '\' list_TS(id_TS).name '\'];
                exp_list(num_TS).save_path_cut = [save_path '\' list_day(id_day).name '\' list_mouse(id_mouse).name '\' list_TS(id_TS).name '\cut\'];

                if ~isdir([exp_list(num_TS).save_path_cut])
                    mkdir([exp_list(num_TS).save_path_cut])
                end
            end
            
                
            exp_list(num_TS).mouse = list_mouse(id_mouse).name;
            exp_list(num_TS).TSname = list_TS(id_TS).name;
            exp_list(num_TS).exp_day = list_day(id_day).name;
            
            num_TS = num_TS+1;
        end
        
    end
    
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

%% assign classification to each exp
[tag_all,class_all] = import_exp_tags('/home/calcium/Monica/endoscopes_project/analyses/ver20180917/single_exp/exp_evaluation.txt');
for id_TS = 1:length(exp_list)
    tag_temp = exp_list(id_TS).tag;
    id_class = find(strcmp(tag_temp,tag_all));
    
    if ~isempty(id_class)
        exp_list(id_TS).classification = class_all(id_class);
    else
        error('No classification!');
    end
end

%% cut FOV at 70 um and plot correlation image and ROIs figure
radius_cut = 70; %um

for id_TS = 1:length(exp_list)
    load([exp_list(id_TS).save_path 'params.mat']);
    %run analyses only for data without stimulus
    if params.stimulus == 0
        load([exp_list(id_TS).save_path 'raw_state_var.mat']);
        load([exp_list(id_TS).save_path 'processed_var.mat']);
        
        [data_cut,params_cut] = cut_FOV_radius(data,params,radius_cut);
        
        figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
        plot_FOV_and_ROIs(data_cut,params_cut);
        if isunix
            saveas(gcf,[exp_list(id_TS).save_path_cut '/FOV_ROIs.fig']);
            saveas(gcf,[exp_list(id_TS).save_path_cut '/FOV_ROIs.png']);
            
            save([exp_list(id_TS).save_path_cut '/processed_var.mat'], 'data_cut');
            save([exp_list(id_TS).save_path_cut '/params.mat'], 'params_cut');
            
        else
            saveas(gcf,[exp_list(id_TS).save_path_cut '\FOV_ROIs.fig']);
            saveas(gcf,[exp_list(id_TS).save_path_cut '\FOV_ROIs.png']);
            
            save([exp_list(id_TS).save_path_cut '\processed_var.mat'], 'data_cut');
            save([exp_list(id_TS).save_path_cut '\params.mat'], 'params_cut');
        end
        close
    end
end

%% plot single exp state variables and calcium activity figure

for id_TS = 1:length(exp_list)
    load([exp_list(id_TS).save_path_cut 'params.mat']);
    %run analyses only for data without stimulus
    if params.stimulus == 0
        load([exp_list(id_TS).save_path 'raw_state_var.mat']);
        load([exp_list(id_TS).save_path_cut 'processed_var.mat']);
        
        figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
        plot_state_var_and_ca(raw_state_var,data_cut,params_cut);
        saveas(gcf,[exp_list(id_TS).save_path_cut exp_list(id_TS).tag '_state_var.fig']);
        saveas(gcf,[exp_list(id_TS).save_path_cut exp_list(id_TS).tag '_state_var.png']);
        close
    end
end

%% compute behavioral state vector and cut L_only frames_TO RUN BEFORE OTHER ANALYSES

for id_TS = 1:length(exp_list)
    load([exp_list(id_TS).save_path_cut 'params.mat']);
    if exist([exp_list(id_TS).save_path_cut 'analyses.mat'],'file')
        load([exp_list(id_TS).save_path_cut 'analyses.mat']);
    end
    %run analyses only for data without stimulus
    if params_cut.stimulus == 0
        load([exp_list(id_TS).save_path_cut 'processed_var.mat']);
        
        %build behavioral state vector
        analyses_cut.behavior = behavioral_state_vector(data_cut,params_cut);
        %compute ca activity across states
        analyses_cut.single_cell = calcium_state_modulation(data_cut,analyses_cut,params_cut);
        
        figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
        plot_states_pupil_ca(data_cut,analyses_cut,params_cut);
        saveas(gcf,[exp_list(id_TS).save_path_cut exp_list(id_TS).tag '_states_pupil_ca.fig']);
        saveas(gcf,[exp_list(id_TS).save_path_cut exp_list(id_TS).tag '_states_pupil_ca.png']);
        close
        
        [data_cut,analyses_cut] = cut_L_only_frames(data_cut,analyses_cut);
    end
    
    save([exp_list(id_TS).save_path_cut 'analyses.mat'], 'analyses_cut');
    save([exp_list(id_TS).save_path_cut 'data_cut_noL.mat'], 'data_cut');
end

%% compute single ROI information theory
addpath(genpath('/home/calcium/Monica/endoscopes_project/code/infotoolbox - v.1.1.0b3/'));

for id_TS = 1:length(exp_list)
    load([exp_list(id_TS).save_path_cut 'params.mat']);
    if exist([exp_list(id_TS).save_path_cut 'analyses.mat'],'file')
        load([exp_list(id_TS).save_path_cut 'analyses.mat']);
    
        %run analyses only for data without stimulus
        if params_cut.stimulus == 0
            load([exp_list(id_TS).save_path_cut 'data_cut_noL.mat']);
            analyses_cut = whisking_info_rois(data_cut,analyses_cut,params_cut);
%             analyses_cut = locomotion_info_rois(data_cut,analyses_cut,params_cut);
            
            figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
            plot_info_map_single_exp(data_cut,analyses_cut,params_cut);
            saveas(gcf,[exp_list(id_TS).save_path_cut exp_list(id_TS).tag '_info_map.fig']);
            saveas(gcf,[exp_list(id_TS).save_path_cut exp_list(id_TS).tag '_info_map.png']);
            close
            
            figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
            plot_info_distance_single_exp(data_cut,analyses_cut,params_cut);
            saveas(gcf,[exp_list(id_TS).save_path_cut exp_list(id_TS).tag '_info_distance.fig']);
            saveas(gcf,[exp_list(id_TS).save_path_cut exp_list(id_TS).tag '_info_distance.png']);
            close
            
            save([exp_list(id_TS).save_path_cut 'analyses.mat'], 'analyses_cut');
        end
    else
        error('This dataset does not have behavioral analyses!')
    end
end

%% compute single ROI information theory for all states

for id_TS = 1:length(exp_list)
    load([exp_list(id_TS).save_path_cut 'params.mat']);
    if exist([exp_list(id_TS).save_path_cut 'analyses.mat'],'file')
        load([exp_list(id_TS).save_path_cut 'analyses.mat']);
    
        %run analyses only for data without stimulus
        if params.stimulus == 0
            load([exp_list(id_TS).save_path_cut 'data_cut_noL.mat']);
            analyses_cut = states_info_rois(data_cut,analyses_cut,params_cut);
            
            figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
            plot_info_states_hist(data_cut,analyses_cut,params_cut);
            saveas(gcf,[exp_list(id_TS).save_path_cut exp_list(id_TS).tag '_info_all_states.fig']);
            saveas(gcf,[exp_list(id_TS).save_path_cut exp_list(id_TS).tag '_info_all_states.png']);
            close

%             figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
%             plot_info_states_map(data,analyses,params);
%             saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_info_map_all_states.fig']);
%             saveas(gcf,[exp_list(id_TS).save_path exp_list(id_TS).tag '_info_map_all_states.png']);
%             close
            
            figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
            plot_info_map_W_and_WL(data_cut,analyses_cut,params_cut);
            saveas(gcf,[exp_list(id_TS).save_path_cut exp_list(id_TS).tag '_info_map_W_L_only.fig']);
            saveas(gcf,[exp_list(id_TS).save_path_cut exp_list(id_TS).tag '_info_map_aW_L_only.png']);
            close


            save([exp_list(id_TS).save_path_cut 'analyses.mat'], 'analyses_cut');
        end
    else
        error('This dataset does not have behavioral analyses!')
    end
end

%% fisher LDA decoder based on ROIs DF/F activity

for id_TS = 1:length(exp_list)
    load([exp_list(id_TS).save_path_cut 'params.mat']);
    if exist([exp_list(id_TS).save_path_cut 'analyses.mat'],'file')
        load([exp_list(id_TS).save_path_cut 'analyses.mat']);
    
        %run analyses only for data without stimulus
        if params_cut.stimulus == 0
            load([exp_list(id_TS).save_path_cut 'data_cut_noL.mat']);

            analyses_cut = whisking_lda_decoder(data_cut, analyses_cut, params_cut);
            analyses_cut = Q_W_WL_lda_decoder(data_cut, analyses_cut, params_cut);
            
            figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
            plot_decoding_map_single_exp(data_cut,analyses_cut,params_cut);
            saveas(gcf,[exp_list(id_TS).save_path_cut exp_list(id_TS).tag '_decoding_map.fig']);
            saveas(gcf,[exp_list(id_TS).save_path_cut exp_list(id_TS).tag '_decoding_map.png']);
            close
            
            save([exp_list(id_TS).save_path_cut 'analyses.mat'], 'analyses_cut');
        end
    else
        error('This dataset does not have behavioral analyses!')
    end
end

%% correlation analyses

for id_TS = 1:length(exp_list)
    load([exp_list(id_TS).save_path_cut 'params.mat']);
    if exist([exp_list(id_TS).save_path_cut 'analyses.mat'],'file')
        load([exp_list(id_TS).save_path_cut 'analyses.mat']);
    
        %run analyses only for data without stimulus
        if params.stimulus == 0
            load([exp_list(id_TS).save_path_cut 'data_cut_noL.mat']);

            analyses_cut = pairwise_correlations(data_cut,analyses_cut,params_cut);
            [analyses_cut, params_cut] = correlations_distance_count(analyses_cut,params_cut);
            
            figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
            plot_correlations_1(analyses_cut,params_cut)
            saveas(gcf,[exp_list(id_TS).save_path_cut exp_list(id_TS).tag '_correlations.png']);
            saveas(gcf,[exp_list(id_TS).save_path_cut exp_list(id_TS).tag '_correlations.fig']);
            close
            
            figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
            plot_correlations_2(analyses_cut,params_cut);
            saveas(gcf,[exp_list(id_TS).save_path_cut exp_list(id_TS).tag '_correlations_states.png']);
            saveas(gcf,[exp_list(id_TS).save_path_cut exp_list(id_TS).tag '_correlations_states.fig']);
            close
            
            figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
            [analyses_cut, params_cut] = correlations_distance_count_2(analyses_cut,params_cut);
            saveas(gcf,[exp_list(id_TS).save_path_cut exp_list(id_TS).tag '_correlations_sign.png']);
            saveas(gcf,[exp_list(id_TS).save_path_cut exp_list(id_TS).tag '_correlations_sign.fig']);
            close
            
            figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
            summary_corr_plot(analyses_cut,params_cut);
            saveas(gcf,[exp_list(id_TS).save_path_cut exp_list(id_TS).tag '_correlations_summary.png']);
            saveas(gcf,[exp_list(id_TS).save_path_cut exp_list(id_TS).tag '_correlations_summary.fig']);
            close
            
            save([exp_list(id_TS).save_path_cut 'analyses.mat'], 'analyses_cut');
            save([exp_list(id_TS).save_path_cut 'params.mat'], 'params_cut');
        end
    else
        error('This dataset does not have behavioral analyses!')
    end
end