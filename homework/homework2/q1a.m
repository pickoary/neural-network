clc; 
clear all; 
iteration = 1; 
x(iteration) = rand(1); 
y(iteration) = rand(1); 
f(iteration) = (1-x(iteration))^2 + 100*(y(iteration)-x(iteration)^2)^2; 
eta = 0.001; 

while f(iteration) > 1e-8
fx(iteration) = 2*x(iteration)-2+400*(x(iteration)^3-x(iteration)*y(iteration));
fy(iteration) = 200*(y(iteration)-x(iteration)^2);
iteration = iteration + 1;
x(iteration) = x(iteration-1) - eta*fx(iteration-1);
y(iteration) = y(iteration-1) - eta*fy(iteration-1);
f(iteration) = (1-x(iteration))^2 + 100*(y(iteration)-x(iteration)^2)^2; 
end

figure;
plot(x,y,'-');
s = sprintf('Trajectory of (x, y) for eta = 0.001');
title(s);