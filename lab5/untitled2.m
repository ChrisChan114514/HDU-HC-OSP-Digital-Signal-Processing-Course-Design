% IIR和FIR低通滤波器设计与心电信号滤波实验
% 目标：设计IIR和FIR低通滤波器分别滤除心电信号中的白噪声干扰
% 滤波器指标要求：通带截止频率Wp=0.1π，阻带截止频率Ws=0.16π
%                阻带衰减不小于15dB，通带衰减不大于1dB


% 最后图像生成
%1.干净的ECG信号及其频谱
%2.含噪声的ECG信号及其频谱
%3.IIR滤波后的ECG信号及其频谱
%4.FIR滤波后的ECG信号及其频谱


clear,clc;
% 导入心电信号数据
val = importdata('Ecg.txt');
signal = val(1,1:1800);
Fs = 500; % 采样频率

% 绘制原始干净的心电信号
figure(2);
subplot(4,1,1);
plot(signal);
title('干净的ECG信号');
xlabel('采样点');ylabel('幅值(dB)');
grid on;

% 计算并绘制原始信号的频谱
XK1=fft(signal,1800); % 快速傅里叶变换
magXK1=abs(XK1); % 计算频谱幅值
figure(3);
subplot(4,1,1);
k1=0:length(magXK1)-1;
stem(k1,magXK1,'.'); % 绘制信号幅频特性曲线
xlabel('k');
ylabel('|X(k)|');
title('干净的ECG信号频谱');

% 添加高斯白噪声信号（信噪比10dB）
% 白噪声的特点是在整个频谱范围内能量均匀分布，没有特定的频率
% 它会影响信号的所有频率成分，因此需要设计低通滤波器来滤除高频噪声
signal1 = awgn(signal,10,'measured'); %10就是控制信噪比
figure(2);
subplot(4,1,2);
plot(signal1);
title('含噪声的ECG信号');
xlabel('采样点');ylabel('幅值(dB)');
grid on;

% 计算并绘制含噪声信号的频谱
XK2=fft(signal1,1800);
magXK2=abs(XK2); % 计算频谱幅值
figure(3);
subplot(4,1,2);
k2=0:length(magXK2)-1;
stem(k2,magXK2,'.'); % 绘制信号幅频特性曲线
xlabel('k');
ylabel('|X(k)|');
title('含噪声的ECG信号频谱');

% IIR低通滤波器设计（Butterworth滤波器）
% 由于白噪声分布在所有频段，而心电信号的有用成分主要集中在低频段
% 设计低通滤波器保留低频有用信号，滤除高频噪声
wp=0.1*pi;  % 通带截止频率
ws=0.16*pi; % 阻带截止频率
% 预畸变处理，将数字滤波器转换为模拟滤波器设计问题
Fp=2*Fs*tan(wp/2);
Fc=2*Fs*tan(ws/2);
Rp=1;   % 通带最大衰减（dB）
Rs=15;  % 阻带最小衰减（dB）

% 计算滤波器阶数和截止频率
[N,Wn] = buttord(Fp,Fc,Rp,Rs,'s');
% 生成Butterworth模拟原型滤波器零极点和增益
[Z,P,K] = buttap(N);
% 零极点形式转换为传递函数系数
[Bap,Aap] = zp2tf(Z,P,K);
% 低通滤波器频率变换
[b,a] = lp2lp(Bap,Aap,Wn);
% 双线性变换，将模拟滤波器转换为数字滤波器
[bz,az] = bilinear(b,a,Fs);

% 计算IIR滤波器的频率响应
[H1,W]=freqz(bz,az);
% 对含噪声信号进行IIR滤波
y1=filter(bz,az,signal1);

% 绘制IIR滤波器的幅频响应特性
figure(1);
subplot(2,1,1);
plot(W/pi,20*log10(abs(H1)));
xlabel('\omega/\pi');
ylabel('幅度 (dB)');
title('IIR低通滤波器频率响应');
grid on;

% 绘制IIR滤波后的时域信号
figure(2);
subplot(4,1,3);
plot(y1);
title('IIR滤波后的ECG信号');
xlabel('采样点');ylabel('幅值(dB)');
grid on;

% 计算并绘制IIR滤波后信号的频谱
XK3=fft(y1,1800);
magXK3=abs(XK3); % 计算频谱幅值
figure(3);
subplot(4,1,3);
k3=0:length(magXK3)-1;
stem(k3,magXK3,'.'); % 绘制信号幅频特性曲线
xlabel('k');
ylabel('|X(k)|');
title('IIR低通滤波后的ECG信号频谱');

% FIR低通滤波器设计（基于汉宁窗的FIR滤波器）
wp=0.1*pi;  % 通带截止频率
ws=0.16*pi; % 阻带截止频率
wdelta=ws-wp; % 过渡带宽度
% 根据过渡带宽度估算滤波器阶数
N=ceil(8*pi/wdelta);
wn=(wp+ws)/2; % 理想滤波器的截止频率
% 使用汉宁窗设计FIR滤波器
h=fir1(N-1,wn/pi,hanning(N));

%虽然在FIR部分没有显式指定阻带衰减，
%但通过汉宁窗设计的FIR滤波器通常可以提供大约31dB的阻带衰减，
%远大于要求的"不小于15dB"。

%使用汉宁窗设计的FIR滤波器在通带内的纹波较小，一般可以满足通带衰减"不大于1dB"的要求

% 计算FIR滤波器的频率响应
[H2,W2]=freqz(h,1,512);
% 对含噪声信号进行FIR滤波
y2=conv(signal1, h);

% 绘制FIR滤波器的幅频响应特性
figure(1);
subplot(2,1,2);
plot(W/pi,20*log10(abs(H2)));
xlabel('\omega/\pi');
ylabel('幅度 (dB)');
title('FIR低通滤波器频率响应');
grid on;

% 绘制FIR滤波后的时域信号
figure(2);
subplot(4,1,4);
plot(y2);
title('FIR滤波后的ECG信号')
xlabel('采样点');ylabel('幅值(dB)');
grid on;

% 计算并绘制FIR滤波后信号的频谱
XK4=fft(y2,1800);
magXK4=abs(XK4); % 计算频谱幅值
figure(3);
subplot(4,1,4);
k4=0:length(magXK4)-1;
stem(k4,magXK4,'.'); % 绘制信号幅频特性曲线
xlabel('k');
ylabel('|X(k)|');
title('FIR低通滤波后的ECG信号频谱');
