function [TypeResult,predictLabel] = predictClass(dataOriginPath,modelPath,leadway,frequency,correctway,extractway,typeA,typeB)
%PREDICTCLASS ���������ļ���Ԥ��������
%   �˴���ʾ��ϸ˵�� ,newaccuracy,typeResultSize
%   dataOriginPath��.mat�ļ���·������E:\icbeb\TrainingSet\A0001.mat��
%   modelPath�Ƿ�����·������E:\icbeb\programs\MLII\9beats\��



%��ȡ�ļ���Ԥ���������collection�����oneSignalFeature
%--------------------loadData---------------------------
loadPath=dataOriginPath;
% leadway=2
eval(['load(loadPath);']);% һ����ECG
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

% ��Ҫ����try catch
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
% �������з��������õ�36�������ͶƱ�������ٵ�����
% �ظ���Σ�ֱ��ʣ��һ��������������
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
