clc
clear all;
close all;

x = linspace(-pi,pi,400);
trainX = [x; 2*sin(x)]; 

plot(trainX(1,:),trainX(2,:),'+r');


%som实现
%2016-11-12
%by wangbaojia
%  som原理及参数说明
% 1.竞争：匹配最佳神经元---------->计算每个样本和初始神经网络的距离，距离最近神经元作为获胜神经元
%
% 2.合作：在权值更新过程中，不仅获胜神经元的权
%值向量得到更新，而且其近邻神经元的权值向量也按照某个“近邻函数”进行更新。这样在开
%始时移动量很大，权值向量大致地可按它们的最终位置来排序；
%获胜神经元决定兴奋神经元的拓扑邻域的空间位置,从而提供了相邻神经元合作的基础
%   拓扑邻域：规则多边形一般都可以作为邻域形状,常用的主要有正方形或六边形,正方形更为普遍
%
%权重向量的调整就发生在获胜神经元的邻域内。在训练的刚开始阶段,这个邻域比较大,
%随着训练的进行,这个邻域开始不断减小
%
% 3.自适应：权值更新过程
% 算法：
% 1.初始化
%    1)迭代次数：时间步长iter
%    2)输出结点权值向量初始值,向量各元素可选区间(0，1)上的随机值,这里选择正方形邻域
%    3)学习率初始值
%    4)邻域半径的设置应尽量包含较多的邻神经元,整个输出平面的一半
% 2.求竞争获胜神经元;欧拉距离函数求解
% 3.权值更新：
%        获胜节点和邻域范围内神经元集合的m个节点更新权值，j=1:m；    
%            wj(t+1)=wj(t)+learnfun(t)*neighborfun(t)*(x-wj);
% 4.更新学习率，更新邻域函数 
%        neighborfun(t)=neighbor0*exp(-dij/t1);   t1=iter/log(neighbor0)
%         learnfun(t)=learn0*exp(-t/t2);     t2=iter
% 5.当特征映射不再发生明显变化时或达到最大网络训练次数时退出,否则转入第2步

%载入数据，data数据每一行为一个用空格区分的多维数据样本
%样本数据的位置
file_path='/Users/yin/Desktop/Neural Networks/part 1/homework3';
% path=strcat(file_path,'data.txt');
%path=strcat(file_path,'data_path.txt');
% data=load(path);
[data_row,data_clown]=size(trainX(1,:));

%自组织映射网络m*n
m=1;
n=36;
%神经元节点总数som_sum
som_sum=m*n;
%权值初始化，随机初始化
w = rand(som_sum, data_clown);
%初始化学习率
learn0 = 0.6;
learn_rate = learn0;
%学习率参数
learn_para=1000;
%设置迭代次数
iter =600;
%神经元位置
[I,J] = ind2sub([m, n], 1:som_sum);
%邻域初始化 
neighbor0 =2;
neighbor_redius = neighbor0;
%邻域参数
neighbor_para = 1000/log(neighbor0);

%迭代次数
for t=1:iter 
    %  样本点遍历
    for j=1:data_row  
        %获取样本点值
        data_x = trainX(j,:); 
        %找到获胜神经元
        [win_row, win_som_index]=min(dist(data_x,w'));  
        %获胜神经元的拓扑位置
        [win_som_row,win_som_cloumn] =  ind2sub([m, n],win_som_index);
        win_som=[win_som_row,win_som_cloumn];
        %计算其他神经元和获胜神经元的距离,邻域函数
        %distance_som = sum(( ([I( : ), J( : )] - repmat(win_som, som_sum,1)) .^2) ,2);
        distance_som = exp( sum(( ([I(:), J(:)] - repmat(win_som, som_sum,1)) .^2) ,2)/(-2*neighbor_redius*neighbor_redius)) ;
        %权值更新
        for i = 1:som_sum
           % if distance_som(i)<neighbor_redius*neighbor_redius 
            w(i,:) = w(i,:) + learn_rate.*distance_som(i).*( data_x - w(i,:));
        end
    end

    %更新学习率
    learn_rate = learn0 * exp(-t/learn_para);   
    %更新邻域半径
    neighbor_redius = neighbor0*exp(-t/neighbor_para);  
end
%data数据在神经元的映射
%神经元数组som_num存储图像编号
som_num=cell(1,size(w,1));
for i=1:size(w,1)
    som_num{1,i}=[];
end
%每个神经元节点对应的data样本编号
for num=1:data_row
    [som_row,clown]= min(sum(( (w - repmat(trainX(num,:), som_sum,1)) .^2) ,2));
    som_num{1,clown}= [som_num{1,clown},num];    
end

%存储神经元数组，.mat格式
path1=strcat(file_path,'som_num.mat');
save(path1,'som_num');

