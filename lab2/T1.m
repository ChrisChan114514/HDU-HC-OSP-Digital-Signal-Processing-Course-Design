clear all
N = 32;
n = 0:N-1;
xn = sin(2*pi*n/N)  %32点的正弦信号 
XK = fft(xn, N);   %32点FFT转换
magXK = abs(XK);
phaXK = angle(XK);

subplot(1,2,1)
plot(n, xn)
xlabel('n'); ylabel('x(n)');
title('x(n) N=32');

subplot(1,2,2)
k = 0:length(magXK)-1;  %绘制时域信号和频域幅度谱
stem(k, magXK, '.'); 
xlabel('k'); ylabel('|X(k)|');
title('X(k) N=32');


%频谱特性解释：
%频点横坐标确定：生成的信号是频率为1周期/32点的正弦波，在DFT后，理论上应该在k=1和k=31(即N-1)处有两个峰值
                %这是因为DFT的周期性：k=N-1对应的是负频率分量(-1/32点)，K=1对应的是正频率分量(1/32点)
                %正负频率分量，关于N/2对称，这是FFT频谱的特性
%频点强度确定：对于纯正弦波Asin(2πfn)，DFT系数的理论幅度为AN/2，这里就是16