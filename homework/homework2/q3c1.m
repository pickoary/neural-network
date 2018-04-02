clc
clear all;
close all;

dirName = 'Face Database/TrainImages';


files_jpg = dir( fullfile(dirName,'*.jpg') );
files_jpg_name = {files_jpg.name}';
x = ones(2500,1000);

for i=1:numel(files_jpg_name)
    file_name = fullfile(dirName,files_jpg_name{i});
    I = imread(file_name);
    G =rgb2gray(I);
    [m,n] = size(G);
    G=imresize(G,[50,50]);
    V = G(:);
    data_img{i} = V;
end

for i=1:1000
    x(:,i) = data_img{1,i};
end

Des_out=zeros(1,1000);

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
        Des_out(i)=1.0;
    elseif data{i,1}(1,1)==0
        femle=femle+1;
        Des_out(i)=0;
    end
end

mutest = mean(x(1:2500),2);
sigmatest = std(x(1:2500),1,2);

for i=1:1000

x(:,i)=(x(:,i)-mutest)./sigmatest;

end

dirName = 'Face Database/TestImages';

files_jpg = dir( fullfile(dirName,'*.jpg') );
files_jpg_name = {files_jpg.name}';
xtest = zeros(2500,250);

for i = 1:numel(files_jpg_name)
    file_name = fullfile(dirName,files_jpg_name{i});
    I = imread(file_name);
    G = rgb2gray(I);
    [m,n] = size(G);
    G = imresize(G,[50,50]);
    V = G(:);
    data_img{i} = V;
end

for i = 1:250
    xtest(:,i) = data_img{1,i};
end

Des_test = zeros(1,250);

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
        Des_test(i) = 1.0;
    elseif data_t{i,1}(1,1)==0
        femail_t = femail_t+1;
        Des_test(i) = 0;
    end
end

for i=1:250
    xtest(:,i)=(xtest(:,i)-mutest)./sigmatest;
end

n=1; 
weights(:,n)=rand(1,2500); 
eta=0.1; 
epochs=100; 

for i=1:epochs
    for j=1:1000
        v=weights(:,n)'*x(:,j);
        if (v>=0)
            y(j)=1;
        else
            y(j)=0;
        end
        e(j)= Des_out(j)-y(j);
        weights(:,n+1)=weights(:,n)+(eta*e(j)*x(:,j));
        n=n+1;
    end
end

accuracy_train = 1 ;
accuracy_test = 1;

for j=1:1000
   if ((weights(:,n)'*x(:,j)) >=0)
       clas_train_y(j)=1.0;
   else
       clas_train_y(j)=0;
   end
   if(((Des_out(j)== 0) && (clas_train_y(j)== 0))||((Des_out(j)== 1.0) && (clas_train_y(j)==1.0)))
       accuracy_train = accuracy_train + 1;
   end
end

for j=1:250
    if ((weights(:,n)'*xtest(:,j)) >=0)
        clas_test_y(j)=1.0;
    else
        clas_test_y(j)=0;
    end
    if(((Des_test(j)== 0) && (clas_test_y(j)== 0))||((Des_test(j)== 1.0) && (clas_test_y(j)==1.0)))
        accuracy_test = accuracy_test + 1;
    end
end

accuracy_perc_test = accuracy_test/250*100;
accuracy_perc_train = accuracy_train/1000*100;
disp(accuracy_perc_train);
disp(accuracy_perc_test);