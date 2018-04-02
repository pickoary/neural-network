clc
clear all;
x = -2:0.05:2;
y = 1.2*sin(pi*x) - cos(2.4*pi*x);
net = newff(minmax(x),[100,1],{'tansig','purelin'},'trainlm');
net.trainparam.lr = 0.01;
net.trainparam.epochs = 10000;
net.trainparam.goal = 1e-4;
net.trainParam.max_fail = 10;
net = train(net,x,y); 

xtest = -2:0.01:2;
ytest = 1.2*sin(pi*xtest) - cos(2.4*pi*xtest);
net_output = sim(net,xtest);


plot(xtest,ytest,'b+');
hold on;
plot(xtest,net_output,'r-');
legend('target function','MLP output')
hold off