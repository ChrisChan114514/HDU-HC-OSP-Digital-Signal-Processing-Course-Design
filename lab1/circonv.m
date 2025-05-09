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
