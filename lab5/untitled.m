clear,clc;
val = importdata('Ecg.txt'); %读取Ecg文件中的信号
signal = val(1,1:1800);
fs = 500;
figure(1);
subplot(1,1,1);
plot(signal);
title('干净的ECG信号');
xlabel('采样点');
ylabel('幅值(dB)');
grid on;
