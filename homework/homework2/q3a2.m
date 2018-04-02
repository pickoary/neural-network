%% creating the test input vector, reading images

dirName= 'Face Database\TestImages';

xtest=zeros(10201,250);

files_jpg= dir( fullfile(dirName,'*.jpg') );

files_jpg= {files_jpg.name}';

for i=1:numel(files_jpg)

% list all *.jpg files

% file names

file_name = fullfile(dirName,files_jpg{i});

%# full path to file

A = imread(file_name);

A=rgb2gray(A);

[m,n] = size(A);

if (m>=101 || n>=101)

A=imresize(A,[101,101]);

end

B = A( : );

data_img{i} = B;

end

for i=1:250

xtest(:,i)=data_img{1,i};

end

%corresponding desired outputs

Des_test=zeros(1,250);

files = dir( fullfile(dirName,'*.att') );

files = {files.name}';

data_t = cell(numel(files),1);

g_t=0; % No of persons with glasses

nog_t=0; % No of persons

without glasses

for i=1:numel(files)

fname = fullfile(dirName,files{i});

% list all *.att files

% file names

% store file contents

% full path to file

data_t{i} = load(fname);

% load file

%--output vector

if data_t{i,1}(3,1)==1

g_t=g_t+1;

Des_test(i)=1.0; %--desired value= one for with glasses

elseif data_t{i,1}(3,1)==0

nog_t=nog_t+1;

Des_test(i)=0; %--desired value= zero for without glasses

end

end