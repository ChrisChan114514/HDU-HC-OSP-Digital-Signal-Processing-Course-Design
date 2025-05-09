n= [0:1:17];
m= [0:1:16];
Nl=length(n);
N2=length(m);
hn=0.5.^n;  %生成数字滤波器脉冲序列 hn为0.5指数衰减序列
x1n=ones(1,N2); %生成输入序列x1n 即 x1[n]=[1,1,1,...,1](单位步进序列)
x2n=ones(1,N2).*cos(2*pi/N2*m); %生成一个余弦波序列x2n = cos(2πn/N2)
x3n=ones(1,N2).*0.33.^m; %生成一个指数衰减序列 x3[n]= 0.33^n
N=N1+N2-1;
X1K=fft(x1n, N); %输入序列和数字滤波器脉冲序列进行FFT运算
X2K=fft(x2n, N);
X3K=fft(x3n, N);
HK=fft(hn, N);
Y1K=X1K.*HK;   %频域相乘=时域卷积 FFT数字滤波实现关键 Xi[n]此时滤波
Y2K=X2K.*HK;
Y3K=X3K.*HK;
y1n=ifft(Y1K,N); %反傅里叶变换 由频域得到时域结果
y2n=ifft(Y2K,N);
y3n=ifft(Y3K,N);
x=0:N-1;
subplot(3, 1, 1);%将计算结果呈现在图表上
stem(x,y1n,'.');
subplot(3, 1, 2);
stem(x,y2n,'.');
subplot(3, 1 , 3);
stem(x,y3n,'.');