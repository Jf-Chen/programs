function oneSignalFeature = averageFeature(beats,collection)
%AVERAGEFEATUREBYWINDOW2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��      ����������˴���
% function oneSignalFeature = averageFeature(beats,collection)
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
numofFea=4;%max,min,aver,var���ĸ�ֵ���ɴ����ڲö��ó�
%---------------------------------------------------------------------------
%������ĸ�ֵ��max,min,average,var(X,1,2)�����������ķ���,����ֵ��������
clumnSize=size(collection,2);%����źŰ������ٸ�����
% beats=clumnSize; %���д���ʱ����Ҫ
rowSize=size(collection,1); %����������������������RR,SP,RS����ô���Ҫ�õ�3x4��tempOneSignalFeature
tempClumn=floor(clumnSize-beats+1);% ���������Ϊ����,39����������35������
tempOneSignalFeature=zeros(rowSize,numofFea);  %beats������tempClumn
for k=1:rowSize
    interval=zeros(tempClumn,numofFea+1);
    for i=1:tempClumn
        X=collection(k,i:i+beats-1);
%         interval(i,1)=max(X,[],2);
%         interval(i,2)=min(X,[],2);
%         interval(i,3)=mean(X,2);
%         interval(i,4)=var((X),1,2);
        interval(i,5)=max(X,[],2)-min(X,[],2);
    end
        %3,4ȡ��ֵ
%         tempOneSignalFeature(k,:)=mean(interval,1); 
        %3,4ȡ��ֵ
%     for j=1:size(interval,1)
        tempOneSignalFeature(k,1)=max(interval(:,5),[],1);
        tempOneSignalFeature(k,2)=min(interval(:,5),[],1);
        tempOneSignalFeature(k,3)=mean(interval(:,5),1);
        tempOneSignalFeature(k,4)=var(interval(:,5),1,1);
%     end
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






