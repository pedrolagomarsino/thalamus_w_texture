import numpy as np
import matplotlib.pyplot as plt
import h5py
import scipy.signal as sig
file_name = 'C:/Users/plagomarsino/work/Thalamus_proyect/Whisking on Texture/\
Data/20180412/Mouse_2314/TSeries-04122018-0853-1003/Post_proc_2/TS1003_C_no_stim_times.mat'
f = h5py.File(file_name,'r')
trace_all = f.get('data/C_df')
period = f.get('data/framePeriod')

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

        rise_init: array of valleys-indexes with starting valleys of events
        decay_indx: array of valleys-indexes with ending valleys of events
        n_events: number of events detected
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
    rise_valley_indx = [extremes[idx-1] for peak in peaks for idx in np.where(extremes==peak)[0] if idx>0]
    decay_valley_indx = [extremes[idx] for init in rise_valley_indx for idx in \
                        np.nditer(next((i for i,v in enumerate(np.logical_and(extremes>init,trace[extremes]\
                        <= trace[init]+(trace[extremes[np.where(extremes==init)[0]+1]]-trace[init])*.5))\
                        if v==True),-100)) if idx != -100]

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
    events['event_init'] = rise_events
    events['event_end'] = decay_valley_indx
    events['n_events'] = len(rise_events)
    events['n_peaks'] = len(peaks)

    return events

events = find_events(trace[:,1],period)
