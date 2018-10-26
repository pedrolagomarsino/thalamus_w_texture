function [] = plot_correlations_1(analyses,params)

if params.stimulus == 0
    if isfield(analyses,'corr')
        subplot(3,5,1);
        hold on; scatter(analyses.corr.distances(~isnan(analyses.corr.distances)),...
            analyses.corr.global.values(~isnan(analyses.corr.global.values)));
        title('global correlations');
        subplot(3,5,6);
        hold on; imagesc(params.dist_edges,params.corr_edges,analyses.corr.corr_dist_G);
        colorbar;
        xlim([params.dist_edges(1) params.dist_edges(end)]);
        ylim([params.corr_edges(1) params.corr_edges(end)]);
        title('prob density');
        subplot(3,5,11);
        hold on; imagesc(params.dist_edges,params.corr_edges,analyses.corr.shuffled.corr_dist_G);
        xlim([params.dist_edges(1) params.dist_edges(end)]);
        ylim([params.corr_edges(1) params.corr_edges(end)]);
        colorbar;
        
        if isfield(analyses.corr,'Q')
            subplot(3,5,2);
            hold on; scatter(analyses.corr.distances(~isnan(analyses.corr.distances)),...
                analyses.corr.Q.values(~isnan(analyses.corr.Q.values)));
            title('Q correlations');
            subplot(3,5,7);
            hold on; imagesc(params.dist_edges,params.corr_edges,...
                analyses.corr.corr_dist_Q);
            colorbar;
            xlim([params.dist_edges(1) params.dist_edges(end)]);
            ylim([params.corr_edges(1) params.corr_edges(end)]);
            title('prob density');
            subplot(3,5,12);
            hold on; imagesc(params.dist_edges,params.corr_edges,...
                analyses.corr.shuffled.corr_dist_Q);
            colorbar;
            xlim([params.dist_edges(1) params.dist_edges(end)]);
            ylim([params.corr_edges(1) params.corr_edges(end)]);
        end
        
        if isfield(analyses.corr,'W')
            subplot(3,5,3);
            hold on; scatter(analyses.corr.distances(~isnan(analyses.corr.distances)),...
                analyses.corr.W.values(~isnan(analyses.corr.W.values)));
            title('W correlations');
            subplot(3,5,8);
            hold on; imagesc(params.dist_edges,params.corr_edges,...
                analyses.corr.corr_dist_W);
            colorbar;
            xlim([params.dist_edges(1) params.dist_edges(end)]);
            ylim([params.corr_edges(1) params.corr_edges(end)]);
            title('prob density');
            subplot(3,5,13);
            hold on; imagesc(params.dist_edges,params.corr_edges,...
                analyses.corr.shuffled.corr_dist_W);
            colorbar;
            xlim([params.dist_edges(1) params.dist_edges(end)]);
            ylim([params.corr_edges(1) params.corr_edges(end)]);
        end
        
        if isfield(analyses.corr,'partial')
            subplot(3,5,4);
            hold on; scatter(analyses.corr.distances(~isnan(analyses.corr.distances)),...
                analyses.corr.partial.values(~isnan(analyses.corr.partial.values)));
            title('partial correlations');
            subplot(3,5,9);
            hold on; imagesc(params.dist_edges,params.corr_edges,...
                analyses.corr.corr_dist_partial);
            colorbar;
            xlim([params.dist_edges(1) params.dist_edges(end)]);
            ylim([params.corr_edges(1) params.corr_edges(end)]);
            title('prob density');
            subplot(3,5,14);
            hold on; imagesc(params.dist_edges,params.corr_edges,...
                analyses.corr.shuffled.corr_dist_partial);
            colorbar;
            xlim([params.dist_edges(1) params.dist_edges(end)]);
            ylim([params.corr_edges(1) params.corr_edges(end)]);
        end
        
        if isfield(analyses.corr,'WL')
            subplot(3,5,5);
            hold on; scatter(analyses.corr.distances(~isnan(analyses.corr.distances)),...
                analyses.corr.WL.values(~isnan(analyses.corr.WL.values)));
            title('WL correlations');
            subplot(3,5,10);
            hold on; imagesc(params.dist_edges,params.corr_edges,...
                analyses.corr.corr_dist_WL);
            colorbar;
            xlim([params.dist_edges(1) params.dist_edges(end)]);
            ylim([params.corr_edges(1) params.corr_edges(end)]);
            title('prob density');
            subplot(3,5,15);
            hold on; imagesc(params.dist_edges,params.corr_edges,...
                analyses.corr.shuffled.corr_dist_WL);
            colorbar;
            xlim([params.dist_edges(1) params.dist_edges(end)]);
            ylim([params.corr_edges(1) params.corr_edges(end)]);
        end
    end
    
end