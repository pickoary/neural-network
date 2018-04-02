% 3个径向基网络的matlab源程序 
% 
% 一维输入，一维输出，逼近效果很好！
% 
% 1.基于聚类的RBF 网设计算法
SamNum = 100; % 总样本数
TestSamNum = 101; % 测试样本数
InDim = 1; % 样本输入维数
ClusterNum = 10; % 隐节点数，即聚类样本数
Overlap = 1.0; % 隐节点重叠系数

% 根据目标函数获得样本输入输出
rand('state',sum(100*clock))
NoiseVar = 0.1;
Noise = NoiseVar*randn(1,SamNum);
SamIn = 8*rand(1,SamNum)-4;
SamOutNoNoise = 1.1*(1-SamIn+2*SamIn.^2).*exp(-SamIn.^2/2);
SamOut = SamOutNoNoise + Noise;

TestSamIn = -4:0.08:4;
TestSamOut = 1.1*(1-TestSamIn+2*TestSamIn.^2).*exp(-TestSamIn.^2/2);

figure
hold on
grid
plot(SamIn,SamOut,'k+')
plot(TestSamIn,TestSamOut,'k--')
xlabel('Input x');
ylabel('Output y');

Centers = SamIn(:,1:ClusterNum);

NumberInClusters = zeros(ClusterNum,1); % 各类中的样本数，初始化为零
IndexInClusters = zeros(ClusterNum,SamNum); % 各类所含样本的索引号
while 1,
NumberInClusters = zeros(ClusterNum,1); % 各类中的样本数，初始化为零
IndexInClusters = zeros(ClusterNum,SamNum); % 各类所含样本的索引号

