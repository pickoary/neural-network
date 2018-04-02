X = [1 0 0;1 0 1;1 1 0;1 1 1]£»
d = [0;1;1;1]£»
£»
flag = 1;
while flag
    flag = 0 ;
    for n = 1:20
        for i = 1:length(d)
        y = sign(X(i,:)*w) >= 0; 
        e = d(i)-y;
            if e ~= 0
            w = w+e*X(i,:)'; 
            flag = 1;
            end
        end
    end
end