clear all
%load('C:\Users\user\OneDrive\桌面\DSP_Lab\Lab8\MIT database\easy\100m.mat')
%load('112m.csv');
load('C:\Users\user\OneDrive\桌面\DSP_Lab\Lab8\MIT database\mid\219m.mat')
%load('C:\Users\user\OneDrive\桌面\DSP_Lab\Lab8\MIT database\hard\222m.mat')

fs = 360;
raw_ECG = val(1,:);
len = length(raw_ECG);

t_axis = (0:len - 1) / fs;
f_axis = (-len/2 : len/2 - 1) / len * fs;

raw_ECG = raw_ECG - mean(raw_ECG);

figure(1)
plot(t_axis(1:3600), raw_ECG(1:3600));
xlabel('Time(sec)');
ylabel('Quantized value');
title('raw ECG');
% 
% figure(2)
% plot(f_axis, abs(fftshift(fft(raw_ECG))));
% xlabel('Frequency(Hz)');
% ylabel('Quantized value');
% title('raw ECG');

gd = 12;

ma = ones(1,6)/6;
%freqz(ma, 1);
%gd = gd - mean(grpdelay(ma, 5));
ma2 = ones(1,20)/20;
gd = gd - mean(grpdelay(ma2, 5));
df = [2, 1, -1, -2];
gd = gd - mean(grpdelay(df, 5));

FIR_notch_60 = fir1(30,[0.28 0.38], 'stop');
FIR_notch_30 = fir1(60,[0.12 0.2], 'low');
HP = fir1(34, 0.3, 'low');
%freqz(FIR_notch_30, 1);

%ECG = conv(raw_ECG, ma, 'same');
ECG = conv(raw_ECG, HP, 'same');
ECG = conv(ECG, FIR_notch_60, 'same');

ECG = conv(ECG, df, 'same');

% figure(5)
% plot(t_axis(1:3600), ECG(1:3600));
% xlabel('Time(sec)');
% ylabel('Quantized value');
% title('ECG');

ECG = ECG .* ECG;

ECG = conv(ECG, ma2, 'same');

figure(6)
plot(t_axis(1:3600), ECG(1:3600));
xlabel('Time(sec)');
ylabel('Quantized value');
title('ECG');

%[pks, locs] = findpeaks(ECG(1:3600),1,'MinPeakHeight',250, 'MinPeakDistance', 100);
[pks, locs] = findpeaks(ECG,1, 'MinPeakDistance', 200);
%[pks, locs] = findpeaks(ECG,1,'MinPeakHeight',8000, 'MinPeakDistance', 200);


predict = t_axis(locs + 1) + gd / 360;
[pks, locs] = findpeaks(raw_ECG,1, 'MinPeakDistance', 200);
answer = t_axis(locs + 1);

TP = 0;
TN = 0;
FP = 0;
for i = 1 : length(predict)
    if(abs(predict(i) - answer(i)) <= 1 / 360)
        TP = TP + 1;
    end
end

TN = length(answer) - TP;
FP = length(predict) - TP;

X = sprintf("TP = %g, TN = %g, FP = %g", TP, TN, FP);
disp(X);


%findpeaks(ECG(1:3600),fs,'MinPeakHeight',60);
% [pks, locs] = findpeaks(ECG(1:3600),1, 'MinPeakDistance', 200);
% figure(5)
% hold on
% %plot(t_axis(1:3600), raw_ECG(1:3600));
% plot(t_axis(1:3600), ECG(1:3600));
% %plot(t_axis(locs+1+gd), raw_ECG(locs+1+gd), 'o');
% plot(t_axis(locs + 1), ECG(locs + 1), 'o');
% hold off
% xlabel('Time(sec)');
% ylabel('Quantized value');
% title('ECG');