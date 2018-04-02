clc; 
clear all; 
iteration = 1; 
x(iteration) = rand(1); 
y(iteration) = rand(1); 
f(iteration) = (1-x(iteration))^2 + 100*(y(iteration)-x(iteration)^2)^2; 
while f(iteration) > 1e-8 || iteration > 20000
fx(iteration) = 2*x(iteration)-2+400*(x(iteration)^3-x(iteration)*y(iteration));
fy(iteration) = 200*(y(iteration)-x(iteration)^2);
H{iteration} = [1200*x(iteration)^2-400*y(iteration)+2 -400*x(iteration); -400*x(iteration) 200];
iteration = iteration + 1;
tmp = [x(iteration-1);y(iteration-1)] - inv(H{iteration-1})*[fx(iteration-1);fy(iteration-1)];
x(iteration) = tmp(1);
y(iteration) = tmp(2);
f(iteration) = (1-x(iteration))^2 + 100*(y(iteration)-x(iteration)^2)^2; 
end

i = 1:iteration;

figure
plot(i,f(i),'-');