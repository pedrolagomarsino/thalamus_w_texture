function [duration]=mean_state_dur(raw_state_var)
%define a state_vector for quiet (has to be different from the state_vector defined before because it was defined using the downsampled data)
Quiet = zeros(size(raw_state_var.time));
for i=1:length(Quiet)
    if raw_state_var.stimulus(i) == 0 && raw_state_var.locomotion(i) == 0 && raw_state_var.whisking(i) == 0
        Quiet(i) = 1;
    end
end
start_Quiet = find(diff(Quiet)>.5);
end_Quiet = find(diff(Quiet)<-.5);
if Quiet(1)==1
start_Quiet = [1;start_Quiet];
end
if Quiet(end)==1
end_Quiet = [end_Quiet;length(Quiet)];
end
dur_Quiet = raw_state_var.time(end_Quiet)-raw_state_var.time(start_Quiet);

start_stimulus = find(diff(raw_state_var.stimulus)>.5);
end_stimulus = find(diff(raw_state_var.stimulus)<-.5);
if raw_state_var.stimulus(1)==1
start_stimulus = [1;start_stimulus];
end
if raw_state_var.stimulus(end)==1
end_stimulus = [end_stimulus;length(raw_state_var.stimulus)];
end
dur_stimulus = raw_state_var.time(end_stimulus)-raw_state_var.time(start_stimulus);

start_loco = find(diff(raw_state_var.locomotion)>.5);
end_loco = find(diff(raw_state_var.locomotion)<-.5);
if raw_state_var.locomotion(1)==1
start_loco = [1;start_loco];
end
if raw_state_var.locomotion(end)==1
end_loco = [end_loco;length(raw_state_var.locomotion)];
end
dur_loco = raw_state_var.time(end_loco)-raw_state_var.time(start_loco);

start_whisking = find(diff(raw_state_var.whisking)>.5);
end_whisking = find(diff(raw_state_var.whisking)<-.5);
if raw_state_var.whisking(1)==1
start_whisking = [1;start_whisking];
end
if raw_state_var.whisking(end)==1
end_whisking = [end_whisking;length(raw_state_var.whisking)];
end
dur_whisking = raw_state_var.time(end_whisking)-raw_state_var.time(start_whisking);
%vectors with the length of all the periods for each state
duration.Quite = dur_Quiet;
duration.locomotion = dur_loco;
duration.whisking = dur_whisking;
duration.stimulus = dur_stimulus;

end