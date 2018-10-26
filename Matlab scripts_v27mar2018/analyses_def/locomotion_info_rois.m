function analyses = locomotion_info_rois(data,analyses,params)

%% information theory
original_settings = params.usePeaks;
if params.stimulus == 0
    params.usePeaks = 0;
    
    info_locom_tot = information_binary(data, data.locomotion, params);

    analyses.info.info_locom = info_locom_tot;
    analyses.info.num_info_locom = length(find(mean(info_locom_tot,2)>0));
    analyses.info.ID_info_locom = find(mean(info_locom_tot,2)>0);
    analyses.info.dist_pair_info_locom =...
        pdist(data.rois_centers(analyses.info.ID_info_locom,:))*params.mm_px;
    
else
    
end
%set back original values for analyses with/without peaks
params.usePeaks = original_settings;
params.usePeaks = original_settings;