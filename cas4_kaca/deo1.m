clear all;
close all;
clc;
%% Ucitavanje sekvence
[x, fs] = audioread('sekvenca_Aleksa.wav');
figure()
plot(0:1/fs:(length(x)-1)/fs,x);
title('Govorna sekvenca')
xlabel('t[s]'); 
ylabel('x(t)');
%% Grubo odsecanje tisine
start_time = 0.7*fs;
x = x(start_time:end);
figure()
plot(0:1/fs:(length(x)-1)/fs,x);
title('Govorna sekvenca')
xlabel('t[s]'); 
ylabel('x(t)');
% Na domacem treba bolje uraditi odsecanje tisine
%% Filtriranje
Wn = [90 350]/(fs/2); %normalizujemo
[B A] = butter(6,Wn, 'bandpass');
x = filter(B, A, x);
%% Pravljenje sekvenci (m1,...,m6)
[m1,m2,m3,m4,m5,m6] = sekvence(x);
figure()
subplot(611)
stem(m1(1:1000));
subplot(612)
stem(m2(1:1000));
subplot(613)
stem(m3(1:1000));
subplot(614)
stem(m4(1:1000));
subplot(615)
stem(m5(1:1000));
subplot(616)
stem(m6(1:1000));
%% Procena pitch frekvencije
N = length(x);
[pt1, pt2, pt3, pt4, pt5, pt6, pt] = procena_perionde(fs,N,m1,m2,m3,m4,m5,m6);
figure()
plot(1./pt)
1./nanmedian(pt)
% lambda ili tau nekada treba da se promene 
