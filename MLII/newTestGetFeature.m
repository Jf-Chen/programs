%% 示例标题
% 示例目标摘要

%% 节 1 标题
% first 代码块说明


%% 节 2 标题
% second 代码块说明


% function [collection,oneSignalFeature]=newTestGetFeature(datanum)




% function   [collection]=getFeature(data,extractway)
%GETFEATURE 此处显示有关此函数的摘要
%   collection在extractway==1时是3xYY的矩阵，代表三种间隔
%   RR是RR间隔 1xYY,SP是P波峰和S波谷间隔,RS是R波峰S波谷间隔
%   leadway参数范围是1-12，代表12种导联方式，这里以MLII为示例
%   inputPath是输入路径，末尾包含'\',outputPath同理
%   data是经过correctBaseline的数据，代表一个信号的一个导联,data格式必须是1xYYYY
%   extractway是提取方式,如1是提取三个特征



%   默认值
extractway=1;
% load data0001.mat;
%  data=correctBaseline(2,data,500);
dataPath='E:\icbeb\TrainingSet';
% datanum=3261;
% datanum=6671;
% datanum=1668;
% datanum=3861;
% datanum=5223;
% datanum=565;
% datanum=2860;
% datanum=4765;
% datanum=6671;
% datanum=6485;
% datanum=1372;
% datanum=2933;
% datanum=11;

% datanum=2933 ;
% datanum=679;
% datanum=1670;
datanum=46;

leadway=2;
correctway=1;
frequency=500;


[origindata] = loadData(dataPath,datanum,leadway);
% figure(20);plot(origindata);axis tight;
data = correctBaseline(correctway,origindata,frequency);

%GETFEATURE 此处显示有关此函数的摘要
%   collection在extractway==1时是3xYY的矩阵，代表三种间隔
%   RR是RR间隔 1xYY,SP是P波峰和S波谷间隔,RS是R波峰S波谷间隔
%   leadway参数范围是1-12，代表12种导联方式，这里以MLII为示例
%   inputPath是输入路径，末尾包含'\',outputPath同理
%   data是经过correctBaseline的数据，代表一个信号的一个导联,data格式必须是1xYYYY
%   extractway是提取方式,如1是提取三个特征



%   默认值
% extractway=1;
% load data0001.mat;
%  data=correctBaseline(2,data,500);



%-----------------------------------------------------------------
figure(1);plot(data);axis tight;
%-------------------------------------------------------------------



% figure(6);plot(data);axis tight;

slope=[];%斜率，期望得到1xYYYY-1
derivative=[];%斜率的导数，期望得到1xYYYY-2
%---------------定位R波峰模块start----------------------------------
dataLength=size(data,2);

%计算除开最后一点的斜率
for i=1:dataLength-1
    slope(end+1)=data(1,i+1)-data(1,i);
end

%figure(7);plot(abs(slope));axis tight;title('abs slope');
% figure(8);plot((slope));axis tight;title('slope');

for i=1:dataLength-2
    derivative(end+1)=slope(1,i+1)-slope(1,i);%derivative是除开第一点和最后一点的所有点的斜率的导数
end

%二分聚类

derivative=derivative';
opts = statset('Display','final');
% [IDX_derivative,cluster_center2]=kmeans(derivative,2,'emptyaction','drop');
[IDX_derivative,cluster_center2]=kmeans(derivative,2,'emptyaction','drop','Replicates',5,'Options',opts,'Start','sample');%导数毫无意义
%输出观察一下
outputCluster_center2=cluster_center2;
IDX_derivative=IDX_derivative';
IDX_derivative=IDX_derivative-1;%IDX是1和0,大小为1xYYYY-2


% figure(2);subplot(2,1,2);%  画图发现IDX大部分是0
% plot(IDX_derivative);axis tight;legend('derivative');


absslope=abs(slope);
absslope=absslope';
slope=slope';

[IDX_slope1,cluster_center1]=kmeans(absslope,2,'emptyaction','drop');

% data=data';
% [IDX_slope1,cluster_center1]=kmeans(data,2,'emptyaction','drop');
% data=data';
IDX_slope1=IDX_slope1';
IDX_slope1=IDX_slope1-1;



%-----------------------------------------------------------------
% figure(2);plot(IDX_slope1);axis tight;legend('slope');
%----------------------------------------------------------------------




bound=0;
if sum(IDX_derivative)<size(IDX_derivative,2)
    bound=1;%bound是R波峰所在类
end
Rsharp=[];%Rwave,1xYYY,记录R波峰所在是第几个点，如Rwave(1,1)=30,对应data的第31个点

%利用斜率定位R波比较靠谱

