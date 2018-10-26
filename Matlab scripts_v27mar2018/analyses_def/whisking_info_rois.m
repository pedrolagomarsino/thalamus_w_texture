function analyses = whisking_info_rois(data,analyses,params)

%% information theory
original_settings = params.usePeaks;
if params.stimulus == 0
    params.usePeaks = 0;
     
    %only whisking
    stimulus_bin = (analyses.behavior.states_vector==1)+0;
%     stimulus_bin = data.whisking;
    info_whisk_tot = information_binary(data, stimulus_bin, params);

    analyses.info.info_whisk = info_whisk_tot;
    analyses.info.num_info_whisk = length(find(mean(info_whisk_tot,2)>0));
    analyses.info.ID_info_whisk = find(mean(info_whisk_tot,2)>0);
    analyses.info.dist_pair_info_whisk =...
        pdist(data.rois_centers(analyses.info.ID_info_whisk,:))*params.mm_px;
    
else
    
end
%set back original values for analyses with/without peaks
params.usePeaks = original_settings;
params.usePeaks = original_settings;