N = 100;
eta = 0.02;
for n = 0 : N 
    for i = 1:length(d)
        e = d(i) - X(i,:) * w;
        w = w + e * eta * X(i,:);
    end
end
