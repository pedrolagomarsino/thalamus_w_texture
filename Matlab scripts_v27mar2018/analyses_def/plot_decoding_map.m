function [] = plot_decoding_map(projection,numROIs,rois_centers,decoder_perf)

imagesc(projection); colormap('gray'); axis image;
for indROI = 1:numROIs
    if mean(decoder_perf.perc_correct_singleROIs(indROI,:))>0
        hold on; scatter(rois_centers(indROI,2),...
            rois_centers(indROI,1),...
            mean(decoder_perf.perc_correct_singleROIs(indROI,:)),...
            'MarkerFaceColor','r',...
            'MarkerEdgeColor','r');
        if mod(indROI,5)==0
            text(rois_centers(indROI,2),...
                rois_centers(indROI,1),...
                num2str(mean(decoder_perf.perc_correct_singleROIs(indROI,:))),...
                'Color','y');
        end
    else
        hold on; scatter(rois_centers(indROI,2),...
            rois_centers(indROI,1),...
            10,...
            'MarkerFaceColor','y',...
            'MarkerEdgeColor','y');
    end
    title(['population decoding= ' num2str(mean(decoder_perf.perc_correct))]);
    set(gca,'XTick',[],'yTick',[],'XTickLabel',{},'YTickLabel',{},...
        'FontSize',10);
end

end