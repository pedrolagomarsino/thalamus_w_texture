function [analyses,params] = correlations_distance_count(analyses,params)

corr_edges = -1:0.2:1;
dist_edges = 0:50:500; %um
params.corr_edges = corr_edges;
params.dist_edges = dist_edges;
num_perm = 250;
normal = 'probability';

% upper_part = triu(ones(params.numROIs,params.numROIs),1);
% upper_part(upper_part==0) = NaN;


%real values
if isfield(analyses,'corr')
    [analyses.corr.corr_dist_G,~,~] =...
        histcounts2(analyses.corr.global.values,...
        analyses.corr.distances,...
        corr_edges,dist_edges,'Normalization',normal);
    
    if isfield(analyses.corr,'Q')
        [analyses.corr.corr_dist_Q,~,~] =...
            histcounts2(analyses.corr.Q.values,...
            analyses.corr.distances,...
            corr_edges,dist_edges,'Normalization',normal);
    end
    if isfield(analyses.corr,'W')
        [analyses.corr.corr_dist_W,~,~] =...
            histcounts2(analyses.corr.W.values,...
            analyses.corr.distances,...
            corr_edges,dist_edges,'Normalization',normal);
    end
    if isfield(analyses.corr,'WL')
        [analyses.corr.corr_dist_WL,~,~] =...
            histcounts2(analyses.corr.WL.values,...
            analyses.corr.distances,...
            corr_edges,dist_edges,'Normalization',normal);
    end
    if isfield(analyses.corr,'partial')
        [analyses.corr.corr_dist_partial,~,~] =...
            histcounts2(analyses.corr.partial.values,...
            analyses.corr.distances,...
            corr_edges,dist_edges,'Normalization',normal);
    end
    if isfield(analyses.corr,'T')
        [analyses.corr.corr_dist_T,~,~] =...
            histcounts2(analyses.corr.T.values,...
            analyses.corr.distances,...
            corr_edges,dist_edges,'Normalization',normal);
    end
    
    
    
    
    %shuffled values
    %initialize shuffled array
    corr_hist_G_sh = zeros([size(analyses.corr.corr_dist_G),num_perm]);
    if isfield(analyses.corr,'Q')
        corr_hist_Q_sh = zeros([size(analyses.corr.corr_dist_G),num_perm]);
    end
    if isfield(analyses.corr,'W')
        corr_hist_W_sh = zeros([size(analyses.corr.corr_dist_G),num_perm]);
    end
    if isfield(analyses.corr,'WL')
        corr_hist_WL_sh = zeros([size(analyses.corr.corr_dist_G),num_perm]);
    end
    if isfield(analyses.corr,'partial')
        corr_hist_partial_sh = zeros([size(analyses.corr.corr_dist_G),num_perm]);
    end
    if isfield(analyses.corr,'T')
        corr_hist_T_sh = zeros([size(analyses.corr.corr_dist_G),num_perm]);
    end
    
    for ind_perm = 1:num_perm
        ind_shuffled = randperm(params.numROIs);
        
        shuffled_distances =...
            shuffle_mat(analyses.corr.distances,ind_shuffled);
        
        %     corr_shuffled_G =...
        %         shuffle_mat(analyses.corr.global.values,ind_shuffled);
        %     %         pvalues_shuffled_G =...
        %     %             shuffle_mat(analyses.corr.global.p,ind_shuffled);
        [corr_hist_G_sh(:,:,ind_perm),~,~] =...
            histcounts2(analyses.corr.global.values,shuffled_distances,...
            corr_edges,dist_edges,'Normalization',normal);
        
        if isfield(analyses.corr,'Q')
            %         corr_shuffled_Q =...
            %             shuffle_mat(analyses.corr.Q.values,ind_shuffled);
            %         %             pvalues_shuffled_Q =...
            %         %                 shuffle_mat(analyses.corr.Q.p,ind_shuffled);
            [corr_hist_Q_sh(:,:,ind_perm),~,~] =...
                histcounts2(analyses.corr.Q.values,shuffled_distances,...
                corr_edges,dist_edges,'Normalization',normal);
        end
        if isfield(analyses.corr,'W')
            %         corr_shuffled_W =...
            %             shuffle_mat(analyses.corr.W.values,ind_shuffled);
            %         %             pvalues_shuffled_W =...
            %         %                 shuffle_mat(analyses.corr.W.p,ind_shuffled);
            [corr_hist_W_sh(:,:,ind_perm),~,~] =...
                histcounts2(analyses.corr.W.values,shuffled_distances,...
                corr_edges,dist_edges,'Normalization',normal);
        end
        if isfield(analyses.corr,'WL')
            %         corr_shuffled_WL =...
            %             shuffle_mat(analyses.corr.WL.values,ind_shuffled);
            %         %             pvalues_shuffled_WL =...
            %         %                 shuffle_mat(analyses.corr.WL.p,ind_shuffled);
            [corr_hist_WL_sh(:,:,ind_perm),~,~] =...
                histcounts2(analyses.corr.WL.values,shuffled_distances,...
                corr_edges,dist_edges,'Normalization',normal);
        end
        if isfield(analyses.corr,'partial')
            %         corr_shuffled_L =...
            %             shuffle_mat(analyses.corr.L.values,ind_shuffled);
            %         %             pvalues_shuffled_L =...
            %         %                 shuffle_mat(analyses.corr.L.p,ind_shuffled);
            [corr_hist_partial_sh(:,:,ind_perm),~,~] =...
                histcounts2(analyses.corr.partial.values,shuffled_distances,...
                corr_edges,dist_edges,'Normalization',normal);
        end
        if isfield(analyses.corr,'T')
            %         corr_shuffled_T =...
            %             shuffle_mat(analyses.corr.T.values,ind_shuffled);
            %         %             pvalues_shuffled_T =...
            %         %                 shuffle_mat(analyses.corr.T.p,ind_shuffled);
            [corr_hist_T_sh(:,:,ind_perm),~,~] =...
                histcounts2(analyses.corr.T.values,shuffled_distances,...
                corr_edges,dist_edges,'Normalization',normal);
        end
    end
    
    analyses.corr.shuffled.corr_dist_G = mean(corr_hist_G_sh,3);
    if isfield(analyses.corr,'Q')
        analyses.corr.shuffled.corr_dist_Q = mean(corr_hist_Q_sh,3);
    end
    if isfield(analyses.corr,'W')
        analyses.corr.shuffled.corr_dist_W = mean(corr_hist_W_sh,3);
    end
    if isfield(analyses.corr,'WL')
        analyses.corr.shuffled.corr_dist_WL = mean(corr_hist_WL_sh,3);
    end
    if isfield(analyses.corr,'partial')
        analyses.corr.shuffled.corr_dist_partial = mean(corr_hist_partial_sh,3);
    end
    if isfield(analyses.corr,'T')
        analyses.corr.shuffled.corr_dist_T = mean(corr_hist_T_sh,3);
    end
    
end

end

function M_shuffled= shuffle_mat(M,ind_perm)

M_shuffled = zeros(size(M));
upper_part = triu(ones(size(M)),1);
upper_part(upper_part==0) = NaN;

M(isnan(M)) = 0;
M = M+M';
for i = 1:size(M,1)
    for j = 2:size(M,2)
        M_shuffled(i,j) = M(ind_perm(i),ind_perm(j));
    end
end
M_shuffled = M_shuffled.*upper_part;

end
