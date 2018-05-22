% function [collection,outputCluster_center2] = getFea8(data,extractway)
%GETFEA ��getFeature���ƣ������T����������������ԣ���������getFea���getFeature
%   collection��extractway==1ʱ��X x YY�ľ���X=8���������ּ�����μ�fiveclasses/getwave
%   RR��RR��� 1xYY,SP��P�����S���ȼ��,RS��R����S���ȼ��
%   leadway������Χ��1-12������12�ֵ�����ʽ��������MLIIΪʾ��
%   inputPath������·����ĩβ����'\',outputPathͬ��
%   data�Ǿ���correctBaseline�����ݣ�����һ���źŵ�һ������,data��ʽ������1xYYYY
%   extractway����ȡ��ʽ,��1����ȡ��������


%-------------------Ĭ��ֵ
dataPath='E:\icbeb\TrainingSet';
% datanum=3261;
% datanum=6671;
% datanum=1668;
% datanum=3861;
% datanum=565;
datanum=11;
leadway=2;
correctway=1;
frequency=500;

[origindata] = loadData(dataPath,datanum,leadway);
% figure(20);plot(origindata);axis tight;
data = correctBaseline(correctway,origindata,frequency);
figure(1);plot(data);axis tight;
%-------- QRS��Ⱥ��� (��Rwave2.m)slopeƽ��/abs(slope)--------------------------------
t2=clock;
datasize=size(data,2); %data�Ǻ������е�
slope=zeros(datasize-1,1); % б��
for k=1:datasize-1
    slope(k)=data(k+1)-data(k);
end;
% slope_sq=slope.*slope;
abslope=abs(slope);

% abslope=slope_sq;
[IDX,cluster_center]=kmeans(abslope,2,'emptyaction','drop');  % K-means����
% IDX=kmeans(abslope,2); 
IDX=IDX-1;%-----------------------------------------------------------------[1/2]->[0/1]
bound=0;
if sum(IDX)<size(IDX,1)/2 %-------------------------------------------------bound==0
    bound=1;
end;


figure(7);
subplot(311);plot(slope);axis tight;title('slope');
subplot(312);plot(abslope);axis tight;title('absolute slope');
subplot(313);plot(IDX);axis tight;title('k-means������');


flag=[];
siz=size(IDX,1)-1;
i=1;
a=0; % ��¼�����ġ�0��������bound==0��
b=0; % ��¼�����ġ�1��������bound==0��
for k=2:siz-1
    if IDX(k)==bound %------------------------------------------------------б�ʼ���ĵ�ļ�
        if IDX(k-1)==1-bound && IDX(k+1)==bound %---------------------------��ƽ̹��б�ʴ�
            flag(i,1)=1;
            flag(i,2)=k; %--------------------------------------------------flag(i) [,,a;,,b;1,k,]
            if i>2
                flag(i-1,3)=b; 
                b=0;
                flag(i-2,3)=a;
                a=0;
            end;
            i=i+1;
        else
            if IDX(k-1)==bound && IDX(k+1)==1-bound
                flag(i,1)=-1;
                flag(i,2)=k;
                i=i+1;
            end;
        end;
        a=a+1;
    end;
    if i>2 && IDX(k)==1-bound  
        b=b+1;
    end;
end;
% IDX2=zeros(size(IDX,1),1);
f=flag(1,1);
loc=flag(1,2);
R_border=[];
for k=1:size(flag,1)
    if(flag(k,2)-loc>frequency/3)
        R_border(end+1)=loc;
        R_border(end+1)=flag(k-1,2);
        loc=flag(k,2);
    end;
end;
R_border(end+1)=loc;
R_border(end+1)=flag(k,2);
IDX2=zeros(size(IDX,1),1);
for k=1:size(R_border,2)
    IDX2(R_border(k))=1;
end;
QRS_complex=[];
k=1;
while k<size(R_border,2)
    QRS_complex(end+1)=R_border(k+1)-R_border(k);
    k=k+2;
end;

QRS_R=[];
k=1;i=1;
while k<size(R_border,2)
    [QRS_R(i,1),QRS_R(i,2)]=max(data(R_border(k):R_border(k+1)));
    QRS_R(i,2)=QRS_R(i,2)+R_border(k)-1;
    k=k+2;
    i=i+1;
end;


% figure(1);hold on;plot(R_border,data(R_border),'ro');
fprintf('--------------------------------------------');

i=1;
j=1;
%-----------��Q����S��-----------------------------------------------------
%===========��Q����S��===================
Qwave=[];
Swave=[];
n=size(R_border,2);
k=1;
while k<n
    i=R_border(k);
    j=R_border(k+1);
    %-----------------------------------------------------------��һ���������������㹻ƽ������Ȼȥ�������߲���ƽ��
    while slope(i)>0 || slope(i)==0     % find first trough
        i=i-1;
        if i<1
            break;
        end;
    end;
    Qwave(end+1)=i+1;
    while slope(j)<0 || slope(j)==0
        j=j+1;
        if j>size(slope,1)
            break;
        end;
    end;
    Swave(end+1)=j;
    k=k+2;
end;

