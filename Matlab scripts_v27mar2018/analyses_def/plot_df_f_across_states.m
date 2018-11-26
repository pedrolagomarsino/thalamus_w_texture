function [] = plot_df_f_across_states(analyses,params)

[~,~,stats] = anova1(analyses.single_cell.calcium.mean,[],'off');
if params.numROIs>1
    [c,~,~] = multcompare(stats,'Display','off');
end
if params.stimulus == 0
    bar(mean(analyses.single_cell.calcium.mean,1));
    hold on; errorbar(mean(analyses.single_cell.calcium.mean,1),std(analyses.single_cell.calcium.mean,[],1)/sqrt(size(analyses.single_cell.calcium.mean,1)),...
        'lineStyle','none');
    ylabel('df/f');
    set(gca,'XTickLabel',{'Q','W','W + L'},'FontSize',10);% _Q_W_T_WL_WT_WLT_LT_L
    
    
    if params.numROIs>1
        for i = 1:size(c,1)
            hold on;
            line(c(i,1:2),(0.01*i+max(mean(analyses.single_cell.calcium.mean,1)+std(analyses.single_cell.calcium.mean,[],1)/sqrt(size(analyses.single_cell.calcium.mean,1))))*ones(2,1),'Color','k');
            if c(i,end)>0.05
                text(mean(c(i,1:2)),0.01*i+0.005+max(mean(analyses.single_cell.calcium.mean,1)+std(analyses.single_cell.calcium.mean,[],1)/sqrt(size(analyses.single_cell.calcium.mean,1))),'n.s.')
            elseif c(i,end)>0.01
                text(mean(c(i,1:2)),0.01*i+0.005+max(mean(analyses.single_cell.calcium.mean,1)+std(analyses.single_cell.calcium.mean,[],1)/sqrt(size(analyses.single_cell.calcium.mean,1))),['* p=' num2str(c(i,end))]);
            elseif c(i,end)>0.001
                text(mean(c(i,1:2)),0.01*i+0.005+max(mean(analyses.single_cell.calcium.mean,1)+std(analyses.single_cell.calcium.mean,[],1)/sqrt(size(analyses.single_cell.calcium.mean,1))),['** p=' num2str(c(i,end))]);
            else
                text(mean(c(i,1:2)),0.01*i+0.005+max(mean(analyses.single_cell.calcium.mean,1)+std(analyses.single_cell.calcium.mean,[],1)/sqrt(size(analyses.single_cell.calcium.mean,1))),['*** p=' num2str(c(i,end))]);
            end
        end
    end
else
    bar(mean(analyses.single_cell.calcium.mean,1));
    hold on; errorbar(mean(analyses.single_cell.calcium.mean,1),std(analyses.single_cell.calcium.mean,[],1)/sqrt(size(analyses.single_cell.calcium.mean,1)),...
        'lineStyle','none');
    ylabel('df/f');
    set(gca,'XTickLabel',{'Q','T','W','WT','LT','WL','WLT'},'FontSize',10);% _Q_W_T_WL_WT_WLT_LT_L
    %Build table with p-values
    Variables = {'Q','T','W','WT','LT','WL','WLT'};
%     for i = 1:size(c,1)
%         if c(i,end)<.05
%             line(c(i,1:2),(0.01 + max(mean(analyses.single_cell.calcium.mean(:,c(i,1:2)),1)+std(analyses.single_cell.calcium.mean(:,c(i,1:2)),[],1)/sqrt(size(analyses.single_cell.calcium.mean(:,c(i,1:2)),1))))*ones(2,1),'Color','k');
%         end
%     end

end