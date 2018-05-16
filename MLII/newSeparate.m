function [annotation,testSet,trainSet] = newSeparate(csvPath,share)
%SEPARATE 读取csv，将不同类型信号区分开来，1x9的cell
%         每个cell包含1xYYYY的矩阵，含有多种类型的可以重复计算
%   testSet,1x9cell，测试集，trainSet,1x9cell训练集，每个cell(1xYYY)包含乱序的文件number,如1代表A0001.mat
%   csvPath包含完整的路径,share是值一共分成多少分，如11代表1/11作为测试集


%   测试时的默认值
csvPath='E:\icbeb\REFERENCE.csv';
share=11;


annotation=cell(1,9);
temp1=readtable(csvPath);
temp2=table2cell(temp1);
%使用1,2作为训练集，使用3作为测试集，需要知道文件夹内文件数量多少
%获取目录下所有文件,取得fileNames大小
fileFolder=fullfile(['E:\icbeb\TrainingSet']);
dirOutput=dir(fullfile(fileFolder,'*.mat'));
fileNames={dirOutput.name}';% fileNames是2000x1cell，内容为A0001.mat等等,可以用char()转化
sizes=size(fileNames,1);
temptype=0;
%k代表第几个文件夹，i代表csv中的序列，j代表一条注释中的第几个
    for i=1:sizes
        %-----------校验标签是否正确--------------------------
        for j=2:4  %校验标签是否正确
            if isnan(temp2{i,j}(1,1)) %如果是NaN,则 是
                break;%前提是NaN后面都是NaN
            else
                temptype=temp2{i,j}(1,1);
                annotation{1,temptype}(end+1)=i;%存储的是文件夹中的实际序列
            end
        end
    end

%---------------校验标签读取-------------------------
% sumFirst=ones(1,9);
% for k=1:1
%     for i=1:9
%         sumFirst(k,i)=size(annotation{k,i},2);
%     end
%     
% end
% test1=sum(sumFirst,2); 
%结果是 [918,1098,704,207,1695,574,653,826,202],略有偏差，不过总数一致
%-------------------校验标签读取 end-----------------
%annotation可以输出了

%-------------分离测试集与训练集-----------------------------
testSet=cell(1,9);%测试集
trainSet=cell(1,9);% 训练集
for k=1:9
    sizeofAll=size(annotation{1,k},2);
    randomA=randperm(sizeofAll);
    randomB=round(sizeofAll/share);
    testSet{1,k}=annotation{1,k}(randomA(1:randomB));
    trainSet{1,k}=annotation{1,k}(randomA(randomB+1:sizeofAll));
end

%---校验分离结果
% sumFirst=ones(1,9);
% sumSecond=ones(1,9);
% for k=1:1
%     for i=1:9
%         sumFirst(k,i)=size(testSet{k,i},2);
%         sumSecond(k,i)=size(trainSet{k,i},2);
%     end
%     
% end
% test1=sum(sumFirst,2); 
% test2=sum(sumSecond,2); 
%---分离训练集测试集成功

% end


