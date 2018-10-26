function [] = plot_info_distance(numROIs, rois_centers, info_matrix)

scatter( sqrt((rois_centers(:,2)+...
    rois_centers(:,1)).^2),...
    mean(info_matrix,2));
if numROIs>1
    [r,p] = corrcoef(sqrt((rois_centers(:,2)+...
        rois_centers(:,1)).^2), mean(info_matrix,2));
    
    text(0.65,0.95,['corr = ' num2str(r(1,2))],'Units','normalized');
    text(0.65,0.9,['p-val = ' num2str(p(1,2))],'Units','normalized');
end
end