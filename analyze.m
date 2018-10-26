% Compare a digital video stream in both spatial and frequency domain using the following formats:
% (a) Original component signal (RGB).
% (b) Original component signal (YIQ).
% (c) Composite signal (YIQ).
% (d) Recovered component signal (YIQ).
% (e) Recovered component signal (RGB).
clear;
close all;
clc;
load data.mat;
spatialLength = 2000;
frequencyLength = 2800000;
b_spatial = signal_transmit_digital;
b_frequency = fft(b_spatial);
a_spatial = ntsc2rgb(b_spatial);
a_frequency = fft(a_spatial);
c_spatial = [y_transmit i_transmit q_transmit iq_transmit video_transmit];
c_frequency = fft(c_spatial);
d_spatial = signal_receive_digital;
d_frequency = fft(d_spatial);
e_spatial = ntsc2rgb(d_spatial);
e_frequency = fft(e_spatial);
n = numel(t_digital);
% Original component signal (RGB) VS Recovered component signal (RGB)
% In spatial domain
figure('Name','Original Component Signal VS Recovered Component Signal (RGB) in Spatial Domain','NumberTitle','off');
subplot(2, 1, 1);
hold on;
for channel = 1:3
    plot(t_digital(1:spatialLength)*1000, a_spatial(1:spatialLength, channel)*255);
end
grid on;
title('Original Component Signal (RGB)');
legend('Red Channel', 'Green Channel', 'Blue Channel');
xlabel('Time (msec)');
ylabel('Gray Level');
subplot(2, 1, 2);
hold on;
for channel = 1:3
    plot(t_digital(1:spatialLength)*1000, e_spatial(1:spatialLength, channel)*255);
end
grid on;
title('Recovered Component Signal (RGB)');
legend('Red Channel', 'Green Channel', 'Blue Channel');
xlabel('Time (msec)');
ylabel('Gray Level');
% In frequency domain
figure('Name','Original Component Signal VS Recovered Component Signal (RGB) in Frequency Domain','NumberTitle','off');
P2 = abs(a_frequency/n);
P1 = P2(1:n/2+1, :);
P1(2:end-1, :) = 2*P1(2:end-1, :);
f = fs*(0:(n/2))/n;
subplot(2, 3, 1);
semilogy(f(1:frequencyLength)/1000000, P1(1:frequencyLength, 1));
grid on;
title('Original Component Signal (R)');
xlabel('Frequency (MHz)');
ylabel('Single-Sided Amplitude');
subplot(2, 3, 2);
semilogy(f(1:frequencyLength)/1000000, P1(1:frequencyLength, 2));
grid on;
title('Original Component Signal (G)');
xlabel('Frequency (MHz)');
ylabel('Single-Sided Amplitude');
subplot(2, 3, 3);
semilogy(f(1:frequencyLength)/1000000, P1(1:frequencyLength, 3));
grid on;
title('Original Component Signal (B)');
xlabel('Frequency (MHz)');
ylabel('Single-Sided Amplitude');
P2 = abs(e_frequency/n);
P1 = P2(1:n/2+1, :);
P1(2:end-1, :) = 2*P1(2:end-1, :);
f = fs*(0:(n/2))/n;
subplot(2, 3, 4);
semilogy(f(1:frequencyLength)/1000000, P1(1:frequencyLength, 1));
grid on;
title('Recovered Component Signal (R)');
xlabel('Frequency (MHz)');
ylabel('Single-Sided Amplitude');
subplot(2, 3, 5);
semilogy(f(1:frequencyLength)/1000000, P1(1:frequencyLength, 2));
grid on;
title('Recovered Component Signal (G)');
xlabel('Frequency (MHz)');
ylabel('Single-Sided Amplitude');
subplot(2, 3, 6);
semilogy(f(1:frequencyLength)/1000000, P1(1:frequencyLength, 3));
grid on;
title('Recovered Component Signal (B)');
xlabel('Frequency (MHz)');
ylabel('Single-Sided Amplitude');
% Original component signal (YIQ) VS Recovered component signal (YIQ)
% In spatial domain
figure('Name','Original Component Signal VS Recovered Component Signal (YIQ) in Spatial Domain','NumberTitle','off');
subplot(2, 2, 1);
plot(t_digital(1:spatialLength)*1000, b_spatial(1:spatialLength, 1)*255);
grid on;
title('Original Component Signal (Y)');
xlabel('Time (msec)');
ylabel('Gray Level');
subplot(2, 2, 2);
hold on;
for channel = 2:3
    plot(t_digital(1:spatialLength)*1000, b_spatial(1:spatialLength, channel)*255);
end
grid on;
title('Original Component Signal (IQ)');
legend('I Channel', 'Q Channel');
xlabel('Time (msec)');
ylabel('Gray Level');
subplot(2, 2, 3);
plot(t_digital(1:spatialLength)*1000, d_spatial(1:spatialLength, 1)*255);
grid on;
title('Recovered Component Signal (Y)');
xlabel('Time (msec)');
ylabel('Gray Level');
subplot(2, 2, 4);
hold on;
for channel = 2:3
    plot(t_digital(1:spatialLength)*1000, d_spatial(1:spatialLength, channel)*255);
