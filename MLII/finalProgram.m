% function [outputArg1,outputArg2] = finalProgram(leadway,dataPath,outputPath)
%FINALPROGRAM 该函数每次只处理一个存储文件的信号，即A0001.mat，得出一个输出结果，命名为Result0001.mat，
%首先经过correctBaseline去噪，之后经过getFeature得到特征（RR,QR,QS）
%
%   leadway参数范围是1-12，代表12种导联方式，这里以MLII为示例
%   dataPath是文件夹，添加上foldernum是完整的文件夹路径，末尾不包含'\',
%   outputPath是完整的路径，需要'\'时手动添加
%   

%测试时默认值

leadway=2;
frequency=500;
dataPath='E:\icbeb\TrainingSet';
inputPath=[dataPath];
datanum=11;
csvPath='E:\icbeb\REFERENCE.csv';
type1=1;type2=2;
beats=5;



%获取目录下所有文件,取得fileNames大小
fileFolder=fullfile(inputPath);
dirOutput=dir(fullfile(fileFolder,'*.mat'));
fileNames={dirOutput.name}';% fileNames是2000x1cell，内容为A0001.mat等等,可以用char()转化
filename=char(fileNames(1,1));
allFileNum=size(fileNames,1);

%以下只对单个信号
%---------------加载数据模块start----------------------------------
%origindata就是可以使用的文件夹下第datanum个mat的leadway导联的1xYYYYdouble矩阵
% [origindata] = loadData(dataPath,datanum,leadway);
% 
% correctedData=correctBaseline(correctway,origindata,frequency);%应该得到1xYYYY
%---------------加载数据模块end-------------------------------



%---------------加载专家注释---------------
share=11; %每种取1/11作为测试集，10/11作为训练集，如果要进行交叉验证用10折交叉验证
[annotation,testSet,trainSet] = newSeparate(csvPath,share); %所有的注释，测试集和训练集
%---------------加载专家注释end------------------


%---------------进行10折交叉验证--------------------------------------


%---------------进行10折交叉验证 end-------------------------------

%---------------形成总的分类模型---------------------------
trainFeatures = combineFeature(trainSet,leadway,beats);
testFeatures = combineFeature(testSet,leadway,beats);
accuracy=0;
[model,accuracy]=oneclassifer(type1,type2,trainFeatures,testFeatures);
%---------------形成总的分类模型 end-----------------------
accuracy=accuracy-1;
% end

