function [analyses,params] = correlations_distance_count_2(analyses,params)

corr_edges = -1:0.2:1;
dist_edges = 0:50:500; %um
params.corr_edges = corr_edges;
params.dist_edges = dist_edges;
num_perm = 250;
normal = 'probability';

% upper_part = triu(ones(params.numROIs,params.numROIs),1);
% upper_part(upper_part==0) = NaN;
% figure;
%keep only significant correlations
if isfield(analyses,'corr')
    corr_G = analyses.corr.global.values(analyses.corr.global.p<0.05);
    dist_G = analyses.corr.distances(analyses.corr.global.p<0.05);
    analyses.corr.global.sign.value = corr_G;
    analyses.corr.global.sign.dist = dist_G;
    
    [dist_G_tot,~,~] =...
        histcounts(dist_G,... 
        dist_edges,'Normalization',normal);
    subplot(3,6,1); plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
        dist_G_tot,'k','LineWidth',2);
    ylabel('p'); xlabel('dist'); title('G tot');
    [dist_G_pos,~,~] =...
        histcounts(dist_G(corr_G>=0),... 
        dist_edges,'Normalization',normal);
    subplot(3,6,7); plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
        dist_G_pos,'k','LineWidth',2);
    ylabel('p'); xlabel('dist'); title('G pos');
    [dist_G_neg,~,~] =...
        histcounts(dist_G(corr_G<0),... 
        dist_edges,'Normalization',normal);
    subplot(3,6,13); plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
        dist_G_neg,'k','LineWidth',2);
    ylabel('p'); xlabel('dist'); title('G neg');
    
    if isfield(analyses.corr,'Q')
        corr_Q = analyses.corr.Q.values(analyses.corr.Q.p<0.05);
        dist_Q = analyses.corr.distances(analyses.corr.Q.p<0.05);
        analyses.corr.Q.sign.value = corr_Q;
        analyses.corr.Q.sign.dist = dist_Q;
        [dist_Q_tot,~,~] =...
            histcounts(dist_Q,...
            dist_edges,'Normalization',normal);
        subplot(3,6,2); plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            dist_Q_tot,'k','LineWidth',2);
        ylabel('p'); xlabel('dist'); title('Q tot');
        [dist_Q_pos,~,~] =...
            histcounts(dist_Q(corr_Q>=0),...
            dist_edges,'Normalization',normal);
        subplot(3,6,8); plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            dist_Q_pos,'k','LineWidth',2);
        ylabel('p'); xlabel('dist'); title('Q pos');
        [dist_Q_neg,~,~] =...
            histcounts(dist_Q(corr_Q<0),...
            dist_edges,'Normalization',normal);
        subplot(3,6,14); plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            dist_Q_neg,'k','LineWidth',2);
        ylabel('p'); xlabel('dist'); title('Q neg');
    end
    
    if isfield(analyses.corr,'partial')
        corr_partial = analyses.corr.partial.values(analyses.corr.partial.p<0.05);
        dist_partial = analyses.corr.distances(analyses.corr.partial.p<0.05);
        analyses.corr.partial.sign.value = corr_partial;
        analyses.corr.partial.sign.dist = dist_partial;
        [dist_partial_tot,~,~] =...
            histcounts(dist_partial,...
            dist_edges,'Normalization',normal);
        subplot(3,6,3); plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            dist_partial_tot,'k','LineWidth',2);
        ylabel('p'); xlabel('dist'); title('partial tot');
        [dist_partial_pos,~,~] =...
            histcounts(dist_partial(corr_partial>=0),...
            dist_edges,'Normalization',normal);
        subplot(3,6,9); plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            dist_partial_pos,'k','LineWidth',2);
        ylabel('p'); xlabel('dist'); title('partial pos');
        [dist_partial_neg,~,~] =...
            histcounts(dist_partial(corr_partial<0),...
            dist_edges,'Normalization',normal);
        subplot(3,6,15); plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            dist_partial_neg,'k','LineWidth',2);
        ylabel('p'); xlabel('dist'); title('partial neg');
    end
    
    if isfield(analyses.corr,'W')
        corr_W = analyses.corr.W.values(analyses.corr.W.p<0.05);
        dist_W = analyses.corr.distances(analyses.corr.W.p<0.05);
        analyses.corr.W.sign.value = corr_W;
        analyses.corr.W.sign.dist = dist_W;
        [dist_W_tot,~,~] =...
            histcounts(dist_W,...
            dist_edges,'Normalization',normal);
        subplot(3,6,4); plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            dist_W_tot,'k','LineWidth',2);
        ylabel('p'); xlabel('dist'); title('W tot');
        [dist_W_pos,~,~] =...
            histcounts(dist_W(corr_W>=0),...
            dist_edges,'Normalization',normal);
        subplot(3,6,10); plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            dist_W_pos,'k','LineWidth',2);
        ylabel('p'); xlabel('dist'); title('W pos');
        [dist_W_neg,~,~] =...
            histcounts(dist_W(corr_W<0),...
            dist_edges,'Normalization',normal);
        subplot(3,6,16); plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            dist_W_neg,'k','LineWidth',2);
        ylabel('p'); xlabel('dist'); title('W neg');
    end
    
    if isfield(analyses.corr,'WL')
        corr_WL = analyses.corr.WL.values(analyses.corr.WL.p<0.05);
        dist_WL = analyses.corr.distances(analyses.corr.WL.p<0.05);
        analyses.corr.WL.sign.value = corr_WL;
        analyses.corr.WL.sign.dist = dist_WL;
        [dist_WL_tot,~,~] =...
            histcounts(dist_WL,...
            dist_edges,'Normalization',normal);
        subplot(3,6,5); plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            dist_WL_tot,'k','LineWidth',2);
        ylabel('p'); xlabel('dist'); title('WL tot');
        [dist_WL_pos,~,~] =...
            histcounts(dist_WL(corr_WL>=0),...
            dist_edges,'Normalization',normal);
        subplot(3,6,11); plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            dist_WL_pos,'k','LineWidth',2);
        ylabel('p'); xlabel('dist'); title('WL pos');
        [dist_WL_neg,~,~] =...
            histcounts(dist_WL(corr_WL<0),...
            dist_edges,'Normalization',normal);
        subplot(3,6,17); plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            dist_WL_neg,'k','LineWidth',2);
        ylabel('p'); xlabel('dist'); title('WL neg');
    end
    
    if isfield(analyses.corr,'T')aN;
        corr_T = analyses.corr.T.values(analyses.corr.T.p<0.05);
        dist_T = analyses.corr.distances(analyses.corr.T.p<0.05);
        analyses.corr.T.sign.value = corr_T;
        analyses.corr.T.sign.dist = dist_T;
        [dist_T_tot,~,~] =...
            histcounts(dist_T,...
            dist_edges,'Normalization',normal);
        subplot(3,6,6); plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            dist_T_tot,'k','LineWidth',2);
        ylabel('p'); xlabel('dist'); title('T tot');
        [dist_T_pos,~,~] =...
            histcounts(dist_T(corr_T>=0),...
            dist_edges,'Normalization',normal);
        subplot(3,6,12); plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            dist_T_pos,'k','LineWidth',2);
        ylabel('p'); xlabel('dist'); title('T pos');
        [dist_T_neg,~,~] =...
            histcounts(dist_T(corr_T<0),...
            dist_edges,'Normalization',normal);
        subplot(3,6,18); plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            dist_T_neg,'k','LineWidth',2);
        ylabel('p'); xlabel('dist'); title('T neg');
    end
    
    %shuffled values
    
    for ind_perm = 1:num_perm
        ind_shuffled = randperm(params.numROIs);
        
        shuffled_distances =...
            shuffle_mat(analyses.corr.distances,ind_shuffled);
        
        dist_G_sh = shuffled_distances(~isnan(analyses.corr.global.values));
        
        [dist_G_tot_sh(:,ind_perm),~,~] =...
            histcounts(dist_G_sh,...
            dist_edges,'Normalization',normal);
        [dist_G_pos_sh(:,ind_perm),~,~] =...
            histcounts(dist_G_sh(corr_G>=0),...
            dist_edges,'Normalization',normal);
        [dist_G_neg_sh(:,ind_perm),~,~] =...
            histcounts(dist_G_sh(corr_G<0),...
            dist_edges,'Normalization',normal);
        
        
        if isfield(analyses.corr,'Q')
            dist_Q_sh = shuffled_distances(~isnan(analyses.corr.Q.values));
            
            [dist_Q_tot_sh(:,ind_perm),~,~] =...
                histcounts(dist_Q_sh,...
                dist_edges,'Normalization',normal);
            [dist_Q_pos_sh(:,ind_perm),~,~] =...
                histcounts(dist_Q_sh(corr_Q>=0),...
                dist_edges,'Normalization',normal);
            [dist_Q_neg_sh(:,ind_perm),~,~] =...
                histcounts(dist_Q_sh(corr_Q<0),...
                dist_edges,'Normalization',normal);
        end
        
        if isfield(analyses.corr,'partial')
            dist_partial_sh = shuffled_distances(~isnan(analyses.corr.partial.values));
            
            [dist_partial_tot_sh(:,ind_perm),~,~] =...
                histcounts(dist_partial_sh,...
                dist_edges,'Normalization',normal);
            [dist_partial_pos_sh(:,ind_perm),~,~] =...
                histcounts(dist_partial_sh(corr_partial>=0),...
                dist_edges,'Normalization',normal);
            [dist_partial_neg_sh(:,ind_perm),~,~] =...
                histcounts(dist_partial_sh(corr_partial<0),...
                dist_edges,'Normalization',normal);
        end
        
        if isfield(analyses.corr,'W')
            dist_W_sh = shuffled_distances(~isnan(analyses.corr.W.values));
            
            [dist_W_tot_sh(:,ind_perm),~,~] =...
                histcounts(dist_W_sh,...
                dist_edges,'Normalization',normal);
            [dist_W_pos_sh(:,ind_perm),~,~] =...
                histcounts(dist_W_sh(corr_W>=0),...
                dist_edges,'Normalization',normal);
            [dist_W_neg_sh(:,ind_perm),~,~] =...
                histcounts(dist_W_sh(corr_W<0),...
                dist_edges,'Normalization',normal);
        end
        
        if isfield(analyses.corr,'WL')
            dist_WL_sh = shuffled_distances(~isnan(analyses.corr.WL.values));
            
            [dist_WL_tot_sh(:,ind_perm),~,~] =...
                histcounts(dist_WL_sh,...
                dist_edges,'Normalization',normal);
            [dist_WL_pos_sh(:,ind_perm),~,~] =...
                histcounts(dist_WL_sh(corr_WL>=0),...
                dist_edges,'Normalization',normal);
            [dist_WL_neg_sh(:,ind_perm),~,~] =...
                histcounts(dist_WL_sh(corr_WL<0),...
                dist_edges,'Normalization',normal);
        end
        
        if isfield(analyses.corr,'T')
            dist_T_sh = shuffled_distances(~isnan(analyses.corr.T.values));
            
            [dist_T_tot_sh(:,ind_perm),~,~] =...
                histcounts(dist_T_sh,...
                dist_edges,'Normalization',normal);
            [dist_T_pos_sh(:,ind_perm),~,~] =...
                histcounts(dist_T_sh(corr_T>=0),...
                dist_edges,'Normalization',normal);
            [dist_T_neg_sh(:,ind_perm),~,~] =...
                histcounts(dist_T_sh(corr_T<0),...
                dist_edges,'Normalization',normal);
        end
        
        
    end
    
    hold on;
    subplot(3,6,1); hold on;
    errorbar(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
        mean(dist_G_tot_sh,2),std(dist_G_tot_sh,[],2),'r','LineWidth',1);
    ylim([0 Inf]);
    dist_G_tot_sh = mean(dist_G_tot_sh,2);
    hold on;
    subplot(3,6,7); hold on;
    errorbar(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
        mean(dist_G_pos_sh,2),std(dist_G_pos_sh,[],2),'r','LineWidth',1);
    ylim([0 Inf]);
    dist_G_pos_sh = mean(dist_G_pos_sh,2);
    hold on;
    subplot(3,6,13); hold on;
    errorbar(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
        mean(dist_G_neg_sh,2),std(dist_G_neg_sh,[],2),'r','LineWidth',1);
    ylim([0 Inf]);
    dist_G_neg_sh = mean(dist_G_neg_sh,2);
    
    if isfield(analyses.corr,'Q')
        hold on;
        subplot(3,6,2); hold on;
        errorbar(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            mean(dist_Q_tot_sh,2),std(dist_Q_tot_sh,[],2),'r','LineWidth',1);
        ylim([0 Inf]);
        dist_Q_tot_sh = mean(dist_Q_tot_sh,2);
        hold on;
        subplot(3,6,8); hold on;
        errorbar(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            mean(dist_Q_pos_sh,2),std(dist_Q_pos_sh,[],2),'r','LineWidth',1);
        ylim([0 Inf]);
        dist_Q_pos_sh = mean(dist_Q_pos_sh,2);
        hold on;
        subplot(3,6,14); hold on;
        errorbar(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            mean(dist_Q_neg_sh,2),std(dist_Q_neg_sh,[],2),'r','LineWidth',1);
        ylim([0 Inf]);
        dist_Q_neg_sh = mean(dist_Q_neg_sh,2);
    end
    if isfield(analyses.corr,'partial')
        hold on;
        subplot(3,6,3); hold on;
        errorbar(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            mean(dist_partial_tot_sh,2),std(dist_partial_tot_sh,[],2),'r','LineWidth',1);
        ylim([0 Inf]);
        dist_partial_tot_sh = mean(dist_partial_tot_sh,2);
        hold on;
        subplot(3,6,9); hold on;
        errorbar(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            mean(dist_partial_pos_sh,2),std(dist_partial_pos_sh,[],2),'r','LineWidth',1);
        ylim([0 Inf]);
        dist_partial_pos_sh = mean(dist_partial_pos_sh,2);
        subplot(3,6,15); hold on;
        errorbar(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            mean(dist_partial_neg_sh,2),std(dist_partial_neg_sh,[],2),'r','LineWidth',1);
        ylim([0 Inf]);
        dist_partial_neg_sh = mean(dist_partial_neg_sh,2);
    end
    if isfield(analyses.corr,'W')
        hold on;
        subplot(3,6,4); hold on;
        errorbar(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            mean(dist_W_tot_sh,2),std(dist_W_tot_sh,[],2),'r','LineWidth',1);
        ylim([0 Inf]);
        dist_W_tot_sh = mean(dist_W_tot_sh,2);
        hold on;
        subplot(3,6,10); hold on;
        errorbar(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            mean(dist_W_pos_sh,2),std(dist_W_pos_sh,[],2),'r','LineWidth',1);
        ylim([0 Inf]);
        dist_W_pos_sh = mean(dist_W_pos_sh,2);
        subplot(3,6,16); hold on;
        errorbar(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            mean(dist_W_neg_sh,2),std(dist_W_neg_sh,[],2),'r','LineWidth',1);
        ylim([0 Inf]);
        dist_W_neg_sh = mean(dist_W_neg_sh,2);
    end
    if isfield(analyses.corr,'WL')
        hold on;
        subplot(3,6,5); hold on;
        errorbar(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            mean(dist_WL_tot_sh,2),std(dist_WL_tot_sh,[],2),'r','LineWidth',1);
        ylim([0 Inf]);
        dist_WL_tot_sh = mean(dist_WL_tot_sh,2);
        hold on;
        subplot(3,6,11); hold on;
        errorbar(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            mean(dist_WL_pos_sh,2),std(dist_WL_pos_sh,[],2),'r','LineWidth',1);
        ylim([0 Inf]);
        dist_WL_pos_sh = mean(dist_WL_pos_sh,2);
        subplot(3,6,17); hold on;
        errorbar(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            mean(dist_WL_neg_sh,2),std(dist_WL_neg_sh,[],2),'r','LineWidth',1);
        ylim([0 Inf]);
        dist_WL_neg_sh = mean(dist_WL_neg_sh,2);
    end

    if isfield(analyses.corr,'T')
        hold on;
        subplot(3,6,6); hold on;
        errorbar(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            mean(dist_T_tot_sh,2),std(dist_T_tot_sh,[],2),'r','LineWidth',1);
        ylim([0 Inf]);
        dist_T_tot_sh = mean(dist_T_tot_sh,2);
        hold on;
        subplot(3,6,12); hold on;
        errorbar(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            mean(dist_T_pos_sh,2),std(dist_T_pos_sh,[],2),'r','LineWidth',1);
        ylim([0 Inf]);
        dist_T_pos_sh = mean(dist_T_pos_sh,2);
        subplot(3,6,18); hold on;
        errorbar(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            mean(dist_T_neg_sh,2),std(dist_T_neg_sh,[],2),'r','LineWidth',1);
        ylim([0 Inf]);
        dist_T_neg_sh = mean(dist_T_neg_sh,2);
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
