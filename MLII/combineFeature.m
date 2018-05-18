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
%替换文件，类型1-类型9
replaceFile=[2,3,39,11,1,47,5,8,21];
beReplacedFile=cell(1,9); % 按类型排列 存放被替换的文件

for k=1:size(trainSet,2)    %------------观察一下其他类型的
    typeSet=trainSet{1,k}; %1xYYY
    tempFeature=cell(1,1);
    for i=1:size(typeSet,2) 
%         fprintf('trainSet locate at %d ',k);
        datanum=typeSet(1,i);
        origindata = loadData(dataPath,datanum,leadway);
        correctedData = correctBaseline(correctway,origindata,frequency);
        %控制台打印所执行的文件
        fprintf('当前文件 %d',datanum)
        collection=getFeature(correctedData,extractway);
        %校验维数是否有0出现
        if(size(collection,1)==0 || size(collection,2)<5)
            beReplacedFile{1,k}(end+1)=typeSet(1,i);
            fprintf('  文件%d被替换了  ',typeSet(1,i));
            clear collection origindata correctedData;
            datanum=replaceFile(1,k);
            origindata = loadData(dataPath,datanum,leadway);
            correctedData = correctBaseline(correctway,origindata,frequency);
            collection=getFeature(correctedData,extractway);
        end
        fprintf('collection=%d x %d',size(collection,1),size(collection,2));
        oneSignalFeature = averageFeature(beats,collection); %得到1x15的矩阵，假如取RR,SP,RS和五个心跳周期用来观察
        fprintf(' oneSignalFea=% dx %d',size(oneSignalFeature,1),size(oneSignalFeature,2));
        tempFeature{1,1}(end+1,:)=oneSignalFeature; % 需要维度一致
        fprintf(' tempFea=%d x %d\n',size(tempFeature{1,1},1),size(tempFeature{1,1},2));
    end
    %此时tempFeature是一个1x1cell,包含size(typeSet,2) x size（oneSingalFeature,2）的矩阵
    % 可以看做是1000x15
    Features{1,k}=tempFeature;
end

%Feature是1x9 cell 包含特征矩阵



end

