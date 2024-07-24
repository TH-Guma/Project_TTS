%=====================CORRELATION RECEIVER==========================

clc; clear; close all;

% ================ Represent s1(t) and s2(t)========================

ts = 0.05; % The sample time

%==========================s1(t)============================

t1 = 0: ts: 0.5 - 0.05;
t2 = 0.5: ts: 1 - 0.05;
t_1bit = [t1 t2]; % Time of 1 bit
L = length(t_1bit); % The number of samples of 1 bit
s1_t1 = 1.5*ones(1,length(t1));
s1_t2 = 0.5*ones(1,length(t2));
s1 = [s1_t1 s1_t2]; % s1(t)

%===========================s2(t)================================

s2_t1 = 0*ones(1,length(t1));
s2_t2 = -2*ones(1,length(t2));
s2 = [s2_t1 s2_t2]; % s2(t)

% ================ The transmitted signal===========================

Ntry = 10^1; % The total transmitted bits
Bit = randsrc(1,Ntry,[0 1]) ;% Transmission with P1 = P2 = 0.5 -> randsrc(hàng, cột, giá trị)
s = []; % The transmitted signal s(t)
t = []; % The time of s(t)
for i = 1:Ntry

%=========gộp 2 tín hiệu lại với s1 = bit 0 / s2 = bit 1============

if Bit(i) == 0
s = [s s1];
else
s = [s s2];
end

%============chia nhỏ thời gian -> 2 bit = 1s====================

t_ibit = t_1bit + (i-1); %  Time of i-bit
t = [t t_ibit];
end

% ================= The AWGN channel =============================

N0_2 = 0.5; % The noise power spectrum desity (W/Hz) N0/2 - mật độ công suất nhiễu
B = 1/ts; % Bandwidth of signals
Power_noise = B*N0_2; % The power of noise
w = sqrt(Power_noise)*randn(1,length(s)); % tuân theo mật độ công suất nhiễu và phân phối Gauss

% ================= The received signal ==========================

r = s + w;

%=================================================================
phi1_t1 = 1*ones(1,length(t1));
phi1_t2 = 1*ones(1,length(t2));
phi1 = [phi1_t1 phi1_t2]; % The orthonormal function 1

phi2_t1 = 1*ones(1,length(t1));
phi2_t2 = -1*ones(1,length(t2));
phi2 = [phi2_t1 phi2_t2]; % The orthonormal function 2

h1 = flip(phi1); % The matched filter 1
h2 = flip(phi2); % The matched filter 2
 
Bit_rec = zeros(1,Ntry);
for i = 1:Ntry
    Frame = r((i-1)*L + 1 : i*L); % Construct 1 Frame with L samples of 1 symbol
    y1 = conv(Frame, h1) * ts; % r(t) passes through the matched filter 1
    r1 = y1(L);
    y2 = conv(Frame, h2) * ts; % r(t) passes through the matched filter 2
    r2 = y2(L);
    Th = -4 * r1+ r2 -3/4 + log(0.5/0.5);
    % --------- Comparator for decision
    if Th >= 0
        Bit_rec(i) = 1;
    else
        Bit_rec(i) = 0;
    end
end


%========================= Plot===================================

 figure(1)
 subplot(5,1,1)
 plot(t_1bit,s1,'b-','linewidth',1.8); 
 hold on;
 xlabel('t (s)'); 
 ylabel('s_1(t)');
 axis([0 1.1 -1 1.6])

 subplot(5,1,2)
 plot(t_1bit,s2,'r-','linewidth',1.8);
 xlabel('t (s)'); 
 ylabel('s_2(t)')
axis([0 1.1 -2.2 1])

x_note = 0.5 :1 :Ntry - 0.5;
y_note = 2.4 *ones(1,Ntry);
Text = string(Bit);
subplot(5,1,3)
plot(t,s,'g-','linewidth',1.8);
text(x_note, y_note, Text);
xlabel('t (s)'); 
ylabel('s(t)')
axis([0 Ntry -3 3])

subplot(5,1,4)
 plot(t,w,'k-','linewidth',1.4);
 text(x_note, y_note, Text);
 xlabel('t (s)'); ylabel('w(t)')
 axis([0 Ntry -6 6])

 subplot(5,1,5)
 plot(t,r,'m-','linewidth',1.8);
 text(x_note, y_note, Text);
 xlabel('t (s)'); ylabel('s(t)')
 axis([0 Ntry -6 6])

% ============ Plot the matched filters ==============

figure(2);
subplot(4,1,1);
plot(t_1bit, h1, 'b-', 'linewidth', 1.8);
xlabel('t (s)');
ylabel('h1(t)');

subplot(4,1,2);
plot(t_1bit, h2, 'r-', 'linewidth', 1.8);
xlabel('t (s)');
ylabel('h2(t)');

% =========================== Decision signal =========================
subplot(4,1,3);
xlabel('m(t)');
ylabel('Received Bit');
stairs(1:Ntry, Bit, 'LineWidth', 1.8);
for idx = 1:Ntry
    grid on;
    text(idx+0.5, 1+0.2, num2str(Bit(idx)), 'FontWeight', 'bold');
    hold on;
end
title('CHUỖI BIT BAN ĐẦU');
 axis([1 Ntry 0 1.5])


% ============ Decision signal ==============
subplot(4,1,4);
xlabel('r(t)');
ylabel('Received Bit');
stairs(1:Ntry, Bit_rec, 'LineWidth', 1.8);
for idx = 1:Ntry
    grid on;
    text(idx+0.5, 1+0.2, num2str(Bit_rec(idx)), 'FontWeight', 'bold');
    hold on;
end
title('CHUỖI BIT SAU KHI QUA ĐẦU THU');
 axis([1 Ntry 0 1.5])
