function [annotation,testSet,trainSet] = newSeparate(csvPath,share)
%SEPARATE ��ȡcsv������ͬ�����ź����ֿ�����1x9��cell
%         ÿ��cell����1xYYYY�ľ��󣬺��ж������͵Ŀ����ظ�����
%   testSet,1x9cell�����Լ���trainSet,1x9cellѵ������ÿ��cell(1xYYY)����������ļ�number,��1����A0001.mat
%   csvPath����������·��,share��ֵһ���ֳɶ��ٷ֣���11����1/11��Ϊ���Լ�


%   ����ʱ��Ĭ��ֵ
csvPath='E:\icbeb\REFERENCE.csv';
share=11;


annotation=cell(1,9);
temp1=readtable(csvPath);
temp2=table2cell(temp1);
%ʹ��1,2��Ϊѵ������ʹ��3��Ϊ���Լ�����Ҫ֪���ļ������ļ���������
%��ȡĿ¼�������ļ�,ȡ��fileNames��С
fileFolder=fullfile(['E:\icbeb\TrainingSet']);
dirOutput=dir(fullfile(fileFolder,'*.mat'));
fileNames={dirOutput.name}';% fileNames��2000x1cell������ΪA0001.mat�ȵ�,������char()ת��
sizes=size(fileNames,1);
temptype=0;
%k����ڼ����ļ��У�i����csv�е����У�j����һ��ע���еĵڼ���
    for i=1:sizes
        %-----------У���ǩ�Ƿ���ȷ--------------------------
        for j=2:4  %У���ǩ�Ƿ���ȷ
            if isnan(temp2{i,j}(1,1)) %�����NaN,�� ��
                break;%ǰ����NaN���涼��NaN
            else
                temptype=temp2{i,j}(1,1);
                annotation{1,temptype}(end+1)=i;%�洢�����ļ����е�ʵ������
            end
        end
    end

%---------------У���ǩ��ȡ-------------------------
% sumFirst=ones(1,9);
% for k=1:1
%     for i=1:9
%         sumFirst(k,i)=size(annotation{k,i},2);
%     end
%     
% end
% test1=sum(sumFirst,2); 
%����� [918,1098,704,207,1695,574,653,826,202],����ƫ���������һ��
%-------------------У���ǩ��ȡ end-----------------
%annotation���������

%-------------������Լ���ѵ����-----------------------------
testSet=cell(1,9);%���Լ�
trainSet=cell(1,9);% ѵ����
for k=1:9
    sizeofAll=size(annotation{1,k},2);
    randomA=randperm(sizeofAll);
    randomB=round(sizeofAll/share);
    testSet{1,k}=annotation{1,k}(randomA(1:randomB));
    trainSet{1,k}=annotation{1,k}(randomA(randomB+1:sizeofAll));
end

%---У�������
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
%---����ѵ�������Լ��ɹ�

% end