%---------------定位R波峰模块end-------------------------------
%用学长的方法
bound=0;
if sum(IDX_slope1)<size(IDX_slope1,2)/2
    bound=1;
end;
flag=[];
siz=size(IDX_slope1,2)-1;
i=1;
a=0; % 记录连续的‘0’个数（bound==0）
b=0; % 记录连续的‘1’个数（bound==0）
for k=2:siz-1
    if IDX_slope1(k)==bound
        if IDX_slope1(k-1)==1-bound && IDX_slope1(k+1)==bound
            flag(i,1)=1;
            flag(i,2)=k;
            if i>2
                flag(i-1,3)=b;
                b=0;
                flag(i-2,3)=a;
                a=0;
            end;
            i=i+1;
        else
            if IDX_slope1(k-1)==bound && IDX_slope1(k+1)==1-bound
                flag(i,1)=-1;
                flag(i,2)=k;
                i=i+1;
            end;
        end;
        a=a+1;
    end;
    if i>2 && IDX_slope1(k)==1-bound  
        b=b+1;
    end;
end;


%---------------------第一次计算-------------------------------------
f=flag(1,1);
loc=flag(1,2);
Rl_border=[];Rr_border=[];
cycle=500;%如何确定一个心跳周期的长度？
for k=1:size(flag,1)
    if(flag(k,2)-loc>cycle*9/24)
        Rl_border(end+1)=loc;
        Rr_border(end+1)=flag(k-1,2);
        loc=flag(k,2);
    end;
end;
Rl_border(end+1)=loc;
Rr_border(end+1)=flag(k,2);
% figure(1);hold on;plot(Rl_border,data(Rl_border),'rx');plot(Rr_border,data(Rr_border),'rs');
%观察图像可知大致对上了，但是在1800点之前略有偏差
R_peak=[];maxR=0;maxloc=0;
for k=1:size(Rl_border,2)
    maxR=-1;maxloc=Rl_border(1,1);
    for i=Rl_border(1,k):Rr_border(1,k)
        if data(1,i)>maxR
            maxR=data(1,i);
            maxloc=i;
        end
    end
     R_peak(end+1)=maxloc;%R_peak 1x40
end
sumR_peakData=0;
for k=1:size(R_peak,2)
    sumR_peakData=sumR_peakData+data(R_peak(1,k));
end
averageR_hight=sumR_peakData/size(R_peak,2);%检测出的R波的均值，方便第二次检测引入R波振幅大的特征
fprintf('sumR_peakData %f size(R_peak,2) %d ',sumR_peakData,size(R_peak,2));
%-----------------------第一次计算 end------------------------------------



%----------------------计算平均周期后再计算一次------------------------------
sumRR=0;averageRR=0;
for k=2:size(R_peak,2) %计算平均RR间隔作为周期
    sumRR=sumRR+R_peak(k)-R_peak(k-1);
end
tempRinterval=size(R_peak,2);
fprintf('R_peak= %d ',tempRinterval);
if size(R_peak,2)<1
    temp=1;
end
averageRR=sumRR/tempRinterval;
f=flag(1,1);
loc=flag(1,2);
Rl_border=[];Rr_border=[];
cycle=500;%如何确定一个心跳周期的长度？
for k=1:size(flag,1)
    if(flag(k,2)-loc>2/3*averageRR)  %-------------------此处值得商榷-------------
        Rl_border(end+1)=loc;
        Rr_border(end+1)=flag(k-1,2);
        loc=flag(k,2);
    end;
end;
Rl_border(end+1)=loc;
Rr_border(end+1)=flag(k,2);
% figure(1);hold on;plot(Rl_border,data(Rl_border),'rx');plot(Rr_border,data(Rr_border),'rs');
%观察图像可知大致对上了，但是在1800点之前略有偏差
clear R_peak;
R_peak=[];maxR=0;maxloc=0;
for k=1:size(Rl_border,2)
    maxR=averageR_hight*5/6;%maxloc=Rl_border(1,1); %---------------平均“R波”振幅-----------可能误伤正常波形
    maxloc=0;
    for i=Rl_border(1,k):Rr_border(1,k)
        if data(1,i)>maxR
            maxR=data(1,i);
            maxloc=i;
        end
    end
    if maxloc ~= 0
         R_peak(end+1)=maxloc;%R_peak 1x40
    end
    
end

%----------------------计算平均周期后再计算一次 end--------------------------

%引入averageR_hight后Rl_border和Rr_border也需要重新计算吗？似乎不必


%----------------------------------------------------------------------------
figure(1);hold on;plot(R_peak,data(R_peak),'ro');
%----------------------------------------------------------------------------



