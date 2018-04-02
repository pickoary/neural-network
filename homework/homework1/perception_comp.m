n = 1;
w = [0.2,0.4];
P = [0,1];
d = [1,0];

P = [ones(1,2);P];
MAX = 20;
i = 0;
while 1
    v = w * P;
    y = hardlim(v);
    e = (d-y);   
    ee(i+1) = mae(e);
    w = w+n*(d-y)*P';
    i = i+1;
    w1(i+1) = w(1);
    w2(i+1) = w(2); 
    if (i>=MAX)
        break;
    end
end

figure;
subplot(2,1,1);
plot(0,1,'o');
grid on;
hold on;
plot(1,0,'*');
axis([-0.5,1.1,-0.6,1.1]);
s = sprintf('Function AND:%.2f+(%.2f)*x = 0',w(1),w(2));
title(s);
x = -w(1)/w(2);
plot([x x],[-0.6 1.1]);

subplot(2,1,2);
x = 0:i;
plot(x,w1,'o-');
grid on;
hold on;
plot(x,w2,'*-');
hold on;
axis([0,20,-1,0.5]);
legend('b','w1');
title('Trajectory of weights');
hold off;

