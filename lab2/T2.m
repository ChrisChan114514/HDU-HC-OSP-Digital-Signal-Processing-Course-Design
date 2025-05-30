clear all
N = 100;
n = 0:N-1;
xn = 0.9*sin(2*pi*n/N) + 0.6*sin(2*pi*n/N*3);
%时域信号构成：
%第一个正弦波：频率1周期/100点，幅度0.9
%第二个正弦波：频率3周期/100点，幅度0.6

XK = fft(xn, N);
magXK = abs(XK);
phaXK = angle(XK);

subplot(1,2,1)
plot(n, xn)
xlabel('n'); ylabel('x(n)');
title('x(n) N=100');

subplot(1,2,2)
k = 0:length(magXK)-1; %绘制时域信号和频域幅度谱
stem(k, magXK, '.'); 
xlabel('k'); ylabel('|X(k)|');
title('X(k) N=100');

%FFT频谱解释：
%横坐标(k)：DFT频点序号（0到99）
    %k=1对应频率：1/100 cycles/sample（即第一个正弦波）
    %k=3对应频率：3/100 cycles/sample（即第二个正弦波）
    %k=97对应频率：-3/100 cycles/sample（第二个正弦波的负频率分量）
    %k=99对应频率：-1/100 cycles/sample（第一个正弦波的负频率分量）    
    %正负频率分量关于N/2对称
%纵坐标(|X(k)|)：频谱幅度（理论预测值）
    %对于幅度A的正弦波，DFT峰值幅度应为A*N/2
    %第一个正弦波：0.9×100/2 = 45（k=1和k=99）
    %第二个正弦波：0.6×100/2 = 30（k=3和k=97）

%由于 N=3 太小，无法分辨原始信号中的高频分量（3 cycles/100），导致频谱严重失真。
%当 N=3，最高可分辨频率是 0.5 cycles/sample（Nyquist 频率）。但原信号的高频分量0.03cycles/sample 在 N=3 时被 混叠（aliasing） 到低频。
%原信号周期100/3=33.3,N=3太短，频谱泄漏严重