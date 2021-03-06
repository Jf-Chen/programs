function [Features,beReplacedFile] = combineFeature(trainSet,leadway,beats)
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
replaceFile=[2,3,39,11,43,47,5,8,21];
beReplacedFile=cell(1,9); % 按类型排列 存放被替换的文件
loopFlag=5;
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
        try
            collection=getFeature(correctedData,extractway);
        catch
            if loopFlag<5
                i=i-1; %为了防止出现无限循环，加入一个标记，当这个循环出现多次后不再进行循环
                loopFlag=loopFlag+1;
                continue;
            else
                collection=[];
            end
        end
        %校验维数是否有0出现
%         if(size(collection,1)==0 || size(collection,2)<(beats+1))
        if(size(collection,1)==0 || size(collection,2)<(beats))  %原来的程序就长这样
            beReplacedFile{1,k}(end+1)=typeSet(1,i);
            fprintf('  文件%d被替换了  ',typeSet(1,i));
            clear collection origindata correctedData;
            datanum=replaceFile(1,k);
            origindata = loadData(dataPath,datanum,leadway);
            correctedData = correctBaseline(correctway,origindata,frequency);
            collection=getFeature(correctedData,extractway);
        end
        fprintf('collection=%d x %d',size(collection,1),size(collection,2));
%         oneSignalFeature = averageFeature(beats,collection); %得到1x15的矩阵，假如取RR,SP,RS和五个心跳周期用来观察
        
        %---------------------------------------------------------------------
        %在此处添加多窗口到同一特征
        oneSignalFeature1 = averageFeature(1,collection);
        oneSignalFeature2 = averageFeature(2,collection);
        oneSignalFeature3 = averageFeature(3,collection);
        oneSignalFeature4 = averageFeature(4,collection);
        oneSignalFeature5 = averageFeature(5,collection);
        oneSignalFeature6 = averageFeature(6,collection);
        oneSignalFeature7 = averageFeature(7,collection);
        oneSignalFeature8 = averageFeature(8,collection);
%         oneSignalFeature9 = averageFeature(9,collection);
        oneSignalFeature=[oneSignalFeature1,oneSignalFeature2,oneSignalFeature3,oneSignalFeature4,...
            oneSignalFeature5,oneSignalFeature6,oneSignalFeature7,oneSignalFeature8];
%             oneSignalFeature9];
        %--------------------------------------------------------------------
        
        fprintf(' oneSignalFea=% dx %d',size(oneSignalFeature,1),size(oneSignalFeature,2));
        tempFeature{1,1}(end+1,:)=oneSignalFeature; % 需要维度一致
        fprintf(' tempFea=%d x %d\n',size(tempFeature{1,1},1),size(tempFeature{1,1},2));
        loopFlag=0;
    end
    %此时tempFeature是一个1x1cell,包含size(typeSet,2) x size（oneSingalFeature,2）的矩阵
    % 可以看做是1000x15
    Features{1,k}=tempFeature;
end

beReplacedFileFileName=['E:\icbeb\programs\MLII\',num2str(beats),'beats\beReplacedFile',num2str(beats),'beats.mat'];
beReplacedFileName='beReplacedFile';
eval('save(beReplacedFileFileName,beReplacedFileName);');
%Feature是1x9 cell 包含特征矩阵



end

