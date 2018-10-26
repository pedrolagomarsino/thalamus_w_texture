function [perc_correct, perc_correct_singleROI] = decoding_performance(activity, stimulus)
%compute performance of linear decoders based an all ROIs calcium activity

addpath(genpath('/home/calcium/Monica/endoscopes_project/code/PopulationSpikeTrainFactorization'));

ind_1 = find(stimulus == 1); %find frame with whisking
ind_0 = find(stimulus == 0); %find frames without whisking
ind = min(length(ind_0),length(ind_1)); %find min number of frames
if mod(ind,2)~=0
    ind = ind-1;
end

rep = 100; %run decoder rep times and compute mean and std of decoding performance
if ind<=2
    perc_correct = zeros(1,rep);
    perc_correct_singleROI = zeros(size(activity,1),rep);
else
    for iter = 1:rep
        ind_1_keep = ind_1(randperm(length(ind_1),ind)); %randomly select frames with whisking
        ind_0_keep = ind_0(randperm(length(ind_0),ind)); %randomly select frames without whisking
        
        %divide considered frames in train and test set
        train_ind_0 = randperm(ind,round(ind/2))';
        train_ind_1 = randperm(ind,round(ind/2))';
        test_ind_0 = 1:1:ind;
        test_ind_0(train_ind_0) = [];
        test_ind_1 = 1:1:ind;
        test_ind_1(train_ind_1) = [];
        
        train_ind = [ind_1_keep(train_ind_1); ind_0_keep(train_ind_0)];
        test_ind = [ind_1_keep(test_ind_1); ind_0_keep(test_ind_0)];
        activity_train = activity(:,train_ind);
        groups_train = [ones(1,length(train_ind_1)) zeros(1,length(train_ind_0))]';
        activity_test = activity(:,test_ind);
        groups_test = [ones(1,length(train_ind_1)) zeros(1,length(train_ind_0))]';
        
        % Process activation coefficients for classification
        predictors_train = activity_train';
        predictors_test = activity_test';
        % Get classification performance on training and test sets
        [cc_train(iter),cc_test(iter)] = ldacc(predictors_train,groups_train,...
            predictors_test,groups_test);
        
        for id_roi = 1:size(activity,1)
            try
            [cc_train_singleROI(id_roi,iter),cc_test_singleROI(id_roi,iter)] = ...
                ldacc(predictors_train(:,id_roi),groups_train,...
                predictors_test(:,id_roi),groups_test);
            catch
                cc_train_singleROI(id_roi,iter)=50;
                cc_test_singleROI(id_roi,iter)=50;
            end
        end
    end
    
    perc_correct = cc_test;
    perc_correct_singleROI = cc_test_singleROI;
end
end