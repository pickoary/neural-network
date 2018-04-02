n = 1;
w = [0.2,0.4,0.6];
P = [0,0,1,1;0,1,0,1];
d = [0,1,1,1];

P = [ones(1,4);P];
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
    w3(i+1) = w(3); 
    if (i>=MAX)
        break;
    end
end

figure;
subplot(2,1,1);
plot([1,0,1],[1,1,0],'o');
grid on;
hold on;
plot(0,0,'*');
axis([-0.6,1.1,-0.6,1.1]);
s = sprintf('Function AND:%.2f+%.2f*x1+%.2f*x2 = 0',w(1),w(2),w(3));
title(s);
x = -0.6:.01:1.1;
y = x*(-w(2)/w(3))-w(1)/w(3);
plot(x,y);

subplot(2,1,2);
x = 0:i;
plot(x,w1,'o-');
grid on;
hold on;
plot(x,w2,'*-');
hold on;
plot(x,w3,'+-');
axis([0,20,-5,5]);
legend('b','w1','w2');
title('Trajectory of weights');
hold off;

