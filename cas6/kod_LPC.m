clear;
close all;
clc;

%% Snimanje sekvence AVALA
% dur = 3; % trajanje snimka u sekundama
% fs = 10000; % ucestanost odabiranja
% x = audiorecorder(fs, 16, 1);
% disp('Start speaking.');
% recordblocking(x, dur);
% disp('End of Recording.');
% play(x); % reprodukcija kao audio objekat
% y = getaudiodata(x);
% %sound(y, fs); % reprodukcija kao vektor realnih vrednosti
% audiowrite('test.wav', y, fs);
%% Prozorovanje i procena LPC koeficijenata
[x, fs] = audioread('avala.wav');
win = 20*10^-3*fs;
p = 14;
num = round(length(x)/win);
LPC_kor = zeros(p + 1, num);
LPC_ugr = zeros(p + 1, num);

recon = [];
k = 1;
for i = 1:win:length(x) - win
    rxx = autocorrelation(x(i:i + win - 1), p);
    [a, s] = estimate_lpc(rxx);
    LPC_kor(:, k) = a';
    [a, s] = aryule(x(i:i + win - 1), p);
    LPC_ugr(:, k) = a;
    recon = [recon, filter(1, a, randn(1, win)*sqrt(s))];
    k = k + 1;
end

figure();
plot(x);

figure(2);
hold all;
for i = 2:(p + 1)
    plot(LPC_kor(i, :));
end

figure(3);
hold all;
for i = 2:(p + 1)
    plot(LPC_ugr(i, :));
end

%% Rekonstrukcija signala (kao beli šum propušten kroz filtar)
% uradjeno gore

%% Samoglasnik A u reci
x_A = x(0.6*fs:0.72*fs); % od 0.6s do 0.72s je izgovoreno A
figure(4)
plot(x_A); title('Samoglasnik A - vremenski oblik')
%sound(x_A,fs);

%% Predikcija na osnovu LPC za 1 prozor
win = 20*10^-3*fs;
x_Aw = x_A(1:win);
% aryule - najjednostavnija - najgora
% arcov - kovariaciona metoda
% armcov - modifikovana kovarijantna

p = 50;
[LPC_w, s_w] = armcov(x_Aw, p);
y_Aw = zeros(1, length(x_Aw));
y_Aw(1:p) = x_Aw(1:p);

for i = (p + 1):length(y_Aw)
    y_Aw(i) = -sum(LPC_w(2:end).*y_Aw(i - 1:-1:i - p));
end

figure();
hold all;
plot(x_Aw);
plot(y_Aw);
legend('original', 'predikcija');

%% Poredjenje SGS
f = linspace(0, 0.5, 1000);
[Pxx1, W1] = periodogram(x_Aw);

figure();
hold all;
plot(W1, 10*log10(Pxx1));

p = 10;
[Pxx2, W2] = pmcov(x_Aw, p, 2*pi*f);
plot(W2, 10*log10(Pxx2*2*pi)); % matlab ponekad podrazumeva dvostrani a ponekad jednostrani spektar pa se moze razlikovati do na konstantu
