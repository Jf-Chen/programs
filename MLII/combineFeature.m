function [Features] = combineFeature(trainSet,leadway,beats)
%COMBINEFEATURE 整合特征，处理averageFeature得到的oneSinglaFeature
%               合成整个训练集的Features
%   此处显示详细说明
%   beats,1--9,选择多少个心跳周期的样本
%   data是输入的经过处理的信号
%


dataPath='E:\icbeb\TrainingSet';
frequency=500;
correctway=1;
extractway=1;
trainSetClumn=size(trainSet,2);
Features=cell(1,trainSetClumn);
for k=1:size(trainSet,2)
    typeSet=trainSet{1,k}; %1xYYY
    tempFeature=cell(1,1);
    for i=1:size(typeSet,2)
        datanum=typeSet(1,i);
        origindata = loadData(dataPath,datanum,leadway);
        correctedData = correctBaseline(correctway,origindata,frequency);
        collection=getFeature(correctedData,extractway);
        oneSignalFeature = averageFeature(beats,collection); %得到1x15的矩阵，假如取RR,SP,RS和五个心跳周期用来观察
        tempFeature{1,1}(end+1,:)=oneSignalFeature; % 需要维度一致
    end
    %此时tempFeature是一个1x1cell,包含size(typeSet,2) x size（oneSingalFeature,2）的矩阵
    % 可以看做是1000x15
    Features{1,k}=tempFeature;
end

%Feature是1x9 cell 包含特征矩阵



end

