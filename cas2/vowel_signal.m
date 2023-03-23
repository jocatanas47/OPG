function s = vowel_signal(fs, f0, v, d)
e = genpulse(f0, d, fs);
t1 = 7.5*1e-3;
t2 = 13*1e-3;
g = rosenmodel(t1, t2, fs);
y = conv(e, g);
switch v
    case 'a'
        f = [800; 1200; 2800; 3600];
        a = [0.98; 0.96; 0.88; 0.9];
    case 'e'
        f = [500; 1900; 2150; 3300];
        a = [0.99; 0.96; 0.95; 0.96];
    case 'o'
        f = [500; 900; 2300; 3200];
        a = [0.98; 0.97; 0.89; 0.87];
end
[A, B] = makevowel(a, f, fs);
yf = filter(B, A, y);
yf = filter([1, -1], 1, yf);
s = yf;
end