QRSborder=[];
n=size(Qwave,2);
k=1;
while k<n+1
    i=Qwave(k)-1;
    j=Swave(k);
    while i>0 && slope(i)<0 % find first trough
        i=i-1;
    end;
    QRSborder(end+1)=i+1;
    while j<size(slope,1) && slope(j)>0
        j=j+1;    
    end;
    QRSborder(end+1)=j;
    k=k+1; 
end;



%--------------------------------------------------------------------
figure(1);hold on;plot(QRSborder,data(QRSborder),'ro');%����ȥ��Ч�������룬��һ���Ϳ��������
%-------------------------------------------------------------------------


%-------------------Pwave3_6.m-----------------------------------------
data2=data;
% data2=samp(:,2);

average=0;
a=0;b=0;
k=1;
%-----��ԭʼ�źţ����˵�QRS��Ⱥ��ȡ��Ⱥ����ƽ��ֵ---------------------------------------
n=size(QRSborder,2);
i=0;
k=1;
slp=0;
data3=data2;
while k<n
    a=data2(QRSborder(k));
    b=data2(QRSborder(k+1));
    slp=(b-a)/(QRSborder(k+1)-QRSborder(k));
    for i=QRSborder(k):QRSborder(k+1)
        data2(i)=a+(i-QRSborder(k))*slp;    
    end;
    k=k+2;
end;


n=size(Qwave,2);
k=1;
i=0;
slp=0;
while k<n+1
    a=data3(Qwave(k));
    b=data3(Swave(k));
    slp=(b-a)/(Swave(k)-Qwave(k));
    for i=Qwave(k):Swave(k)
        data3(i)=a+(i-Qwave(k))*slp;
    end;
    k=k+1;
end;



slope2=zeros(datasize-1,1); %��¼�˳�QRS��Ⱥ���slope
for k=1:datasize-1
    slope2(k)=data2(k+1)-data2(k);
end;

%--------------------------------------------------------------------------
peaks2=[];
dis_peaks2=[];
for k=1:size(slope2,1)-1
    if(slope2(k)>0&&slope2(k+1)<0)
        peaks2(end+1)=k+1;                 % ���еĲ���
        dis_peaks2(end+1)=slope2(k)-slope2(k+1);
    end;
end;
n=size(Swave,2);
i=1;
peaks3=[];          % P��T��
for k=1:n-1
    left=Swave(k);
    right=Qwave(k+1);
    comp=[];
    if peaks2(i)<left
        while peaks2(i)<left
            i=i+1;
            if i>size(peaks2,2)
                break;
            end;
        end;
    end;
    if i>size(peaks2,2)
        peaks3(end+1)=0;
        peaks3(end+1)=0;
        break;
    end;
    while peaks2(i)>left && peaks2(i)<right
        comp(end+1)=peaks2(i);
        i=i+1;
        if i>size(peaks2,2);
            break;
        end;
    end;
    if size(comp,2)~=0
        [val,loc]=max(data2(comp));
        peaks3(end+1)=comp(loc);
        comp(loc)=[];
        if size(comp,2)~=0
            [val,loc]=max(data2(comp));
            peaks3(end+1)=comp(loc);
        else 
            peaks3(end+1)=0;
        end;
    else
        peaks3(end+1)=0;
        peaks3(end+1)=0;
    end;
end;

Pwave=[];   % P��
Twave=[];
n=size(peaks3,2);   
k=1;
while k<n
    if peaks3(k)<peaks3(k+1)
        Twave(end+1)=peaks3(k);
        Pwave(end+1)=peaks3(k+1);
    else
        Twave(end+1)=peaks3(k+1);
        Pwave(end+1)=peaks3(k);
    end;
    k=k+2;
end;

n=size(Pwave,2);   
k=1;
Pbegin=[];
Pend=[];
Tbegin=[];
Tend=[];
while k<n+1
    i=Twave(k);
    j=Pwave(k);
 
    if i==0
        Tbegin(end+1)=Swave(k);
        Tend(end+1)=Swave(k);
    else
        i2=i-1;
        i3=i;
        while slope2(i2)>0
            i2=i2-1;
            if i2<1
                break;
            end;
        end;
        while slope2(i3)<0
            i3=i3+1;
        end;
        Tbegin(end+1)=i2;
        Tend(end+1)=i3;
    end;
    
    if j==0
        Pbegin(end+1)=Qwave(k+1);
        Pend(end+1)=Qwave(k+1);
    else
        j2=j-1;
        j3=j;
        while slope2(j2)>0
            j2=j2-1;
            if j2<1
                break;
            end;
        end;
        while slope2(j3)<0
            j3=j3+1;
            if j3>size(slope2,1)
                break;
            end;
        end;
        Pbegin(end+1)=j2;
        Pend(end+1)=j3;
    end;
   
    
    k=k+1;
end


figure(1);hold on;plot(QRS_R,data(QRS_R),'ro');
plot(QRSborder,data(QRSborder),'ro');
plot(Twave,data(Twave),'ro');
plot(Tend,data(Tend),'ro');
plot(Tend,data(Tbegin),'ro');
plot(Tend,data(Pwave),'ro');
plot(Tend,data(Pend),'ro');
plot(Tend,data(Pbegin),'ro');
% end

