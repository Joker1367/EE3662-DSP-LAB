%clear
%close all

%% Load ECG data
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
NSample =2000; % Number of sampling points, i.e., number of data points to acquire
fs = 500; % Sampling rate, check the setting in Arduino 

%% ---------- Display buffer setting ----------
display_length = 2000; % Display buffer length 
display_buffer = nan(1, display_length); % Display buffer is a first in first out queue
result = nan(1, NSample);
t_axis = (0 : display_length - 1) * (1 / fs); % Time axis of the display buffer
f_axis = (-display_length / 2 : display_length / 2 - 1) * (fs / display_length);

gd = 31;

ma = ones(1,8)/8;
gd = gd - mean(grpdelay(ma, 5));
ma2 = ones(1,50)/50;
gd = gd - mean(grpdelay(ma2, 5));

df = [2, 1, -1, -2];
%gd = gd - mean(grpdelay(df, 5));
FIR_notch = fir1(20,[0.20 0.28], 'stop');
bhi = fir1(34,0.06,'high');

% Initialize figure object
figure
hold on
%axis([0 4 -20 100000])
axis([0 4 -200 1000])
h_plot = plot(nan,nan);
h_plot2 = plot(nan, nan, 'o');
hold off 
xlabel('Time(sec)');
ylabel('Quantized value');
        
i = 1;

time = 0;

for i = 1 : 5000
    tic
    %read data for Arduino
    data = fscanf(s1); % Read from Arduino
    data = str2double(data);
    
    if(isnan(data))
        data = 0;
    end

    % Add data to display buffer
    if i <= display_length
        display_buffer(i) = data;
    else
        display_buffer = [display_buffer(2:end) data]; % first in first out
    end
    
    
    if mod(i, 25) == 0
%         for j = 1 : NSample
%             if(isnan(display_buffer(j)))
%                 display_buffer(j) = 0;
%             end
%         end

        RESULT = conv(display_buffer, ma, 'same');         % moving average filter
        RESULT = conv(RESULT, FIR_notch, 'same');          % notch filter
        ECG = conv(RESULT, df, 'same');                    % difference filter
        ECG  = ECG .* ECG;                                 % squarer
        ECG = conv(ECG, ma2, 'same');                      % flattening
        %RESULT = RESULT / 10;                              % normalize for suitable size for plot

        %[pks, locs] = findpeaks(ECG(1:display_length),1,'MinPeakHeight',25000);  % detect peak
        %[pks, locs] = findpeaks(ECG(1:display_length),1,'MinPeakHeight',20000, 'MinPeakDistance',300);  % detect peak
    
        % setting title and plot
        len = length(locs);
        if len <= 1
            title_string = sprintf('Average Heart rate : %g', 0);
        else
            title_string = sprintf('Average Heart rate : %g', 500*60 * (len - 1) / (locs(len) - locs(1)));
        end

        set(h_plot, 'xdata', t_axis, 'ydata', RESULT);
        set(h_plot2, 'xdata', t_axis(locs + 1 + gd), 'ydata', RESULT(locs + 1 + gd));   
        title(title_string);
        drawnow;
    end
    i = i + 1;
    time = time + toc;
end
X = sprintf("elapsed time of 2500 loops : %g", time);
disp(X);
time = time / 2500;
X = sprintf("average elapsed time : %g", time);
disp(X);


fclose('all');
