function [A, B] = makevowel(a, f, fs)
fz = f/fs * 2*pi; % u radijanima normalizovana ucestanost
z = tf('z', 1/fs);
Ai = [ones(4, 1), -2*a.*cos(fz), a.^2] * [1; z^-1; z^-2];
Az = Ai(1)*Ai(2)*Ai(3)*Ai(4); % svaki polinom odgovara jednom paru konjuovano kompleksnih polova
[A, B] = tfdata(Az, 'v');
%[B, A] = tfdata(1/Az, 'v');
end