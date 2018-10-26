function [] = summary_corr_plot(analyses,params)

dist_edges = 0:50:500; %um
normal = 'probability';

if isfield(analyses, 'corr')

    corr_box = [];
    group_box = [];
    corr_s_box = [];
    group_s_box = [];
    perc_corr_sign = [];
    perc_corr_sign_pos = [];
    perc_corr_sign_neg = [];
    corr_G = analyses.corr.global.values(~isnan(analyses.corr.global.values));
    corr_box = [corr_box; corr_G];
    group_box = [group_box; char('G'*ones(length(corr_G),1))];
    corr_s_box = [corr_s_box; analyses.corr.global.sign.value];
    group_s_box = [group_s_box; char('G'*ones(length(analyses.corr.global.sign.value),1))];
    perc_corr_sign = [perc_corr_sign length(analyses.corr.global.sign.value)/length(corr_G)];
    perc_corr_sign_pos = [perc_corr_sign_pos sum(analyses.corr.global.sign.value>0)/length(corr_G)];
    perc_corr_sign_neg = [perc_corr_sign_neg sum(analyses.corr.global.sign.value<0)/length(corr_G)];
    
    subplot(2,6,7);
    plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
        histcounts(analyses.corr.global.sign.dist,... 
        dist_edges,'Normalization',normal),'k');
    subplot(2,6,7);
    hold on;
    plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
        histcounts(analyses.corr.global.sign.dist(analyses.corr.global.sign.value>0),... 
        dist_edges,'Normalization',normal),'b');
    subplot(2,6,7);
    hold on;
    plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
        histcounts(analyses.corr.global.sign.dist(analyses.corr.global.sign.value<0),... 
        dist_edges,'Normalization',normal),'r');
    xlabel('dist (um)'); ylabel('prob');
    %legend('all','pos','neg');
    %Pedro mod
    title('G');

    
    if isfield(analyses.corr, 'partial')
        corr_P = analyses.corr.partial.values(~isnan(analyses.corr.partial.values));
        corr_box = [corr_box; corr_P];
        group_box = [group_box; char('P'*ones(length(corr_P),1))];
        corr_s_box = [corr_s_box; analyses.corr.partial.sign.value];
        group_s_box = [group_s_box; char('P'*ones(length(analyses.corr.partial.sign.value),1))];
        perc_corr_sign = [perc_corr_sign length(analyses.corr.partial.sign.value)/length(corr_P)];
        perc_corr_sign_pos = [perc_corr_sign_pos sum(analyses.corr.partial.sign.value>0)/length(corr_P)];
        perc_corr_sign_neg = [perc_corr_sign_neg sum(analyses.corr.partial.sign.value<0)/length(corr_P)];
    
        subplot(2,6,8);
        hold on; plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            histcounts(analyses.corr.partial.sign.dist,...
            dist_edges,'Normalization',normal),'k');
        subplot(2,6,8);
        hold on; plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            histcounts(analyses.corr.partial.sign.dist(analyses.corr.partial.sign.value>0),...
            dist_edges,'Normalization',normal),'b');
        subplot(2,6,8);
        hold on; plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            histcounts(analyses.corr.partial.sign.dist(analyses.corr.partial.sign.value<0),...
            dist_edges,'Normalization',normal),'r');
        xlabel('dist (um)'); ylabel('prob');
        %legend('all','pos','neg');
        %Pedro mod
        title('P');
    
    end
    if isfield(analyses.corr, 'Q')
        corr_Q = analyses.corr.Q.values(~isnan(analyses.corr.Q.values));
        corr_box = [corr_box; corr_Q];
        group_box = [group_box; char('Q'*ones(length(corr_Q),1))];
        corr_s_box = [corr_s_box; analyses.corr.Q.sign.value];
        group_s_box = [group_s_box; char('Q'*ones(length(analyses.corr.Q.sign.value),1))];
        perc_corr_sign = [perc_corr_sign length(analyses.corr.Q.sign.value)/length(corr_Q)];
        perc_corr_sign_pos = [perc_corr_sign_pos sum(analyses.corr.Q.sign.value>0)/length(corr_Q)];
        perc_corr_sign_neg = [perc_corr_sign_neg sum(analyses.corr.Q.sign.value<0)/length(corr_Q)];
        subplot(2,6,9);
        hold on; plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            histcounts(analyses.corr.Q.sign.dist,...
            dist_edges,'Normalization',normal),'k');
        subplot(2,6,9);
        hold on; plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            histcounts(analyses.corr.Q.sign.dist(analyses.corr.Q.sign.value>0),...
            dist_edges,'Normalization',normal),'b');
        subplot(2,6,9);
        hold on; plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            histcounts(analyses.corr.Q.sign.dist(analyses.corr.Q.sign.value<0),...
            dist_edges,'Normalization',normal),'r');
        xlabel('dist (um)'); ylabel('prob');
        %legend('all','pos','neg');
        %Pedro mod
        title('Q');
    end
    if isfield(analyses.corr, 'W')
        corr_W = analyses.corr.W.values(~isnan(analyses.corr.W.values));
        corr_box = [corr_box; corr_W];
        group_box = [group_box; char('W'*ones(length(corr_W),1))];
        corr_s_box = [corr_s_box; analyses.corr.W.sign.value];
        group_s_box = [group_s_box; char('W'*ones(length(analyses.corr.W.sign.value),1))];
        perc_corr_sign = [perc_corr_sign length(analyses.corr.W.sign.value)/length(corr_W)];
        perc_corr_sign_pos = [perc_corr_sign_pos sum(analyses.corr.W.sign.value>0)/length(corr_W)];
        perc_corr_sign_neg = [perc_corr_sign_neg sum(analyses.corr.W.sign.value<0)/length(corr_W)];
        subplot(2,6,10);
        hold on; plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            histcounts(analyses.corr.W.sign.dist,...
            dist_edges,'Normalization',normal),'k');
        subplot(2,6,10);
        hold on; plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            histcounts(analyses.corr.W.sign.dist(analyses.corr.W.sign.value>0),...
            dist_edges,'Normalization',normal),'b');
        subplot(2,6,10);
        hold on; plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            histcounts(analyses.corr.W.sign.dist(analyses.corr.W.sign.value<0),...
            dist_edges,'Normalization',normal),'r');
        xlabel('dist (um)'); ylabel('prob');
        %legend('all','pos','neg');
        %Pedro mod
        title('W');
    end
    if isfield(analyses.corr, 'WL')
        corr_WL = analyses.corr.WL.values(~isnan(analyses.corr.WL.values));
        corr_box = [corr_box; corr_WL];
        group_box = [group_box; char('B'*ones(length(corr_WL),1))];
        corr_s_box = [corr_s_box; analyses.corr.WL.sign.value];
        group_s_box = [group_s_box; char('B'*ones(length(analyses.corr.WL.sign.value),1))];
        perc_corr_sign = [perc_corr_sign length(analyses.corr.WL.sign.value)/length(corr_WL)];
        perc_corr_sign_pos = [perc_corr_sign_pos sum(analyses.corr.WL.sign.value>0)/length(corr_WL)];
        perc_corr_sign_neg = [perc_corr_sign_neg sum(analyses.corr.WL.sign.value<0)/length(corr_WL)];
        
        subplot(2,6,11);
        hold on; plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            histcounts(analyses.corr.WL.sign.dist,...
            dist_edges,'Normalization',normal),'k');
        subplot(2,6,11);
        hold on; plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            histcounts(analyses.corr.WL.sign.dist(analyses.corr.WL.sign.value>0),...
            dist_edges,'Normalization',normal),'b');
        subplot(2,6,11);
        hold on; plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            histcounts(analyses.corr.WL.sign.dist(analyses.corr.WL.sign.value<0),...
            dist_edges,'Normalization',normal),'r');
        xlabel('dist (um)'); ylabel('prob');
        %legend('all','pos','neg');
        %Pedro mod
        title('WL');
    end
    if isfield(analyses.corr, 'T')
        corr_T = analyses.corr.T.values(~isnan(analyses.corr.T.values));
        corr_box = [corr_box; corr_T];
        group_box = [group_box; char('T'*ones(length(corr_T),1))];
        corr_s_box = [corr_s_box; analyses.corr.T.sign.value];
        group_s_box = [group_s_box; char('T'*ones(length(analyses.corr.T.sign.value),1))];
        perc_corr_sign = [perc_corr_sign length(analyses.corr.T.sign.value)/length(corr_T)];
        perc_corr_sign_pos = [perc_corr_sign_pos sum(analyses.corr.T.sign.value>0)/length(corr_T)];
        perc_corr_sign_neg = [perc_corr_sign_neg sum(analyses.corr.T.sign.value<0)/length(corr_T)];
        
        subplot(2,6,12);
        hold on; plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            histcounts(analyses.corr.T.sign.dist,...
            dist_edges,'Normalization',normal),'k');
        subplot(2,6,12);
        hold on; plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            histcounts(analyses.corr.T.sign.dist(analyses.corr.T.sign.value>0),...
            dist_edges,'Normalization',normal),'b');
        subplot(2,6,12);
        hold on; plot(dist_edges(1:end-1)+(dist_edges(2)-dist_edges(1))/2,...
            histcounts(analyses.corr.T.sign.dist(analyses.corr.T.sign.value<0),...
            dist_edges,'Normalization',normal),'r');
        xlabel('dist (um)'); ylabel('prob');
        %legend('all','pos','neg');
        %Pedro mod
        title('T');
    end
    subplot(2,6,[1 2]);
    boxplot(corr_box,group_box);
    ylabel('corr');
    title('all corr');
    
    subplot(2,6,[4 5]);
    boxplot(corr_s_box,group_s_box);
    ylabel('corr');
    xlab = get(gca,'XTickLabel');
    title('sign corr');
    
    subplot(2,6,6);
    bar(1:length(perc_corr_sign),[perc_corr_sign; perc_corr_sign_pos; perc_corr_sign_neg]');
    ylabel('perc correlated pairs')
    set(gca,'XTickLabel',xlab);
    xlim([0 length(perc_corr_sign)+1]);
    %legend('all','pos','neg');
    %Pedro mod
end
