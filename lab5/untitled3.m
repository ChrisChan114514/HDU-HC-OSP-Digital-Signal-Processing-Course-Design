%50HZ工频噪声产生叠加与IIR陷波消除

clear,clc;  % 清除工作区变量和命令窗口
val = importdata('Ecg.txt');  % 导入ECG心电信号数据文件
signal = val(1,1:1800);  % 提取前1800个采样点作为处理信号
Fs = 500;  % 采样频率设置为500Hz

% 绘制原始ECG信号的时域波形
figure(2);
subplot(3,1,1);
plot(signal);
title('干净的ECG信号');
xlabel('采样点');ylabel('幅值(dB)');
grid on;

% 计算并绘制原始ECG信号的频谱
XK1=fft(signal,1800);  % 对信号进行FFT变换
magXK1=abs(XK1);  % 计算幅频特性
figure(3);
subplot(3,1,1);
k1=0:length(magXK1)-1;
stem(k1,magXK1,'.');  % 使用离散点绘制频谱
xlabel('k');
ylabel('|X(k)|');
title('干净的ECG信号频谱');

% 产生模拟工频信号(50Hz)，与干净心电信号混合
av=100;
f0=50; % 工频干扰频率50Hz
t=1:length(signal);
noise2=av*cos(2*pi*f0*t/Fs);
signal2=noise2+signal; %直接相加添加工频噪声
figure(2);
subplot(3,1,2);
plot(signal2);
title('含干扰的ECG信号');
xlabel('采样点');ylabel('幅值(dB)');
grid on;
XK2=fft(signal2,1800);
magXK2=abs(XK2); %幅频特性
figure(3);
subplot(3,1,2);
k2=0:length(magXK2)-1;
stem(k2,magXK2,'.'); %信号幅频特性曲线
xlabel('k');
ylabel('|X(k)|');
title('含干扰的ECG信号频谱');

% IIR带阻滤波器设计
% 根据题目要求设置滤波器参数
% 通带下限频率 Wp1=0.18π
% 阻带下截止频率 Ws1=0.192π
% 阻带上截止频率 Ws2=0.208π
% 通带上限频率 Wp2=0.22π
% 阻带衰减不小于15dB，通带衰减不大于1dB
wp = [0.18,0.22]; % 通带边界频率
ws = [0.192,0.208]; % 阻带边界频率
Rp = 1; % 通带衰减1dB
Rs = 15; % 阻带衰减15dB
[N,Wn] = buttord(wp,ws,Rp,Rs,'s');
[b,a] = butter(N,Wn,'stop');

% 计算并绘制滤波器的频率响应曲线|H(e^jω)|
n=0:0.001:pi;
[H,W] = freqz(b,a,n);
figure(1);
subplot(1,1,1);
plot(W/pi,20*log10(abs(H)));
xlabel('\omega/\pi');
ylabel('幅度 (dB)');
title('IIR带阻滤波器频率响应');
grid on;

% 使用带阻滤波器处理含工频干扰的心电信号
[h,t]=impz(b,a);
y=conv(signal2,h); % 进行带阻滤波

% 显示滤波后的信号波形
figure(2);
subplot(3,1,3);
plot(y);
title('IIR带阻滤波后的心电信号');
xlabel('采样点');ylabel('幅值(dB)');
grid on;

% 计算并展示滤波后信号的频谱
XK3=fft(y,1800);
magXK3=abs(XK3); %幅频特性
figure(3);
subplot(3,1,3);
k3=0:length(magXK3)-1;
stem(k3,magXK3,'.'); %信号幅频特性曲线
xlabel('k');
ylabel('|X(k)|');
title('IIR带阻滤波后的信号频谱');

% 对滤波前后的心电信号的频谱进行分析比较
figure(4);
subplot(2,1,1);
plot(k2(1:900)/1800*Fs,magXK2(1:900),'b',k3(1:900)/1800*Fs,magXK3(1:900),'r');
legend('滤波前','滤波后');
title('滤波前后心电信号频谱比较');
xlabel('频率(Hz)');
ylabel('幅值');
grid on;

% 放大显示工频附近的频谱变化
subplot(2,1,2);
freq_range = [40 60]; % 工频附近频率范围
idx = round(freq_range/Fs*1800)+1;
plot(k2(idx(1):idx(2))/1800*Fs,magXK2(idx(1):idx(2)),'b',k3(idx(1):idx(2))/1800*Fs,magXK3(idx(1):idx(2)),'r');
legend('滤波前','滤波后');
title('工频(50Hz)附近频谱对比');
xlabel('频率(Hz)');
ylabel('幅值');
grid on;
