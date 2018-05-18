% function [outputArg1,outputArg2] = testTwoSignal(inputArg1,inputArg2)
%TESTTWOSIGNAL 此处显示有关此函数的摘要
%   此处显示详细说明
replaceFile=[2,3,39,11,1,47,5,8,21];
beReplacedFile=cell(1,9); % 按类型排列 存放被替换的文件


% testnum=2933;
% for datanum=testnum-3:testnum+3
% for datanum=1215:1235
observe=0;
% for datanum=6673:6673
% for datanum=1225:1225
% for datanum=1366:1366

% for datanum=1670:1670
% for datanum=1687:1687
% for newk=1:20
% for datanum=2513:2513
for datanum=1:6877
    fprintf('now datanum=%d ',datanum);
    dataPath='E:\icbeb\TrainingSet';
    leadway=2;extractway=1;
    correctway=1;
    frequency=500;
    [origindata] = loadData(dataPath,datanum,leadway);
%     figure(20);plot(origindata);axis tight;Two
    data = correctBaseline(correctway,origindata,frequency);
    try
    [collection,outputCluster_center2]=getFeature(data,extractway);
    catch 
        datanum=datanum-1;
        continue;
    end
        if(size(collection,1)==0 || size(collection,2)<5)
            %可以将这一部分的程序打包，提供给try catch 使用
            beReplacedFile{1,1}(end+1)=datanum;
            fprintf('  文件%d被替换了  ',datanum);
            clear collection origindata correctedData;
            datanum=replaceFile(1,1);
            origindata = loadData(dataPath,datanum,leadway);
            correctedData = correctBaseline(correctway,origindata,frequency);
            collection=getFeature(correctedData,extractway);
        end
    
    observe=outputCluster_center2;
    
    oneSignalFeature = averageFeature(5,collection);
    %[collection,oneSignalFeature]=newTestGetFeature(datanum);
    collectionRow=size(collection,1);
    collectionClumn=size(collection,2);
    oneSignalFeatureRow=size(oneSignalFeature,1);
    oneSignalFeatureClumn=size(oneSignalFeature,2);
    fprintf('collection size %d x %d ',size(collection,1),size(collection,2));
    fprintf('oneSignalFeature size %d x %d \n',size(oneSignalFeature,1),size(oneSignalFeature,2));
    if collectionRow==0||collectionClumn==0||oneSignalFeatureRow==0||oneSignalFeatureClumn==0
        error(' ! ');
    end
    
end


% end

