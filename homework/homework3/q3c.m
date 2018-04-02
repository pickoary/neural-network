clc
clear all;
close all;

load('characters10.mat');
% train_data training data, 3000x784 matrix
% train_label labels of the training data, 3000x1 vector
% test_data  test data, 500x784 matrix
% test_label  labels of the test data, 500x1 vector

    
% To select a few classes for training, you may refer to the following code:
trainIdx = find(train_label~=1&train_label~=2); % omit classes 1, 2
trainY = train_label(trainIdx);
trainX = train_data(trainIdx,:);
TrData = zeros(size(trainX));

mutest = mean(double(trainX(1,1:784)),2);
sigmatest = std(double(trainX(1,1:784)),1,2);
for i = 1:size(trainX,1)
    TrData(i,:) = (double(trainX(i,:)) - mutest)./sigmatest;
end

testIdx = find(test_label~=1&test_label~=2); % omit classes 1, 2
testY = test_label(testIdx);
testX = test_data(testIdx,:);
TeData = zeros(size(testX));

mutest = mean(double(testX(1,1:784)),2);
sigmatest = std(double(testX(1,1:784)),1,2);
for i = 1:size(testX,1)
    TeData(i,:) = (double(testX(i,:)) - mutest)./sigmatest;
end

[w,wIdx] = somc(TrData,trainY,10,10,2000);
temp = reshape(wIdx,[10 10]);
wmap = temp';

for i = 1:100
        subplot(10,10,i);
        imshow(reshape(w(i,:),[28 28]));
end

for k = 1:size(TeData,1)
    for r = 1:size(w,1)
        D(r) = (w(r,:) - TeData(k,:))*(w(r,:) - TeData(k,:))';
    end
    point = find(D==min(D));
    teIdx(k) = wIdx(point);
end

account = 0;
Acc = 0;
for i = 1:length(teIdx)
    if ((teIdx(i) - testY(i))== 0) 
        account = account+1;
    end
end
Acc = account/length(teIdx);
