function [data_cut,params_cut] = cut_FOV_radius(data,params,radius)

data_cut = data;
params_cut = params;

cut_rois = zeros(size(data.C_df,1),1);

x_FOV = size(data.corr_projection,2)*params.mm_px;
y_FOV = size(data.corr_projection,1)*params.mm_px;

% center is the real center
random_center_x = x_FOV/2;
random_center_y = y_FOV/2;

for ind_ROI = 1:size(data.C_df,1)
    
    x(ind_ROI) = data.rois_centers(ind_ROI,1)*params.mm_px;
    y(ind_ROI) = data.rois_centers(ind_ROI,2)*params.mm_px;
    
    dist(ind_ROI) = sqrt((x(ind_ROI)-random_center_x)^2 + (y(ind_ROI)-random_center_y)^2);
    if dist(ind_ROI) > radius
        cut_rois(ind_ROI) = 1;
    end
end
% figure; histogram(dist);

data_cut.rois_centers(find(cut_rois),:)=[];
data_cut.Fraw(find(cut_rois),:)=[];
data_cut.C_df(find(cut_rois),:)=[];
params_cut.numROIs = sum(cut_rois==0);
data_cut.A(:,find(cut_rois))=[];



params_cut.max_n_mod = params_cut.numROIs; %max number of modules for NMF
peakData = zeros(size(data_cut.C_df)); %find C_df peaks
for i = 1:size(peakData,1)
    [pks,locs] = findpeaks(data_cut.C_df(i,:));
    peakData(i,locs) = pks;
end
binPeakData = double(peakData>0);
data_cut.peaks = peakData; %peaks with amplitude
data_cut.peaks_bin = binPeakData; %binary peaks