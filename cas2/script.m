clear;
close all;
clc;

fs = 8*1e3; % 8 kHz
f0 = 200; % 200Hz - zenski glas
d = 2; % trajanje

e = genpulse(f0, d, fs);
% za saputanje - beli sum
e = randn(1, d*fs);

figure();
plot(1/fs:1/fs:d, e);
title('povorka impulsa');

%% impulsni odziv glasnih zica, rosenberg-ov model
% definisane modelom
t1 = 7.5*1e-3;
t2 = 13*1e-3;

g = rosenmodel(t1, t2, fs);
figure()
plot(g);
title('impulsni odziv glasnih zica');

%% konvolucija g i e
y = conv(g, e);
figure();
plot(y);

% y = y - mean(y); %- ovako se cuje
% sound(y, fs); % ne cuje se nista

%% ar model prenosni fje usne duplje

% samoglasnik /a/
f_a = [800; 1200; 2800; 3600]; % ucestanosti formanata
a = [0.98; 0.96; 0.88; 0.9]; % amplitude parova konjugovano kompleksnih polova

% samoglasnik /e/
f_e = [500; 1900; 2150; 3300];
e = [0.99; 0.96; 0.95; 0.96];

% samoglasnik /o/
f_o = [500; 900; 2300; 3200];
o = [0.98; 0.97; 0.89; 0.87];

[A, B] = makevowel(a, f_a, fs);

freqz(B, A, 1024);

yf = filter(B, A, y); % signal na izlazu iz H(z)
% efekat usana
yf = filter([1, -1], 1, yf);

sound(yf, fs);

%% konacna fja
s = vowel_signal(8000, 100, 'o', 2);
sound(s, 8000);