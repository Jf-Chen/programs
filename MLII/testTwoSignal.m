% function [outputArg1,outputArg2] = testTwoSignal(inputArg1,inputArg2)
%TESTTWOSIGNAL 此处显示有关此函数的摘要
%   此处显示详细说明

% testnum=2933;
% for datanum=testnum-3:testnum+3
% for datanum=1215:1235
for datanum=1225:1225
% for datanum=1366:1366

% for datanum=1670:1670
% for datanum=1687:1687
% for datanum=1:6877
    fprintf('now datanum=%d ',datanum);
    dataPath='E:\icbeb\TrainingSet';
    leadway=2;extractway=1;
    correctway=1;
    frequency=500;
    [origindata] = loadData(dataPath,datanum,leadway);
%     figure(20);plot(origindata);axis tight;Two
    data = correctBaseline(correctway,origindata,frequency);
    [collection]=getFeature(data,extractway);
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

