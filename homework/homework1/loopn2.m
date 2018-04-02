N = 100;
X = [1 0.5;1 1.5;1 3;1 4;1 5];
d = [8.0;6;5;2;0.5];
w = [0.4;0.6];
lr = 0.2;
for n = 0 : N
    for i = 1:length(d)
        e = d(i) - X(i,:) * w;
        e1(n+1) = e*e/2;
        w = w + e * lr * X(i,:)';
        w1(n+1) = w(1);
        w2(n+1) = w(2);
    end
end

figure;
subplot(2,1,1);
x = 0:N;
plot(x,w1,'.-');
grid on;
hold on;
plot(x,w2,'--');
hold on;
axis([0,100,-10e+55,1e+55]);
legend('b','w1');
title('Trajectory of Weights');
hold off;

subplot(2,1,2);
x = 0:N;
plot(x,e1,'-');
grid on;
axis([0,100,-8e+111,8e+111]);
legend('AE');
title('Average Error');