%-----------检测P和S----------------------------
%目前来看R波边界不会把S波包含进去，可以使用自R波峰向前向后搜索波谷（斜率一正一负的点）
%前提是去噪算法足够好，没有毛刺
%去除斜率图中的毛刺
%因为Q波不容易验证，所以使用P波峰和S波谷，使用P_peak,S_trough表示
% P波峰：R波峰之前，斜率又正转负，验证5个点的斜率都是正然后之后5个点的斜率都是负，选取最高点
% R波峰之前5/12周期的所有斜率一正一负的点取最大的那个，这时候可以算RR间期了
newslope=correctBaseline(1,slope,500);
% figure(9);plot(newslope);axis tight;title('corrected slope')
sumRR=0;averageRR=0;
for k=2:size(R_peak,2) %计算平均RR间隔作为周期
    sumRR=sumRR+R_peak(k)-R_peak(k-1);
end
tempRinterval=size(R_peak,2);
fprintf('R_peak= %d ',tempRinterval);
if size(R_peak,2)<1
    temp=1;
end
averageRR=sumRR/tempRinterval;
%寻找P_peak
tempR=0;startP=0;maxPdata=0;maxPi=0;
P_peak=[];% 记录P波峰
for i=1:size(R_peak,2)
    tempR=R_peak(1,i);
    endP=tempR-averageRR/12;
    endP=round(endP);
    endP=max(endP,1);
    startP=max(tempR-averageRR/3,0);%防止R波峰前1/3周期超出0，同样，后面要考虑超出data最末尾
    startP=round(startP);
    endP=max(endP,startP+2);
    %----------------报错后添加一行
    %endP=max(tempR-averageRR/12,startP+2);
    %-------------------------
    maxPdata=0;maxPi=startP+2;
    
%     if((k-1)<=0 || k>size(slope,2))
%         error(['定位R出错，检查k和当前文件 k=',num2str(k)...
%             ,'  averageRR/12=',num2str(averageRR/12)...
%             ,'  startP=',num2str(startP)...
%              ,'  endP=',num2str(endP)...
%             ,'  sizeof slope=',num2str(size(slope,1))]);
%         
%     end
    %for k=startP+2:tempR-averageRR/12 %报错后换成下面的
    for k=startP+2:endP
        if slope(k-1)>=0&&slope(k)<=0
            if maxPdata<data(k)
                maxPi=k;
                maxPdata=data(k);
            end
        end
    end
    P_peak(end+1)=maxPi;
end
 %查看结果  
 
 
 
 
%----------------------------------------------------------------------------
 figure(1);hold on;plot(P_peak,data(P_peak),'rx'); %基本准确，受到去噪效果的影响
%----------------------------------------------------------------------------
 
 
 
 
 
 %寻找S波
 tempR=0;endS=0;minSdata=0;minSi=0;
 S_trough=[];
 for i=1:size(R_peak,2)
     tempR=R_peak(1,i);
     endS=min(tempR+averageRR/2,size(data,2));% S波结束段大约在一半之内，为了避免病变情况，取完整的RR间期内的最小值
     minSdata=0;minSi=endS;
     for k=tempR:endS
         if minSdata>data(k)
             minSdata=data(k);
             minSi=k;
         end
     end
     S_trough(end+1)=minSi;
 end
 
 
 
%---------------------------------------------------
figure(1);hold on;plot(S_trough,data(S_trough),'r^');  %基本准确
%------------------------------------------------------------------------
  
  
  
%-----------检测P和S end-----------------
collection=[];RR=[];SP=[];RS=[];
switch extractway
    case 1
        
        
        %与之前的不同，猜测信号的首尾部分一定存在R波而不一定存在P,S波,
        %以两个R波峰之间为一个周期进行统计，
        %PS是一个RR间隔内的距离，RS是S波与靠前的R波峰之间的距离
        for k=1:size(R_peak,2)-1
            RR(end+1)=R_peak(k+1)-R_peak(k);
            SP(end+1)=P_peak(k+1)-S_trough(k);
            RS(end+1)=S_trough(k+1)-R_peak(k);
            collection=[RR;SP;RS];%这一语句不出错的前提是RR,SP,RS的列数一致
        end

end

%然后做什么来着,多个一组进行简单的分类器训练


% clear data;
% clear dataLength derivative IDX_derivative;
% clear absslope data slope;
% clear IDX_slope Rl_border Rrborder;
% clear R_peak maxR maxloc;
% clear newslope tempRinterval averageRR;
% clear sumRR P_peak tempR;
% clear startP maxPdata maxPi;
% clear endS minSdata minSi;
% clear S_trough RR SP;
% clear RS extractway;
% 
% 




 beats=5;
 oneSignalFeature = averageFeature(beats,collection);
%然后做什么来着,多个一组进行简单的分类器训练



% end
% end
