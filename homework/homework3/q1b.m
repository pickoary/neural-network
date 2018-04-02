clc
clear all;
close all;

x = -1:0.05:1;
y = 1.2*sin(pi*x) - cos(2.4*pi*x);
d = 1.2*sin(pi*x) - cos(2.4*pi*x) + 0.3*randn(size(x));
w = zeros(length(x),1);
temp = randperm(numel(x));
mu = x(temp(1:20));
dm = max(max(dist(mu',mu)));
D = zeros(length(x),length(mu));
% D1 = zeros(length(x),length(mu));

% for j = 1:length(x)
%     for i = 1:length(mu)
%         D(j,i) = exp(-length(mu)/(dm^2)*((x(j)-mu(i)).^2));
%     end
% end

D = exp(-length(mu)/(dm^2)*(dist(x',mu)).^2);
w = pinv(D'*D)*D'*d';
% w1 = pinv(D1'*D1)*D1'*d';
xtest = -1:0.01:1;
ytest = 1.2*sin(pi*xtest) - cos(2.4*pi*xtest);
y_out = zeros(size(xtest));
% y_outtest = zeros(size(xtest));

% for i = 1:length(mu)
%     y_out = y_out + w(i)*exp(-length(mu)/(dm^2)*(xtest - mu(i)).^2);
% end

DD = exp(-length(mu)/(dm^2)*(dist(xtest',mu)).^2);
y_out = (DD*w)';

a = sum((y - d).^2)/length(x);
b = sum((y_out - ytest).^2)/length(xtest);

figure
plot(xtest,ytest,'b-');
hold on;
plot(xtest,y_out,'r+-');
hold on;
plot(x,d,'gs-');
legend('Test Data','NN output','Train Data')
hold off

