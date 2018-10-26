% Transmit a video in NTSC (GPU Version)
% Author: Zephyr
% 09/25/2018
clear;
close all;
clc;
tic;
% Load the video
video = VideoReader('video240p.mp4');
% Get video information
height = video.Height;
width = video.Width;
frameRate = video.FrameRate;
% Set sampling frequency
fs = 13.5e6;
% Set amplitude of trigonometric functions
A = 1;
% Set frequency of trigonometric functions
fc = 3.58e6;
% Set lenght of FIR filters
firLength = 20;
framesNum = 0;
while hasFrame(video)
    framesNum = framesNum+1;
    transmitter(framesNum).rgb = im2double(readFrame(video));
    transmitter(framesNum).yiq = rgb2ntsc(transmitter(framesNum).rgb);
    % Interlanced scan
    transmitter(framesNum).yiq_field1 = reshape(transmitter(framesNum).yiq(1:2:height, :, :), height*width/2, 3);
    transmitter(framesNum).yiq_field2 = reshape(transmitter(framesNum).yiq(2:2:height, :, :), height*width/2, 3);
end
% ---------------------------Transmitting Phase----------------------------
signal_transmit_digital= [gpuArray(transmitter(1).yiq_field1); gpuArray(transmitter(1).yiq_field2)];
for a = 2 : framesNum
    signal_transmit_digital(end+1: end+height*width, :) = [gpuArray(transmitter(a).yiq_field1); gpuArray(transmitter(a).yiq_field2)];
end
% Generate analog signal
n = gpuArray(framesNum*width*height);
t_digital = (0 : n-1) / (frameRate*width*height);
t_analog = 0: 1/fs : max(t_digital);
t_digital = t_digital';
t_analog = t_analog';
signal_transmit_analog = interp1(t_digital,signal_transmit_digital,t_analog);
c = A*cos(2*pi*fc*t_analog);
s = A*sin(2*pi*fc*t_analog);
% Set FIR filters, LPF_XX = X.X MHz low pass filter
LPF_42 = fir1(firLength, 4.2e6/(fs/2));
LPF_15 = fir1(firLength, 1.5e6/(fs/2));
LPF_05 = fir1(firLength, 0.5e6/(fs/2));
LPF_20 = fir1(firLength, 2e6/(fs/2));
BPF = fir1(firLength, [2e6/(fs/2) 4.2e6/(fs/2)]);
y_transmit = conv(signal_transmit_analog(:, 1), LPF_42, "same");
i_transmit = conv(signal_transmit_analog(:, 2), LPF_15, "same");
q_transmit = conv(signal_transmit_analog(:, 3), LPF_05, "same");
% QMA modulate
iq_transmit = conv(i_transmit.*c+q_transmit.*s, BPF, "same");
% Combine signal to transmit
video_transmit = y_transmit+iq_transmit;
% ----------------------------Receiving Phase------------------------------
video_receive = video_transmit;
% Recover Y channel signal
signal_receive_analog(:, 1) = conv(video_receive, LPF_20, "same");
iq_receive = video_receive-signal_receive_analog(:, 1);
% QMA demodulate
signal_receive_analog(:, 2) = conv(2*iq_receive.*c, LPF_15, "same");
signal_receive_analog(:, 3) = conv(2*iq_receive.*s, LPF_05, "same");
signal_receive_analog = gather(signal_receive_analog);
% Sample the analog signal
signal_receive_digital = signal_receive_analog(1:(numel(t_analog)-1)/(numel(t_digital)-1):end, :);
% Recover frames
for a = 1 : framesNum
    receiver(a).yiq_field1 = signal_receive_digital(1+(a-1)*height*width: (a-1/2)*height*width, :);
    receiver(a).yiq_field2 = signal_receive_digital(1+(a-1/2)*height*width: a*height*width, :);
    receiver(a).yiq = zeros(height, width, 3);
    receiver(a).yiq(1:2:height, :, :) = reshape(receiver(a).yiq_field1, height/2, width, 3);
    receiver(a).yiq(2:2:height, :, :) = reshape(receiver(a).yiq_field2, height/2, width, 3);
    receiver(a).rgb = ntsc2rgb(receiver(a).yiq);
end
toc;
% Play original frames
figure('Name','Video to Transmit','NumberTitle','off');
for a = 1:framesNum
    imshow(transmitter(a).rgb);
end
pause(0.5);
% Play received frames
figure('Name','Video to Receive','NumberTitle','off');
for a = 1:framesNum
    imshow(receiver(a).rgb);
end
% Save useful data for analysis
signal_transmit_digital = gather(signal_transmit_digital);
y_transmit = gather(y_transmit);
i_transmit = gather(i_transmit);
q_transmit = gather(q_transmit);
iq_transmit = gather(iq_transmit);
video_transmit = gather(video_transmit);
y_transmit = y_transmit(1:(numel(t_analog)-1)/(numel(t_digital)-1):end, :);
i_transmit = i_transmit(1:(numel(t_analog)-1)/(numel(t_digital)-1):end, :);
q_transmit = q_transmit(1:(numel(t_analog)-1)/(numel(t_digital)-1):end, :);
iq_transmit = iq_transmit(1:(numel(t_analog)-1)/(numel(t_digital)-1):end, :);
video_transmit = video_transmit(1:(numel(t_analog)-1)/(numel(t_digital)-1):end, :);
t_digital = gather(t_digital);
save data.mat signal_transmit_digital signal_receive_digital y_transmit i_transmit q_transmit iq_transmit video_transmit t_digital fs