end
grid on;
title('Recovered Component Signal (IQ)');
legend('I Channel', 'Q Channel');
xlabel('Time (msec)');
ylabel('Gray Level');
% In frequency domain
figure('Name','Original Component Signal VS Recovered Component Signal (YIQ) in Frequency Domain','NumberTitle','off');
P2 = abs(b_frequency/n);
P1 = P2(1:n/2+1, :);
P1(2:end-1, :) = 2*P1(2:end-1, :);
f = fs*(0:(n/2))/n;
subplot(2, 3, 1);
semilogy(f(1:frequencyLength)/1000000, P1(1:frequencyLength, 1));
grid on;
title('Original Component Signal (Y)');
xlabel('Frequency (MHz)');
ylabel('Single-Sided Amplitude');
subplot(2, 3, 2);
semilogy(f(1:frequencyLength)/1000000, P1(1:frequencyLength, 2));
grid on;
title('Original Component Signal (I)');
xlabel('Frequency (MHz)');
ylabel('Single-Sided Amplitude');
subplot(2, 3, 3);
semilogy(f(1:frequencyLength)/1000000, P1(1:frequencyLength, 3));
grid on;
title('Original Component Signal (Q)');
xlabel('Frequency (MHz)');
ylabel('Single-Sided Amplitude');
P2 = abs(d_frequency/n);
P1 = P2(1:n/2+1, :);
P1(2:end-1, :) = 2*P1(2:end-1, :);
f = fs*(0:(n/2))/n;
subplot(2, 3, 4);
semilogy(f(1:frequencyLength)/1000000, P1(1:frequencyLength, 1));
grid on;
title('Recovered Component Signal (Y)');
xlabel('Frequency (MHz)');
ylabel('Single-Sided Amplitude');
subplot(2, 3, 5);
semilogy(f(1:frequencyLength)/1000000, P1(1:frequencyLength, 2));
grid on;
title('Recovered Component Signal (I)');
xlabel('Frequency (MHz)');
ylabel('Single-Sided Amplitude');
subplot(2, 3, 6);
semilogy(f(1:frequencyLength)/1000000, P1(1:frequencyLength, 3));
grid on;
title('Recovered Component Signal (Q)');
xlabel('Frequency (MHz)');
ylabel('Single-Sided Amplitude');
% Composite signal (YIQ)
% In spatial domain
figure('Name','Composite signal (YIQ) in Spatial Domain','NumberTitle','off');
subplot(2, 2, 1);
plot(t_digital(1:spatialLength)*1000, c_spatial(1:spatialLength, 1)*255);
grid on;
title('Composite signal (Y)');
xlabel('Time (msec)');
ylabel('Gray Level');
subplot(2, 2, 2);
hold on;
for channel = 2:3
    plot(t_digital(1:spatialLength)*1000, c_spatial(1:spatialLength, channel)*255);
end
grid on;
title('Composite signal (IQ)');
xlabel('Time (msec)');
ylabel('Gray Level');
legend('I Channel', 'Q Channel');
subplot(2, 2, 3);
plot(t_digital(1:spatialLength)*1000, c_spatial(1:spatialLength, 4)*255);
grid on;
title('Composite signal (QAM of I&Q)');
xlabel('Time (msec)');
ylabel('Gray Level');
subplot(2, 2, 4);
plot(t_digital(1:spatialLength)*1000, c_spatial(1:spatialLength, 5)*255);
grid on;
title('Composite signal (Y + QAM of I&Q)');
xlabel('Time (msec)');
ylabel('Gray Level');
% In frequency domain
figure('Name','Composite signal (YIQ) in Frequency Domain','NumberTitle','off');
P2 = abs(c_frequency/n);
P1 = P2(1:n/2+1, :);
P1(2:end-1, :) = 2*P1(2:end-1, :);
f = fs*(0:(n/2))/n;
subplot(2, 3, 4);
semilogy(f(1:frequencyLength)/1000000, P1(1:frequencyLength, 1));
grid on;
title('Composite signal (Y)');
xlabel('Frequency (MHz)');
ylabel('Single-Sided Amplitude');
subplot(2, 3, 1);
semilogy(f(1:frequencyLength)/1000000, P1(1:frequencyLength, 2));
grid on;
title('Composite signal (I)');
xlabel('Frequency (MHz)');
ylabel('Single-Sided Amplitude');
subplot(2, 3, 2);
semilogy(f(1:frequencyLength)/1000000, P1(1:frequencyLength, 3));
grid on;
title('Composite signal (Q)');
xlabel('Frequency (MHz)');
ylabel('Single-Sided Amplitude');
subplot(2, 3, 3);
semilogy(f(1:frequencyLength)/1000000, P1(1:frequencyLength, 4));
grid on;
title('Composite signal (QAM of I&Q)');
xlabel('Frequency (MHz)');
ylabel('Single-Sided Amplitude');
subplot(2, 3, 6);
semilogy(f(1:frequencyLength)/1000000, P1(1:frequencyLength, 5));
grid on;
title('Composite signal (Y + QAM of I&Q)');
xlabel('Frequency (MHz)');
ylabel('Single-Sided Amplitude');