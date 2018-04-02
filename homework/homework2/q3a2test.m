clc
clear all;
close all;
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

Des_test = zeros(1,250);

files = dir( fullfile(dirName,'*.att') );
files_name = {files.name}';

data_t = cell(numel(files_name),1);
male_t = 0;
femail_t = 0;

for i = 1:numel(files_name)
    fname = fullfile(dirName,files_name{i});
    data_t{i} = load(fname);
    y(i) = data_t{i,1}(1,1);
    
    if data_t{i,1}(1,1)==1
        male_t = male_t+1;
        Des_test(i) = 1.0;
    elseif data_t{i,1}(1,1)==0
        femail_t = femail_t+1;
        Des_test(i) = 0;
    end
end

figure;
hist(y,2);
