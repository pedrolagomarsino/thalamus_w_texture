function [] = plot_decoding_map_single_exp(data,analyses,params)

if isfield(analyses,'decoder')
    if isfield(analyses.decoder,'Q_W_WL')
        %plot locomotion informative ROIs
        subplot(1,2,1);
        plot_decoding_map(data.corr_projection,params.numROIs,...
            data.rois_centers,analyses.decoder.Q_W_WL);
        title(['Q_W_WL DECODING population = ' num2str(mean(analyses.decoder.Q_W_WL.perc_correct))]);
    end
    
    if isfield(analyses.decoder,'whisk')
        %plot locomotion informative ROIs
        subplot(1,2,2);
        plot_decoding_map(data.corr_projection,params.numROIs,...
            data.rois_centers,analyses.decoder.whisk);
        title(['whisking DECODING population = ' num2str(mean(analyses.decoder.whisk.perc_correct))]);
    end
end