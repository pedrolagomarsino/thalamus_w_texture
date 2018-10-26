function [] = plot_info_map_single_exp(data,analyses,params)

if isfield(analyses,'info')
    if isfield(analyses.info,'info_whisk')
        %plot whisking informative ROIs
        plot_info_map(data.corr_projection, params.numROIs,...
            data.rois_centers, analyses.info.info_whisk);
        title('whisking MODULATED ROIS (red)')
    end
end