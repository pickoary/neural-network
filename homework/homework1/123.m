flag = 1;
while flag
flag = 0;
    for i = length(d)
    y = sign(X(i,:) * w) >= 0; % y = 0 is defined to be positive
    e = d(i) - y;
        if e ~= 0
        w = w + e * X(i,:)'; % update weight vector
        flag = 1;
        end
    end
end