function [time,pre_win_f,post_win_f,whisk_triggered_act] = whisk_triggered_activity(data, params, pre_win, post_win)

% pre_win = pre-window in s
% post_win = post_window in s


%convert pre- and post-windows in time bins
pre_win_f = ceil(pre_win/params.framePeriod);
post_win_f = ceil(post_win/params.framePeriod);

time = [-pre_win_f:1:post_win_f]*params.framePeriod;

whisk = data.whisking;
onsets_temp = find(diff(whisk) == 1)+1;
offsets = find(diff(whisk) == -1);
if isempty(onsets_temp)
    return
end
if ~isempty(offsets) && offsets(1)<onsets_temp(1)
    offsets(1)=[];
end
if onsets_temp(end)+post_win_f > size(data.C_df,2)
    onsets_temp(end) = [];
end
trials = 0;
onsets = [];
for i = 1:length(onsets_temp)
    if i == 1
        if onsets_temp(i) > pre_win_f
            trials = trials+1;
            onsets(trials) = onsets_temp(i);
        end
    else
        if onsets_temp(i) >= offsets(i-1)+ pre_win_f && onsets_temp(i) + post_win_f <= size(data.C_df,2)
            trials = trials+1;
            onsets(trials) = onsets_temp(i);
        end
    end
end
activity_aligned = zeros(params.numROIs,...
    post_win_f+pre_win_f+1,...
    length(onsets));

for id_ROI = 1:params.numROIs
    for id_trial = 1:length(onsets)
        baseline = prctile(data.Fraw(id_ROI,:),20);
        df_raw = (data.Fraw(id_ROI,:)-baseline)/baseline;
        activity_aligned(id_ROI,:,id_trial) = ...
            df_raw(onsets(id_trial)-pre_win_f:onsets(id_trial)+post_win_f);
    end
end

whisk_triggered_act = nanmean(activity_aligned,3);
end