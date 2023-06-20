'''
@Modified by Paul Cho; 10th, Nov, 2020

For NTHU DSP Lab 2022 Autumn
'''

import numpy as np
import soundfile as sf
import matplotlib.pyplot as plt
from librosa.filters import mel as librosa_mel_fn
from scipy.fftpack import dct

from Lab1_functions_student import pre_emphasis, STFT, mel2hz, hz2mel, get_filter_banks

filename = './audio.wav'
source_signal, sr = sf.read(filename)  # sr:sampling rate
print('Sampling rate={} Hz.'.format(sr))

# hyper parameters
frame_length = 512                    # Frame length(samples)
frame_step = 256                      # Step length(samples)
emphasis_coeff = 0.95                 # pre-emphasis para
num_bands = 12                    # Filter number = band number
num_FFT = frame_length                # FFT freq-quantization
freq_min = 0
freq_max = int(0.5 * sr)
signal_length = len(source_signal)    # Signal length

# number of frames it takes to cover the entirety of the signal
num_frames = 1 + int(np.ceil((1.0 * signal_length - frame_length) / frame_step))

##########################
'''
Part I:
(1) Perform STFT on the source signal to obtain one spectrogram (with the provided STFT() function)
(2) Pre-emphasize the source signal with pre_emphasis()
(3) Perform STFT on the pre-emphasized signal to obtain the second spectrogram
(4) Plot the two spectrograms together to observe the effect of pre-emphasis

hint for plotting:
you can use "plt.subplots()" to plot multiple figures in one.
you can use "axis.pcolor" of matplotlib in visualizing a spectrogram.
'''
# YOUR CODE STARTS HERE:

############################################## Pre-emphasis #######################################################################
pre_emphasis_signal_65 = pre_emphasis(source_signal, 0.65)        # s[n] = x[n] - 0.65 * x[n - 1]
pre_emphasis_signal_95 = pre_emphasis(source_signal, 0.95)        # s[n] = x[n] - 0.95 * x[n - 1]
pre_emphasis_signal_99 = pre_emphasis(source_signal, 0.99)        # s[n] = x[n] - 0.99 * x[n - 1]

################################################# STFT ############################################################################
original_spectrogram = STFT(source_signal, num_frames, num_FFT, frame_step, frame_length, signal_length, False)
pre_emphasis_spectrogram_95 = STFT(pre_emphasis_signal_95, num_frames, num_FFT, frame_step, frame_length, signal_length, False)
pre_emphasis_spectrogram_99 = STFT(pre_emphasis_signal_99, num_frames, num_FFT, frame_step, frame_length, signal_length, False)
pre_emphasis_spectrogram_65 = STFT(pre_emphasis_signal_65, num_frames, num_FFT, frame_step, frame_length, signal_length, False)

########################################## Plot the spectrum of different pre-emphasis coefficient ################################
fig, ax = plt.subplots()
c = ax.pcolor(original_spectrogram);
ax.set_xlabel('frame')
ax.set_ylabel('frequency band')
ax.set_title('Original')

fig, ax = plt.subplots()
c = ax.pcolor(pre_emphasis_spectrogram_95);
ax.set_xlabel('frame')
ax.set_ylabel('frequency band')
ax.set_title('coeff = 0.95')


fig, ax = plt.subplots()
c = ax.pcolor(pre_emphasis_spectrogram_99);
ax.set_xlabel('frame')
ax.set_ylabel('frequency band')
ax.set_title('coeff = 0.99')

fig, ax = plt.subplots()
c = ax.pcolor(pre_emphasis_spectrogram_65);
ax.set_xlabel('frame')
ax.set_ylabel('frequency band')
ax.set_title('coeff = 0.65')

plt.show()

# YOUR CODE ENDS HERE;
##########################

'''
Head to the import source 'Lab1_functions_student.py' to complete these functions:
mel2hz(), hz2mel(), get_filter_banks()
'''
# get Mel-scaled filter
fbanks = get_filter_banks(num_bands, num_FFT, sr, freq_min, freq_max)  # fbank.shape = (12, 257)

##########################
'''
Part II:
(1) Convolve the pre-emphasized signal with the filter
(2) Convert magnitude to logarithmic scale
(3) Perform Discrete Cosine Transform (dct) as a process of information compression to obtain MFCC
    (already implemented for you, just notice this step is here and skip to the next step)
(4) Plot the filter banks alongside the MFCC
'''
# YOUR CODE STARTS HERE:

#  fbank.shape = (12, 257), pre_emphasis_spectrum.shape = (257, 552)
mel_spectrogram = np.matmul(fbanks, pre_emphasis_spectrogram_95)       # M = fbank * pre-emphasis spectrum -> M.shape = (12, 512), row represent frequency, column reresent frame
features = np.log10(mel_spectrogram)                                   # Log energy
features = features.T                                                  # make row becomes frame, column becomes amplitude. This step help us perform the DCT correctly

# step(3): Discrete Cosine Transform
MFCC = dct(features, norm='ortho')[:, :num_bands]
# equivalent to Matlab dct(x)
# The numpy array [:,:] stands for everything from the beginning to end.

################################ Plot MFCC of a random frame #####################################################
fig, ax = plt.subplots()
plt.plot(MFCC[5])
ax.set_xlabel('cepstral coefficient')
ax.set_ylabel('Magnitude')
ax.set_title('MFCC of random frame')
plt.show()

MFCC = MFCC.T  # make row become frame, column become MFCC. This step makes us easier to plot the MFCC

############################## Plot the tringular window filter #################################################
fig, ax = plt.subplots()
for i in range(0, num_bands):
    plt.plot(fbanks[i])
ax.set_xlabel('frequency (kHz)')
ax.set_ylabel('Mel-scale filter banks')
ax.set_title('mel-scaled filter bank')

############################## Plot the MFCC of each frame ######################################################
fig, ax = plt.subplots()
ax.pcolor(MFCC)
ax.set_xlabel('frame')
ax.set_ylabel('MFCC coeffient')
ax.set_title('MFCC')

plt.show()

# YOUR CODE ENDS HERE;
##########################
