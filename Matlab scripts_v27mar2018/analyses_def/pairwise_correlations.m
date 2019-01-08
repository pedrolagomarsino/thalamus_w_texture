function analyses = pairwise_correlations(data,analyses,params)
%correlations: columns are global, Q, W, WL (and T)  

calcium = data.C_df;
% calcium = data.S;
vector_states = analyses.behavior.states_vector;
if params.stimulus~=0
    %recompute state vector
    vector_T = data.stimulus;
    vector_states(vector_T==1) = 5;
end
centers = data.rois_centers;

upper_part = triu(ones(params.numROIs,params.numROIs),1);
upper_part(upper_part==0) = NaN;

if params.numROIs>1
    %compute correlations and p-values for different conditions
    [corr_G, pvalue_G] = corr(calcium');
    analyses.corr.global.values = corr_G.*upper_part;
    analyses.corr.global.p = pvalue_G.*upper_part;
    [corr_partial, pvalue_partial] = partialcorr(calcium',vector_states);
    analyses.corr.partial.values = corr_partial.*upper_part;
    analyses.corr.partial.p = pvalue_partial.*upper_part;

    if sum(vector_states==0)>1 %Quiet
        [corr_Q, pvalue_Q] = corr(calcium(:,vector_states==0)');
        analyses.corr.Q.values = corr_Q.*upper_part;
        analyses.corr.Q.p = pvalue_Q.*upper_part;
    end
    if sum(vector_states==1)>1 %Whisking
        [corr_W, pvalue_W] = corr(calcium(:,vector_states==1)');
        analyses.corr.W.values = corr_W.*upper_part;
        analyses.corr.W.p = pvalue_W.*upper_part;
    end
    if sum(vector_states==2)>1 %Locomotion
        [corr_L, pvalue_L] = corr(calcium(:,vector_states==2)');
        analyses.corr.L.values = corr_L.*upper_part;
        analyses.corr.L.p = pvalue_L.*upper_part;
    end
    if sum(vector_states==3)>1 %Whisking and Locomotion
        [corr_WL, pvalue_WL] = corr(calcium(:,vector_states==3)');
        analyses.corr.WL.values = corr_WL.*upper_part;
        analyses.corr.WL.p = pvalue_WL.*upper_part;
    end
    if sum(vector_states==5)>1 %Texture
        [corr_T, pvalue_T] = corr(calcium(:,vector_states==5)');
        analyses.corr.T.values = corr_T.*upper_part;
        analyses.corr.T.p = pvalue_T.*upper_part;
    end
    
    % compute pairwise distances
    pair_dist = pdist(centers)*params.mm_px;
    analyses.corr.distances = squareform(pair_dist).*upper_part;
    
else
    %there is only 1 ROI, no correlations!
end
