function oneSignalFeature = averageFeature(beats,collection)
%AVERAGEFEATUREBYWINDOW2 此处显示有关此函数的摘要
%   此处显示详细说明      适用于添加了窗口
% function oneSignalFeature = averageFeature(beats,collection)
%AVERAGEFEATUREBYWINDOW 名字由averageFeatureByWindow改为averageFeature
%                       用于处理collection,由分段切片改为窗口滑动的方式

%   此处显示详细说明
% function oneSignalFeature = averageFeature(beats,collection)
%COMBINEFEATURE  期望：依据beats得到单个信号单个导联的特征值的均值，如beat=3,
%                就3个信号的RR,SP,RS作为特征，然后取均值
%   此处显示详细说明
%   beats,1--9,选择多少个心跳周期的样本
%   data通过loadData得到
%

%默认值
numofFea=4;%max,min,aver,var，四个值，由窗口内裁定得出
%---------------------------------------------------------------------------
%输出就四个值，max,min,average,var(X,1,2)返回行向量的方差,返回值是列向量
clumnSize=size(collection,2);%这个信号包含多少个周期
% beats=clumnSize; %当有窗口时不需要
rowSize=size(collection,1); %假设有三种特征表征，如RR,SP,RS，那么最后要得到3x4的tempOneSignalFeature
tempClumn=floor(clumnSize-beats+1);% 五个心跳作为窗口,39个心跳就有35组数据
tempOneSignalFeature=zeros(rowSize,numofFea);  %beats而不是tempClumn
for k=1:rowSize
    interval=zeros(tempClumn,numofFea+1);
    for i=1:tempClumn
        X=collection(k,i:i+beats-1);
%         interval(i,1)=max(X,[],2);
%         interval(i,2)=min(X,[],2);
%         interval(i,3)=mean(X,2);
%         interval(i,4)=var((X),1,2);
        interval(i,5)=max(X,[],2)-min(X,[],2);
    end
        %3,4取均值
%         tempOneSignalFeature(k,:)=mean(interval,1); 
        %3,4取极值
%     for j=1:size(interval,1)
        tempOneSignalFeature(k,1)=max(interval(:,5),[],1);
        tempOneSignalFeature(k,2)=min(interval(:,5),[],1);
        tempOneSignalFeature(k,3)=mean(interval(:,5),1);
        tempOneSignalFeature(k,4)=var(interval(:,5),1,1);
%     end
end


%--------------------------有滑动窗口时-----------------------------
%每个窗口输出就四个值,这些都是窗口内的取值max,min,average,var(X,1,2)返回行向量的方差,返回值是列向量
%最终得到的是3x(4x35)的矩阵，
% clumnSize=size(collection,2);%这个信号包含多少个周期
% beats=clumnSize;
% rowSize=size(collection,1); %假设有三种特征表征，如RR,SP,RS，那么最后要得到3x4的tempOneSignalFeature
% tempClumn=floor(clumnSize-beats+1);% 五个心跳作为窗口,39个心跳就有35组数据
% tempOneSignalFeature=zeros(rowSize,numofFea);  %beats而不是tempClumn
% for k=1:rowSize
%     interval=zeros(1,numofFea);
%     for i=1:tempClumn
%         interval(1,1)=max(collection(k,:),[],2);
%         interval(1,2)=min(collection(k,:),[],2);
%         interval(1,3)=mean(collection(k,:),[],2);
%         interval(1,4)=var(collection(k,:),1,2);
%     end
%         tempOneSignalFeature(k,:)=interval; 
% end



%---------------------- ---有滑动窗口时 end------------------------
%此时oneSignalFeature是一个3x(39/5)的矩阵，假如该信号有40个周期，取RR,SP,RS，五个心跳作为整体观察
%最好整合成一维信号
tempOneSignalFeature=tempOneSignalFeature';
oneSignalFeature=tempOneSignalFeature(:);
oneSignalFeature=oneSignalFeature';  %此时oneSignalFeature是1xYYY的矩阵,
%相当于[1 2 3 4 5;6 7 8 9 10;11 12 13 14 15]->[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]


end






