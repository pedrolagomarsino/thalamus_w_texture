import numpy as np
import h5py
file_name = 'C:/Users/plagomarsino/work/Thalamus_proyect/Whisking on Texture/\
Data/20180412/Mouse_2314/TSeries-04122018-0853-1003/Post_proc_2/TS1003_C_no_stim_times.mat'
f = h5py.File(file_name,'r')
trace = f.get('data/C_df')
print(trace)

def events = find_events(trace,period):
    """
    Find events in paninski processed calcium traces.
    Events are defined as calcium activity between the first valley
    preceding a peak, and the next valley whos value (Df/F) is at most half
    the intensity difference between the peak and the valley.
    
    Obs: whit this definition each event can contain several other peaks and
    valleys, and the half amplitud constrain is not necesary between the
    highest peak and the lowest valley in the event.
    ----------------------------------------------------------------------------
    INPUTS
    trace = 1 neuron calcium trace processed as paninski: data.C_df in
           Monica's code.
    period = period of sampling. data.framePeriod in Monica's code
    ----------------------------------------------------------------------------
    OUTPUTS
    find_events returns "events" a struct array containing fields:
        peaks: all peaks above one std of the trace
        value: array of the DF/F value of peaks
        time: array of time in seconds of each peak in peaks
        valleys: all valleys
        value: array of the DF/F value of valleys
        time: array of time in seconds of each valley in valleys

        rise_init: array of valleys-indexes with starting valleys of events
        decay_indx: array of valleys-indexes with ending valleys of events
        n_events: number of events detected
    """
    events = struct();
    # findpeaks
    [peaks,indx] = findpeaks(trace);
    peaksbig = peaks(peaks>std(trace));
    indxbig = indx(peaks>std(trace));
    # find valleys
    [valley,indxval] = findpeaks(-trace);
    rise_valley_indx = [];
    decay_valley_indx = [];
    for i = 1:length(peaksbig)
        rise_valley_indx = [rise_valley_indx , find(indxval<indxbig(i),1,'last')];
        if (isempty(decay_valley_indx) || indxbig(i)>=indxval(decay_valley_indx(end))) && ~isempty(rise_valley_indx)
            decay_indx = find(indxval>indxval(rise_valley_indx(end)) & -valley<=(peaksbig(i)-.5*(peaksbig(i)+valley(rise_valley_indx(end)))),1);
            decay_valley_indx = [decay_valley_indx ,decay_indx ];
        end
    end

    rise_events = rise_valley_indx(1);
    for i = 2:length(decay_valley_indx)
        rise_events = [rise_events , rise_valley_indx(find(rise_valley_indx<decay_valley_indx(i) & rise_valley_indx>=decay_valley_indx(i-1),1)) ];
    end

    events.peaks.value = peaksbig;
    events.peaks.time = indxbig*period;
    events.valleys.value = -valley;
    events.valleys.time = indxval*period;
    events.event_init = rise_events;
    events.event_end = decay_valley_indx;
    events.n_events = length(events.event_init);
    events.n_peaks = length(events.peaks.value);
    end
