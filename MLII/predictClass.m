function [TypeResult,predictLabel,allresult,finalResult] = predictClass(dataOriginPath,modelPath,leadway,frequency,correctway,extractway)
%PREDICTCLASS �������ļ���Ԥ�������ͣ�ʹ��9beats��model
%   �˴���ʾ��ϸ˵�� ,newaccuracy,typeResultSize
%   dataOriginPath��.mat�ļ���·������E:\icbeb\TrainingSet\A0001.mat��
%   modelPath�Ƿ�����·������E:\icbeb\programs\MLII\9beats\��



%��ȡ�ļ���Ԥ�������collection�����oneSignalFeature
%--------------------loadData---------------------------
loadPath=dataOriginPath;
% leadway=2
eval(['load(loadPath);']);% һ����ECG
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
            %��A0011.mat�����
            error('��ȡcollection����');
        end
        
    end
end

% ��Ҫ���try catch
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
% �ʣ���ξ��߳��������
% �𣺼������з�������ͶƱ������������ٵ����֣�������ط��������ظ����Ϲ��̣�ֱ�����һ����ʣ������һ�Σ��ó�������
% �������з��������õ�36�������ͶƱ�������ٵ�����
% �ظ���Σ�ֱ��ʣ��һ��������������
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
        Te2typeLabel=[1]; %��������
        Te2type=oneSignalFeature;
        eval(['[predictLabel,accuracy,dec_values]=svmpredict(Te2typeLabel,Te2type,',tempModelName,');']);
        if predictLabel==1  %ǰ����typeA<typeB%���������Ըĳ�-1
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

%ͳ��allresult��������ٵģ�������ط��������
% ������ú���һ����,ѭ��9�Σ�ÿ�ζ����������ٵ���һ����صķ���������6�����Ҳ�Ϊ0����������0����6����0
%-------------------------------------------------------------------------------
finalResult=0;
for t=1:9 %ѭ��9��
    tempnum=zeros(1,9);
    for k=1:9 %ͳ��ÿ�����͵�����
        for i=1:8 %������
            for j=1:9 %������
                if allresult(i,j)==k
                    tempnum(1,k)=tempnum(1,k)+1;
                end
            end
        end
    end
    minType=0;minNum=9; %�Է���һ,minType=1;
    if sum(tempnum)>0 %����ȫΪ0��
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
% �����txt,·��Ϊ E:\icbeb\programs\MLII\9beats\result.txt
dlmwrite('E:\icbeb\programs\MLII\9beats\result.txt',finalResult,'delimiter',',','newline','pc'); %�ļ�����ĩβ�����һ���س�
%ÿ��д����滻��֮ǰ������
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

