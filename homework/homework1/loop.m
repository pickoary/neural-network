N = 100;
X = [1 0.5;1 1.5;1 3;1 4;1 5];
d = [8.0;6;5;2;0.5];
w = [0.4;0.6];
lr = 0.02;
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
subplot(3,1,1);
x = 0:N;
plot(x,w1,'.-');
grid on;
hold on;
plot(x,w2,'--');
hold on;
axis([0,100,-5,10]);
legend('b','w1');
title('Trajectory of Weights');
hold off;

subplot(3,1,2);
x = 0:N;
plot(x,e1,'-');
grid on;
axis([0,100,0,8]);
legend('AE');
title('Average Error');

subplot(3,1,3);
plot([0.5 1.5 3 4 5],[8.0 6 5 2 0.5],'o');
grid on;
hold on;
axis([-1,10,-1,10]);
s = sprintf('Function AND:%.2f+(%.2f)*x1 = 0',w(1),w(2));
title(s);
x = -1:.01:11;
y = x*w(2)+w(1);
plot(x,y);