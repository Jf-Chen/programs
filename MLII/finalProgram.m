function  finalProgram(leadway,dataPath,beats)
%FINALPROGRAM �ú���ÿ��ֻ����һ���洢�ļ����źţ���A0001.mat���ó�һ��������������ΪResult0001.mat��
%���Ⱦ���correctBaselineȥ�룬֮�󾭹�getFeature�õ�������RR,QR,QS��
%
%   leadway������Χ��1-12������12�ֵ�����ʽ��������MLIIΪʾ��
%   dataPath���ļ��У������foldernum���������ļ���·����ĩβ������'\',
%  
%   

%����ʱĬ��ֵ

leadway=2;
frequency=500;
dataPath='E:\icbeb\TrainingSet';
inputPath=[dataPath];
csvPath='E:\icbeb\REFERENCE.csv';
share=11; %ÿ��ȡ1/11��Ϊ���Լ���10/11��Ϊѵ���������Ҫ���н�����֤��10�۽�����֤




%��ȡĿ¼�������ļ�,ȡ��fileNames��С
fileFolder=fullfile(inputPath);
dirOutput=dir(fullfile(fileFolder,'*.mat'));
fileNames={dirOutput.name}';% fileNames��2000x1cell������ΪA0001.mat�ȵ�,������char()ת��
filename=char(fileNames(1,1));
allFileNum=size(fileNames,1);

%---------------����ר��ע��---------------
%ÿ��ȡ1/11��Ϊ���Լ���10/11��Ϊѵ���������Ҫ���н�����֤��10�۽�����֤
[annotation,testSet,trainSet] = newSeparate(csvPath,share); %���е�ע�ͣ����Լ���ѵ����
TeSetName=['E:\icbeb\programs\MLII\',num2str(beats),'beats\TeSets.mat',];
TrSetName=['E:\icbeb\programs\MLII\',num2str(beats),'beats\TrSets.mat',];
testSetName='testSet';
trainSetName='trainSet';
eval('save(TeSetName,testSetName);');
eval('save(TrSetName,trainSetName);');
%---------------����ר��ע��end------------------

%---------------����10�۽�����֤--------------------------------------
%����֤�ˣ�д��oneclassifer��
%---------------����10�۽�����֤ end-------------------------------

%---------------�γ��ܵķ���ģ��---------------------------
%������ΪtrainFeatures5beats�����Ǵ洢�ڰ������ֿ����ļ����У�������ΪΪ5beats\trainFeatures5beats.mat
trainFeaturesFileName=['E:\icbeb\programs\MLII\',num2str(beats),'beats\trainFeatures',num2str(beats),'beats.mat'];
trainFeaturesName=['trainFeatures',num2str(beats),'beats'];
testFeaturesFileName=['E:\icbeb\programs\MLII\',num2str(beats),'beats\testFeatures',num2str(beats),'beats.mat'];
testFeaturesName=['testFeatures',num2str(beats),'beats'];
%[trainFeatures,trBeReplacedFile] = combineFeature(trainSet,leadway,beats);
eval(['[',trainFeaturesName,',trBeReplacedFile] = combineFeature(trainSet,leadway,beats);']);
eval(['[',testFeaturesName,',teBeReplacedFile] = combineFeature(testSet,leadway,beats);']);
eval('save(trainFeaturesFileName,trainFeaturesName);');
% save('trainFeatures.mat','trainFeatures');
% save testFeatures.mat testFeatures

%----------------�γ�9*8/2����������---------------------------------------
eval(['saveModel(',trainFeaturesName,',',testFeaturesName,',beats);']);
%----------------�γ�9*8/2���������� end------------------------------------


%---------------�γ��ܵķ���ģ�� end-----------------------

end

