% 定义FIR低通滤波器的设计参数
Fs = 720;        % 采样频率 (Hz)
N = 21;          % 滤波器阶数
wc = 0.537 * pi;   % 归一化截止频率 (0.5π)

% 设计FIR低通滤波器（Hamming窗）
b = fir1(N, wc/pi);
a = 1;

% 计算频率响应
[H, W] = freqz(b, a, 1024);
freq_normalized = W/pi;  % 归一化频率(0~1)

% 精确找到截止频率对应的索引
[~, idx_wc] = min(abs(W - wc));
H_wc = H(idx_wc);  % 该频率点的复频响应

% ===== 专业绘图 =====
figure('Position', [100 100 900 800]);

% 1. 幅频特性(线性)
subplot(3,2,1);
plot(freq_normalized, abs(H), 'b', 'LineWidth', 1.5);
hold on;
% 精确标定截止频率点（红色圆点落在曲线上）
plot(freq_normalized(idx_wc), abs(H_wc), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
text(freq_normalized(idx_wc), abs(H_wc), ...
    sprintf(' (%.2fπ, %.3f)', freq_normalized(idx_wc), abs(H_wc)), ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
title('幅频特性（线性）');
xlabel('归一化频率 (\times\pi rad/sample)');
ylabel('幅度');
grid on;
xlim([0 1]);

% 2. 幅频特性(dB)
subplot(3,2,2);
plot(freq_normalized, 20*log10(abs(H)), 'b', 'LineWidth', 1.5);
hold on;
% 精确标定截止频率点
plot(freq_normalized(idx_wc), 20*log10(abs(H_wc)), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
text(freq_normalized(idx_wc), 20*log10(abs(H_wc)), ...
    sprintf(' (%.2fπ, %.1f dB)', freq_normalized(idx_wc), 20*log10(abs(H_wc))), ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
title('幅频特性（dB）');
xlabel('归一化频率 (\times\pi rad/sample)');
ylabel('幅度 (dB)');
grid on;
xlim([0 1]);
ylim([-80 5]);

% 3. 相位响应（解卷绕）
subplot(3,2,3);
phase = unwrap(angle(H));
plot(freq_normalized, phase, 'm', 'LineWidth', 1.5);
hold on;
% 标定截止频率相位
plot(freq_normalized(idx_wc), phase(idx_wc), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
title('相位响应');
xlabel('归一化频率 (\times\pi rad/sample)');
ylabel('相位 (rad)');
grid on;
xlim([0 1]);



% 5. 单位脉冲响应
subplot(3,2,[5 6]);
stem(0:N, b, 'filled', 'LineWidth', 1.5, 'MarkerSize', 5);
title('单位脉冲响应 h(n)');
xlabel('采样点 n');
ylabel('幅度');
grid on;

% 显示关键参数
disp(['截止频率: ', num2str(wc/pi), 'π (', num2str(wc*Fs/(2*pi)), ' Hz)']);
disp(['-3dB点实际增益: ', num2str(20*log10(abs(H_wc))), ' dB']);
disp(['群延迟(理论N/2): ', num2str(mean(group_delay(1:idx_wc_gd))), ' 采样点']);
