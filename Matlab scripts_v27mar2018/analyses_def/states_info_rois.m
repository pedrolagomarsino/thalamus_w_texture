function analyses = states_info_rois(data,analyses,params)

%% information theory
original_settings = params.usePeaks;
if params.stimulus == 0
    params.usePeaks = 0;
     
    info_states = information_W_L_WL(data, analyses.behavior.states_vector, params);
    analyses.info.info_states = info_states;    
else
    
end
%set back original values for analyses with/without peaks
params.usePeaks = original_settings;
params.usePeaks = original_settings;