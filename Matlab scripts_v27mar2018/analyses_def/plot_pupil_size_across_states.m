function [] = plot_pupil_size_across_states(data,analyses)

pupil_norm = data.pupil/max(data.pupil);
[Pupil_StateMean, Pupil_Statesem] = grpstats(pupil_norm,analyses.behavior.states_vector,{'nanmean','sem'},'Alpha',0.05);
[~,~,Stats_pupil]= anova1(pupil_norm,analyses.behavior.states_vector,'off');
[p_pupil_means,~,~] = multcompare(Stats_pupil,'Display','off');

Idx = [0,.5,1,1.5,2.5,3,3.5;1:7];
states = unique(analyses.behavior.states_vector);
states(states==2)=[];
% Variable_names has zeros in the columns of non present states
Variable_names = {'Q','T','W','WT','LT','WL','WLT'};
Variables = zeros(1,length(Variable_names));
for i = 1:length(states)
    Variables(Idx(2,Idx(1,:)==states(i))) = Pupil_StateMean(i);
    Variables_sem(Idx(2,Idx(1,:)==states(i))) = Pupil_Statesem(i);
end

bar(Variables);
hold on;
errorbar(Variables,Variables_sem,'lineStyle','none');
ylabel('Norm Pupil size');
set(gca,'XTickLabel',{'Q','T','W','WT','LT','WL','WLT'},'FontSize',10);% _Q_W_T_WL_WT_WLT_LT_L
set(gca,'YLim',[min(Pupil_StateMean)-(max(Pupil_StateMean)-min(Pupil_StateMean)),max(Pupil_StateMean)+2*max(Pupil_Statesem)])

%Build table with p-values

p_stars = cell(length(Variable_names),length(Variable_names));
for i = 1:size(p_pupil_means,1)
    if p_pupil_means(i,6)>0.05
        p_stars{Idx(2,Idx(1,:)==states(p_pupil_means(i,1))),Idx(2,Idx(1,:)==states(p_pupil_means(i,2)))} = 'ns';
    elseif p_pupil_means(i,6)>0.01
        p_stars{Idx(2,Idx(1,:)==states(p_pupil_means(i,1))),Idx(2,Idx(1,:)==states(p_pupil_means(i,2)))} = '*';
    elseif p_pupil_means(i,6)>0.001
        p_stars{Idx(2,Idx(1,:)==states(p_pupil_means(i,1))),Idx(2,Idx(1,:)==states(p_pupil_means(i,2)))} = '**';
    else
        p_stars{Idx(2,Idx(1,:)==states(p_pupil_means(i,1))),Idx(2,Idx(1,:)==states(p_pupil_means(i,2)))} = '***';
    end
end
p_stars = p_stars(1:end-1,2:end);
ha = subplot(2,9,7:9);
pos = get(ha,'Position');
un = get(ha,'Units');
delete(ha)
p_table = uitable('Data',p_stars,'ColumnName',Variable_names(2:end),'RowName',Variable_names(1:end-1),'Units',un,'Position',pos,'FontSize',12);
p_table.Position(3:4) = p_table.Extent(3:4);
end