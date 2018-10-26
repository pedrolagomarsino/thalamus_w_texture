function [] = plot_info_distance_single_exp(data,analyses,params)


if isfield(analyses,'info')
    if isfield(analyses.info,'info_whisk')
        %plot whisking informative ROIs
        plot_info_distance(params.numROIs, data.rois_centers, analyses.info.info_whisk);
        xlabel('dist from center');
        ylabel('info W (bits)');
        
    end
end
