import numpy as np


def pre_emphasis(signal, coefficient=0.95):

    return np.append(signal[0], signal[1:] - coefficient*signal[:-1])

########################## Short Time Fourier Transform #####################################################################################


def STFT(time_signal, num_frames, num_FFT, frame_step, frame_length, signal_length, verbose=False):
    padding_length = int((num_frames - 1) * frame_step + frame_length)
    padding_zeros = np.zeros((padding_length - signal_length,))
    padded_signal = np.concatenate((time_signal, padding_zeros))

    # split into frames
    indices = np.tile(np.arange(0, frame_length), (num_frames, 1)) + np.tile(np.arange(0, num_frames*frame_step, frame_step), (frame_length, 1)).T
    indices = np.array(indices, dtype=np.int32)

    # slice signal into frames
    frames = padded_signal[indices]
    # apply window to the signal
    frames *= np.hamming(frame_length)

    # FFT
    complex_spectrum = np.fft.rfft(frames, num_FFT).T
    print(complex_spectrum.shape)
    absolute_spectrum = np.abs(complex_spectrum)

    if verbose:
        print('Signal length :{} samples.'.format(signal_length))
        print('Frame length: {} samples.'.format(frame_length))
        print('Frame step  : {} samples.'.format(frame_step))
        print('Number of frames: {}.'.format(len(frames)))
        print('Shape after FFT: {}.'.format(absolute_spectrum.shape))

    return absolute_spectrum


def mel2hz(mel):
    '''
    Transfer Mel scale to Hz scale
    '''
    ###################
    # YOUR CODE HERE
    hz = (np.power(10, mel / 2595) - 1) * 700  # change mel to Hz using the conversion formula
    ###################

    return hz


def hz2mel(hz):
    '''
    Transfer Hz scale to Mel scale
    '''
    ###################
    # YOUR CODE HERE
    mel = 2595 * np.log10(1 + hz / 700)       # change Hz to mel using the conversion formula
    ###################

    return mel


def get_filter_banks(num_filters, num_FFT, sample_rate, freq_min=0, freq_max=None):
    ''' Mel Bank
    num_filters: filter numbers
    num_FFT: number of FFT quantization values
    sample_rate: as the name suggests
    freq_min: the lowest frequency that mel frequency include
    freq_max: the Highest frequency that mel frequency include
    '''
    # convert from hz scale to mel scale
    low_mel = hz2mel(freq_min)
    high_mel = hz2mel(freq_max)

    # define freq-axis
    mel_freq_axis = np.linspace(low_mel, high_mel, num_filters + 2)
    hz_freq_axis = mel2hz(mel_freq_axis)

    # Mel triangle bank design (Triangular band-pass filter banks)
    bins = np.floor((num_FFT + 1) * hz_freq_axis / sample_rate)
    bins = np.array(bins, dtype = 'int32')
    fbanks = np.zeros((num_filters, int(num_FFT / 2 + 1)))

    ###################
    # YOUR CODE HERE
    
    # use linspace function and the index from bins to construct the triangular filter
    for i in range(1, num_filters + 1):
        up = np.linspace(0, 1, bins[i] - bins[i - 1] + 1)            # there are {bins[i] - bins[i - 1] + 1} points on the left part of triangle and the gain is from 0 to 1
        down = np.linspace(1, 0, bins[i + 1] - bins[i] + 1)          # there are {bins[i + 1] - bins[i] + 1} points on the right part of triangle and the gain is from 1 to 0
        fbanks[i - 1][bins[i - 1] : bins[i] + 1] += up               # add the constructed slope to the filter
        fbanks[i - 1][bins[i] + 1 : bins[i + 1] + 1] += down[1:]     # add the constucted slope to the filter
        
    ###################

    return fbanks
