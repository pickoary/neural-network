clc
clear all;
close all;
dirName = 'Face Database/TrainImages';

files_jpg = dir( fullfile(dirName,'*.jpg') );
files_jpg_name = {files_jpg.name}';
x = ones(10201,1000);

for i=1:numel(files_jpg_name)
    file_name = fullfile(dirName,files_jpg_name{i});
    I = imread(file_name);
    G =rgb2gray(I);
    [m,n] = size(G);
    if (m>=101 || n>=101)
        G=imresize(G,[101,101]);
    end
    V = G(:);
    data_img{i} = V;
end

for i=1:1000
    x(:,i) = data_img{1,i};
end

y=zeros(1,1000);

files = dir( fullfile(dirName,'*.att') );
files_name = {files.name}';

data = cell(numel(files_name),1);
male=0; 
femle=0;

for i=1:numel(files_name)
    fname = fullfile(dirName,files_name{i});
    data{i} = load(fname);
    
    if data{i,1}(1,1)==1
        male=male+1;
        y(i)=0.8;
    elseif data{i,1}(1,1)==0
        femle=femle+1;
        y(i)=0.2;
    end
end

mutest = mean(x,2);
sigmatest = std(x,1,2);

for i=1:1000
    x(:,i)=(x(:,i)-mutest)./sigmatest;
end

dirName = 'Face Database/TestImages';

files_jpg = dir( fullfile(dirName,'*.jpg') );
files_jpg_name = {files_jpg.name}';
xtest = zeros(10201,250);

for i = 1:numel(files_jpg_name)
    file_name = fullfile(dirName,files_jpg_name{i});
    I = imread(file_name);
    G = rgb2gray(I);
    [m,n] = size(G);
    if (m>=101 || n>=101)
        G = imresize(G,[101,101]);
    end
    V = G(:);
    data_img{i} = V;
end

for i = 1:250
    xtest(:,i) = data_img{1,i};
end

ytest=zeros(1,250);

files = dir( fullfile(dirName,'*.att') );
files_name = {files.name}';

data_t = cell(numel(files_name),1);
male_t = 0;
femail_t = 0;

for i = 1:numel(files_name)
    fname = fullfile(dirName,files_name{i});
    data_t{i} = load(fname);
    
    if data_t{i,1}(1,1)==1
        male_t = male_t+1;
        ytest(i) = 0.8;
    elseif data_t{i,1}(1,1)==0
        femail_t = femail_t+1;
        ytest(i) = 0.2;
    end
end

mutest = mean(xtest,2);
sigmatest = std(xtest,1,2);

for i=1:250
    xtest(:,i)=(xtest(:,i)-mutest)./sigmatest;
end

n= [1,2,5,10,20,50,100];

accuracy_train = zeros(length(n),1);
accuracy_test = zeros(length(n),1);
accuracy_perc_test=zeros(length(n),1);
accuracy_perc_train=zeros(length(n),1);

epoch_s=1000;

for k=1:length(n)
    net = feedforwardnet(n(k),'trainlm');
    net.layers{1}.transferFcn = 'tansig';
    net.layers{2}.transferFcn = 'logsig';
    net = configure(net,x,y);
    net.trainparam.lr=0.01;
    net.trainparam.epochs=1;
    net.trainparam.goal=1e-8;
    net.divideParam.trainRatio=1.0;
    net.divideParam.valRatio=0.0;
    net.divideParam.testRatio=0.0;
    for i = 1 : epoch_s
        index = randperm(1000);
        net = adapt(net,x(:,index),y(index));
    end
    test_output=sim(net,xtest);
    train_output =sim(net,x); 
    for j=1:length(train_output)
        if train_output(j) > 0.5
            clas_train_y(j)=1.0;
        else
            clas_train_y(j)=0;
        end
        if(((y(j)==0.2) && (clas_train_y(j)==0))||((y(j)==0.8) && (clas_train_y(j)==1.0)))
            accuracy_train(k,1) = accuracy_train(k,1) + 1;
        end
        accuracy_perc_train(k,1) = accuracy_train(k,1)/1000*100;
    end
    for j=1:length(test_output)
        if test_output(j) > 0.5
            clas_test_y(j)= 1.0;
        else
            clas_test_y(j)=0;
        end
        if(((ytest(j)==0.2) && (clas_test_y(j)==0))||((ytest(j)==0.8) && (clas_test_y(j)==1.0)))
            accuracy_test(k,1) = accuracy_test(k,1) + 1;
        end
        accuracy_perc_test(k,1) = accuracy_test(k,1)/250*100;
    end
end