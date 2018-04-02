clc
clear all;
close all;

load('characters10.mat');
load('q2c.mat');
% train_data training data, 3000x784 matrix
% train_label labels of the training data, 3000x1 vector
% test_data  test data, 500x784 matrix
% test_label  labels of the test data, 500x1 vector
    
% To select a few classes for training, you may refer to the following code:
trainIdx1 = find(train_label==1); % select classes 1
trainX1 = train_data(trainIdx1,:);
Class1 = mean(trainX1,1);

trainIdx2 = find(train_label==2); % select classes 2
trainX2 = train_data(trainIdx2,:);
Class2 = mean(trainX2,1);


% After loading the data, you may view them using the code below:
imshow(reshape(mu(1, :), [28,28]));

imshow(reshape(mu(2, :), [28,28]));

