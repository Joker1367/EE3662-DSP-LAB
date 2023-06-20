%%
%% Note that you have to fill the "???" parts by yourself before running the codes
%% You also can modify the codes to meet your applications
%%
%%


%% Clear and close everything
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
fs = 1000; % Sampling rate, check the setting in Arduino 

%% ---------- Display buffer setting ----------
display_length = 3000; % Display buffer length 
display_buffer = nan(1, display_length); % Display buffer is a first in first out queue
result = nan(1, NSample)
time_axis = (0 : display_length - 1) * (1 / fs); % Time axis of the display buffer
freq_axis = (-display_length / 2 : display_length / 2 - 1) * (fs / display_length)

% Initialize figure object
figure
h_plot = plot(nan,nan);
%fft_plot = plot(nan,nan);
hold off 

tic
for i = 1:NSample
    data = fscanf(s1); % Read from Arduino
    data = str2double(data);
    disp(data);
    result(i) = data;

    % Add data to display buffer
    if i <= display_length
        display_buffer(i) = data;
    else
        display_buffer = [display_buffer(2:end) data]; % first in first out
    end
    

    % Update figure plot
    set(h_plot, 'xdata', time_axis, 'ydata', display_buffer);
    title('ECG');
    xlabel('Time(sec)');
    ylabel('Quantized value');
    drawnow;
end
toc
%% ---------- Display buffer setting ----------
for i = 1 : NSample
    if(isnan(display_buffer(i)))
        display_buffer(i) = 0;
    end
end

for i = 1 : NSample - 5
    display_buffer(i) = sum(display_buffer(i : i + 5)) / 6;
end
figure(2)
result = fft(display_buffer);
result = fftshift(result);
plot(freq_axis, abs(result));
title('Frequency Domain');
ylabel('Magnitude');
xlabel('Frequency(Hz)');


% Disconnect the serial port object from the serial port
fclose(s1);  
