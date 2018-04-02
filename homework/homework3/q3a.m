clc
clear all;
close all;

X = randn(800,2);
s2 = sum(trainX.^2,2);
trainX = (X.*repmat(1*(gammainc(s2/2,1).^(1/2))./sqrt(s2),1,2))';

plot(trainX(1,:),trainX(2,:),'+r'); axis equal

w = som(trainX',1,36,600);

figure
plot(trainX(1,:),trainX(2,:),'*r',w(:,1),w(:,2),'-dk');
legend('tr','som');