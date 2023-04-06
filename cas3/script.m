clear;
close all;
clc;

% ucitavanje
[x, fs] = audioread('sekvenca1.wav');

figure()
time = 1/fs:1/fs:length(x)/fs;
plot(time, x);
xlabel('t[s]');
title('vremenski oblik signala');

N = 2048;
X = fft(x, N);
Xa = abs(X(1:N/2 + 1));

figure();
plot(0:fs/N:fs/2, Xa);
xlabel('f[Hz]');
ylabel('|X(jf)|');
title('amplitudska frekvencijska karakteristika');

% filtriranje
Wn = [60, 3400]/(fs/2);
[B, A] = butter(6, Wn, 'bandpass');
xf = filter(B, A, x);

N = 2048;
X = fft(xf, N);
Xa = abs(X(1:N/2 + 1));

figure();
plot(0:fs/N:fs/2, Xa);
xlabel('f[Hz]');
ylabel('|X(jf)|');
title('amplitudska frekvencijska karakteristika filtriranog signala');

% prozor
for wl = [1e-3, 10e-3, 20e-3, 80e-3]*fs
    E = zeros(size(xf));
    for i = wl:length(xf)
        rng = (i - wl + 1):i;
        E(i) = sum(xf(rng).^2);
    end
    
    figure(40);
    hold all;
    plot(1/fs:1/fs:length(E)/fs, E);
    title('kratkovrememnska energija - KVE za razlicite duzine prozora');
    
end

% 20ms i pravougaoni
wl = 20e-3*fs;
E = zeros(size(xf));
Z = zeros(size(xf));
for i = wl:length(xf)
    rng = (i - wl + 1):(i - 1);
    E(i) = sum(xf(rng).^2);
    Z(i) = sum(abs(sign(xf(rng + 1)) - sign(xf(rng))));
end

Z = Z/wl/2; % da ne bi zavisilo od duzine prozora
time = 1/fs:1/fs:length(E)/fs;

figure();
plotyy(time, xf, time, E);
figure();
plotyy(time, xf, time, Z);
title('kratkovremenski zeros-crossing rate');

% segmentacija
ITU = 0.1*max(E);
ITL = 0.0001*max(E);

poceci = [];
krajevi = [];

for i = 2:length(E)
    if (E(i) > ITU && E(i - 1) < ITU)
        poceci = [poceci, i];
    end
    if (E(i) < ITU && E(i - 1) > ITU)
        krajevi = [krajevi, i];
    end
end

rec = zeros(1, length(E));

for i  = 1:length(poceci)
    rec(poceci(i):krajevi(i)) = max(E);
end

figure();
plot(time, E, time, rec);
title('pocetna detekcija');

% potencijalno prosirenje reci
for i = 1:length(poceci)
    pomeraj = poceci(i);
    while (E(pomeraj) > ITL)
        pomeraj = pomeraj - 1;
    end
    poceci(i) = pomeraj;
end

for i = 1:length(krajevi)
    pomeraj = krajevi(i);
    while (E(pomeraj) > ITL)
        pomeraj = pomeraj + 1;
    end
    krajevi(i) = pomeraj;
end

% uklanjanje ponovljenih pocetaka i krajeva
poceci = unique(poceci);
krajevi = unique(krajevi);

rec = zeros(1, length(E));

for i  = 1:length(poceci)
    rec(poceci(i):krajevi(i)) = max(E);
end

figure();
plot(time, E, time, rec);
title('finalna detekcija');

% preslusavanje reci
for i = 1:length(poceci)
    sound(xf(poceci(i):krajevi(i)), fs);
    pause();
end

% zero crossing rate histogram - nema smisla za ovaj signal

% figure();
% hold all;
% histogram(Z(16*fs:18*fs), 20);
% pause();
% histogram(Z(5.3*fs:6.1*fs), 20);
% legend('tisina', 'govor');

% teager energija za snimljenu sekvencu
win = ones(1, fs*20*1e-3);
no_overlap = length(win) - 1;
Nfft = 512;
figure();
spectrogram(xf, win, no_overlap, Nfft, fs, 'yaxis');

[S, F, T, P] = spectrogram(xf, win, no_overlap, Nfft, fs, 'yaxis');
% od ovih se nadje teager

%% spektrogram

time = 0:0.001:2;
y = chirp(time, 100, 1, 200, 'q');
figure(50);
plot(time, y);
figure(51);
spectrogram(y, kaiser(128, 18), 120, 128, 1E3, 'yaxis');