% function [annotation] = separate(csvPath)
%SEPARATE ��ȡcsv������ͬ�����ź����ֿ�����3x9��cell
%         ÿ��cell����1xYYYY�ľ��󣬺��ж������͵Ŀ����ظ�����
%   csvPath����������·��

%   ����ʱ��Ĭ��ֵ
csvPath='E:\icbeb\REFERENCE.csv';



annotation=cell(3,9);
temp1=readtable(csvPath);
temp2=table2cell(temp1);
%ʹ��1,2��Ϊѵ������ʹ��3��Ϊ���Լ�����Ҫ֪���ļ������ļ���������
%��ȡĿ¼�������ļ�,ȡ��fileNames��С
sizes=[0];%1x3�洢�����ļ�����Ŀ
for k=1:3
    fileFolder=fullfile(['E:\icbeb\TrainingSet',num2str(k)]);
    dirOutput=dir(fullfile(fileFolder,'*.mat'));
    fileNames={dirOutput.name}';% fileNames��2000x1cell������ΪA0001.mat�ȵ�,������char()ת��
    sizes(end+1)=size(fileNames,1);
end
tempsizes=cumsum(sizes); %[0,2000,4470,6877]
temptype=0;
%k����ڼ����ļ��У�i����csv�е����У�j����һ��ע���еĵڼ���
for k=1:size(tempsizes,2)-1
    for i=tempsizes(1,k)+1:tempsizes(1,k+1)
        for j=2:4  %У���ǩ�Ƿ���ȷ
            if isnan(temp2{i,j}(1,1)) %�����NaN,�� ��
                break;%ǰ����NaN���涼��NaN
            else
                temptype=temp2{i,j}(1,1);
                annotation{k,temptype}(end+1)=i-tempsizes(1,k);%�洢�����ļ����е�ʵ������
            end
        end
    end
end
 
%---------------У���ǩ��ȡ-------------------------
% sumFirst=ones(3,9);
% for k=1:3
%     for i=1:9
%         sumFirst(k,i)=size(annotation{k,i},2);
%     end
%     
% end
% test1=sum(sumFirst,1); 
%����� [918,1098,704,207,1695,574,653,826,202],����ƫ���������һ��
% test2=sum(test1,2)
%-------------------У���ǩ��ȡ end-----------------
%annotation���������


% end

