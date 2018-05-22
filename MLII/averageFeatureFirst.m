function oneSignalFeature = averageFeatureByWindow(beats,collection)
%COMBINEFEATURE  期望：依据beats得到单个信号单个导联的特征值的均值，如beat=3,
%                就3个信号的RR,SP,RS作为特征，然后取均值
%   此处显示详细说明
%   beats,1--9,选择多少个心跳周期的样本
%   data通过loadData得到
%



%
clumnSize=size(collection,2);%这个信号包含多少个周期
rowSize=size(collection,1); %三种特征表征，如RR,SP,RS
tempClumn=floor(clumnSize/beats);% 五个心跳作为整体重复的次数
tempOneSignalFeature=zeros(rowSize,beats);  %beats而不是tempClumn
for k=1:rowSize
    interval=zeros(1,beats);
    
    for j=1:beats
        for i=1:tempClumn
            interval(1,j)=interval(1,j)+collection(k,(i-1)*beats+j);
        end
        tempOneSignalFeature(k,j)=interval(1,j)/tempClumn;
    end
    
%     for i=0:tempClumn-1
%         for j=1:beats
%             interval(1,j)=interval(1,j)+collection(k,i*beats+j); 
%         end  %此时interval是1x5的矩阵
%         tempOneSignalFeature(k,j)=sum(interval,2)/tempClumn;
%     end
    
    
end

%此时oneSignalFeature是一个3x(39/5)的矩阵，假如该信号有40个周期，取RR,SP,RS，五个心跳作为整体观察
%最好整合成一维信号
tempOneSignalFeature=tempOneSignalFeature';
oneSignalFeature=tempOneSignalFeature(:);
oneSignalFeature=oneSignalFeature';  %此时oneSignalFeature是1xYYY的矩阵,
%相当于[1 2 3 4 5;6 7 8 9 10;11 12 13 14 15]->[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]


end

