function [] = compute_and_plot_WTA(data,params,pre_win,post_win)

[time,pre_win_f,~,whisk_triggered_act] =...
    whisk_triggered_activity(data, params, pre_win, post_win);

plot(time,whisk_triggered_act');
hold on; line([time(pre_win_f+1) time(pre_win_f+1)],[0 max(whisk_triggered_act(:))],'Color','k','LineWidth',3);
title('Average activity');
xlabel('time from whisking onset (s)'); ylabel('dF/F');
xlim([time(1) time(end)]);
set(gca,'FontSize',10);

end