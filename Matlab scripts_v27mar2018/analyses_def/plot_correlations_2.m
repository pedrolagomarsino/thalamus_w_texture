function [] = plot_correlations_2(analyses,params)



if params.stimulus == 0
    if isfield(analyses,'corr')
        
        if isfield(analyses.corr,'Q')
            subplot(4,4,1)
            plot([-1:1:1],[-1:1:1],'k'); hold on;
            scatter(analyses.corr.Q.values(~isnan(analyses.corr.distances)),...
                analyses.corr.global.values(~isnan(analyses.corr.distances)));
            xlabel('corr Q'); xlim([-1 1]);
            ylabel('corr G'); ylim([-1 1]);

            if isfield(analyses.corr,'W')
                subplot(4,4,2)
                plot([-1:1:1],[-1:1:1],'k'); hold on;
                scatter( analyses.corr.W.values(~isnan(analyses.corr.distances)),...
                    analyses.corr.global.values(~isnan(analyses.corr.distances)));
                xlabel('corr W'); xlim([-1 1]);
                ylabel('corr G'); ylim([-1 1]);
                
                subplot(4,4,6)
                plot([-1:1:1],[-1:1:1],'k'); hold on;
                scatter(analyses.corr.W.values(~isnan(analyses.corr.distances)),...
                    analyses.corr.Q.values(~isnan(analyses.corr.distances)));
                xlabel('corr W'); xlim([-1 1]);
                ylabel('corr Q'); ylim([-1 1]);
                if isfield(analyses.corr,'partial')
                    subplot(4,4,3)
                    plot([-1:1:1],[-1:1:1],'k'); hold on;
                    scatter(analyses.corr.partial.values(~isnan(analyses.corr.distances)),...
                        analyses.corr.global.values(~isnan(analyses.corr.distances)));
                    xlabel('corr partial'); xlim([-1 1]);
                    ylabel('corr G'); ylim([-1 1]);
                
                    subplot(4,4,7)
                    plot([-1:1:1],[-1:1:1],'k'); hold on;
                    scatter(analyses.corr.partial.values(~isnan(analyses.corr.distances)),...
                        analyses.corr.Q.values(~isnan(analyses.corr.distances)));
                    xlabel('corr partial'); xlim([-1 1]);
                    ylabel('corr Q'); ylim([-1 1]);
                    
                    subplot(4,4,11)
                    plot([-1:1:1],[-1:1:1],'k'); hold on;
                    scatter( analyses.corr.partial.values(~isnan(analyses.corr.distances)),...
                        analyses.corr.W.values(~isnan(analyses.corr.distances)));
                    xlabel('corr partial'); xlim([-1 1]);
                    ylabel('corr W'); ylim([-1 1]);
                    
                    if isfield(analyses.corr,'WL')
                        subplot(4,4,4)
                        plot([-1:1:1],[-1:1:1],'k'); hold on;
                        scatter(analyses.corr.WL.values(~isnan(analyses.corr.distances)),...
                            analyses.corr.global.values(~isnan(analyses.corr.distances)));
                        xlabel('corr WL'); xlim([-1 1]);
                        ylabel('corr G'); ylim([-1 1]);
                        
                        subplot(4,4,8)
                        plot([-1:1:1],[-1:1:1],'k'); hold on;
                        scatter(analyses.corr.WL.values(~isnan(analyses.corr.distances)),...
                            analyses.corr.Q.values(~isnan(analyses.corr.distances)));
                        xlabel('corr WL'); xlim([-1 1]);
                        ylabel('corr Q'); ylim([-1 1]);
                        
                        subplot(4,4,12)
                        plot([-1:1:1],[-1:1:1],'k'); hold on;
                        scatter(analyses.corr.WL.values(~isnan(analyses.corr.distances)),...
                            analyses.corr.W.values(~isnan(analyses.corr.distances)));
                        xlabel('corr WL'); xlim([-1 1]);
                        ylabel('corr W'); ylim([-1 1]);
                        
                        subplot(4,4,16)
                        plot([-1:1:1],[-1:1:1],'k'); hold on;
                        scatter(analyses.corr.WL.values(~isnan(analyses.corr.distances)),...
                            analyses.corr.partial.values(~isnan(analyses.corr.distances)));
                        xlabel('corr WL'); xlim([-1 1]);
                        ylabel('corr partial'); ylim([-1 1]);
                    end
                else
                    if isfield(analyses.corr,'WL')
                        subplot(4,4,4)
                        plot([-1:1:1],[-1:1:1],'k'); hold on;
                        scatter(analyses.corr.WL.values(~isnan(analyses.corr.distances)),...
                            analyses.corr.global.values(~isnan(analyses.corr.distances)));
                        xlabel('corr WL'); xlim([-1 1]);
                        ylabel('corr G'); ylim([-1 1]);
                        
                        subplot(4,4,8)
                        plot([-1:1:1],[-1:1:1],'k'); hold on;
                        scatter(analyses.corr.WL.values(~isnan(analyses.corr.distances)),...
                            analyses.corr.Q.values(~isnan(analyses.corr.distances)));
                        xlabel('corr WL'); xlim([-1 1]);
                        ylabel('corr Q'); ylim([-1 1]);
                        
                        subplot(4,4,12)
                        plot([-1:1:1],[-1:1:1],'k'); hold on;
                        scatter(analyses.corr.WL.values(~isnan(analyses.corr.distances)),...
                            analyses.corr.W.values(~isnan(analyses.corr.distances)));
                        xlabel('corr WL'); xlim([-1 1]);
                        ylabel('corr W'); ylim([-1 1]);
                    end
                end
            else
                if isfield(analyses.corr,'partial')
                    subplot(4,4,3)
                    plot([-1:1:1],[-1:1:1],'k'); hold on;
                    scatter(analyses.corr.partial.values(~isnan(analyses.corr.distances)),...
                        analyses.corr.global.values(~isnan(analyses.corr.distances)));
                    xlabel('corr partial'); xlim([-1 1]);
                    ylabel('corr G'); ylim([-1 1]);
                
                    subplot(4,4,7)
                    plot([-1:1:1],[-1:1:1],'k'); hold on;
                    scatter(analyses.corr.partial.values(~isnan(analyses.corr.distances)),...
                        analyses.corr.Q.values(~isnan(analyses.corr.distances)));
                    xlabel('corr partial'); xlim([-1 1]);
                    ylabel('corr Q'); ylim([-1 1]);
                    
                    if isfield(analyses.corr,'WL')
                        subplot(4,4,4)
                        plot([-1:1:1],[-1:1:1],'k'); hold on;
                        scatter(analyses.corr.WL.values(~isnan(analyses.corr.distances)),...
                            analyses.corr.global.values(~isnan(analyses.corr.distances)));
                        xlabel('corr WL'); xlim([-1 1]);
                        ylabel('corr G'); ylim([-1 1]);
                        
                        subplot(4,4,8)
                        plot([-1:1:1],[-1:1:1],'k'); hold on;
                        scatter(analyses.corr.WL.values(~isnan(analyses.corr.distances)),...
                            analyses.corr.Q.values(~isnan(analyses.corr.distances)));
                        xlabel('corr WL'); xlim([-1 1]);
                        ylabel('corr Q'); ylim([-1 1]);
                        
                        subplot(4,4,16)
                        plot([-1:1:1],[-1:1:1],'k'); hold on;
                        scatter(analyses.corr.WL.values(~isnan(analyses.corr.distances)),...
                            analyses.corr.partial.values(~isnan(analyses.corr.distances)));
                        xlabel('corr WL'); xlim([-1 1]);
                        ylabel('corr partial'); ylim([-1 1]);
                    end
                else
                    if isfield(analyses.corr,'WL')
                        subplot(4,4,4)
                        plot([-1:1:1],[-1:1:1],'k'); hold on;
                        scatter(analyses.corr.WL.values(~isnan(analyses.corr.distances)),...
                            analyses.corr.global.values(~isnan(analyses.corr.distances)));
                        xlabel('corr WL'); xlim([-1 1]);
                        ylabel('corr G'); ylim([-1 1]);
                        
                        subplot(4,4,8)
                        plot([-1:1:1],[-1:1:1],'k'); hold on;
                        scatter(analyses.corr.WL.values(~isnan(analyses.corr.distances)),...
                            analyses.corr.Q.values(~isnan(analyses.corr.distances)));
                        xlabel('corr WL'); xlim([-1 1]);
                        ylabel('corr Q'); ylim([-1 1]);
                        
                    end
                end
            end
        else
            if isfield(analyses.corr,'W')
                subplot(4,4,2)
                plot([-1:1:1],[-1:1:1],'k'); hold on;
                scatter( analyses.corr.W.values(~isnan(analyses.corr.distances)),...
                    analyses.corr.global.values(~isnan(analyses.corr.distances)));
                xlabel('corr W'); xlim([-1 1]);
                ylabel('corr G'); ylim([-1 1]);

                if isfield(analyses.corr,'partial')
                    subplot(4,4,3)
                    plot([-1:1:1],[-1:1:1],'k'); hold on;
                    scatter(analyses.corr.partial.values(~isnan(analyses.corr.distances)),...
                        analyses.corr.global.values(~isnan(analyses.corr.distances)));
                    xlabel('corr partial'); xlim([-1 1]);
                    ylabel('corr G'); ylim([-1 1]);
                    
                    subplot(4,4,11)
                    plot([-1:1:1],[-1:1:1],'k'); hold on;
                    scatter( analyses.corr.partial.values(~isnan(analyses.corr.distances)),...
                        analyses.corr.W.values(~isnan(analyses.corr.distances)));
                    xlabel('corr partial'); xlim([-1 1]);
                    ylabel('corr W'); ylim([-1 1]);
                    
                    if isfield(analyses.corr,'WL')
                        subplot(4,4,4)
                        plot([-1:1:1],[-1:1:1],'k'); hold on;
                        scatter(analyses.corr.WL.values(~isnan(analyses.corr.distances)),...
                            analyses.corr.global.values(~isnan(analyses.corr.distances)));
                        xlabel('corr WL'); xlim([-1 1]);
                        ylabel('corr G'); ylim([-1 1]);
                        
                        subplot(4,4,12)
                        plot([-1:1:1],[-1:1:1],'k'); hold on;
                        scatter(analyses.corr.WL.values(~isnan(analyses.corr.distances)),...
                            analyses.corr.W.values(~isnan(analyses.corr.distances)));
                        xlabel('corr WL'); xlim([-1 1]);
                        ylabel('corr W'); ylim([-1 1]);
                        
                        subplot(4,4,16)
                        plot([-1:1:1],[-1:1:1],'k'); hold on;
                        scatter(analyses.corr.WL.values(~isnan(analyses.corr.distances)),...
                            analyses.corr.partial.values(~isnan(analyses.corr.distances)));
                        xlabel('corr WL'); xlim([-1 1]);
                        ylabel('corr partial'); ylim([-1 1]);
                    end
                else
                    if isfield(analyses.corr,'WL')
                        subplot(4,4,4)
                        plot([-1:1:1],[-1:1:1],'k'); hold on;
                        scatter(analyses.corr.WL.values(~isnan(analyses.corr.distances)),...
                            analyses.corr.global.values(~isnan(analyses.corr.distances)));
                        xlabel('corr WL'); xlim([-1 1]);
                        ylabel('corr G'); ylim([-1 1]);
                        
                        subplot(4,4,12)
                        plot([-1:1:1],[-1:1:1],'k'); hold on;
                        scatter(analyses.corr.WL.values(~isnan(analyses.corr.distances)),...
                            analyses.corr.W.values(~isnan(analyses.corr.distances)));
                        xlabel('corr WL'); xlim([-1 1]);
                        ylabel('corr W'); ylim([-1 1]);
                    end
                end
            else
                if isfield(analyses.corr,'partial')
                    subplot(4,4,3)
                    plot([-1:1:1],[-1:1:1],'k'); hold on;
                    scatter(analyses.corr.partial.values(~isnan(analyses.corr.distances)),...
                        analyses.corr.global.values(~isnan(analyses.corr.distances)));
                    xlabel('corr partial'); xlim([-1 1]);
                    ylabel('corr G'); ylim([-1 1]);
                    
                    if isfield(analyses.corr,'WL')
                        subplot(4,4,4)
                        plot([-1:1:1],[-1:1:1],'k'); hold on;
                        scatter(analyses.corr.WL.values(~isnan(analyses.corr.distances)),...
                            analyses.corr.global.values(~isnan(analyses.corr.distances)));
                        xlabel('corr WL'); xlim([-1 1]);
                        ylabel('corr G'); ylim([-1 1]);
                        
                        subplot(4,4,16)
                        plot([-1:1:1],[-1:1:1],'k'); hold on;
                        scatter(analyses.corr.WL.values(~isnan(analyses.corr.distances)),...
                            analyses.corr.partial.values(~isnan(analyses.corr.distances)));
                        xlabel('corr WL'); xlim([-1 1]);
                        ylabel('corr partial'); ylim([-1 1]);
                    end
                else
                    if isfield(analyses.corr,'WL')
                        subplot(4,4,4)
                        plot([-1:1:1],[-1:1:1],'k'); hold on;
                        scatter(analyses.corr.WL.values(~isnan(analyses.corr.distances)),...
                            analyses.corr.global.values(~isnan(analyses.corr.distances)));
                        xlabel('corr WL'); xlim([-1 1]);
                        ylabel('corr G'); ylim([-1 1]); 
                    end
                end
            end
        end
    end
end
