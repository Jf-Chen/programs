function oneSignalFeature = averageFeature1(beats,collection)
%    �������ڲ��Ӵ���
%AVERAGEFEATUREBYWINDOW ������averageFeatureByWindow��ΪaverageFeature
%                       ���ڴ���collection,�ɷֶ���Ƭ��Ϊ���ڻ����ķ�ʽ

%   �˴���ʾ��ϸ˵��
% function oneSignalFeature = averageFeature(beats,collection)
%COMBINEFEATURE  ����������beats�õ������źŵ�������������ֵ�ľ�ֵ����beat=3,
%                ��3���źŵ�RR,SP,RS��Ϊ������Ȼ��ȡ��ֵ
%   �˴���ʾ��ϸ˵��
%   beats,1--9,ѡ����ٸ��������ڵ�����
%   dataͨ��loadData�õ�
%

%Ĭ��ֵ
numofFea=4;%max,min,aver,var���ĸ�ֵ

%---------------------------------------------------------------------------
%������ĸ�ֵ��max,min,average,var(X,1,2)�����������ķ���,����ֵ��������
clumnSize=size(collection,2);%����źŰ������ٸ�����
beats=clumnSize;
rowSize=size(collection,1); %����������������������RR,SP,RS����ô���Ҫ�õ�3x4��tempOneSignalFeature
tempClumn=floor(clumnSize-beats+1);% ���������Ϊ����,39����������35������
tempOneSignalFeature=zeros(rowSize,numofFea);  %beats������tempClumn
for k=1:rowSize
    interval=zeros(1,numofFea);
    for i=1:tempClumn
        interval(1,1)=max(collection(k,:),[],2);
        interval(1,2)=min(collection(k,:),[],2);
        interval(1,3)=mean(collection(k,:),[],2);
        interval(1,4)=var(collection(k,:),1,2);
    end
        tempOneSignalFeature(k,:)=interval; 
end


%--------------------------�л�������ʱ-----------------------------
%ÿ������������ĸ�ֵ,��Щ���Ǵ����ڵ�ȡֵmax,min,average,var(X,1,2)�����������ķ���,����ֵ��������
%���յõ�����3x(4x35)�ľ���
% clumnSize=size(collection,2);%����źŰ������ٸ�����
% beats=clumnSize;
% rowSize=size(collection,1); %����������������������RR,SP,RS����ô���Ҫ�õ�3x4��tempOneSignalFeature
% tempClumn=floor(clumnSize-beats+1);% ���������Ϊ����,39����������35������
% tempOneSignalFeature=zeros(rowSize,numofFea);  %beats������tempClumn
% for k=1:rowSize
%     interval=zeros(1,numofFea);
%     for i=1:tempClumn
%         interval(1,1)=max(collection(k,:),[],2);
%         interval(1,2)=min(collection(k,:),[],2);
%         interval(1,3)=mean(collection(k,:),[],2);
%         interval(1,4)=var(collection(k,:),1,2);
%     end
%         tempOneSignalFeature(k,:)=interval; 
% end



%---------------------- ---�л�������ʱ end------------------------
%��ʱoneSignalFeature��һ��3x(39/5)�ľ��󣬼�����ź���40�����ڣ�ȡRR,SP,RS�����������Ϊ����۲�
%������ϳ�һά�ź�
tempOneSignalFeature=tempOneSignalFeature';
oneSignalFeature=tempOneSignalFeature(:);
oneSignalFeature=oneSignalFeature';  %��ʱoneSignalFeature��1xYYY�ľ���,
%�൱��[1 2 3 4 5;6 7 8 9 10;11 12 13 14 15]->[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]


end




