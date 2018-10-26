function resampled = resample_state_var(time_s, activity, time_f, bin, draw)
%time_s: original time, array 1*N
%activity: trace to be resampled, array 1*N
%time_f: time for the resampling, array 1*M
%bin: 1 if binary data, 0 otherwise
%draw: 1 if drawing resampled traces. 0 otherwise

method = 'linear';
if bin == 0 %resample continuous traces
    resampled = interp1(time_s, activity, time_f ,method);
else   %resample binary (0/1) traces
    timeOnset = time_s(find(diff(activity)==1));
    timeOffset = time_s(find(diff(activity)==-1));
    if isempty(timeOnset) && isempty(timeOffset)
        resampled  = activity(1)*ones(length(time_f),1);
    else
        if isempty(timeOffset)
            timeOffset = time_s(end);
        elseif isempty(timeOnset)
            timeOnset = 1;
        end
        
        if timeOnset(1)>timeOffset(1)
            timeOnset = [time_s(1); timeOnset];
        end
        if timeOnset(end)>timeOffset(end)
            timeOffset(end+1) = time_s(end);
        end
        timeOnsetCalcium = discretize(timeOnset,[time_f Inf]);
        timeOffsetCalcium = discretize(timeOffset,[time_f+0.001 Inf])+1;
        timeOffsetCalcium = min(length(time_f),timeOffsetCalcium);
        
        if timeOnsetCalcium(1)>timeOffsetCalcium(1)
            timeOnsetCalcium = [1; timeOnsetCalcium];
        end
        if timeOnsetCalcium(end)>timeOffsetCalcium(end)
            timeOffsetCalcium(end+1) = length(time_f);
        end
        resampled  = zeros(length(time_f),1);
        for i = 1:length(timeOnsetCalcium)
            resampled(timeOnsetCalcium(i):timeOffsetCalcium(i))=1;
        end
    end
end

if draw == 1
    figure;
    plot(time_s,activity,'k');
    hold on;
    plot(time_f,resampled,'r');
    xlim([time_f(1) time_f(end)]);
end