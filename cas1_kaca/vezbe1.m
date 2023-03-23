clear all;
close all;
clc;
%% Snimanje i reprodukovanje audio sekvence
%% Zadavanje parametara

fs = 16000; %Nesto sto je bitno u govornom signalu moze da bude na frekv do 8kHz, na visim moze da bude muzika, neki sum i slicno
%44.kHz za nesto nasnimljeno na CD, 48kHz za neki video zapis
Ts = 1/fs;
% Razlika izmedju mono i stereo - mozak moze da prepozna i najmanje
% prostorne razlike izvora
nchans = 2; %2-stereo, 1-mono
nbits = 16; %8-malo, 16,32 - ok
%trajanje 
duration = 4;
%broj odbiraka
N = duration*fs;

% %% Snimanje audio sekvence
% X = audiorecorder(fs,nbits,nchans);
% %audiorecorder - objekat klase koji sadrzi info o snimku
% disp('Start speaking');
% recordblocking(X,duration);
% disp('End of recording');
% %%
% y = getaudiodata(X);
% audiowrite('sekvenca1.wav',y,fs);

%% Ucitavanje audio sekvence
[y, fs] = audioread('sekvenca1.wav');
%prva kolona oznacava levi output, a druga desni
%interaural time difference - minimalna vremenska razlika koju nas mozak
%prepoznaje
N = length(y(:,1));
chan1 = y(:,1); %neizmenjen prvi kanal
chan2 = zeros(N,1);
delay = 10;
chan2(delay:end) = y(1:(N-delay+1),2);
y_left = [chan1,chan2];

chan2 = y(:,2); %neizmenjen drugi kanal
chan1 = zeros(N,1);
delay = 10;
chan1(delay:end) = y(1:(N-delay+1),1);
y_right = [chan1,chan2];

y_shift = [y_left(1:N/2,:);y_right(N/2:end,:)];

%% Prikazivanje govornog signala
y1 = y(:,1); %uzimamo jedan kanal
figure(1)
plot(0:1/fs:(length(y1)-1)/fs,y1);
title('Vremenski oblik');
%Oblikom signala nazivamo anvelopu.
%% Transformacije govornog (audio) signala

%pojacavanje - mnozenje brojem vecim od jedan
%% Invertovanje
y_inv = y1(end:-1:1);
%sound(y_inv,fs);
%snimiti palindrom
%% Ubrzavanje signala
speed = 2;
sound(y1, speed*fs);
% alternativa da se ne bi preslikao spektar na vecu frekvenciju i promenio
% zvuk
y_fast = y1(1:2:end);
sound(y_fast,fs);
%% Spektrogram signala
%nestacionarnost
figure(2)
spectrogram(y1,128,120,128,fs,'yaxis');
%SIGNAL, WINDOW, OVERLAP

%% Filtriranje signala
wp=2000/(fs/2);
ws=2500/(fs/2);
rp=3;
rs=40;
[n_ord, wn] = buttord(wp,ws,rp,rs);
[b, a] = butter(n_ord,wn);
y_filtered = filter(b,a,y1);
sound(y1,fs);
pause(); %ceka klik na space
sound(y_filtered,fs);

