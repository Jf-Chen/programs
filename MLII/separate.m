% function [annotation] = separate(csvPath)
%SEPARATE 读取csv，将不同类型信号区分开来，3x9的cell
%         每个cell包含1xYYYY的矩阵，含有多种类型的可以重复计算
%   csvPath包含完整的路径

%   测试时的默认值
csvPath='E:\icbeb\REFERENCE.csv';



annotation=cell(3,9);
temp1=readtable(csvPath);
temp2=table2cell(temp1);
%使用1,2作为训练集，使用3作为测试集，需要知道文件夹内文件数量多少
%获取目录下所有文件,取得fileNames大小
sizes=[0];%1x3存储所含文件的数目
for k=1:3
    fileFolder=fullfile(['E:\icbeb\TrainingSet',num2str(k)]);
    dirOutput=dir(fullfile(fileFolder,'*.mat'));
    fileNames={dirOutput.name}';% fileNames是2000x1cell，内容为A0001.mat等等,可以用char()转化
    sizes(end+1)=size(fileNames,1);
end
tempsizes=cumsum(sizes); %[0,2000,4470,6877]
temptype=0;
%k代表第几个文件夹，i代表csv中的序列，j代表一条注释中的第几个
for k=1:size(tempsizes,2)-1
    for i=tempsizes(1,k)+1:tempsizes(1,k+1)
        for j=2:4  %校验标签是否正确
            if isnan(temp2{i,j}(1,1)) %如果是NaN,则 是
                break;%前提是NaN后面都是NaN
            else
                temptype=temp2{i,j}(1,1);
                annotation{k,temptype}(end+1)=i-tempsizes(1,k);%存储的是文件夹中的实际序列
            end
        end
    end
end
 
%---------------校验标签读取-------------------------
% sumFirst=ones(3,9);
% for k=1:3
%     for i=1:9
%         sumFirst(k,i)=size(annotation{k,i},2);
%     end
%     
% end
% test1=sum(sumFirst,1); 
%结果是 [918,1098,704,207,1695,574,653,826,202],略有偏差，不过总数一致
% test2=sum(test1,2)
%-------------------校验标签读取 end-----------------
%annotation可以输出了


% end

