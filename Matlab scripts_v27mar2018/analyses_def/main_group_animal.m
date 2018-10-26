% group results for each mouse
% 1. generate summary figures with single exps

mouseID_list = {'2087';'2091';'2092';'2124';'2139';...
    '2314';'2322';'2466';'2474';'2716';'2846';'2848'};

%% create array with a "mouse" label for each experiment
mouse_labels = zeros(1,length(exp_list));
for id_TS = 1:length(exp_list)
    mouse_labels(id_TS) = find(contains(mouseID_list,exp_list(id_TS).mouse(end-3:end)));
end

%% create folder to save figures
save_dir = '/home/calcium/Monica/endoscopes_project/analyses/ver20180917/single_animal';
save_dir_summary = '/home/calcium/Monica/endoscopes_project/analyses/ver20180917/summary_figures/';
for id_mouse = 1:length(mouseID_list)
    mouse_list(id_mouse).ID = mouseID_list{id_mouse};
    if isunix
        mouse_list(id_mouse).save_path = [save_dir '/' mouseID_list{id_mouse} '/'];
    elseif ismac
        mouse_list(id_mouse).save_path = [save_dir '\' mouseID_list{id_mouse} '\'];
    else
        mouse_list(id_mouse).save_path = [save_dir '\' mouseID_list{id_mouse} '\'];
    end
    if ~isdir(mouse_list(id_mouse).save_path)
        mkdir(mouse_list(id_mouse).save_path)
    end
end

%% generate figures
for id_mouse = 1:length(mouseID_list)
    TS_temp = find(mouse_labels==id_mouse);
    n_TS = length(TS_temp);
    n_col = 4;
    if mod(n_TS,n_col)==0
        n_rows = floor(n_TS/n_col);
    else
        n_rows = floor(n_TS/n_col)+1;
    end
    %generate figures for all TS of same animal
    %     fig_FOV = figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
    
%     fig_WTA = figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
    
    fig_DF_F_states = figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
    
    %     fig_info_map_loc = figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
    %     fig_info_map_whisk = figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
    %     fig_info_dist_loc = figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
    %     fig_info_dist_whisk = figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
    %
    %     fig_decod_loc = figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
    %     fig_decod_whisk = figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
    
    
    
    for id_TS = 1:n_TS
        load([exp_list(TS_temp(id_TS)).save_path 'params.mat']);
        if exist([exp_list(TS_temp(id_TS)).save_path 'analyses.mat'],'file')
            load([exp_list(TS_temp(id_TS)).save_path 'analyses.mat']);
            
            %run analyses only for data without stimulus
            if params.stimulus == 0
                load([exp_list(TS_temp(id_TS)).save_path 'processed_var.mat']);
                
                %                 %ROIs in FOV
                %                 figure(fig_FOV);
                %                 subplot(n_rows,n_col,id_TS);
                %                 plot_FOV_and_ROIs(data,params);
                
%                 %WTA
%                 pre_win = 2;
%                 post_win = 5;
%                 figure(fig_WTA);
%                 subplot(n_rows,n_col,id_TS);
%                 compute_and_plot_WTA(data,params,pre_win,post_win)
                
                %DF/F across states
                figure(fig_DF_F_states);
                subplot(n_rows,n_col,id_TS);
                plot_df_f_across_states(analyses,params)
                
                %                 %info_map_L
                %                 figure(fig_info_map_loc);
                %                 subplot(n_rows,n_col,id_TS);
                %                 plot_info_map(data.corr_projection, params.numROIs,...
                %                     data.rois_centers, analyses.info.info_locom);
                %                 %info_dist_L
                %                 figure(fig_info_dist_loc);
                %                 subplot(n_rows,n_col,id_TS);
                %                 plot_info_distance(params.numROIs, data.rois_centers, ...
                %                     analyses.info.info_locom);
                %                 xlabel('dist from center (um)');
                %                 ylabel('info L (bits)');
                %
                %                 %info_map_W
                %                 figure(fig_info_map_whisk);
                %                 subplot(n_rows,n_col,id_TS);
                %                 plot_info_map(data.corr_projection, params.numROIs,...
                %                     data.rois_centers, analyses.info.info_whisk);
                %                 %info_dist_W
                %                 figure(fig_info_dist_whisk);
                %                 subplot(n_rows,n_col,id_TS);
                %                 plot_info_distance(params.numROIs, data.rois_centers, ...
                %                     analyses.info.info_whisk);
                %                 xlabel('dist from center (um)');
                %                 ylabel('info W (bits)');
                %
                %                 %decoder L
                %                 figure(fig_decod_loc);
                %                 subplot(n_rows,n_col,id_TS);
                %                 plot_decoding_map(data.corr_projection,params.numROIs,...
                %                     data.rois_centers,analyses.decoder.locom);
                %                  set(gca,'FontSize',8);
                %
                %                 %decoder W
                %                 figure(fig_decod_whisk);
                %                 subplot(n_rows,n_col,id_TS);
                %                 plot_decoding_map(data.corr_projection,params.numROIs,...
                %                     data.rois_centers,analyses.decoder.whisk);
                %                 set(gca,'FontSize',8)
                
            end
            
        end
    end
    
    %     saveas(fig_FOV,[mouse_list(id_mouse).save_path mouse_list(id_mouse).ID '_FOV.fig']);
    %     saveas(fig_FOV,[mouse_list(id_mouse).save_path mouse_list(id_mouse).ID '_FOV.png']);
    %     close(fig_FOV);
    
%     saveas(fig_WTA,[mouse_list(id_mouse).save_path mouse_list(id_mouse).ID '_WTA.fig']);
%     saveas(fig_WTA,[mouse_list(id_mouse).save_path mouse_list(id_mouse).ID '_WTA.png']);
%     close(fig_WTA);
    
    saveas(fig_DF_F_states,[mouse_list(id_mouse).save_path mouse_list(id_mouse).ID '_DF_F_states.fig']);
    saveas(fig_DF_F_states,[mouse_list(id_mouse).save_path mouse_list(id_mouse).ID '_DF_F_states.png']);
    close(fig_DF_F_states);    

    
    %     saveas(fig_info_map_loc,[mouse_list(id_mouse).save_path mouse_list(id_mouse).ID '_info_map_L.fig']);
    %     saveas(fig_info_map_loc,[mouse_list(id_mouse).save_path mouse_list(id_mouse).ID '_info_map_L.png']);
    %     close(fig_info_map_loc);
    %     saveas(fig_info_dist_loc,[mouse_list(id_mouse).save_path mouse_list(id_mouse).ID '_info_dist_L.fig']);
    %     saveas(fig_info_dist_loc,[mouse_list(id_mouse).save_path mouse_list(id_mouse).ID '_info_dist_L.png']);
    %     close(fig_info_dist_loc);
    %     saveas(fig_decod_loc,[mouse_list(id_mouse).save_path mouse_list(id_mouse).ID '_decoder_L.fig']);
    %     saveas(fig_decod_loc,[mouse_list(id_mouse).save_path mouse_list(id_mouse).ID '_decoder_L.png']);
    %     close(fig_decod_loc);
    
    %     saveas(fig_info_map_whisk,[mouse_list(id_mouse).save_path mouse_list(id_mouse).ID '_info_map_W.fig']);
    %     saveas(fig_info_map_whisk,[mouse_list(id_mouse).save_path mouse_list(id_mouse).ID '_info_map_W.png']);
    %     close(fig_info_map_whisk);
    %     saveas(fig_info_dist_whisk,[mouse_list(id_mouse).save_path mouse_list(id_mouse).ID '_info_dist_W.fig']);
    %     saveas(fig_info_dist_whisk,[mouse_list(id_mouse).save_path mouse_list(id_mouse).ID '_info_dist_W.png']);
    %     close(fig_info_dist_whisk);
    %     saveas(fig_decod_whisk,[mouse_list(id_mouse).save_path mouse_list(id_mouse).ID '_decoder_W.fig']);
    %     saveas(fig_decod_whisk,[mouse_list(id_mouse).save_path mouse_list(id_mouse).ID '_decoder_W.png']);
    %     close(fig_decod_whisk);
end

%% compute some stats and generate figures
% fig_num_info_L = figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
% set(gca,'XTick',1:1:length(mouseID_list),...
%     'XTickLabel',mouseID_list);
% 
% fig_num_info_W = figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
% set(gca,'XTick',1:1:length(mouseID_list),...
%     'XTickLabel',mouseID_list);
% 
% fig_bits_info_L = figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
% set(gca,'XTick',1:1:length(mouseID_list),...
%     'XTickLabel',mouseID_list);
% 
% fig_bits_info_W = figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
% set(gca,'XTick',1:1:length(mouseID_list),...
%     'XTickLabel',mouseID_list);
% 
% fig_pop_decoder_L = figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
% set(gca,'XTick',1:1:length(mouseID_list),...
%     'XTickLabel',mouseID_list);
% 
% fig_pop_decoder_W= figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
% set(gca,'XTick',1:1:length(mouseID_list),...
%     'XTickLabel',mouseID_list);
% 
% fig_ROI_decoder_L = figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
% set(gca,'XTick',1:1:length(mouseID_list),...
%     'XTickLabel',mouseID_list);
% 
% fig_ROI_decoder_W= figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
% set(gca,'XTick',1:1:length(mouseID_list),...
%     'XTickLabel',mouseID_list);

fig_deltaI_WL_W= figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
set(gca,'xlim',[0 length(mouse_list)+1],'XTick',1:1:length(mouseID_list),...
    'XTickLabel',mouseID_list);

fig_deltaI_WL_L= figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
set(gca,'xlim',[0 length(mouse_list)+1],'XTick',1:1:length(mouseID_list),...
    'XTickLabel',mouseID_list);


for id_mouse = 1:length(mouseID_list)
    TS_temp = find(mouse_labels==id_mouse);
    n_TS = length(TS_temp);
    n_col = 4;
    if mod(n_TS,n_col)==0
        n_rows = floor(n_TS/n_col);
    else
        n_rows = floor(n_TS/n_col)+1;
    end
    %generate figures for all TS of same animal
    
%     fig_stats = figure('Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
    for id_TS = 1:n_TS
        load([exp_list(TS_temp(id_TS)).save_path 'params.mat']);
        if exist([exp_list(TS_temp(id_TS)).save_path 'analyses.mat'],'file')
            load([exp_list(TS_temp(id_TS)).save_path 'analyses.mat']);
            
            %run analyses only for data without stimulus
            if params.stimulus == 0
                load([exp_list(TS_temp(id_TS)).save_path 'processed_var.mat']);
                
                mouse_analyses(id_mouse).num_info_ROIs_L(id_TS) =...
                    analyses.info.num_info_whisk/params.numROIs;
                mouse_analyses(id_mouse).num_info_ROIs_W(id_TS) =...
                    analyses.info.num_info_locom/params.numROIs;
                mouse_analyses(id_mouse).avg_info_bits_L(id_TS) =...
                    mean(mean(analyses.info.info_locom(analyses.info.ID_info_locom,:)));
                mouse_analyses(id_mouse).avg_info_bits_W(id_TS) =...
                    mean(mean(analyses.info.info_whisk(analyses.info.ID_info_whisk,:)));
                mouse_analyses(id_mouse).pop_decoder_L(id_TS) =...
                    mean(analyses.decoder.locom.perc_correct);
                mouse_analyses(id_mouse).pop_decoder_W(id_TS) =...
                    mean(analyses.decoder.whisk.perc_correct);
                mouse_analyses(id_mouse).ROIs_decoder_L(id_TS) =...
                    mean(mean(analyses.decoder.locom.perc_correct_singleROIs));
                mouse_analyses(id_mouse).ROIs_decoder_W(id_TS) =...
                    mean(mean(analyses.decoder.whisk.perc_correct_singleROIs));
                if isfield(analyses.info,'info_states')
                    if isfield(analyses.info.info_states,'I_W') && isfield(analyses.info.info_states,'I_WL')
                        mouse_analyses(id_mouse).delta_IWL_IW(id_TS) =...
                            mean(analyses.info.info_states.I_WL-analyses.info.info_states.I_W);
                    else
                        mouse_analyses(id_mouse).delta_IWL_IW(id_TS) =NaN;
                    end
                    if isfield(analyses.info.info_states,'I_L') && isfield(analyses.info.info_states,'I_WL')
                        mouse_analyses(id_mouse).delta_IWL_IL(id_TS) =...
                            mean(analyses.info.info_states.I_WL-analyses.info.info_states.I_L);
                    else
                        mouse_analyses(id_mouse).delta_IWL_IL(id_TS) =NaN;
                    end
                else
                    mouse_analyses(id_mouse).delta_IWL_IW(id_TS) =NaN;
                    mouse_analyses(id_mouse).delta_IWL_IL(id_TS) =NaN;
                end
            end
            
        end
    end
    
%     subplot(2,4,1);
%     histogram(mouse_analyses(id_mouse).num_info_ROIs_L,'binWidth',0.1);
%     xlabel('% info ROIs L'); ylabel('# TS');
%     subplot(2,4,5);
%     histogram(mouse_analyses(id_mouse).num_info_ROIs_W,'binWidth',0.1);
%     xlabel('% info ROIs W'); ylabel('# TS');
%     
%     subplot(2,4,2);
%     histogram(mouse_analyses(id_mouse).avg_info_bits_L,'binWidth',0.1);
%     xlabel('avg bits L'); ylabel('# TS');
%     subplot(2,4,6);
%     histogram(mouse_analyses(id_mouse).avg_info_bits_W,'binWidth',0.1);
%     xlabel('avg bits W'); ylabel('# TS');
%     
%     subplot(2,4,3);
%     histogram(mouse_analyses(id_mouse).pop_decoder_L,'binWidth',10);
%     xlabel('pop L decoder perf'); ylabel('# TS');
%     subplot(2,4,7);
%     histogram(mouse_analyses(id_mouse).pop_decoder_W,'binWidth',10);
%     xlabel('pop W decoder perf'); ylabel('# TS');
%     
%     subplot(2,4,4);
%     histogram(mouse_analyses(id_mouse).ROIs_decoder_L,'binWidth',10);
%     xlabel('L decoder perf'); ylabel('# TS');
%     subplot(2,4,8);
%     histogram(mouse_analyses(id_mouse).ROIs_decoder_W,'binWidth',10);
%     xlabel('W decoder perf'); ylabel('# TS');
%     
%     
%     saveas(fig_stats,[mouse_list(id_mouse).save_path mouse_list(id_mouse).ID '_stats.fig']);
%     saveas(fig_stats,[mouse_list(id_mouse).save_path mouse_list(id_mouse).ID '_stats.png']);
%     close(fig_stats);
    
%     figure(fig_num_info_L);
%     hold on;
%     scatter(id_mouse*ones(1,n_TS),mouse_analyses(id_mouse).num_info_ROIs_L,50);
%     hold on;
%     plot(id_mouse,nanmean(mouse_analyses(id_mouse).num_info_ROIs_L),'s','Color','k','LineWidth',2);
%     errorbar(id_mouse,nanmean(mouse_analyses(id_mouse).num_info_ROIs_L),...
%         nanstd(mouse_analyses(id_mouse).num_info_ROIs_L)/...
%         sqrt(length(mouse_analyses(id_mouse).num_info_ROIs_L)),'k');
%     ylabel('% L informative ROIs');
%     xlabel('mouse ID');
%     
%     figure(fig_num_info_W);
%     hold on;
%     scatter(id_mouse*ones(1,n_TS),mouse_analyses(id_mouse).num_info_ROIs_W,50);
%     hold on;
%     plot(id_mouse,nanmean(mouse_analyses(id_mouse).num_info_ROIs_W),'s','Color','k','LineWidth',2);
%     errorbar(id_mouse,nanmean(mouse_analyses(id_mouse).num_info_ROIs_W),...
%         nanstd(mouse_analyses(id_mouse).num_info_ROIs_W)/...
%         sqrt(length(mouse_analyses(id_mouse).num_info_ROIs_W)),'k');
%     ylabel('% W informative ROIs');
%     xlabel('mouse ID');
%     
%     figure(fig_bits_info_L);
%     hold on;
%     scatter(id_mouse*ones(1,n_TS),mouse_analyses(id_mouse).avg_info_bits_L,50);
%     hold on;
%     plot(id_mouse,nanmean(mouse_analyses(id_mouse).avg_info_bits_L),'s','Color','k','LineWidth',2);
%     errorbar(id_mouse,nanmean(mouse_analyses(id_mouse).avg_info_bits_L),...
%         nanstd(mouse_analyses(id_mouse).avg_info_bits_L)/...
%         sqrt(length(mouse_analyses(id_mouse).avg_info_bits_L)),'k');
%     ylabel('% L bits informative ROIs');
%     xlabel('mouse ID');
%     
%     figure(fig_bits_info_W);
%     hold on;
%     scatter(id_mouse*ones(1,n_TS),mouse_analyses(id_mouse).avg_info_bits_W,50);
%     hold on;
%     plot(id_mouse,nanmean(mouse_analyses(id_mouse).avg_info_bits_W),'s','Color','k','LineWidth',2);
%     errorbar(id_mouse,nanmean(mouse_analyses(id_mouse).avg_info_bits_W),...
%         nanstd(mouse_analyses(id_mouse).avg_info_bits_W)/...
%         sqrt(length(mouse_analyses(id_mouse).avg_info_bits_W)),'k');
%     ylabel('% W bits informative ROIs');
%     xlabel('mouse ID');
%     
%     figure(fig_pop_decoder_L);
%     hold on;
%     scatter(id_mouse*ones(1,n_TS),mouse_analyses(id_mouse).pop_decoder_L,50);
%     hold on;
%     plot(id_mouse,nanmean(mouse_analyses(id_mouse).pop_decoder_L),'s','Color','k','LineWidth',2);
%     errorbar(id_mouse,nanmean(mouse_analyses(id_mouse).pop_decoder_L),...
%         nanstd(mouse_analyses(id_mouse).pop_decoder_L)/...
%         sqrt(length(mouse_analyses(id_mouse).pop_decoder_L)),'k');
%     ylabel('% L mean activity decoder');
%     xlabel('mouse ID');
%     
%     figure(fig_pop_decoder_W);
%     hold on;
%     scatter(id_mouse*ones(1,n_TS),mouse_analyses(id_mouse).pop_decoder_W,50);
%     hold on;
%     plot(id_mouse,nanmean(mouse_analyses(id_mouse).pop_decoder_W),'s','Color','k','LineWidth',2);
%     errorbar(id_mouse,nanmean(mouse_analyses(id_mouse).pop_decoder_W),...
%         nanstd(mouse_analyses(id_mouse).pop_decoder_W)/...
%         sqrt(length(mouse_analyses(id_mouse).pop_decoder_W)),'k');
%     ylabel('% W mean activity decoder');
%     xlabel('mouse ID');
%     
%     figure(fig_ROI_decoder_L);
%     hold on;
%     scatter(id_mouse*ones(1,n_TS),mouse_analyses(id_mouse).ROIs_decoder_L,50);
%     hold on;
%     plot(id_mouse,nanmean(mouse_analyses(id_mouse).ROIs_decoder_L),'s','Color','k','LineWidth',2);
%     errorbar(id_mouse,nanmean(mouse_analyses(id_mouse).ROIs_decoder_L),...
%         nanstd(mouse_analyses(id_mouse).ROIs_decoder_L)/...
%         sqrt(length(mouse_analyses(id_mouse).ROIs_decoder_L)),'k');
%     ylabel('% L ROIs activity decoder');
%     xlabel('mouse ID');
%     
%     figure(fig_ROI_decoder_W);
%     hold on;
%     scatter(id_mouse*ones(1,n_TS),mouse_analyses(id_mouse).ROIs_decoder_W,50);
%     hold on;
%     plot(id_mouse,nanmean(mouse_analyses(id_mouse).ROIs_decoder_W),'s','Color','k','LineWidth',2);
%     errorbar(id_mouse,nanmean(mouse_analyses(id_mouse).ROIs_decoder_W),...
%         nanstd(mouse_analyses(id_mouse).ROIs_decoder_W)/...
%         sqrt(length(mouse_analyses(id_mouse).ROIs_decoder_W)),'k');
%     ylabel('% W ROIs activity decoder');
%     xlabel('mouse ID');

    figure(fig_deltaI_WL_W);
    hold on;
    scatter(id_mouse*ones(1,n_TS),mouse_analyses(id_mouse).delta_IWL_IW,50);
    hold on;
    plot(id_mouse,nanmean(mouse_analyses(id_mouse).delta_IWL_IW),'s','Color','k','LineWidth',2);
    errorbar(id_mouse,nanmean(mouse_analyses(id_mouse).delta_IWL_IW),...
        nanstd(mouse_analyses(id_mouse).delta_IWL_IW)/...
        sqrt(length(mouse_analyses(id_mouse).delta_IWL_IW)),'k');
    ylabel('deltaI WL-W');
    xlabel('mouse ID');
%     xlim([0 length(mouse_list)+1]);
    
    figure(fig_deltaI_WL_L);
    hold on;
    scatter(id_mouse*ones(1,n_TS),mouse_analyses(id_mouse).delta_IWL_IL,50);
    hold on;
    plot(id_mouse,nanmean(mouse_analyses(id_mouse).delta_IWL_IL),'s','Color','k','LineWidth',2);
    errorbar(id_mouse,nanmean(mouse_analyses(id_mouse).delta_IWL_IL),...
        nanstd(mouse_analyses(id_mouse).delta_IWL_IL)/...
        sqrt(length(mouse_analyses(id_mouse).delta_IWL_IL)),'k');
    ylabel('deltaI WL-L');
    xlabel('mouse ID');


end

% saveas(fig_num_info_L,[save_dir_summary 'num_info_L.fig']);
% saveas(fig_num_info_L,[save_dir_summary 'num_info_L.png']);
% close(fig_num_info_L);
% 
% saveas(fig_num_info_W,[save_dir_summary 'num_info_W.fig']);
% saveas(fig_num_info_W,[save_dir_summary 'num_info_W.png']);
% close(fig_num_info_W);
% 
% saveas(fig_bits_info_L,[save_dir_summary 'bits_info_L.fig']);
% saveas(fig_bits_info_L,[save_dir_summary 'bits_info_L.png']);
% close(fig_bits_info_L);
% 
% saveas(fig_bits_info_W,[save_dir_summary 'bits_info_W.fig']);
% saveas(fig_bits_info_W,[save_dir_summary 'bits_info_W.png']);
% close(fig_bits_info_W);
% 
% saveas(fig_pop_decoder_L,[save_dir_summary 'pop_decoder_L.fig']);
% saveas(fig_pop_decoder_L,[save_dir_summary 'pop_decoder_L.png']);
% close(fig_pop_decoder_L);
% 
% saveas(fig_pop_decoder_W,[save_dir_summary 'pop_decoder_W.fig']);
% saveas(fig_pop_decoder_W,[save_dir_summary 'pop_decoder_W.png']);
% close(fig_pop_decoder_W);
% 
% saveas(fig_ROI_decoder_L,[save_dir_summary 'ROI_decoder_L.fig']);
% saveas(fig_ROI_decoder_L,[save_dir_summary 'ROI_decoder_L.png']);
% close(fig_ROI_decoder_L);
% 
% saveas(fig_ROI_decoder_W,[save_dir_summary 'ROI_decoder_W.fig']);
% saveas(fig_ROI_decoder_W,[save_dir_summary 'ROI_decoder_W.png']);
% close(fig_ROI_decoder_W);

saveas(fig_deltaI_WL_W,[save_dir_summary 'deltaI_WL_W.fig']);
saveas(fig_deltaI_WL_W,[save_dir_summary 'deltaI_WL_W.png']);
close(fig_deltaI_WL_W);

saveas(fig_deltaI_WL_L,[save_dir_summary 'deltaI_WL_L.fig']);
saveas(fig_deltaI_WL_L,[save_dir_summary 'deltaI_WL_L.png']);
close(fig_deltaI_WL_L);