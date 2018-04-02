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
      if (m~=101 || n~=101)
          G=imresize(G,[101,101]);
      end
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
    y(i) = data{i,1}(1,1);
    
    if data{i,1}(1,1)==1
        male=male+1;
        Des_out(i)=1.0;
    elseif data{i,1}(1,1)==0
        femle=femle+1;
        Des_out(i)=0;
    end
end

figure;
hist(y,2);
