function [data,analyses] = cut_L_only_frames(data,analyses)

%id L only
id_L = find(analyses.behavior.states_vector == 2);

%cut everything
analyses.behavior.states_vector(id_L)=[];
data.time_ca(end-length(id_L)+1:end)=[];
data.Fraw(:,id_L)=[];
data.C_df(:,id_L)=[];
data.peaks(:,id_L)=[];
data.peaks_bin(:,id_L)=[];
data.speed(id_L)=[];
data.pupil(id_L)=[];
data.pupil_norm(id_L)=[];
data.whisk_angle(id_L)=[];
data.locomotion(id_L)=[];
data.whisking(id_L)=[];
data.stimulus(id_L)=[];