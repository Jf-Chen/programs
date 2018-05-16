% function [outputArg1,outputArg2] = finalProgram(leadway,dataPath,outputPath)
%FINALPROGRAM �ú���ÿ��ֻ����һ���洢�ļ����źţ���A0001.mat���ó�һ��������������ΪResult0001.mat��
%���Ⱦ���correctBaselineȥ�룬֮�󾭹�getFeature�õ�������RR,QR,QS��
%
%   leadway������Χ��1-12������12�ֵ�����ʽ��������MLIIΪʾ��
%   dataPath���ļ��У������foldernum���������ļ���·����ĩβ������'\',
%   outputPath��������·������Ҫ'\'ʱ�ֶ����
%   

%����ʱĬ��ֵ

leadway=2;
frequency=500;
dataPath='E:\icbeb\TrainingSet';
inputPath=[dataPath];
datanum=11;
csvPath='E:\icbeb\REFERENCE.csv';
type1=1;type2=2;
beats=5;



%��ȡĿ¼�������ļ�,ȡ��fileNames��С
fileFolder=fullfile(inputPath);
dirOutput=dir(fullfile(fileFolder,'*.mat'));
fileNames={dirOutput.name}';% fileNames��2000x1cell������ΪA0001.mat�ȵ�,������char()ת��
filename=char(fileNames(1,1));
allFileNum=size(fileNames,1);

%����ֻ�Ե����ź�
%---------------��������ģ��start----------------------------------
%origindata���ǿ���ʹ�õ��ļ����µ�datanum��mat��leadway������1xYYYYdouble����
% [origindata] = loadData(dataPath,datanum,leadway);
% 
% correctedData=correctBaseline(correctway,origindata,frequency);%Ӧ�õõ�1xYYYY
%---------------��������ģ��end-------------------------------



%---------------����ר��ע��---------------
share=11; %ÿ��ȡ1/11��Ϊ���Լ���10/11��Ϊѵ���������Ҫ���н�����֤��10�۽�����֤
[annotation,testSet,trainSet] = newSeparate(csvPath,share); %���е�ע�ͣ����Լ���ѵ����
%---------------����ר��ע��end------------------


%---------------����10�۽�����֤--------------------------------------


%---------------����10�۽�����֤ end-------------------------------

%---------------�γ��ܵķ���ģ��---------------------------
trainFeatures = combineFeature(trainSet,leadway,beats);
testFeatures = combineFeature(testSet,leadway,beats);
accuracy=0;
[model,accuracy]=oneclassifer(type1,type2,trainFeatures,testFeatures);
%---------------�γ��ܵķ���ģ�� end-----------------------
accuracy=accuracy-1;
% end

