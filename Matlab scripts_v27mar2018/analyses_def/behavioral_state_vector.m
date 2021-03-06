function behavior = behavioral_state_vector(data,params)

disp('Building behavioral states vector...')
if params.stimulus == 0
    numFramesQuiet = sum( data.whisking+data.locomotion == 0 );
    numFramesWL = sum( data.whisking+data.locomotion == 2 );
    numFramesW = sum( data.whisking == 1 )-numFramesWL;
    numFramesL = sum( data.locomotion == 1 )-numFramesWL;
    
    %build states count vector
    statesCount_Q_W_WL_L = [numFramesQuiet, numFramesW, numFramesWL, numFramesL];
    statesFreq_Q_W_WL_L = statesCount_Q_W_WL_L/length(data.time_ca);
    behavior.count = statesCount_Q_W_WL_L;
    behavior.freq = statesFreq_Q_W_WL_L;
    
    %build states vector
    state_vector = zeros(length(data.time_ca),1);
    state_vector = state_vector + data.whisking + 2*data.locomotion;
    behavior.states_vector = state_vector;
       
else
    numFramesQuiet = sum( data.whisking + data.locomotion + data.stimulus == 0 );
    numFramesWLT = sum( data.whisking + data.locomotion + data.stimulus == 3 );
    numFramesWL = sum( data.whisking + data.locomotion == 2 ) - numFramesWLT;
    numFramesWT = sum( data.whisking + data.stimulus == 2 ) - numFramesWLT;
    numFramesLT = sum( data.stimulus + data.locomotion == 2 ) - numFramesWLT;
    numFramesW = sum( data.whisking == 1 ) - numFramesWL - numFramesWT - numFramesWLT;
    numFramesL = sum( data.locomotion == 1 ) - numFramesWL - numFramesLT - numFramesWLT;
    numFramesT = sum( data.stimulus == 1 ) - numFramesWT - numFramesLT - numFramesWLT;
    
    %build states count vector
    statesCount_Q_W_T_WL_WT_WLT_LT_L = [numFramesQuiet, numFramesW, numFramesT, numFramesWL, numFramesWT, numFramesWLT, numFramesLT, numFramesL];
    statesFreq_Q_W_T_WL_WT_WLT_LT_L = statesCount_Q_W_T_WL_WT_WLT_LT_L/length(data.time_ca);
    behavior.count = statesCount_Q_W_T_WL_WT_WLT_LT_L;
    behavior.freq = statesFreq_Q_W_T_WL_WT_WLT_LT_L;
    
    %build states vector
    state_vector = zeros(length(data.time_ca),1);
    state_vector = state_vector + data.whisking + 2*data.locomotion + .5*data.stimulus;
    behavior.states_vector = state_vector;
end
