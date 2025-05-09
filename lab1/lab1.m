% 主函数
clear all;
n = 0:1:11;
m = 0:1:5;
N1 = length(n);
N2 = length(m);
x = [1 2 3 4 5]; %定义序列x
h = [1 2 1 2]; %定义序列h
res_conv = conv(x,h); % 计算线性卷积
res_circonv5 = circonv(x,h,5);% 计算圆周卷积
res_circonv6 = circonv(x,h,6) ; % 计算圆周卷积
res_circonv9 = circonv(x,h,9); % 计算圆周卷积
res_circonv10 = circonv(x,h,10); % 计算圆周卷积
ny1 = 0:length(res_conv)-1;  % 定义线性卷积的输出时域
ny2 = 0:length(res_circonv5)-1; % 定义圆周卷积的输出时域
ny3 = 0:length(res_circonv6)-1;
ny4 = 0:length(res_circonv9)-1;
ny5 = 0:length(res_circonv10)-1;
subplot(5, 1, 1);
stem(ny1, res_conv);  % 绘制线性卷积结果
subplot(5, 1, 2);
stem(ny2, res_circonv5);  % 绘制圆周卷积结果
subplot(5, 1, 3);
stem(ny3, res_circonv6); 
subplot(5, 1, 4);
stem(ny4, res_circonv9); 
subplot(5, 1, 5);
stem(ny5, res_circonv10); 
axis([0, 10, 0, 25]);  % 设置坐标轴范围