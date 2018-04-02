clc
clear all;
x = -2:0.05:2;
y = 1.2*sin(pi*x) - cos(2.4*pi*x);
net = feedforwardnet(1,'traingd');
net.layers{1}.transferFcn = 'tansig';
net.layers{2}.transferFcn = 'purelin';
net = configure(net,x,y);
net.trainparam.lr=0.01;
net.trainparam.epochs=1;
net.trainparam.goal=1e-8;
net.divideParam.trainRatio=1.0;
net.divideParam.valRatio=0.0;
net.divideParam.testRatio=0.0;
for i = 1 : 1000
    index = randperm(81);
    net = adapt(net,x(:,index),y(index));
end
xtest = -2:0.01:2;
ytest = 1.2*sin(pi*xtest) - cos(2.4*pi*xtest);
net_output = sim(net,xtest);


plot(xtest,ytest,'b+');
hold on;
plot(xtest,net_output,'r-');
legend('target function','MLP output')
hold off