n = 1;
w = [0,0,0];
P = [0,0,1,1;0,1,0,1];
d = [0,0,0,1];

P = [ones(1,4);P];
MAX = 20;
i = 0;
while 1
    v = w * P;
    y = hardlim(v);
    e = (d-y);
    ee(i+1) = mae(e);
    if (ee(i+1)<0.001)
        break;
    end
    w = w+n*(d-y)*P';
    i = i+1;
    if (i>=MAX)
        disp(w);
        break;
    end
end

figure;
subplot(2,1,1);
plot([0,0,1],[0,1,0],'o');
hold on;
plot(1,1,'*');
axis([-0.1,1.6,-0.1,1.6]);
title(Figure3bAND);
x = -0.1:.01:1.6;
y = x*(-w(2)/w(3))-w(1)/w(3);
plot(x,y);

subplot(2,1,2);
x = 0:i;
plot(x,w(1),'o-');
hold on;
plot(x,w(2),'*-');
hold on;
plot(x,w(3),'+-');
hold off;
