clc

clear all;

close all;

dirName = 'Face Database\TrainImages';

%% creating the training input vector, reading images

% folder path

files_jpg = dir( fullfile(dirName,'*.jpg') );

files_jpg = {files_jpg.name}';

x = ones(10201,1000);

for i=1:numel(files_jpg)

file_name = fullfile(dirName,files_jpg{i});

A = imread(file_name);

A =rgb2gray(A);

[m,n] = size(A);

if (m>=101 || n>=101)

% list all *.jpg files

% file names

%# full path to file

A=imresize(A,[101,101]);

end

B = A(:);

data_img{i} = B;

end

for i=1:1000

x(:,i)=data_img{1,i};

end

%corresponding desired outputs

Des_out=zeros(1,1000);

files = dir( fullfile(dirName,'*.att') );

files = {files.name}';

data = cell(numel(files),1);

g=0; % No of persons with glasses

nog=0; % No of persons without glasses

for i=1:numel(files)

fname = fullfile(dirName,files{i});

% list all *.att files

% file names

% store file contents

% full path to file

data{i} = load(fname);

% load file

%--output vector

if data{i,1}(3,1)==1

g=g+1;

Des_out(i)=1.0; %--desired value= one for with glasses

elseif data{i,1}(3,1)==0

nog=nog+1;

Des_out(i)=0; %--desired value= zero for without glasses

end

end