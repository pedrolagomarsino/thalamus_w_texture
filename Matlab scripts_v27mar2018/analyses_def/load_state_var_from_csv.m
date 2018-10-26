function raw_behav_data = load_state_var_from_csv(csv_path)
%load data from csv
%input: csv_path: csv path and name
%output:
%raw_behav_data: structure with
%    time (s)
%    speed (cm/s)
%    radius (mm)
%    meanAngle (rad)
%    locomotion (0/1)
%    whisking (0/1)
%    stimulus (0/1)

[time,cmSec,radius,meanAngle,locomotion,whisking,stimulus] = importfile_s(csv_path);
raw_behav_data.time = time; %raw state time
raw_behav_data.speed = cmSec; %raw speed
raw_behav_data.pupil = radius; %raw pupil radius
raw_behav_data.whisk_angle = meanAngle; %raw whisk angle
raw_behav_data.locomotion = locomotion; %binary locomotion
raw_behav_data.whisking = whisking; %binary whisking
raw_behav_data.stimulus = stimulus; %binary stimulus
end