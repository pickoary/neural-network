%Matlab code

clc

clear all;

%% sampling points in the domain of [-1,1]

x = -2:0.05:2;

%% generating training data, and the desired outputs

y = 1.2*sin(pi*x) - cos(2.4*pi*x);

%% specify the structure and learning algorithm for MLP

net = feedforwardnet(1,'trainlm');

net.layers{1}.transferFcn = 'tansig';

net.layers{2}.transferFcn = 'purelin';

net = configure(net,x,y);

net.trainparam.lr=0.01;

net.trainparam.epochs=10000;

net.trainparam.goal=1e-8;

net.divideParam.trainRatio=1.0;

net.divideParam.valRatio=0.0;

net.divideParam.testRatio=0.0;

%% Train the MLP

[net,tr]=train(net,x,y);

%% Test the MLP, net_output is the output of the MLP, ytest is the desired output.

xtest = -2:0.01:2;

ytest = 1.2*sin(pi*xtest) - cos(2.4*pi*xtest);

net_output = sim(net,xtest);

%% Plot out the test results

plot(xtest,ytest,'b+');

hold on;

plot(xtest,net_output,'r-');

hold off