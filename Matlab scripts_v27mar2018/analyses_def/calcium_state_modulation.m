function single_cell = calcium_state_modulation(data,analyses,params)
%this function compute the mean ROI calcium activity across behavioral
%states

if params.stimulus == 0
    [single_cell.calcium.mean] = singleCellActivity(data,...
        analyses,params);
else
    [single_cell.calcium.mean] = singleCellActivity(data,...
        analyses,params);
end
end

function cellMean = singleCellActivity(data,analyses,params)
%single cell activity characterization

state_vector = analyses.behavior.states_vector;
if params.usePeaks == 0
    activity = data.C_df;
else
    activity = data.peaks;
    %     activity(activity==0)=NaN;
end

%remove frames with only locomotion
activity(:,state_vector==2) = [];
state_vector(state_vector==2)=[];

%population global activity
meanActivity = nanmean(activity,1);

cellMean=[];
%single cell activity
for i = 1:params.numROIs
    activityTemp =  activity(i,:);
    [cellMean(i,:), grMeanCI] = grpstats(activityTemp,state_vector,{'nanmean','meanci'},'Alpha',0.05);
    %             [p,tbl,stats] = anova1(meanActivity,stateVector);
    %             figure;
    %             [c,m,h,nms] = multcompare(stats);
end
cellMean(isnan(cellMean))=0;
if isempty(find(unique(state_vector)==0))
    cellMean = [zeros(size(cellMean,1),1) cellMean];
end
if isempty(find(unique(state_vector)==1))
    cellMean = [cellMean(:,1) zeros(size(cellMean,1),1) cellMean(:,2:end)];
end
if isempty(find(unique(state_vector)==3))
    cellMean = [cellMean(:,1:2) zeros(size(cellMean,1),1)];
end
end