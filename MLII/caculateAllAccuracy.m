function [accuracyOfAll] = caculateAllAccuracy(startNum,endNum)
%CACULATEALLACCURACY ����Ԥ������׼ȷ��
%   �˴���ʾ��ϸ˵��
%   startNum,endNum���ļ���ţ�������1~6877֮��
%   accuracyOfAll�������ļ���׼ȷ�ʣ�Ŀǰ�ļ�������0.2517
startNum=1;endNum=6877;


dataFolderPath='E:\icbeb\TrainingSet';
csvPath='E:\icbeb\REFERENCE.csv';


%��ȡ��ǩ
temp1=readtable(csvPath);
temp2=table2cell(temp1);



%��ȡĿ¼�������ļ�,ȡ��fileNames��С
fileFolder=fullfile(dataFolderPath);
dirOutput=dir(fullfile(fileFolder,'*.mat'));
fileNames={dirOutput.name}';% fileNames��2000x1cell������ΪA0001.mat�ȵ�,������char()ת��
% filename=char(fileNames(1,1));
allFileNum=size(fileNames,1);
startNum=round(max(1,startNum));% �ų�С���͸���
endNum=round(min(allFileNum,endNum)); %�ų�����6877��С��
trueResultNum=0;falseResultNum=0;

writedownFinalResult=cell(0,0);%ǰ������csvһ�£��������Ǽ����

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
