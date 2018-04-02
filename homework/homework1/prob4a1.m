

figure;
plot([0.5 1.5 3 4 5],[8 6 5 2 0.5],'*');
grid on;
hold on;
axis([-5,8,-1,11]);
title('Figure4a');
x = -5:.01:8;
y = x*(-1.6316)+8.8684;
plot(x,y);
hold off;