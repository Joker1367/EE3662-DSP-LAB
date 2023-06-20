ECG_Fs = 1800;
load ECG % ECG: ECG signal, ECG_Fs: sampling rate in Hz
figure(1)
plot((0:length(ECG)-1)/ECG_Fs, ECG);
xlabel('Time (in sec.)')
ylabel('Amplitude (a.u.)');
title('ECG signal');

len = length(ECG);
figure(2)
freq_axis = (-len/2 : len/2 - 1)*ECG_Fs / len;
Total = fft(ECG);
Total = fftshift(Total);
plot(freq_axis, abs(Total));
title('Whole ECG');
ylabel('Magnitude');
xlabel('Frequency(Hz)');

ECG_wavelet = ECG(1500 : 3000);
figure(3)
plot((0:length(ECG_wavelet)-1)/ECG_Fs, ECG_wavelet);
xlabel('Time (in sec.)')
ylabel('Amplitude (a.u.)');
title('singel wavelet ECG signal');

len = length(ECG_wavelet);
figure(4)
freq_axis = (-len/2 : len/2 - 1)*ECG_Fs / len;
Single = fft(ECG_wavelet);
Single = fftshift(Single);
plot(freq_axis, abs(Single));
title('Single ECG');
ylabel('Magnitude');
xlabel('Frequency(Hz)');