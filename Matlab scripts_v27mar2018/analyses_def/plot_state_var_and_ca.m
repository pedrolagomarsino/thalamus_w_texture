function [] = plot_state_var_and_ca(raw_state_var,data,params)

if params.stimulus == 0 %plot for experiments without stimulation
    ax1 = subplot(5,1,1); %plot whisking angle with overlap binary whisking
    plot(raw_state_var.time,raw_state_var.whisk_angle*(180/pi),'k','LineWidth',2);
    colorbar;
    title('Whiskers Angle'); ylabel('[deg]');
    xlim([data.time_ca(1) data.time_ca(end)]);
    set(gca,'XTick',[],'FontSize',10);
    [onset_whisking, offset_whisking] = findOnsetOffset(data.whisking);
    if ~isempty(onset_whisking)
        onset_whisking = (onset_whisking'-1)*params.framePeriod;
        offset_whisking = (offset_whisking'-1)*params.framePeriod;
        barHeight = get(gca,'ylim');
        for i = 1:length(onset_whisking)
            x = [onset_whisking(i) offset_whisking(i) offset_whisking(i) onset_whisking(i)];
            y = [barHeight(1) barHeight(1) barHeight(2) barHeight(2) ];
            hold on; fill(x,y,'r','FaceAlpha',0.3);
        end
    end
    
    ax2 = subplot(5,1,2); %plot locomotion speed with overlap binary locomotion
    plot(raw_state_var.time,raw_state_var.speed,'k','LineWidth',2);
    colorbar;
    title('Speed'); ylabel('[cm/s]');
    ylim([0 max(raw_state_var.speed)])
    xlim([data.time_ca(1) data.time_ca(end)]);
    set(gca,'XTick',[],'FontSize',10);
    [onset_loc, offset_loc] = findOnsetOffset(data.locomotion);
    if ~isempty(onset_loc)
        onset_loc = (onset_loc'-1)*params.framePeriod;
        offset_loc = (offset_loc'-1)*params.framePeriod;
        barHeight = get(gca,'ylim');
        for i = 1:length(onset_loc)
            x = [onset_loc(i) offset_loc(i) offset_loc(i) onset_loc(i)];
            y = [barHeight(1) barHeight(1) barHeight(2) barHeight(2) ];
            hold on; fill(x,y,'b','FaceAlpha',0.3);
        end
    end
    
    ax3 = subplot(5,1,3); %plot pupil diameter
    plot(raw_state_var.time,raw_state_var.pupil/params.pupil_px_mm,'k','LineWidth',2);
    colorbar;
%     xlabel('time (s)');
    title('Pupil diameter'); ylabel('[mm]');
%     ylim([0 2])
    xlim([data.time_ca(1) data.time_ca(end)]);
    set(gca,'XTick',[],'FontSize',10);
%     set(gca,'FontSize',10);
    
    ax4 = subplot(5,1,[4 5]); %plot ROIs normalized fluorescence
    imagesc(data.time_ca,1:params.numROIs,data.C_df); colormap('jet');
    c = colorbar;
%     c.Label.String = 'dF/F';
    xlabel('time (s)'); ylabel('ROIs ID');
    set(gca,'FontSize',10);
    
    linkaxes([ax1,ax2,ax3,ax4],'x');
else
    ax1 = subplot(6,1,1); %plot whisking angle with overlap binary whisking
    plot(raw_state_var.time,raw_state_var.whisk_angle*(180/pi),'k','LineWidth',2);
    colorbar;
    title('Whiskers Angle'); ylabel('[deg]');
    xlim([data.time_ca(1) data.time_ca(end)]);
    set(gca,'XTick',[],'FontSize',10);
    [onset_whisking, offset_whisking] = findOnsetOffset(data.whisking);
    if ~isempty(onset_whisking)
        onset_whisking = (onset_whisking'-1)*params.framePeriod;
        offset_whisking = (offset_whisking'-1)*params.framePeriod;
        barHeight = get(gca,'ylim');
        for i = 1:length(onset_whisking)
            x = [onset_whisking(i) offset_whisking(i) offset_whisking(i) onset_whisking(i)];
            y = [barHeight(1) barHeight(1) barHeight(2) barHeight(2) ];
            hold on; fill(x,y,'r','FaceAlpha',0.3);
        end
    end
    
    ax2 = subplot(6,1,2); %plot locomotion speed with overlap binary locomotion
    plot(raw_state_var.time,raw_state_var.speed,'k','LineWidth',2);
    colorbar;
    title('Speed'); ylabel('[cm/s]');
    ylim([0 max(raw_state_var.speed)])
    xlim([data.time_ca(1) data.time_ca(end)]);
    set(gca,'XTick',[],'FontSize',10);
    [onset_loc, offset_loc] = findOnsetOffset(data.locomotion);
    if ~isempty(onset_loc)
        onset_loc = (onset_loc'-1)*params.framePeriod;
        offset_loc = (offset_loc'-1)*params.framePeriod;
        barHeight = get(gca,'ylim');
        for i = 1:length(onset_loc)
            x = [onset_loc(i) offset_loc(i) offset_loc(i) onset_loc(i)];
            y = [barHeight(1) barHeight(1) barHeight(2) barHeight(2) ];
            hold on; fill(x,y,'b','FaceAlpha',0.3);
        end
    end
    
    ax3 = subplot(6,1,3); %plot pupil diameter
    plot(raw_state_var.time,raw_state_var.pupil/params.pupil_px_mm,'k','LineWidth',2);
    colorbar;
    title('Pupil diameter'); ylabel('[mm]');
%     ylim([0 2])
    xlim([data.time_ca(1) data.time_ca(end)]);
    set(gca,'XTick',[],'FontSize',10);
    
    ax4 = subplot(6,1,4); %plot texture presentation
    plot(raw_state_var.time,raw_state_var.stimulus,'k','LineWidth',2);
    colorbar;
%     xlabel('time (s)');
    ylabel('Stimulus');
%     ylim([min(raw_state_var.stimulus) max(raw_state_var.stimulus)]);
    xlim([data.time_ca(1) data.time_ca(end)]);
    set(gca,'XTick',[],'FontSize',10);
%     set(gca,'FontSize',10);
    
    ax5 = subplot(6,1,[5 6]); %plot ROIs normalized fluorescence
    imagesc(data.time_ca,1:params.numROIs,data.C_df); colormap('jet');
    c = colorbar;
%     c.Label.String = 'dF/F';
    xlabel('time (s)'); ylabel('ROIs ID');
    set(gca,'FontSize',10);
    
    linkaxes([ax1,ax2,ax3,ax4,ax5],'x');
end