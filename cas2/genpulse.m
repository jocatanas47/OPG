function e = genpulse(f0, d, fs)
N = d*fs;
e = zeros(1, N);
e(fs/f0:fs/f0:end) = 1;
end