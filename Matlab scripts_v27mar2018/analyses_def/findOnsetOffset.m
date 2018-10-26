function [onsetTime, offsetTime] = findOnsetOffset(binarySignal)
%compute onset and offet time of binary signal
%NOTE: units are frames, the results must be multiplied by the frameRate if
%you want to have seconds

if size(binarySignal,2)~=1
    binarySignal = binarySignal';
end

onsetTime = find(diff(binarySignal)==1)+1;
offsetTime = min(length(binarySignal),find(diff(binarySignal)==-1));
if isempty(onsetTime) && ~isempty(offsetTime)
    offsetTime = length(binarySignal);
elseif ~isempty(onsetTime) && isempty(offsetTime)
    onsetTime = 1;
elseif ~isempty(onsetTime) && ~isempty(offsetTime)
    if onsetTime(1)>offsetTime(1)
        onsetTime = [1; onsetTime];
    end
    if onsetTime(end)>offsetTime(end)
        offsetTime = [offsetTime; length(binarySignal)];
    end
end