clc
clear all;
close all;

X = randn(800,2);
s2 = sum(X.^2,2);
trainX = (X.*repmat(1*(gammainc(s2/2,1).^(1/2))./sqrt(s2),1,2))';

w = som(trainX',6,6,5000);

figure
plot(trainX(1,:),trainX(2,:),'+r'); 
axis equal;
hold on;
for i = 0:5
    plot(w(i*6+1:(i+1)*6,1),w(i*6+1:(i+1)*6,2),'-dk');
end
hold on;
for i = 1:6
    plot(w(i:6:i+30,1),w(i:6:i+30,2),'-dk');
end
hold off;
legend('tr','som');