clear all
M = 16;
n=[0:1:7];
N = length(n);
xn = ones(1,N);   %这是一个宽度为8的矩形脉冲，在数字信号处理中称为矩形窗函数
X1K = fft(xn, N); %FFT运算
X2K = fft(xn, M);
magX1K = abs(X1K);
phaX1K = angle(X1K);
magX2K = abs(X2K);
phaX2K = angle(X2K);

subplot(1,3,1)
stem(n, xn)
xlabel('n'); ylabel('x(n)');
title('x(n) N=8');

subplot(1,3,2)
k1 = 0:length(magX1K)-1; % Corrected the index calculation
stem(k1, magX1K, '.'); % Changed '.' to '.' for marker style
xlabel('k'); ylabel('|X(k)|');
title('X(k) N=8');

subplot(1,3,3)
k2 = 0:length(magX2K)-1; % Corrected the index calculation
stem(k2, magX2K, '.'); % Changed '.' to '.' for marker style
xlabel('k'); ylabel('|X(k)|');
title('X(k) M=16');

%频谱图1：（N=8）
%FFT分析：对8点信号做8点FFT（N=8）
%对于8点采集宽度为8的矩形脉冲，就是只有直流信号（时域信号幅值一直为1，没有振荡成分，没有交流分量）
%所以K=1~7(交流分量)FFT频谱上的幅值就是0，所有FFT幅值都在k=0
%k=0，e^j0=1，计算得幅值为8

%频谱图2：(N=16)
%幅值：对于16点采集宽度为8的矩形脉冲，时域呈现出窗函数，窗函数对应的FFT频谱就是离散Sinc函数，并关于N/2对称
%横坐标：由于分子1-e^(j*pi*k)为偶数时为 0，奇数时为 2，所以奇数时有幅值，偶数时没有幅值，而是呈现离散 sinc 函数的形状。



