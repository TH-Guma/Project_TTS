clc; clear; close all;
% ================ Biểu diễn s1(t) và s2(t)=========================
ts = 0.05; % Thời gian mẫu
t1 = 0: ts: 0.5 - 0.05;
t2 = 0.5: ts: 1 - 0.05;
t_1bit = [t1 t2]; % Thời gian của 1 bit
L = length(t_1bit); % Số lượng mẫu của 1 bit
s1_t1 = 1.5*ones(1,length(t1));
s1_t2 = 0.5*ones(1,length(t2));
s1 = [s1_t1 s1_t2]; % s1(t)
s2_t1 = 0*ones(1,length(t1));
s2_t2 = -2*ones(1,length(t2));
s2 = [s2_t1 s2_t2]; % s2(t)

% ================ Tín hiệu truyền==========================%
Ntry = 10^4; % Tổng số bit truyền
N0_2 = 0.2:0.2:1.2; % Mật độ phổ công suất nhiễu (W/Hz) N0/2
P_error_simul = zeros(1,length(N0_2)); %Xác suất lỗi bit từ quá trình mô phỏng 
P_error_theo = zeros(1,length(N0_2)); % Xác suất lỗi bit theo lý thuyết 

for j = 1:length(N0_2)
    Bit = randsrc(1,Ntry,[0 1]);%Bit: vector được tạo random với giá trị là 0 1 
    s = []; % Tín hiệu truyền s(t)
    t = []; % Thời gian của s(t)
    for i = 1:Ntry
        if Bit(i) == 0
            s = [s s1];
        else
            s = [s s2];
        end
        t_ibit = t_1bit + (i-1); % Thời gian của i-bit
        t = [t t_ibit];
    end
    % ================= Kênh AWGN========================= %
    B = 1/ts; % Băng thông của tín hiệu
    Power_noise = B * N0_2(j); % Công suất của nhiễu
    w = sqrt(Power_noise)*randn(1,length(s));   %Tín hiệu nhiễu 
    % ================= Tín hiệu nhận được=======================%
    r = s+w;
    % ================= Tín hiệu khôi phục======================%
    h_t1 = -5/sqrt(17) * ones(1,length(t1));
    h_t2 = -3/sqrt(17) * ones(1,length(t2));
    h = [h_t1 h_t2]; % Đáp ứng xung của bộ lọc phù hợp
    T = 3/(4*sqrt(17)); % Ngưỡng quyết định
    Bit_rec = zeros(1,Ntry);
    Bit_rec1 = zeros(1,Ntry);
    for i = 1:Ntry
        Frame = r((i-1)*L+1:i*L); % Xây dựng 1 khung với L mẫu
        y = conv(Frame,h)/L; % Tín hiệu đi qua bộ lọc phù hợp
        r2_mu = y(L);
        % Bộ so sánh cho quyết định
        if r2_mu >= T
            Bit_rec(i) = 1;
        else
            Bit_rec(i) = 0;
        end
    end
    % ================== Xác suất lỗi bit===============%
    % ------------------------Mô phỏng--------------------------
    [Num, rate] = biterr(Bit, Bit_rec);
    P_error_simul(j) = rate;
    % ---------------------------- Lý thuyết-------------------
    s12_mu = -7/(2*sqrt(17));
    s22_mu = 5/sqrt(17);
    P_error_theo(j) = qfunc((s22_mu - s12_mu) / (2 * sqrt(N0_2(j))));

    % Tạo chuỗi Bit_rec1
    for L1 = 1:Ntry
        Bit_rec1(L1) = 0; % Khởi tạo tất cả các bit nhận được ban đầu là 0
        for k = 1:L1
            if Bit(k) == 1
                Bit_rec1(L1) = 1; % Nếu có bit 1, Bit_rec1 được thiết lập thành 1
            else 
                Bit_rec1(L1) = 0;
            end
        end
    end
end

%=============================Vẽ đồ thị===================================

% Vẽ biểu đồ cho các bit được truyền và nhận được
figure(1);
grid on;
subplot(3,1,1); % Tạo subplot cho các bit được truyền
stairs(1:Ntry, Bit, 'LineWidth', 2); % Vẽ 50 bit đầu tiên được truyền
title('Các Bit Được Truyền (Bit)');
xlabel('Chỉ Số Bit');
ylabel('Giá Trị Bit');
axis([0 10 -0.2 1.2]); % Thiết lập giới hạn trục để có thể hiển thị rõ ràng
for idx = 1:50
    grid on;
    text(idx+0.5, 1+0.1, num2str(Bit(idx)), 'FontWeight', 'bold');
    hold on;
end

subplot(3,1,2); % Tạo subplot cho các bit nhận được
stairs(1:Ntry, Bit_rec, 'LineWidth', 2); % Vẽ 50 bit nhận được đầu tiên
title('Các Bit Nhận Được (Bit\_rec)');
xlabel('Chỉ Số Bit');
ylabel('Giá Trị Bit');
axis([0 10 -0.2 1.2]); % Thiết lập giới hạn trục để có thể hiển thị rõ ràng
for idx = 1:50
    grid on;
    text(idx+0.5, 1+0.1, num2str(Bit_rec(idx)), 'FontWeight', 'bold');
    hold on;
end
subplot(3,1,3); % Tạo subplot cho các bit nhận được
stairs(1:Ntry, Bit_rec1, 'LineWidth', 2); % Sử dụng hàm stairs để vẽ Bit_rec1 dưới dạng sóng vuông
title('Các Bit được truyền trong trường hợp không có nhiễu (Bit\_rec1)');
xlabel('Chỉ Số Bit');
ylabel('Giá Trị Bit');
axis([0 10 -0.2 1.2]); % Thiết lập giới hạn trục để có thể hiển thị rõ ràng
for idx = 1:50
    grid on;
    text(idx+0.5, 1+0.1, num2str(Bit_rec1(idx)), 'FontWeight', 'bold');
    hold on;
end
hold on;
figure(2);
plot(N0_2,P_error_simul,'ko','linewidth',1.6,'markersize',6);
hold on;
plot(N0_2,P_error_theo,'r-','linewidth',1.8,'markersize',6);
xlabel('N_0/2'); ylabel('The bit error probability');
legend('Simulation','Theory');

P_error_simul 
P_error_theo 
