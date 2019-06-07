import numpy as np
import matplotlib.pyplot as plt
import h5py
import scipy.signal as sig
file_name = 'C:/Users/plagomarsino/work/Thalamus_proyect/Whisking on Texture/\
Data/20180412/Mouse_2314/TSeries-04122018-0853-1003/Post_proc_2/TS1003_C_no_stim_times.mat'
f = h5py.File(file_name,'r')
trace_all = f.get('data/C_df')
period = f.get('data/framePeriod')[0]
trace = trace_all[:,1]

def find_events(trace,period):
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
    find_events returns a nested dictionary "events" containing keys:
        peaks: all peaks above one std of the trace containing keys:
            value: array of the DF/F value of peaks
            time: array of time in seconds of each peak in peaks
        valleys: all valleys containing keys:
            value: array of the DF/F value of valleys
            time: array of time in seconds of each valley in valleys
        rise_init: array of time in seconds of events start
        decay_indx: array of time in seconds of events end
        n_events: number of events detected
        n_peaks: number of peaks detected
    """
    events = {'peaks'  : {'value':None,'time':None},
              'valleys':{'value':None,'time':None},
              'event_init':None,
              'event_end' :None,
              'n_events'  :None,
              'n_peaks'   :None}
    # findpeaks
    peaks, prop_peaks = sig.find_peaks(trace,np.std(trace))
    # find valleys
    valley, prop_valley = sig.find_peaks(-trace)
    extremes = np.sort(np.concatenate((peaks,valley)))
    #Events
    rise_valley_indx = [extremes[idx-1] for peak in peaks for idx in np.where(extremes==peak)[0] if idx>0] #each valley before a peak
    decay_valley_indx = [extremes[idx] for init in rise_valley_indx for idx in \
                        np.nditer(next((i for i,v in enumerate(np.logical_and(extremes>init,trace[extremes]\
                        <= trace[init]+(trace[extremes[np.where(extremes==init)[0]+1]]-trace[init])*.5))\
                        if v==True),-100)) if idx != -100] #each valley after the beggining of event such that is lower than half the height of the first peak
    #select only non overlapping events
    rise_events  = rise_valley_indx[0:1]
    decay_events = decay_valley_indx[0:1]
    for i,v in enumerate(decay_valley_indx[1:]):
        val = rise_valley_indx[i+1]
        if val>=decay_events[-1]:
            rise_events.append(val)
            decay_events.append(v)

    events['peaks']['value'] = prop_peaks['peak_heights']
    events['peaks']['time'] = peaks*period
    events['valleys']['value'] = trace[valley]
    events['valleys']['time'] = valley*period
    events['event_init'] = rise_events*period
    events['event_end'] = decay_events*period
    events['n_events'] = len(rise_events)
    events['n_peaks'] = len(peaks)

    return events
def event_analysis(trace,events,period):
    """
    Calculate the values that characterize the events
    ----------------------------------------------------------------------------
    INPUTS
    trace = 1 neuron calcium trace processed as paninski: data.C_df in Monica's
            code.
    events: dictionary containing events info (find_events output)
    period = period of sampling. data.framePeriod in Monica's code
    ----------------------------------------------------------------------------
    OUTPUTS
    peak_amp: array with the value of the highest peak in each event
    rise_time: array with the time in seconds to reach the peak_amp
    decay_time: array with the time in seconds from the peak_amp to the end of the event
    AUC_event: area under the curve of the event (trapezoid integration of the signal for the duration of the event)
    """
    init = (events['event_init']/period).astype(int)
    fin = (events['event_end']/period).astype(int)
    peak_amp = np.array([peak for j,_ in enumerate(init) for peak in np.nditer(max(trace[init[j]:fin[j]]))])
    rise_time = np.array([time*period[0] for i,peak in enumerate(peak_amp) for time in (np.where(trace==peak)[0]-init[i])])
    decay_time = np.array([time*period[0] for i,peak in enumerate(peak_amp) for time in (fin[i]-np.where(trace==peak)[0])])
    AUC_event = np.array([area for i,_ in enumerate(init) for area in np.nditer(np.trapz(trace[init[i]:(fin[i]+1)],dx=period))])

    return [peak_amp,rise_time,decay_time,AUC_event]
def peak_analysis(trace,events,period):
    """
    Same as in event analysis but for each peak above 1 std. begining and end
    are defined as the previous and following valley for each peak
    """
    first_flag = False
    last_flag  = False
    peaks = (events['peaks']['time']/period).astype(int)
    valleys = (events['valleys']['time']/period).astype(int)
    extremes = np.sort(np.concatenate((peaks,valleys)))

    if extremes[0] == peaks[0]:
        first_flag = True

    if extremes[-1] == peaks[-1]:
        last_flag = True

    init = [extremes[idx-1] for peak in peaks for idx in np.where(extremes==peak)[0] if idx>0]
    end = [extremes[idx+1] for peak in peaks for idx in np.where(extremes==peak)[0] if idx<len(extremes)-1]
    if first_flag:
        peak_amp = events['peaks']['value'][1:]-trace[init]
        rise_time = events['peaks']['time'][1:]-init*period
    else:
        peak_amp = events['peaks']['value']-trace[init]
        rise_time = events['peaks']['time']-init*period
    if last_flag:
        deca_time = end*period-events['peaks']['time'][:-1]
    else:
        deca_time = end*period-events['peaks']['time']

    # for i = 1:n
        # init_val = find(events.valleys.time < events.peaks.time(i),1,'last');
        # end_val  = find(events.valleys.time > events.peaks.time(i),1);
        
#
        # if ~isempty(init_val) && ~isempty(end_val)
            # peak_amp(i) = events.peaks.value(i)-events.valleys.value(init_val);

#
            # rise_time(i) = events.peaks.time(i)-events.valleys.time(init_val);

#
            # decay_time(i) = events.valleys.time(end_val)-events.peaks.time(i);

#
            # AUC_peak(i) = trapz(time(round(events.valleys.time(init_val)/period:events.valleys.time(end_val)/period)),cal_trace(round(events.valleys.time(init_val)/period:events.valleys.time(end_val)/period)));
        # end
    # end
    # peak_amp(peak_amp==0)     = [];
    # rise_time(rise_time==0)   = [];
    # decay_time(decay_time==0) = [];

    return [peak_amp,rise_time,decay_time,AUC_peak]


events = find_events(trace,period)
[peak_amp,rise_time,decay_time,AUC_event] = event_analysis(trace,events,period)
