function [Features] = combineFeature(trainSet,leadway,beats)
%COMBINEFEATURE ��������������averageFeature�õ���oneSinglaFeature
%               �ϳ�����ѵ������Features
%   �˴���ʾ��ϸ˵��
%   beats,1--9,ѡ����ٸ��������ڵ�����
%   data������ľ���������ź�
%


dataPath='E:\icbeb\TrainingSet';
frequency=500;
correctway=1;
extractway=1;
trainSetClumn=size(trainSet,2);
Features=cell(1,trainSetClumn);
for k=1:size(trainSet,2)
    typeSet=trainSet{1,k}; %1xYYY
    tempFeature=cell(1,1);
    for i=1:size(typeSet,2)
        datanum=typeSet(1,i);
        origindata = loadData(dataPath,datanum,leadway);
        correctedData = correctBaseline(correctway,origindata,frequency);
        collection=getFeature(correctedData,extractway);
        oneSignalFeature = averageFeature(beats,collection); %�õ�1x15�ľ��󣬼���ȡRR,SP,RS������������������۲�
        tempFeature{1,1}(end+1,:)=oneSignalFeature; % ��Ҫά��һ��
    end
    %��ʱtempFeature��һ��1x1cell,����size(typeSet,2) x size��oneSingalFeature,2���ľ���
    % ���Կ�����1000x15
    Features{1,k}=tempFeature;
end

%Feature��1x9 cell ������������



end

