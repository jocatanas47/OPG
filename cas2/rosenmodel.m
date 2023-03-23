function g = rosenmodel(t1, t2, fs)
N1 = t1*fs;
N2 = t2*fs;
n = 0:(N1 + N2);
g = 0.5*(1 - cos(pi*n/N1)).*(n <= N1) + cos(pi*(n - N1)/2/N2).*(n > N1);
end