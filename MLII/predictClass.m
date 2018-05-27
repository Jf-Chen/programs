function [TypeResult,predictLabel,allresult,finalResult] = predictClass(dataOriginPath,modelPath,leadway,frequency,correctway,extractway)
%PREDICTCLASS 处理单个文件，预测其类型，使用9beats的model
%   此处显示详细说明 ,newaccuracy,typeResultSize
%   dataOriginPath是.mat文件的路径包含E:\icbeb\TrainingSet\A0001.mat，
%   modelPath是分类器路径包含E:\icbeb\programs\MLII\9beats\，



%获取文件，预处理，获得collection，获得oneSignalFeature
%--------------------loadData---------------------------
loadPath=dataOriginPath;
% leadway=2
eval(['load(loadPath);']);% 一定是ECG
% origindata=ECG.data(2,:);
eval(['origindata=ECG.data(',num2str(leadway),',:);']);
%--------------------loadData  end-----------------------------------

%----------------correctBaseline------------------------------
% frequency=500;correctway=1;
correctedData = correctBaseline(correctway,origindata,frequency);
%----------------correctBaseline  end----------------------------

%---------------------getFeature------------------------------------
% extractway=1;
for k=1:10
    try
        [collection,outputCluster_center2] = getFeature(correctedData,extractway);
        break;
    catch
        if k<9
            continue;
        else
            %用A0011.mat替代？
            error('获取collection出错！');
        end
        
    end
end

% 需要添加try catch
%---------------------getFeature end------------------------------------

%--------------------averageFeature----------------------------------

        oneSignalFeature1 = averageFeature(1,collection);
        oneSignalFeature2 = averageFeature(2,collection);
        oneSignalFeature3 = averageFeature(3,collection);
        oneSignalFeature4 = averageFeature(4,collection);
        oneSignalFeature5 = averageFeature(5,collection);
        oneSignalFeature6 = averageFeature(6,collection);
        oneSignalFeature7 = averageFeature(7,collection);
        oneSignalFeature8 = averageFeature(8,collection);
%         oneSignalFeature9 = averageFeature(9,collection);
        oneSignalFeature=[oneSignalFeature1,oneSignalFeature2,oneSignalFeature3,oneSignalFeature4,...
            oneSignalFeature5,oneSignalFeature6,oneSignalFeature7,oneSignalFeature8];
%             oneSignalFeature9];

%--------------------averageFeature end----------------------------------


%-----------------------predict-------------------------------------
% 问：如何决策出最后结果？
% 答：加载所有分类器，投票决定出结果最少的那种，丢弃相关分类器，重复以上过程，直到最后一个不剩，上溯一次，得出分类结果
% 加载所有分类器，得到36个结果，投票决定最少的那种
% 重复多次，直到剩下一个或三个分类器
allType=[];
possibleType=[];
predictLabel=0;
allresult=zeros(8,9);
for k=1:8
    for j=k+1:9
        typeA=k;
        typeB=j;
        tempModelName=['model',num2str(typeA),num2str(typeB)];
        tempModelPath=[modelPath,tempModelName];
        eval('load(tempModelPath);');
        % Te2typeLabel=ones(size(oneSignalFeature,1),1);
        Te2typeLabel=[1]; %毫无意义
        Te2type=oneSignalFeature;
        eval(['[predictLabel,accuracy,dec_values]=svmpredict(Te2typeLabel,Te2type,',tempModelName,');']);
        if predictLabel==1  %前提是typeA<typeB%如果结果不对改成-1
            TypeResult=typeA;
        else 
            if predictLabel==-1
                TypeResult=typeB;
            end
        end
        allresult(typeA,typeB)=TypeResult;
%         allresult(typeA,typeB)=TypeResult;
    end    
end

%统计allresult结果中最少的，丢弃相关分类器结果
% 如何利用好这一部分,循环9次，每次丢弃数量最少的那一种相关的分类器，如6最少且不为0，第六列置0，第6行置0
%-------------------------------------------------------------------------------
finalResult=0;
for t=1:9 %循环9次
    tempnum=zeros(1,9);
    for k=1:9 %统计每个类型的数量
        for i=1:8 %遍历行
            for j=1:9 %遍历列
                if allresult(i,j)==k
                    tempnum(1,k)=tempnum(1,k)+1;
                end
            end
        end
    end
    minType=0;minNum=9; %以防万一,minType=1;
    if sum(tempnum)>0 %不能全为0吧
        for x=1:9
            if tempnum(1,x)<minNum &&tempnum(1,x)>0
                minNum=tempnum(1,x);
                minType=x;
            end
        end
    end
    if minType<9
        allresult(minType,:)=0;
    end
    allresult(:,minType)=0;
    if sum(sum(allresult,1),2)==0
        finalResult=minType;
        break;
    end
end
%------------------------------------------------------------------------------

%----------------------------------------------------------------------------
% 输出给txt,路径为 E:\icbeb\programs\MLII\9beats\result.txt
dlmwrite('E:\icbeb\programs\MLII\9beats\result.txt',finalResult,'delimiter',',','newline','pc'); %文件结束末尾会加上一个回车
%每次写完会替换掉之前的内容
%---------------------------------------------------------------------------



% finalResult=0;


% % typeA=1;
% % typeB=2;
% tempModelName=['model',num2str(typeA),num2str(typeB)];
% tempModelPath=[modelPath,tempModelName];
% eval('load(tempModelPath);');
% % Te2typeLabel=ones(size(oneSignalFeature,1),1);
% Te2typeLabel=[-1];
% Te2type=oneSignalFeature;
% eval(['[predictLabel,accuracy,dec_values]=svmpredict(Te2typeLabel,Te2type,',tempModelName,')']);
% if predictLabel==-1
%     TypeResult=typeA;
% else
%     TypeResult=typeB;
% end

%-----------------------predict end-------------------------------------
%  [TypeResult,predictLabel] = predictClass('E:\icbeb\TrainingSet\A0016.mat','E:\icbeb\programs\MLII\9beats\',2,500,1,1,1,2)

end

