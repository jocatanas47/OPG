function [a, s] = estimate_lpc(rxx)
    p = (length(rxx) - 1)/2;
    R = toeplitz(rxx(p + 1:2*p), rxx(p + 1:2*p));
    a = -R\rxx(p + 2:end);
    s = 1; % po formuli se dobije
    a = [1, a'];
end