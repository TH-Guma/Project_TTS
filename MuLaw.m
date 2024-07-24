clear all;clc;

% 1. Load speech signal
Fs = 4000;
[mSpeech,Fs] = audioread("MaleSpeech-16-4-mono-20secs.wav");
% sound(mSpeech,Fs)
% Consider the speech signal in 1.5s
t = 0:1/Fs:1.5;
plot(t,mSpeech(1:length(t)),'LineWidth',2);
hold on

% 2. Quantize the sample signal
L = 16; %the number of quantization levels
V_p = 0.5625; %the peak voltage of signal

% Determine the single quantile interval ?-wide
q =2* V_p/(L-1); % Use the exact equation

s_q_2 = quan_uni(mSpeech(1:length(t)),q); % Uniform quantization

% Plot the sample signal and the quantization signal
plot(t,s_q_2,'ro','MarkerSize',6,'MarkerEdgeColor','r','MarkerFaceColor','r')

% 3. Calculate the average quantization noise power,...
% the average power of the sample signal and SNR

e_uni = mSpeech(1:length(t)) - s_q_2; 
pow_noise_uni = 0;
pow_sig = 0;
for i = 1:length(t)
       pow_noise_uni = pow_noise_uni + e_uni(i)^2;
       pow_sig = pow_sig + mSpeech(i)^2;
end
SNR_a_uni = pow_sig/pow_noise_uni;
%	compression
% 5. Compress the sample signal ‘mSpeech’
mu = 255; % or A = ???; use the standard value
y_max = V_p;
x_max = V_p;

% Replace the compress equation for u-law and A-law
% with x is the 'mSpeech' signal 
s_c_5 = (y_max * (log(1 + (mu * abs(mSpeech(1:length(t))) / x_max)) / log(1 + mu))) .* sign(mSpeech(1:length(t)));

% Plot the compress signal
plot(t,s_c_5);

% 6. Quantize the compress signal and plot the quantized signal 

s_q_6 = quan_uni(s_c_5,q);

plot(t, s_q_6, 'b^', 'MarkerSize', 6, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');

% 7. Expand the quantized signal
s_e_7 = Expand(s_q_6,mu,x_max);
plot(t, s_e_7, 'g*', 'MarkerSize', 6, 'MarkerEdgeColor', 'g', 'MarkerFaceColor', 'g');

legend('Sample signal','Uniform quantized values','Compress signal',...
'Compress quantized values','Nouniform quantized values');
e_com = mSpeech(1:length(t)) - s_e_7;
pow_noise_com = 0;
for i = 1:length(t)
    pow_noise_com = pow_noise_com + e_com(i)^2;
end
SNR_a_com = pow_sig/pow_noise_com;

% 9. Calculate the average quantization noise power,...
% the average power of the analog signal and SNR 
e_com = mSpeech(1:length(t)) - s_e_7;
xlabel('Time (s)')
ylabel('Amplitude (V)')
title('𝜇-Law Companding')
xlim([0.53 0.58])
disp(['SNR (Uniform): ', num2str(SNR_a_uni)]);
disp(['SNR (Compressed): ', num2str(SNR_a_com)]);






