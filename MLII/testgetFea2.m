%% 示例标题
% 示例目标摘要

%% 节 1 标题
% first 代码块说明

%% 节 2 标题
% second 代码块说明

for newk=1:20
    datanum=2513;
    fprintf('now datanum=%d ',datanum);
    dataPath='E:\icbeb\TrainingSet';
    leadway=2;extractway=1;
    correctway=1;
    frequency=500;
    [origindata] = loadData(dataPath,datanum,leadway);
    data = correctBaseline(correctway,origindata,frequency);
    try
        [collection,outputCluster_center2]=getFeature(data,extractway);
    catch 
        k=k-1;
        continue;
    end
    if(size(collection,1)==0 || size(collection,2)<5)
        beReplacedFile{1,1}(end+1)=datanum;
        fprintf('  文件%d被替换了  ',datanum);
        clear collection origindata correctedData;
        datanum=replaceFile(1,1);
        origindata = loadData(dataPath,datanum,leadway);
        correctedData = correctBaseline(correctway,origindata,frequency);
        collection=getFeature(correctedData,extractway);
    end
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
    