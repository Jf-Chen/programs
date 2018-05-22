function oneSignalFeature = averageFeatureByWindow(beats,collection)
%COMBINEFEATURE  ����������beats�õ������źŵ�������������ֵ�ľ�ֵ����beat=3,
%                ��3���źŵ�RR,SP,RS��Ϊ������Ȼ��ȡ��ֵ
%   �˴���ʾ��ϸ˵��
%   beats,1--9,ѡ����ٸ��������ڵ�����
%   dataͨ��loadData�õ�
%



%
clumnSize=size(collection,2);%����źŰ������ٸ�����
rowSize=size(collection,1); %����������������RR,SP,RS
tempClumn=floor(clumnSize/beats);% ���������Ϊ�����ظ��Ĵ���
tempOneSignalFeature=zeros(rowSize,beats);  %beats������tempClumn
for k=1:rowSize
    interval=zeros(1,beats);
    
    for j=1:beats
        for i=1:tempClumn
            interval(1,j)=interval(1,j)+collection(k,(i-1)*beats+j);
        end
        tempOneSignalFeature(k,j)=interval(1,j)/tempClumn;
    end
    
%     for i=0:tempClumn-1
%         for j=1:beats
%             interval(1,j)=interval(1,j)+collection(k,i*beats+j); 
%         end  %��ʱinterval��1x5�ľ���
%         tempOneSignalFeature(k,j)=sum(interval,2)/tempClumn;
%     end
    
    
end

%��ʱoneSignalFeature��һ��3x(39/5)�ľ��󣬼�����ź���40�����ڣ�ȡRR,SP,RS�����������Ϊ����۲�
%������ϳ�һά�ź�
tempOneSignalFeature=tempOneSignalFeature';
oneSignalFeature=tempOneSignalFeature(:);
oneSignalFeature=oneSignalFeature';  %��ʱoneSignalFeature��1xYYY�ľ���,
%�൱��[1 2 3 4 5;6 7 8 9 10;11 12 13 14 15]->[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]


end

