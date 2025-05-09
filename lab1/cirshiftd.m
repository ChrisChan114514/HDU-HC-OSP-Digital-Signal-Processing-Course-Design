% 定义圆周移位函数
function y = cirshiftd(x, m, N)
if length(x) > N
    error('length of x must not be less than N');  % 如果x的长度大于N，返回错误
end
x = [x, zeros(1, N-length(x))];  % 将x补零到长度N
n = 0:N-1;  % 定义时域n
y = x(mod(n-m, N) + 1);  % 进行圆周移位