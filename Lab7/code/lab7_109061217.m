%clear
%close all

%% Load ECG data
% This raw ECG did not go through the analog notch filter
%data = load('ECG_signal.mat');
%ECG = data.ECG;
%fs = data.fs;
%Npoint = length(ECG);

% calculate t_axis and f_axis
%dt = 1 / fs; % time resolution
%t_axis = (0 : dt : 1/fs*(Npoint - 1));
%df = fs / Npoint; % frequency resolution
%f_axis = (0:1:(Npoint-1))*df - fs/2;  % frequency axis (shifted)

clear all;
fclose('all');

% Check if serial port object or any communication interface object exists
serialobj=instrfind;
if ~isempty(serialobj)
    delete(serialobj)
end

clc;
clear all;
close all;
%% ---------- Serial port setting ----------
s1 = serial('COM3');  % Construct serial port object
s1.BaudRate = 115200;     % Define baud rate of the serial port
fopen(s1); % Connect the serial port object to the serial port

%% ---------- Sampling setting ----------
NSample = 3000; % Number of sampling points, i.e., number of data points to acquire
fs = 500; % Sampling rate, check the setting in Arduino 

%% ---------- Display buffer setting ----------
display_length = 3000; % Display buffer length 
display_buffer = nan(1, display_length); % Display buffer is a first in first out queue
result = nan(1, NSample);
t_axis = (0 : display_length - 1) * (1 / fs); % Time axis of the display buffer
f_axis = (-display_length / 2 : display_length / 2 - 1) * (fs / display_length);

% Initialize figure object
figure
h_plot = plot(nan,nan);
hold off 

tic
for i = 1:NSample
    data = fscanf(s1); % Read from Arduino
    data = str2double(data);
    disp(data);
    
    % Add data to display buffer
    if i <= display_length
        display_buffer(i) = data;
    else
        display_buffer = [display_buffer(2:end) data]; % first in first out
    end
    

    % Update figure plot
    %set(h_plot, 'xdata', t_axis, 'ydata', display_buffer);
    %title('ECG');
    %xlabel('Time(sec)');
    %ylabel('Quantized value');
    %drawnow;
end
toc

for i = 1 : NSample
    if(isnan(display_buffer(i)))
        display_buffer(i) = 0;
    end
    %display_buffer(i) = display_buffer(i) - 350;
end

%display_buffer = display_buffer - mean(display_buffer);

figure(1)
plot(t_axis, display_buffer);
xlabel('Time (in sec.)')
ylabel('Amplitude (a.u.)');
title('ECG signal');

% plot signal and its frequency spectrum
figure(2)
plot(f_axis, abs(fftshift(fft(display_buffer))))
xlabel('Frequency(Hz)')
ylabel('Magnitude')
title('Frequency spectrum')

%% (1) Design a digital filter to remove the 60Hz power noise

% filter design
% https://www.mathworks.com/help/signal/filter-design.html
% Hint: you may use moving average filter or fir1() or anything else
% In the report, please describe how you design this filter

% Moving Average filter
ma = ones(1,8)/8;
%freqz(ma, 1)

% IIR Notch
w0 = 60 / (fs / 2);
bw = w0 / 35;
[num,den] = iirnotch(w0,bw);
fvtool(num, den);

% FIR Notch
FIR_notch = fir1(80,[0.20 0.28], 'stop');
%freqz(FIR_notch,1,512)


RESULT = conv(display_buffer, ma, 'same');
%RESULT = filter(num, den, display_buffer);
RESULT = filter(FIR_notch, 1, RESULT);


% Plot the filtered signal and its frequency spectrum
figure(3)
plot(t_axis, RESULT);
xlabel('Time (in sec.)')
ylabel('Amplitude (a.u.)');
title('ECG signal with FIR Notch filter');

figure(4)
plot(f_axis, abs(fftshift(fft(RESULT))))
xlabel('Frequency(Hz)')
ylabel('Magnitude');
title('Frequency spectrum with FIR Notch filter')

%% (2) Design a digital filter to remove baseline wander noise

% filter design or somehow remove the baseline wander noise
% Hint: you may use high-pass filters or (original signal - low passed signal)
bhi = fir1(34,0.06,'high');
%freqz(bhi, 1)
ECG = filter(bhi, 1, RESULT);

%ECG = conv(ECG, ma, 'same');

figure(5)
plot(t_axis, ECG);
xlabel('Time (in sec.)')
ylabel('Amplitude (a.u.)');
title('ECG signal');

figure(6)
plot(f_axis, abs(fftshift(fft(ECG))))
xlabel('Frequency(Hz)')
ylabel('Magnitude');
title('Frequency spectrum')
% plot the filtered signal

%% (3) Utilizing the ADC dynamic range in 8-bit
% the code should be written in Arduino
