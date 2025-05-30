clear all
N = 128;
M = 120;
fs = 3000 ;
t=0:1/fs:120/3000;  %采样时间40ms,整数周期采样
t2=0:1/fs:128/3000;  %采样时间42.67ms，非整数周期采样

xn = cos(2*pi*600*t).*(1+cos(2*pi*100*t));
x2n = cos(2*pi*600*t2).*(1+cos(2*pi*100*t2));
%这是一个幅度调制信号：
%载波：600 Hz 余弦波（高频）。
%调制信号：100 Hz 余弦波（低频），叠加直流分量1，形成时变幅度。

%FFT频谱解释：
%N=120：
%频率分辨率：Fs/120=25HZ
%AM时域信号积化和差得：x(t)=cos(2pai*600t)+0.5*cos(2pai*500t)+0.5*cos(2pai*700t)
%所以横坐标在k=20,24,28有幅值，且k=24的幅值为其余两个的两倍
%对于单频余弦信号，FFT频谱幅值为AN/2,所以k=20时，幅值就是0.5*120/2=30

%N=128
%频率分辨率：Fs/128=23.44HZ
%频谱出现能量扩散（频谱泄漏），因为信号频率未对齐DFT频点。
%主峰（600 Hz，k=25.6(无法对应)）和边带（500/700 Hz）的能量会分散到多个频点。

XK = fft(x2n, N); %N=120采样
X1K = fft(xn, M);
magXK = abs(XK);
phaXK = angle(XK);

magX1K = abs(X1K);
phaX1K = angle(X1K);


subplot(1,4,1)
plot(t, xn)
xlabel('n'); ylabel('x(n)');
title('x(n) N=120');

subplot(1,4,2)
plot(t2, x2n)
xlabel('n'); ylabel('x(n)');
title('x(n) N=128');

subplot(1,4,3)
k = 0:length(magXK)-1; % Corrected the index calculation
stem(k, magXK, '.'); % Changed '.' to '.' for marker style
xlabel('k'); ylabel('|X(k)|');
title('X(k) N=128');

subplot(1,4,4)
k1 = 0:length(magX1K)-1; % Corrected the index calculation
stem(k1, magX1K, '.'); % Changed '.' to '.' for marker style
xlabel('k'); ylabel('|X(k)|');
title('X(k) N=120');