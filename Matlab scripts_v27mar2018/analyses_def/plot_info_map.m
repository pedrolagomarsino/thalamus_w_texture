function [] = plot_info_map(projection, numROIs, rois_centers, info_matrix)

imagesc(projection); colormap('gray'); axis image;
for indROI = 1:numROIs
    if mean(info_matrix(indROI,:))>0
        hold on; scatter(rois_centers(indROI,2),...
            rois_centers(indROI,1),...
            10 + mean(info_matrix(indROI,:))*90,...
            'MarkerFaceColor','r',...
            'MarkerEdgeColor','r');
    else
        hold on; scatter(rois_centers(indROI,2),...
            rois_centers(indROI,1),...
            10,...
            'MarkerFaceColor','y',...
            'MarkerEdgeColor','y');
    end
    set(gca,'XTick',[],'yTick',[],'XTickLabel',{},'YTickLabel',{},...
        'FontSize',10);
end
end