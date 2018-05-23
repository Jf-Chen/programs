function [Features,beReplacedFile] = combineFeature(trainSet,leadway,beats)
%COMBINEFEATURE ��������������averageFeature�õ���oneSinglaFeature
%               �ϳ�����ѵ������Features
%   �˴���ʾ��ϸ˵��
%   beats,1--9,ѡ����ٸ��������ڵ�����
%   data������ľ����������ź�
%


dataPath='E:\icbeb\TrainingSet';
frequency=500;
correctway=1;
extractway=1;
trainSetClumn=size(trainSet,2);
Features=cell(1,trainSetClumn);
%�滻�ļ�������1-����9
replaceFile=[2,3,39,11,43,47,5,8,21];
beReplacedFile=cell(1,9); % ���������� ��ű��滻���ļ�
loopFlag=5;
for k=1:size(trainSet,2)    %------------�۲�һ���������͵�
    typeSet=trainSet{1,k}; %1xYYY
    tempFeature=cell(1,1);
    for i=1:size(typeSet,2) 
%         fprintf('trainSet locate at %d ',k);
        datanum=typeSet(1,i);
        origindata = loadData(dataPath,datanum,leadway);
        correctedData = correctBaseline(correctway,origindata,frequency);
        %����̨��ӡ��ִ�е��ļ�
        fprintf('��ǰ�ļ� %d',datanum)
        try
            collection=getFeature(correctedData,extractway);
        catch
            if loopFlag<5
                i=i-1; %Ϊ�˷�ֹ��������ѭ��������һ����ǣ������ѭ�����ֶ�κ��ٽ���ѭ��
                loopFlag=loopFlag+1;
                continue;
            else
                collection=[];
            end
        end
        %У��ά���Ƿ���0����
        if(size(collection,1)==0 || size(collection,2)<beats)
            beReplacedFile{1,k}(end+1)=typeSet(1,i);
            fprintf('  �ļ�%d���滻��  ',typeSet(1,i));
            clear collection origindata correctedData;
            datanum=replaceFile(1,k);
            origindata = loadData(dataPath,datanum,leadway);
            correctedData = correctBaseline(correctway,origindata,frequency);
            collection=getFeature(correctedData,extractway);
        end
        fprintf('collection=%d x %d',size(collection,1),size(collection,2));
%         oneSignalFeature = averageFeature(beats,collection); %�õ�1x15�ľ��󣬼���ȡRR,SP,RS������������������۲�
        
        %---------------------------------------------------------------------
        %�ڴ˴����Ӷര�ڵ�ͬһ����
        oneSignalFeature1 = averageFeature(1,collection);
        oneSignalFeature2 = averageFeature(2,collection);
        oneSignalFeature3 = averageFeature(3,collection);
        oneSignalFeature4 = averageFeature(4,collection);
        oneSignalFeature5 = averageFeature(5,collection);
        oneSignalFeature6 = averageFeature(6,collection);
        oneSignalFeature7 = averageFeature(7,collection);
        oneSignalFeature8 = averageFeature(8,collection);
        oneSignalFeature9 = averageFeature(9,collection);
        oneSignalFeature=[oneSignalFeature1,oneSignalFeature2,oneSignalFeature3,oneSignalFeature4,...
            oneSignalFeature5,oneSignalFeature6,oneSignalFeature7,oneSignalFeature8,oneSignalFeature9];
        %--------------------------------------------------------------------
        
        fprintf(' oneSignalFea=% dx %d',size(oneSignalFeature,1),size(oneSignalFeature,2));
        tempFeature{1,1}(end+1,:)=oneSignalFeature; % ��Ҫά��һ��
        fprintf(' tempFea=%d x %d\n',size(tempFeature{1,1},1),size(tempFeature{1,1},2));
        loopFlag=0;
    end
    %��ʱtempFeature��һ��1x1cell,����size(typeSet,2) x size��oneSingalFeature,2���ľ���
    % ���Կ�����1000x15
    Features{1,k}=tempFeature;
end

beReplacedFileFileName=['E:\icbeb\programs\MLII\',num2str(beats),'beats\beReplacedFile',num2str(beats),'beats.mat'];
beReplacedFileName='beReplacedFile';
eval('save(beReplacedFileFileName,beReplacedFileName);');
%Feature��1x9 cell ������������



end