% 按最小距离原则对所有样本进行分类
for i = 1:SamNum
AllDistance = dist(Centers',SamIn(:,i));
[MinDist,Pos] = min(AllDistance);
NumberInClusters(Pos) = NumberInClusters(Pos) + 1;
IndexInClusters(Pos,NumberInClusters(Pos)) = i;
end
% 保存旧的聚类中心
OldCenters = Centers;

for i = 1:ClusterNum
Index = IndexInClusters(i,1:NumberInClusters(i));
Centers(:,i) = mean(SamIn(:,Index)')';
end
% 判断新旧聚类中心是否一致，是则结束聚类
EqualNum = sum(sum(Centers==OldCenters));
if EqualNum == InDim*ClusterNum,
break,
end
end

% 计算各隐节点的扩展常数（宽度）
AllDistances = dist(Centers',Centers); % 计算隐节点数据中心间的距离（矩阵）
Maximum = max(max(AllDistances)); % 找出其中最大的一个距离
for i = 1:ClusterNum % 将对角线上的0 替换为较大的值
AllDistances(i,i) = Maximum+1;
end
Spreads = Overlap*min(AllDistances)'; % 以隐节点间的最小距离作为扩展常数

% 计算各隐节点的输出权值
Distance = dist(Centers',SamIn); % 计算各样本输入离各数据中心的距离
SpreadsMat = repmat(Spreads,1,SamNum);
HiddenUnitOut = radbas(Distance./SpreadsMat); % 计算隐节点输出阵
HiddenUnitOutEx = [HiddenUnitOut' ones(SamNum,1)]'; % 考虑偏移
W2Ex = SamOut*pinv(HiddenUnitOutEx); % 求广义输出权值
W2 = W2Ex(:,1:ClusterNum); % 输出权值
B2 = W2Ex(:,ClusterNum+1); % 偏移

% 测试
TestDistance = dist(Centers',TestSamIn);
TestSpreadsMat = repmat(Spreads,1,TestSamNum);
TestHiddenUnitOut = radbas(TestDistance./TestSpreadsMat);
TestNNOut = W2*TestHiddenUnitOut+B2;
plot(TestSamIn,TestNNOut,'k-')
W2
B2

2.基于梯度法的RBF 网设计算法

SamNum = 100; % 训练样本数
TargetSamNum = 101; % 测试样本数
InDim = 1; % 样本输入维数
UnitNum = 10; % 隐节点数
MaxEpoch = 5000; % 最大训练次数
E0 = 0.9; % 目标误差
% 根据目标函数获得样本输入输出
rand('state',sum(100*clock))
NoiseVar = 0.1;
Noise = NoiseVar*randn(1,SamNum);
SamIn = 8*rand(1,SamNum)-4;
SamOutNoNoise = 1.1*(1-SamIn+2*SamIn.^2).*exp(-SamIn.^2/2);
SamOut = SamOutNoNoise + Noise;
TargetIn = -4:0.08:4;
TargetOut = 1.1*(1-TargetIn+2*TargetIn.^2).*exp(-TargetIn.^2/2);
figure
hold on
grid
plot(SamIn,SamOut,'k+')
plot(TargetIn,TargetOut,'k--')
xlabel('Input x');
ylabel('Output y');
Center = 8*rand(InDim,UnitNum)-4;
SP = 0.2*rand(1,UnitNum)+0.1;
W = 0.2*rand(1,UnitNum)-0.1;
lrCent = 0.001; % 隐节点数据中心学习系数
lrSP = 0.001; % 隐节点扩展常数学习系数
lrW = 0.001; % 隐节点输出权值学习系数
ErrHistory = []; % 用于记录每次参数调整后的训练误差
for epoch = 1:MaxEpoch
AllDist = dist(Center',SamIn);
SPMat = repmat(SP',1,SamNum);
UnitOut = radbas(AllDist./SPMat);
NetOut = W*UnitOut;
Error = SamOut-NetOut;
%停止学习判断
SSE = sumsqr(Error)
% 记录每次权值调整后的训练误差
ErrHistory = [ErrHistory SSE];
if SSE<E0, break, end
for i = 1:UnitNum
CentGrad = (SamIn-repmat(Center(:,i),1,SamNum))...
*(Error.*UnitOut(i,*W(i)/(SP(i)^2))';
SPGrad = AllDist(i,.^2*(Error.*UnitOut(i,*W(i)/(SP(i)^3))';
WGrad = Error*UnitOut(i,';
Center(:,i) = Center(:,i) + lrCent*CentGrad;
SP(i) = SP(i) + lrSP*SPGrad;
W(i) = W(i) + lrW*WGrad;
end
end
% 测试
TestDistance = dist(Center',TargetIn);
TestSpreadsMat = repmat(SP',1,TargetSamNum);
TestHiddenUnitOut = radbas(TestDistance./TestSpreadsMat);
TestNNOut = W*TestHiddenUnitOut;
plot(TargetIn,TestNNOut,'k-')
% 绘制学习误差曲线
figure
hold on
grid
[xx,Num] = size(ErrHistory);
plot(1:Num,ErrHistory,'k-');

3.基于OLS 的RBF 网设计算法
SamNum = 100; % 训练样本数
TestSamNum = 101; % 测试样本数
SP = 0.6; % 隐节点扩展常数
ErrorLimit = 0.9; % 目标误差
% 根据目标函数获得样本输入输出
rand('state',sum(100*clock))
NoiseVar = 0.1;
Noise = NoiseVar*randn(1,SamNum);
SamIn = 8*rand(1,SamNum)-4;
SamOutNoNoise = 1.1*(1-SamIn+2*SamIn.^2).*exp(-SamIn.^2/2);
SamOut = SamOutNoNoise + Noise;
TestSamIn = -4:0.08:4;
TestSamOut = 1.1*(1-TestSamIn+2*TestSamIn.^2).*exp(-TestSamIn.^2/2);
figure
hold on
grid
plot(SamIn,SamOut,'k+')
plot(TestSamIn,TestSamOut,'k--')
xlabel('Input x');
ylabel('Output y');
[InDim,MaxUnitNum] = size(SamIn); % 样本输入维数和最大允许隐节点数
% 计算隐节点输出阵
Distance = dist(SamIn',SamIn);
HiddenUnitOut = radbas(Distance/SP);
PosSelected = [];
VectorsSelected = [];
HiddenUnitOutSelected = [];
ErrHistory = []; % 用于记录每次增加隐节点后的训练误差
VectorsSelectFrom = HiddenUnitOut;
dd = sum((SamOut.*SamOut)')';
for k = 1 : MaxUnitNum
% 计算各隐节点输出矢量与目标输出矢量的夹角平方值
PP = sum(VectorsSelectFrom.*VectorsSelectFrom)';
Denominator = dd * PP';
[xxx,SelectedNum] = size(PosSelected);
if SelectedNum>0,
[lin,xxx] = size(Denominator);
Denominator(:,PosSelected) = ones(lin,1);
end
Angle = ((SamOut*VectorsSelectFrom) .^ 2) ./ Denominator;
% 选择具有最大投影的矢量，得到相应的数据中心
[value,pos] = max(Angle);
PosSelected = [PosSelected pos];
% 计算RBF 网训练误差
HiddenUnitOutSelected = [HiddenUnitOutSelected; HiddenUnitOut(pos,];
HiddenUnitOutEx = [HiddenUnitOutSelected; ones(1,SamNum)];
W2Ex = SamOut*pinv(HiddenUnitOutEx); % 用广义逆求广义输出权值
W2 = W2Ex(:,1:k); % 得到输出权值
B2 = W2Ex(:,k+1); % 得到偏移
NNOut = W2*HiddenUnitOutSelected+B2; % 计算RBF 网输出
SSE = sumsqr(SamOut-NNOut)
% 记录每次增加隐节点后的训练误差
ErrHistory = [ErrHistory SSE];
if SSE < ErrorLimit, break, end
% 作Gram-Schmidt 正交化
NewVector = VectorsSelectFrom(:,pos);
ProjectionLen = NewVector' * VectorsSelectFrom / (NewVector'*NewVector);
VectorsSelectFrom = VectorsSelectFrom - NewVector * ProjectionLen;
end
UnitCenters = SamIn(PosSelected);%%%%%%%%%%%
% 测试
TestDistance = dist(UnitCenters',TestSamIn);%%%%%%%%
TestHiddenUnitOut = radbas(TestDistance/SP);
TestNNOut = W2*TestHiddenUnitOut+B2;
plot(TestSamIn,TestNNOut,'k-')
k
UnitCenters
W2
B2 
