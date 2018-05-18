function [origindata] = loadData(dataPath,datanum,leadway)
%LOADDATA 从E:\icbeb\TrainingSet中加载A0011.mat
%   此处显示详细说明
%   origindata是输出的某一导联的的信号，大小为1xYYYYY
%   dataPath是文件夹路径
%   leadway是导联方式，如 2代表MLII


%测试时默认值
% dataPath='E:\icbeb\TrainingSet';
% datanum=1;


%以下部分可以优化，将这一部分存储起来，不必重复计算
dataPath=[dataPath];
%获取目录下所有文件
fileFolder=fullfile(dataPath);
dirOutput=dir(fullfile(fileFolder,'*.mat'));
fileNames={dirOutput.name}';% fileNames是2000x1 cell，内容为A0001.mat等等,可以用char()转化
filename=char(fileNames(datanum,1));
%以下只对单个信号
%---------------加载数据模块start----------------------------------
%这一句是有效的eval(['load(''E:\icbeb\TrainingSet1\A0001.mat'')'])
loadPath=[dataPath,'\',filename];
eval(['load(loadPath);']);% 一定是ECG
% origindata=ECG.data(2,:);
 eval(['origindata=ECG.data(',num2str(leadway),',:);']);
end

