% 定义圆周卷积函数
function yc = circonv(x1, x2, N)
if length(x1) > N
    error('N must not be less than length of x1');  % 如果x1的长度大于N，返回错误
end
if length(x2) > N
    error('N must not be less than length of x2');  % 如果x2的长度大于N，返回错误
end
x1 = [x1, zeros(1, N-length(x1))];  % 将x1补零到长度N
x2 = [x2, zeros(1, N-length(x2))];  % 将x2补零到长度N
n = 0:N-1;  % 定义时域n
x2 = x2(mod(-n, N) + 1);  % 通过模运算对x2进行时间翻转和循环移位
H = zeros(N, N);  % 初始化H矩阵
for n = 1:N
    H(n, :) = cirshiftd(x2, n-1, N);  % 填充H矩阵每行为x2的圆周移位
end
yc = x1 * H';  % 矩阵乘法得到圆周卷积结果

% 定义圆周移位函数
function y = cirshiftd(x, m, N)
if length(x) > N
    error('length of x must not be less than N');  % 如果x的长度大于N，返回错误
end
x = [x, zeros(1, N-length(x))];  % 将x补零到长度N
n = 0:N-1;  % 定义时域n
y = x(mod(n-m, N) + 1);  % 进行圆周移位

% 主函数
clear all;
n = 0:11;
m = 0:5;
N1 = length(n);
N2 = length(m);
xn = 0.8.^n;  % 定义信号xn为指数衰减信号
hn = ones(1, N2);  % 定义脉冲响应hn为长度为N2的单位脉冲
yln = conv(xn, hn);  % 计算线性卷积
ycn = circonv(xn, hn, N1);  % 计算圆周卷积
ny1 = 0:length(yln)-1;  % 定义线性卷积的输出时域
ny2 = 0:length(ycn)-1;  % 定义圆周卷积的输出时域
subplot(2, 1, 1);
stem(ny1, yln);  % 绘制线性卷积结果
subplot(2, 1, 2);
stem(ny2, ycn);  % 绘制圆周卷积结果
axis([0, 16, 0, 4]);  % 设置坐标轴范围