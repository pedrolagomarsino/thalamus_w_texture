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
    % not all recordings have all states, build a way of indexing actual states out of all possible states (excluding only locomotion)
    Idx = [0,.5,1,1.5,2.5,3,3.5;1:7];
    states_vector = analyses.behavior.states_vector(analyses.behavior.states_vector~=2);
    states = unique(states_vector);
    % Variable_names has zeros in the columns of non present states
    Variable_names = {'Q','T','W','WT','LT','WL','WLT'};
    Variables = zeros(size(analyses.single_cell.calcium.mean,1),length(Variable_names));
    for i = 1:length(states)
        Variables(:,Idx(2,Idx(1,:)==states(i))) = analyses.single_cell.calcium.mean(:,i);
    end
    bar(mean(Variables,1));
    hold on; 
    errorbar(mean(Variables,1),std(Variables,[],1)/sqrt(size(Variables,1)),...
        'lineStyle','none');
    ylabel('df/f');
    set(gca,'XTickLabel',Variable_names,'FontSize',10);% _Q_W_T_WL_WT_WLT_LT_L
    %Build table with p-values
    p_stars = cell(length(Variable_names),length(Variable_names));
    for i = 1:size(c,1)
        if c(i,6)>0.05
            p_stars{Idx(2,Idx(1,:)==states(c(i,1))),Idx(2,Idx(1,:)==states(c(i,2)))} = 'ns';
        elseif c(i,6)>0.01
            p_stars{Idx(2,Idx(1,:)==states(c(i,1))),Idx(2,Idx(1,:)==states(c(i,2)))} = '*';
        elseif c(i,6)>0.001
            p_stars{Idx(2,Idx(1,:)==states(c(i,1))),Idx(2,Idx(1,:)==states(c(i,2)))} = '**';
        else
            p_stars{Idx(2,Idx(1,:)==states(c(i,1))),Idx(2,Idx(1,:)==states(c(i,2)))} = '***';
        end
    end
    p_stars = p_stars(1:end-1,2:end);
    ha = subplot(2,9,16:18);
    pos = get(ha,'Position');
    un = get(ha,'Units');
    delete(ha)
    p_table = uitable('Data',p_stars,'ColumnName',Variable_names(2:end),'RowName',Variable_names(1:end-1),'Units',un,'Position',pos,'FontSize',12);
    p_table.Position(3:4) = p_table.Extent(3:4);
    
end