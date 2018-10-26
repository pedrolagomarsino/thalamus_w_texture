function [deltaI] = information_binary(data, stimulus_bin, params)
%% which cells are carrying information about a binary variable?
%info + shuffling
if params.usePeaks == 0
    infoActivity = data.C_df;
else
    infoActivity = data.peaks;
end

%split time whisking/no whisking and keep same # time points for condition
activity1 = infoActivity(:,stimulus_bin==1);
activity0 = infoActivity(:,stimulus_bin==0);
numTimePts1 = size(activity1,2);
numTimePts0 = size(activity0,2);
numTimePts = min(numTimePts1,numTimePts0);



n_iter = 100; %repeat 100 times
frames_thr = 5;
if numTimePts <frames_thr
    deltaI = zeros(params.numROIs,n_iter);
    return
end
if numTimePts>=frames_thr
    for iter = 1:n_iter
        keep1 = randperm(numTimePts1,numTimePts); %select randomly n time poits with whisking
        keep0 = randperm(numTimePts0,numTimePts); %select randomly n time poits without whisking
        act1 = activity1(:,keep1);
        act0 = activity0(:,keep0);
        actArray = [act1 act0];
        stimArray = [ones(1,numTimePts) zeros(1, numTimePts)];
        %set infotoolbox parameters
        opts.method = 'dr';
        opts.bias = 'qe';
        opts.btsp = 500;     
        optsTemp = opts;
        
        for indROI = 1:params.numROIs
            optsTemp = opts;
            [R, nt] = buildr(stimArray,actArray(indROI,:));
            R = binr(R, nt, 8, 'eqspace');
            optsTemp.nt = nt;
            Isc(indROI,:) = information(R, optsTemp, 'I');
            %diff between information of activity and 95th percentile of
            %information for shuffled activity
            if Isc(indROI,1)-prctile(Isc(indROI,2:end),95)<0
                deltaI(indROI,iter) = 0;
            else
                deltaI(indROI,iter) = Isc(indROI,1);
            end
        end
        
    end
end
