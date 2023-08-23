function [m1,m2,m3,m4,m5,m6] = sekvence(x)
    N = length(x);
    m1 = zeros(1,N);
    m2 = zeros(1,N);
    m3 = zeros(1,N);
    m4 = zeros(1,N);
    m5 = zeros(1,N);
    m6 = zeros(1,N);
    
    maxs = zeros(1,N); %Sadrzi nule svuda sem na mestima lokalnog maksimuma
    mins = zeros(1,N); %Sadrzi nule svuda sem na mestima lokalnog minimuma
    
    [peaks, max_indxs] = findpeaks(x);
    maxs(max_indxs) = peaks;
    max_indxs = max_indxs';
    [peaks, min_indxs] = findpeaks(-x);
    mins(min_indxs) = -peaks;
    min_indxs = min_indxs';
    
    m1 = maxs;
    m1(m1<0) = 0; %Moze da se desi da je slucajno neki maksimum ispod nule.
    m4 = -mins;
    m4(m4<0) = 0;
    
    maxp = 0; %Vrednost prethodnog maksimuma
    for i = max_indxs
        if (isempty(find(min_indxs<i,1,'last')))
            minp = 0;
        else
            idx = find(min_indxs<i, 1, 'last');
            minp = mins(min_indxs(idx));
        end
        m2(i) = max(0,maxs(i)-minp);
        m3(i) = max(0,maxs(i)-maxp);
        maxp = maxs(i);
    end
    
    minp = 0; %Vrednost prethodnog maksimuma
    for i = min_indxs
        if (isempty(find(max_indxs<i,1,'last')))
            maxp = 0;
        else
            idx = find(max_indxs<i, 1, 'last');
            maxp = maxs(max_indxs(idx));
        end
        m5(i) = max(0,-(mins(i)-maxp));
        m6(i) = max(0,-(mins(i)-minp));
        minp = mins(i);
    end
    
end