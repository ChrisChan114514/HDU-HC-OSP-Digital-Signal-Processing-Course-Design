%代码功能：
% 1.导入ECG心电图信号
% 2.向干净的ECG信号添加基线漂移干扰
% 3.设计IIR高通滤波器消除基线漂移
% 4.可视化原始信号、含噪声信号和滤波后信号的时域和频域特性
% 5.题目要求：设计一个高通滤波器滤除心电信号中的基线低频干扰
% 6.通带截止频率 Wp=0.0028π，阻带截止频率 Ws=0.0012π
% 7.阻带衰减不小于15 dB，通带衰减不大于1 dB

clear,clc;
% 导入ECG心电信号数据
val = importdata('Ecg.txt');
signal = val(1,1:1800);
Fs = 500; % 采样频率设置为500Hz

% 显示干净的ECG信号的时域波形
figure(2);
subplot(3,1,1);
plot(signal);
title('干净的ECG信号');
xlabel('采样点');ylabel('幅值(dB)');
grid on;

% 计算并显示干净的ECG信号的频谱
XK1=fft(signal,1800); % 对信号进行傅里叶变换
magXK1=abs(XK1); % 计算幅频特性
figure(3);
subplot(3,1,1);
k1=0:length(magXK1)-1;
stem(k1,magXK1,'.'); % 信号幅频特性曲线
xlabel('k');
ylabel('|X(k)|');
title('干净的ECG信号频谱');

% 加入基线漂移信号（模拟低频干扰）
% 基线漂移是心电信号中常见的低频干扰，通常由呼吸、体位变化、电极接触不良等因素引起
% 在这个实验中，我们模拟了一个典型的基线漂移：开始平稳，然后逐渐向上偏移
n1=length(signal)/3;
x1=zeros(1,n1); % 前1/3的信号为0（初始基线平稳）
t=1:length(signal)-n1;
x2=(length(signal)-n1)/2000*(t-1)+1; % 后2/3的信号为线性增加的斜坡（基线逐渐偏移）
% 这里的斜率为(length(signal)-n1)/2000，使基线缓慢上升
% 最终形成的基线漂移是一个阶跃+斜坡的组合，这是临床心电图中常见的漂移形式
noise3=[x1,x2]; % 组合成基线漂移干扰
signal3=noise3+signal; % 将干扰加入到原始信号中

% 显示含基线漂移的ECG信号的时域波形
figure(2);
subplot(3,1,2);
plot(signal3);
title('含基线漂移的ECG信号');
xlabel('采样点');ylabel('幅值(dB)');
grid on;

% 计算并显示含基线漂移的ECG信号的频谱
% 基线漂移作为低频干扰，主要影响信号的低频部分
% 在频谱上会表现为直流分量和极低频部分的幅值增大
XK2=fft(signal3,1800);
magXK2=abs(XK2); % 幅频特性
figure(3);
subplot(3,1,2);
k2=0:length(magXK2)-1;
stem(k2,magXK2,'.'); % 信号幅频特性曲线
xlabel('k');
ylabel('|X(k)|');
title('含基线漂移的ECG信号频谱');

% IIR高通滤波器设计
% 由于基线漂移是低频干扰，使用高通滤波器可以有效滤除这些低频成分
% 同时保留ECG信号中的高频有用成分（如QRS波群等）
% 根据题目要求设置参数
wp = 0.0028*pi; % 通带截止频率
ws = 0.0012*pi; % 阻带截止频率
Rp = 1;         % 通带衰减不大于1 dB
Rs = 15;        % 阻带衰减不小于15 dB

% 进行预畸变以适应巴特沃斯滤波器设计
wp1=2*Fs*tan(wp/2);
ws1=2*Fs*tan(ws/2);

% 计算巴特沃斯滤波器的阶数和截止频率
[N,Wn]=buttord(wp1,ws1,Rp,Rs,'s');
[b,a]=butter(N,Wn,'high','s'); % 设计模拟高通滤波器

% 原型滤波器设计
[Z,P,K]=buttap(N);

% 使用双线性变换将模拟滤波器转换为数字滤波器
[bz,az]=bilinear(b,a,Fs);

% 计算滤波器的频率响应特性
[H,W]=freqz(bz,az);

% 对含噪声的信号进行滤波处理
y=filter(bz,az,signal3); % 进行高通滤波

% 显示滤波器的幅频响应特性
figure(1);
subplot(1,1,1);
plot(W/pi,20*log10(abs(H)));
xlabel('\omega/\pi');
ylabel('幅度 (dB)');
title('IIR高通滤波器的幅频响应特性 |H(e^{jω})|');
grid on;

% 显示滤波后的ECG信号的时域波形
figure(2);
subplot(3,1,3);
plot(y);
title('IIR高通滤波后的ECG信号');
xlabel('采样点');ylabel('幅值(dB)');
grid on;

% 计算并显示滤波后的ECG信号的频谱
XK3=fft(y,1800);
magXK3=abs(XK3); % 幅频特性
figure(3);
subplot(3,1,3);
k3=0:length(magXK3)-1;
stem(k3,magXK3,'.'); % 信号幅频特性曲线
xlabel('k');
ylabel('|X(k)|');
title('IIR高通滤波后的信号频谱');

% 进行滤波前后信号频谱的对比分析
figure(4);
subplot(2,1,1);
plot(signal3); hold on; plot(y); hold on; plot(signal);
title('时域波形对比：含基线漂移信号(蓝)、滤波后信号(橙)和原始信号(黄)');
xlabel('采样点');
ylabel('幅值');
legend('含基线漂移的信号','滤波后的信号','原始干净信号');
grid on;

subplot(2,1,2);
stem(k2,magXK2,'b.'); hold on; stem(k3,magXK3,'r.'); 
title('频域特性对比：滤波前(蓝)和滤波后(红)');
xlabel('k');
ylabel('|X(k)|');
legend('含基线漂移的信号频谱','滤波后的信号频谱');
grid on;
