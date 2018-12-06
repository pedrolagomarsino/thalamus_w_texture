function [] = plot_states_pupil_ca(data,analyses,params)

if params.stimulus==0
    %behavioral states distribution pies
    pie1 = subplot(2,4,1);
    pie([analyses.behavior.count(:,1), sum(analyses.behavior.count(:,2:end))]);
    legend('Quiet awake','Active awake','Location','southoutside');
    colormap(pie1, [0 .5 .5; %//dark green
        1 1 0]);      %// yellow
    pie2 = subplot(2,4,2);
    pie(analyses.behavior.count(:,2:end));
    legend('Whisking','Whisking + Locomotion','Locomotion','Location','southoutside');
    colormap(pie2,[
        1 .5 0;      %// orange
        1 0 0;      %// red
        1 1 0]);      %// yellow
    set(gca,'FontSize',10)
    
    %histogram of pupil size normalized to maximum
    norm = 'probability';%'count';%
    binWidth = 0.05;
    f_alpha = 0.8;
    disp_style = 'stairs';%'bar'
    pupil1 = subplot(2,4,3);
    histogram(data.pupil_norm(analyses.behavior.states_vector==0),'binWidth',binWidth,...
        'Normalization',norm,...
        'DisplayStyle',disp_style);
    hold on; histogram(data.pupil_norm(analyses.behavior.states_vector>=1),'binWidth',binWidth,...
        'Normalization',norm,...
        'DisplayStyle',disp_style);
    legend('Quiet','Active')
    xlabel('Pupil Size (%)');
    ylabel('% frames');
    set(gca,'FontSize',10)
    pupil2 =subplot(2,4,4);
    histogram(data.pupil_norm(analyses.behavior.states_vector==0),'binWidth',binWidth,...
        'Normalization',norm,...
        'DisplayStyle',disp_style);
    hold on; histogram(data.pupil_norm(analyses.behavior.states_vector==1),'binWidth',binWidth,...
        'Normalization',norm,...
        'DisplayStyle',disp_style);
    hold on; histogram(data.pupil_norm(analyses.behavior.states_vector==3),'binWidth',binWidth,...
        'Normalization',norm,...
        'DisplayStyle',disp_style);
    hold on; histogram(data.pupil_norm(analyses.behavior.states_vector==2),'binWidth',binWidth,...
        'Normalization',norm,...
        'DisplayStyle',disp_style);
    legend('Quiet','Whisking','Whisking + Locomotion','Locomotion');
    xlabel('Pupil Size (%)');
    ylabel('% frames');
    set(gca,'FontSize',10)
    linkaxes([pupil1,pupil2],'x')
    
    % mean ROIs activity across behavioral states
    calcium1 = subplot(2,4,[5 6]);
    plot_df_f_across_states(analyses,params);
    title('Mean single cell fluorescence across states');
    
    % whisking triggered activity
    pre_win  = 2; %s
    post_win = 5; %s
    calcium2 = subplot(2,4,[7 8]);
    compute_and_plot_WTA(data,params,pre_win,post_win)
    
    title('Average activity');
    xlabel('time from whisking onset (s)'); ylabel('dF/F');
    %    xlim([time(1) time(end)]);
    set(gca,'FontSize',10);
    
else
    %behavioral states distribution pies
    pie1 = subplot(2,9,1:3);
    pie([analyses.behavior.count(:,1),analyses.behavior.count(:,3), sum(analyses.behavior.count(:,[2,4:end]))]);
    legend('Quiet awake','Quiet Texture','Active awake','Location','northoutside');
    colormap(pie1, [0 .5 .5; %//dark green
        0 0.3 0.3;    %// even darker green
        1 1 0]);      %// yellow
    pie2 = subplot(2,9,10:12);
    pie(analyses.behavior.count(:,2:end)); % _Q_W_T_WL_WT_WLT_LT_L
    legend('W','T','W+L','W+T','W+L+T','L+T','L','Location','westoutside');
    set(gca,'FontSize',10)
    
    % mean pupil diameter across behavioral states
    pupil_means = subplot(2,9,4:6);
    plot_pupil_size_across_states(data,analyses);
    title('Mean pupil diameter across states')
    
    % mean ROIs activity across behavioral states
    calcium1 = subplot(2,9,13:15);
    plot_df_f_across_states(analyses,params);
    title('Mean single cell fluorescence across states');
end

end

