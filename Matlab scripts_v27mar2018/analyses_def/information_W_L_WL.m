function [info_states] = information_W_L_WL(data, status_vector, params)
%% which cells are carrying information about a binary variable?
%info + shuffling
if params.usePeaks == 0
    infoActivity = data.C_df;
else
    infoActivity = data.peaks;
end

%count frames with Q,W,WL
n_Q = sum(status_vector==0);
n_W = sum(status_vector==1);
n_WL = sum(status_vector==3);
n_states = [n_Q n_W n_WL];

min_frames = 5;
n_iter = 100;
%set infotoolbox parameters
opts.method = 'dr';
opts.bias = 'qe';
opts.btsp = 500;


%select number of frames to keep for each condition
state_keep = n_states >= min_frames;
n_keep = min(n_states(state_keep));
if state_keep(1)==0
    info_states = [];
else
    
    %if there are W frames, compute info during whisking only
    if state_keep(2) == 1
        activity1 = infoActivity(:,status_vector==1);
        activity0 = infoActivity(:,status_vector==0);
        numTimePts1 = size(activity1,2);
        numTimePts0 = size(activity0,2);
        
        for iter = 1:n_iter
            keep1 = randperm(numTimePts1,n_keep); %select randomly n time poits with whisking
            keep0 = randperm(numTimePts0,n_keep); %select randomly n time poits without whisking
            act1 = activity1(:,keep1);
            act0 = activity0(:,keep0);
            actArray = [act1 act0];
            stimArray = [ones(1,n_keep) zeros(1, n_keep)];
            
            optsTemp = opts;
            
            for indROI = 1:params.numROIs
                optsTemp = opts;
                [R, nt] = buildr(stimArray,actArray(indROI,:));
                R = binr(R, nt, 8, 'eqspace');
                optsTemp.nt = nt;
                Isc(indROI,:) = information(R, optsTemp, 'I');
                %diff between information of activity and 95th percentile of
                %information for shuffled activity
                I_W_all(indROI,iter) = Isc(indROI,1)-prctile(Isc(indROI,2:end),95);
                if Isc(indROI,1)-prctile(Isc(indROI,2:end),95)<0
                    I_W_all(indROI,iter)=0;
                else
                    I_W_all(indROI,iter) = Isc(indROI,1);
                end
            end
            I_W = mean(I_W_all,2);
            info_states.I_W = I_W;
        end
    end
    
    %if there are WL frames, compute info during whisking AND locomotion
    if state_keep(3) == 1
        activity1 = infoActivity(:,status_vector==3);
        activity0 = infoActivity(:,status_vector==0);
        numTimePts1 = size(activity1,2);
        numTimePts0 = size(activity0,2);
        
        for iter = 1:n_iter
            keep1 = randperm(numTimePts1,n_keep); %select randomly n time poits with whisking
            keep0 = randperm(numTimePts0,n_keep); %select randomly n time poits without whisking
            act1 = activity1(:,keep1);
            act0 = activity0(:,keep0);
            actArray = [act1 act0];
            stimArray = [ones(1,n_keep) zeros(1, n_keep)];
            
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
                    I_WL_all(indROI,iter)=0;
                else
                    I_WL_all(indROI,iter) = Isc(indROI,1);
                end
            end 
            I_WL = mean(I_WL_all,2);
            info_states.I_WL = I_WL;
        end
    end
end