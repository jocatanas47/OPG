clear all;
close all;
clc;

%% Uniformni kvantizator
[x, Fs] = audioread('sekvenca.wav');
N = length(x);
Xmax = max(abs(x));
b = 4;
M = 2^b; %broj nivoa
d = 2*Xmax/M; %korak kvantizacije
%mid_tread
xq_uni = round(x/d)*d; %ne koristi se ni floor ni ceil
xq_uni(x>(M-1)/2*d) = (M/2-1)*d; %da izbegnemo dodavanje jos jednog nivoa

figure()
plot(x,xq_uni,'*'); %preslikavanje iz x u x_kvantizovani
figure()
hold all;
plot(x,'b')
plot(xq_uni, 'r--')

%Odnos signal-sum
fprintf('SNR = %f\n', 10*log10(var(x)/var(x-xq_uni)));

%% Uniformni uz utisan signal
b = 4;
M = 2^b;
Xmax = max(abs(x));
d = 2*Xmax/M;
aten = 0.5; %faktor utisavanja/atenuacije
x1 = aten*x;

xq_uni = round(x1/d)*d; %ne koristi se ni floor ni ceil
xq_uni(x1>(M-1)/2*d) = (M/2-1)*d; %da izbegnemo dodavanje jos jednog nivoa

%Odnos signal-sum
fprintf('SNR = %f\n', 10*log10(var(x1)/var(x1-xq_uni)));

%% Uniformni kvantizator SNR crtanje
[x, Fs] = audioread('sekvenca.wav');
N = length(x);
Xmax = max(abs(x));
aten = 0.1:0.01:1;
for b=[12, 10, 8]
    M = 2^b;
    d = 2*Xmax/M;
    SNR = []; %Pamtimo SNR kada variramo podesavanja
    xvar = []; %Pamtimo varijansu signala kada variremo podesavanja
    for i = 1:length(aten)
        x1 = aten(i)*x;
        xq_uni = round(x1/d)*d; %ne koristi se ni floor ni ceil
        xq_uni(x1>(M-1)/2*d) = (M/2-1)*d; %da izbegnemo dodavanje jos jednog nivoa
        SNR = [SNR 10*log10(var(x1)/var(x1-xq_uni))];
        xvar = [xvar var(x1)];
    end
    figure(3)
    %plot(Xmax./sqrt(xvar),SNR,'b');
    semilogx(Xmax./sqrt(xvar),SNR,'b'); %crta sa logaritamskom sklaom, dobija se linearna zavisnost
    hold all;
    %plot(Xmax./sqrt(xvar),4.77+6*b-20*log10(Xmax./sqrt(xvar)),'r--')
    semilogx(Xmax./sqrt(xvar),4.77+6*b-20*log10(Xmax./sqrt(xvar)),'r--')
    %Dobija se da se teorijska vrednosti i prakticna ne razlikuju mnogo.
end

%Uniformni kvantizator nije dobar zato sto zavisi od amplitude signala.
%Treba nam kvantizator koji ce signale sa malom amplitudom rastegnemo na siri opseg,
% a tek onda primenimo kvantizaciju, ?pa primenimo inverznu f-ju? sto
%lici na logaritamsku f-ju (mi kompanding).


%% mi kompanding kvantizator: mi=100, 500;
clear all;
close all;
clc;
[x, Fs] = audioread('sekvenca.wav');
N = length(x);
b = 4;
Xmax = max(abs(x));
M = 2^b;
d = 2*Xmax/M;
mi = 500; %Faktor koji odredjuje koliko ce da se radi kompresija.
x_comp = Xmax*log10(1+mi*abs(x)/Xmax)/(log10(1+mi)).*sign(x); %kompanding
xq_mi = round(x_comp/d)*d;
xq_mi(x_comp>(M-1)/2*d) = (M/2-1)*d;
%dekompanding
x_decomp = 1/mi*sign(xq_mi).*((1+mi).^(abs(xq_mi)/Xmax)-1)*Xmax;

