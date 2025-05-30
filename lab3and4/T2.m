% 定义数字高通滤波器的设计参数
wp = 0.8*pi;  % 通带截止频率（归一化，单位：弧度/采样点）
ws = 0.5*pi;  % 阻带截止频率（归一化，单位：弧度/采样点）
Rp = 3;       % 通带最大允许纹波（单位：dB）
Rs = 18;      % 阻带最小衰减（单位：dB）
Fs = 1;       % 采样频率，归一化为 1（简化计算）
Ts = 1/Fs;    % 采样周期，根据采样频率计算，Ts = 1/Fs

% 将数字滤波器的频率转换为模拟滤波器的频率
wp1 = 2*Fs*tan(wp/2); % 使用公式 ωp' = 2*Fs*tan(ωp/2) 将通带频率转换为模拟频率
ws1 = 2*Fs*tan(ws/2); % 使用公式 ωs' = 2*Fs*tan(ωs/2) 将阻带频率转换为模拟频率

% 计算巴特沃斯模拟高通滤波器的阶数和归一化截止频率
[N, Wn] = buttord(wp1, ws1, Rp, Rs, 's'); % 's' 表示设计模拟滤波器，求阶数 N 和截止频率 Wn
disp(['滤波器阶数 N = ', num2str(N)]);   % 输出滤波器阶数 N

% 构建巴特沃斯模拟高通滤波器的传递函数系数
[b, a] = butter(N, Wn, 'high', 's'); % 直接生成阶数为 N 的模拟高通滤波器，'high' 指定高通，'s' 表示模拟域

% 生成巴特沃斯滤波器的零点、极点和增益
[Z, P, K] = buttap(N); % 生成阶数为 N 的巴特沃斯滤波器的零点 Z、极点 P 和增益 K（注：此行未直接使用，可能是遗留代码）

% 使用双线性变换将模拟滤波器转换为数字滤波器
[bz, az] = bilinear(b, a, Fs); % 将模拟滤波器系数 (b, a) 转换为数字滤波器系数 (bz, az)

% 计算数字滤波器的频率响应
[H, W] = freqz(bz, az); % H 为复频率响应，W 为归一化频率（弧度/采样点，范围 [0, π]）

% 显示数字滤波器的分子和分母系数
disp('分子系数 bz:'); % 输出提示
disp(bz);             % 输出数字滤波器分子多项式系数
disp('分母系数 az:'); % 输出提示
disp(az);             % 输出数字滤波器分母多项式系数

% 绘制频率响应图并在 ω = 0.5π 处添加标记点
subplot(2,1,1); % 创建 2 行 1 列的子图，选择第一个子图
plot(W*Fs/pi, abs(H), 'b-'); % 绘制线性幅度响应，横轴为实际频率（Hz），因为 Fs = 1，W/pi 范围为 [0, 1]
hold on; % 保持当前图形，以便添加标记点
% 找到 ω = 0.5π 对应的频率点
target_freq = 0.5*pi; % 目标归一化频率
[~, idx] = min(abs(W - target_freq)); % 找到 W 中最接近 0.5π 的索引
scatter(target_freq*Fs/pi, abs(H(idx)), 50, 'r', 'filled', 'Marker', 'o'); % 在 ω = 0.5π 处标记点（红色圆点）
text(target_freq*Fs/pi, abs(H(idx)), sprintf(' (%.3f, %.3f)', target_freq*Fs/pi, abs(H(idx))), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right'); % 添加坐标标签
grid on; % 显示网格线
xlabel('频率/Hz'); % 横轴标签
ylabel('幅度'); % 纵轴标签
title('幅频特性'); % 子图标题
hold off; % 释放图形

subplot(2,1,2); % 选择第二个子图
plot(W/pi, 20*log10(abs(H)), 'b-'); % 绘制 dB 幅度响应，横轴为归一化频率 ω/π，范围 [0, 1]
hold on; % 保持当前图形，以便添加标记点
scatter(target_freq/pi, 20*log10(abs(H(idx))), 50, 'r', 'filled', 'Marker', 'o'); % 在 ω = 0.5π 处标记点（红色圆点）
text(target_freq/pi, 20*log10(abs(H(idx))), sprintf(' (%.3f, %.3f)', target_freq/pi, 20*log10(abs(H(idx)))), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right'); % 添加坐标标签
grid on; % 显示网格线
xlabel('\omega/\pi'); % 横轴标签（归一化频率）
ylabel('幅度 (dB)'); % 纵轴标签
title('幅频特性 (dB)'); % 子图标题
hold off; % 释放图形