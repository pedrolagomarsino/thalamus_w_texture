function [] = plot_info_map_W_and_WL(data,analyses,params)

if isfield(analyses,'info')
    if isfield(analyses.info,'info_states')
        if isfield(analyses.info.info_states,'I_WL')
            %plot L_only informative ROIs
            subplot(1,2,2);
            plot_info_map(data.corr_projection, params.numROIs,...
                data.rois_centers, analyses.info.info_states.I_WL);
            title('WL MODULATED ROIS (red)')
        end
        if isfield(analyses.info.info_states,'I_W')
            %plot L_only informative ROIs
            subplot(1,2,1);
            plot_info_map(data.corr_projection, params.numROIs,...
                data.rois_centers, analyses.info.info_states.I_W);
            title('W MODULATED ROIS (red)')
        end
    end
end