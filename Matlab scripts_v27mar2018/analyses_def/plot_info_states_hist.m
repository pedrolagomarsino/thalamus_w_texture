function [] = plot_info_states_hist(data,analyses,params)

if isfield(analyses,'info')
    if isfield(analyses.info,'info_states') && ~isempty(analyses.info.info_states)
        if isfield(analyses.info.info_states,'I_W') &&...
                isfield(analyses.info.info_states,'I_WL')
            subplot(1,2,1);
            histogram(analyses.info.info_states.I_WL-analyses.info.info_states.I_W);
            xlabel('I_{WL}-I_W');
            subplot(1,2,2);
            bar([1 2],[mean(analyses.info.info_states.I_WL),...
                mean(analyses.info.info_states.I_W)]);
            hold on;
            errorbar([1 2],[mean(analyses.info.info_states.I_WL),...
                mean(analyses.info.info_states.I_W)],...
                [std(analyses.info.info_states.I_WL),...
                std(analyses.info.info_states.I_W)],...
                'k','LineStyle','none');
            set(gca,'XTick',[1 2],'XTickLabel',{'I_{WL}','I_W'});   
        end
    end
end

