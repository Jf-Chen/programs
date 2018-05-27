function [accuracyOfAll] = caculateAllAccuracy(startNum,endNum)
%CACULATEALLACCURACY 计算预测结果的准确率
%   此处显示详细说明
%   startNum,endNum是文件序号，必须在1~6877之间
%   accuracyOfAll是所有文件的准确率，目前的计算结果是0.2517
startNum=1;endNum=6877;


dataFolderPath='E:\icbeb\TrainingSet';
csvPath='E:\icbeb\REFERENCE.csv';


%获取标签
temp1=readtable(csvPath);
temp2=table2cell(temp1);



%获取目录下所有文件,取得fileNames大小
fileFolder=fullfile(dataFolderPath);
dirOutput=dir(fullfile(fileFolder,'*.mat'));
fileNames={dirOutput.name}';% fileNames是2000x1cell，内容为A0001.mat等等,可以用char()转化
% filename=char(fileNames(1,1));
allFileNum=size(fileNames,1);
startNum=round(max(1,startNum));% 排除小数和负数
endNum=round(min(allFileNum,endNum)); %排除超过6877和小数
trueResultNum=0;falseResultNum=0;

writedownFinalResult=cell(0,0);%前四列与csv一致，第五列是检测结果

for i=startNum:endNum
    dataOriginPath=[fileFolder,'\',fileNames{i,1}];
    % dataOriginPath='E:\icbeb\TrainingSet\A0016.mat';
    modelPath='E:\icbeb\programs\MLII\9beats\';
    leadway=2;
    frequency=500;
    correctway=1;
    extractway=1;
    [TypeResult,predictLabel,allresult,finalResult] = predictClass(dataOriginPath,modelPath,leadway,frequency,correctway,extractway);
    
    writedownFinalResult(end+1,1)=fileNames(i,1);
    writedownFinalResult{end,2}=temp2{i,2};
    writedownFinalResult{end,3}=temp2{i,3};
    writedownFinalResult{end,4}=temp2{i,4};
    writedownFinalResult{end,5}(1,1)=finalResult;
    if finalResult==temp2{i,2} || finalResult==temp2{i,3} || finalResult==temp2{i,4}
        trueResultNum=trueResultNum+1;
    else
        falseResultNum=falseResultNum+1;
    end
end

accuracyOfAll=trueResultNum/(trueResultNum+falseResultNum);



end

