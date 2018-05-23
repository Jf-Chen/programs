function [TypeResult,predictLabel] = predictClass(dataOriginPath,modelPath,leadway,frequency,correctway,extractway,typeA,typeB)
%PREDICTCLASS 处理单个文件，预测其类型
%   此处显示详细说明 ,newaccuracy,typeResultSize
%   dataOriginPath是.mat文件的路径包含E:\icbeb\TrainingSet\A0001.mat，
%   modelPath是分类器路径包含E:\icbeb\programs\MLII\9beats\，



%获取文件，预处理，获得collection，获得oneSignalFeature
%--------------------loadData---------------------------
loadPath=dataOriginPath;
% leadway=2
eval(['load(loadPath);']);% 一定是ECG
% origindata=ECG.data(2,:);
eval(['origindata=ECG.data(',num2str(leadway),',:);']);
%--------------------loadData  end-----------------------------------

%----------------correctBaseline------------------------------
% frequency=500;correctway=1;
correctedData = correctBaseline(correctway,origindata,frequency);
%----------------correctBaseline  end----------------------------

%---------------------getFeature------------------------------------
% extractway=1;
[collection,outputCluster_center2] = getFeature(correctedData,extractway);

% 需要添加try catch
%---------------------getFeature end------------------------------------

%--------------------averageFeature----------------------------------

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

%--------------------averageFeature end----------------------------------


%-----------------------predict-------------------------------------
% 加载所有分类器，得到36个结果，投票决定最少的那种
% 重复多次，直到剩下一个或三个分类器
leftType=[];
possibleType=[];

% typeA=1;
% typeB=2;
tempModelName=['model',num2str(typeA),num2str(typeB)];
tempModelPath=[modelPath,tempModelName];
eval('load(tempModelPath);');
% Te2typeLabel=ones(size(oneSignalFeature,1),1);
Te2typeLabel=[-1];
Te2type=oneSignalFeature;
eval(['[predictLabel,accuracy,dec_values]=svmpredict(Te2typeLabel,Te2type,',tempModelName,')']);
if predictLabel==-1
    TypeResult=typeA;
else
    TypeResult=typeB;
end

%-----------------------predict end-------------------------------------
%  [TypeResult,predictLabel] = predictClass('E:\icbeb\TrainingSet\A0016.mat','E:\icbeb\programs\MLII\9beats\',2,500,1,1,1,2)

end

