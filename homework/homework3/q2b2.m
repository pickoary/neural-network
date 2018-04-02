clc
clear all;
close all;

load('characters10.mat');
% train_data training data, 3000x784 matrix
% train_label labels of the training data, 3000x1 vector
% test_data  test data, 500x784 matrix
% test_label  labels of the test data, 500x1 vector
    
load('mu.mat');

% To select a few classes for training, you may refer to the following code:
trainIdx = find(train_label==1 | train_label==2); % select classes 1, 2
trainY = train_label(trainIdx);
trainX = train_data(trainIdx,:);
TrLabel = zeros(size(trainY));
TrData = zeros(size(trainX'));
w = zeros(size(TrLabel));
D = zeros(length(TrLabel),length(TrLabel));

for i = 1:length(trainY)
    if trainY(i) == 1
        TrLabel(i) = 0;
    elseif trainY(i) == 2
        TrLabel(i) = 1;
    end
end

mutest = mean(double(trainX(1,1:784)),2);
sigmatest = std(double(trainX(1,1:784)),1,2);
for i = 1:size(trainX,1)
    TrData(:,i) = (double(trainX(i,:)) - mutest)./sigmatest;
end

mu = a;
sigma = 32500;
D = exp(-(dist(TrData',mu)).^2/(2*sigma^2));
w = pinv(D'*D)*D'*TrLabel;

testIdx = find(test_label==1 | test_label==2); % select classes 1, 2
testY = test_label(testIdx);
testX = test_data(testIdx,:);
TeLabel = zeros(size(testY));
TeData = zeros(size(testX'));
TeOut = zeros(size(testY));

for i = 1:length(testY)
    if testY(i) == 1
        TeLabel(i) = 0;
    elseif testY(i) == 2
        TeLabel(i) = 1;
    end
end

mutest = mean(double(testX(1,1:784)),2);
sigmatest = std(double(testX(1,1:784)),1,2);
for i = 1:size(testX,1)
    TeData(:,i) = (double(testX(i,:)) - mutest)./sigmatest;
end

DD = exp(-(dist(TeData',mu)).^2/(2*sigma^2));
TeOut = DD*w;

% Please use the following code to evaluate:

TrAcc = zeros(1,1000);
TeAcc = zeros(1,1000);
thr = zeros(1,1000);
TrN = length(TrLabel);
TeN = length(TeLabel);
TrPred = D*w;
TePred = DD*w;

for i = 1:1000
    t = (max(TrPred)-min(TrPred)) * (i-1)/1000 + min(TrPred);
    thr(i) = t;
    TrAcc(i) = (sum(TrLabel(TrPred<t)==0) + sum(TrLabel(TrPred>=t)==1)) / TrN;
    TeAcc(i) = (sum(TeLabel(TePred<t)==0) + sum(TeLabel(TePred>=t)==1)) / TeN;
end

figure
plot(thr,TrAcc,'.- ',thr,TeAcc,'^-');
legend('tr','te');
xlabel('Thresholds');
ylabel('Accuracy');
    
  