figure()
plot(x, xq_mi,'*')

figure()
hold all
plot(x,'b')
plot(x_decomp,'r--')

fprintf('SNR = %f\n', 10*log10(var(x)/var(x-x_decomp)));

%% mi kompanding - crtanje SNR karakteristike

[x,Fs]=audioread('sekvenca.wav');
Xmax = max(abs(x));
N = length(x);
b = 8;
M = 2^b;

d = 2*Xmax/(2^b);
Xmax = max(abs(x));

for mi=[100,500]
    aten = 0.1:0.01:1; %atenuacija/utisavanje
    M = 2^b; %broj kvantizacionih nivoa
    d = 2*Xmax/M; %korak kvantizacije
    SNR1 = [];
    xvar1 = [];
    for i=1:length(aten)
        x1 = aten(i)*x;
        xvar1 = [xvar1 var(x1)];
        x_comp = Xmax*log10(1+mi*abs(x1)/Xmax)/(log10(1+mi)).*(sign(x1));
        xq_mi = round(x_comp/d)*d; %kvantizovan signal
        x_mi_decomp =1/mi*sign(xq_mi).*((1+mi).^(abs(xq_mi)/Xmax)-1)*Xmax;
        SNR1 = [SNR1 10*log10(var(x1)/var(x1-x_mi_decomp))];
    end
    figure(9);
    semilogx(Xmax./(sqrt(xvar1)),SNR1,'b');
    %plot(Xmax./(sqrt(xvar)),SNR,'b');
    hold on;
    %semilogx(Xmax./(sqrt(xvar)),4.77+6*b-20*log10(Xmax./sqrt(xvar)),'r--');
    semilogx(Xmax./(sqrt(xvar1)),4.77+6*b-20*log10(log(1+mi))-10*log10(1+(Xmax./mi)^2./xvar1+sqrt(2)*Xmax./mi./sqrt(xvar1)),'r--');
    legend('Eksperimentalno','Teorijski')
end

%Zrtvujemo odnos signal-sum ali dobijamo da se on veoma malo menja kada je
%signal dosta utisan. Recimo samo 2dB zrtvujemo, a snr veoma malo opada
%kad se Xmax smanji.

%% Poredjenje uniformnog i mi kompanding


%% Uniformni mid-rise kvantizator
[x, Fs] = audioread('sekvenca.wav');
N = length(x);
b = 3;
M = 2^b;
Xmax = max(abs(x));
d = 2*Xmax/M;

xq_uni = (floor(x/d)+0.5)*d;
xq_uni(x>(M-1)/2*d) = (M-1)/2*d;
xq_uni(x<-(M-1)/2*d) = -(M-1)/2*d;

figure()
plot(x,xq_uni,'*')
figure()
hold all;
plot(x, 'b')
plot(xq_uni,'r--')


%% Feed-back step-size adaptivni
clear all; close all; clc;
[x, Fs] = audioread('sekvenca.wav');
x = x';
b = 3;
M = 2^b;
Xmax = max(abs(x));
d = Xmax*2/M;
P = [0.85 1 1 1.5]; %koeficijenti za definisani broj bita
P_trenutno = 1;
xq = zeros(1,length(x));
for i = 1:length(x)
    d = d*P_trenutno;
    xq(i) = (floor(x(i)/d)+0.5)*d;
    if xq(i)<-(M-1)/2*d
        xq(i) = -(M-1)/2*d;
    end
    if xq(i)>(M-1)/2*d
        xq(i) = (M-1)/2*d;
    end
    ind = round(abs(xq(i)/d)+0.5); %Vraca broj od 1 do 4.
    %Prouciti formulu.
    P_trenutno = P(ind);
end

figure()
hold all
plot(x,'b');
plot(xq,'r--');

fprintf('SNR = %f\n', 10*log10(var(x)/var(x-xq)));

