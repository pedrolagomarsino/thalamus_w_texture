function [perc_correct, perc_correct_singleROI] = decoding_performance_n(activity, stimulus)
%compute performance of linear decoders based an all ROIs calcium activity

addpath(genpath('/home/calcium/Monica/endoscopes_project/code/PopulationSpikeTrainFactorization'));

stim = unique(stimulus);
n_pt = zeros(1,length(stim));
for id_s = 1:length(stim)
    n_pt(id_s) = length(find(stimulus == stim(id_s))); %find frame with whisking
end

ind = min(n_pt); %find min number of frames
if mod(ind,2)~=0
    ind = ind-1;
end
min_frames = 10;

rep = 100; %run decoder rep times and compute mean and std of decoding performance
if ind<=min_frames
    perc_correct = zeros(1,rep);
    perc_correct_singleROI = zeros(size(activity,1),rep);
else
    for iter = 1:rep
        act_keep = zeros(size(activity,1),ind,length(stim));
        for id_s = 1:length(stim) %randomly select frames for all conditions
           act_temp = activity(:,find(stimulus == stim(id_s)));
           act_keep(:,:,id_s) = act_temp(:,randperm(n_pt(id_s),ind));
        end
        
        %divide considered frames in train and test set
        for id_s = 1:length(stim)
            train_ind(id_s,:) = randperm(ind,round(ind/2))';
            test_ind_temp = 1:1:ind;
            test_ind_temp(train_ind(id_s,:)) = [];
            test_ind(id_s,:) = test_ind_temp;
        end
        
        act_train = [];
        act_test = [];
        groups_train = [];
        groups_test = [];
        for id_s = 1:length(stim)
            act_train = [act_train act_keep(:,train_ind(id_s,:),id_s)];
            groups_train = [groups_train id_s*ones(1,length(train_ind(id_s,:)))];
            act_test = [act_test act_keep(:,test_ind(id_s,:),id_s)];
            groups_test = [groups_test id_s*ones(1,length(test_ind(id_s,:)))];
        end

        % Process activation coefficients for classification
        predictors_train = act_train';
        predictors_test = act_test';
        groups_train = groups_train';
        groups_test = groups_test';
        % Get classification performance on training and test sets
        [cc_train(iter),cc_test(iter)] = ldacc(predictors_train,groups_train,...
            predictors_test,groups_test);
        
        for id_roi = 1:size(activity,1)
            try
                [cc_train_singleROI(id_roi,iter),cc_test_singleROI(id_roi,iter)] = ...
                ldacc(predictors_train(:,id_roi),groups_train,...
                predictors_test(:,id_roi),groups_test);
            catch
                cc_train_singleROI(id_roi,iter)=100/length(unique(groups_train));
                cc_test_singleROI(id_roi,iter)=100/length(unique(groups_train));
            end
        end
    end
    
    perc_correct = cc_test;
    perc_correct_singleROI = cc_test_singleROI;
end
end