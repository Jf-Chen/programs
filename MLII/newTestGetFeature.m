%% ʾ������
% ʾ��Ŀ��ժҪ

%% �� 1 ����
% first �����˵��


%% �� 2 ����
% second �����˵��


% function [collection,oneSignalFeature]=newTestGetFeature(datanum)




% function   [collection]=getFeature(data,extractway)
%GETFEATURE �˴���ʾ�йش˺�����ժҪ
%   collection��extractway==1ʱ��3xYY�ľ��󣬴������ּ��
%   RR��RR��� 1xYY,SP��P�����S���ȼ��,RS��R����S���ȼ��
%   leadway������Χ��1-12������12�ֵ�����ʽ��������MLIIΪʾ��
%   inputPath������·����ĩβ����'\',outputPathͬ��
%   data�Ǿ���correctBaseline�����ݣ�����һ���źŵ�һ������,data��ʽ������1xYYYY
%   extractway����ȡ��ʽ,��1����ȡ��������



%   Ĭ��ֵ
extractway=1;
% load data0001.mat;
%  data=correctBaseline(2,data,500);
dataPath='E:\icbeb\TrainingSet';
% datanum=3261;
% datanum=6671;
% datanum=1668;
% datanum=3861;
% datanum=5223;
% datanum=565;
% datanum=2860;
% datanum=4765;
% datanum=6671;
% datanum=6485;
% datanum=1372;
% datanum=2933;
% datanum=11;

% datanum=2933 ;
% datanum=679;
% datanum=1670;
datanum=46;

leadway=2;
correctway=1;
frequency=500;


[origindata] = loadData(dataPath,datanum,leadway);
% figure(20);plot(origindata);axis tight;
data = correctBaseline(correctway,origindata,frequency);

%GETFEATURE �˴���ʾ�йش˺�����ժҪ
%   collection��extractway==1ʱ��3xYY�ľ��󣬴������ּ��
%   RR��RR��� 1xYY,SP��P�����S���ȼ��,RS��R����S���ȼ��
%   leadway������Χ��1-12������12�ֵ�����ʽ��������MLIIΪʾ��
%   inputPath������·����ĩβ����'\',outputPathͬ��
%   data�Ǿ���correctBaseline�����ݣ�����һ���źŵ�һ������,data��ʽ������1xYYYY
%   extractway����ȡ��ʽ,��1����ȡ��������



%   Ĭ��ֵ
% extractway=1;
% load data0001.mat;
%  data=correctBaseline(2,data,500);



%-----------------------------------------------------------------
figure(1);plot(data);axis tight;
%-------------------------------------------------------------------



% figure(6);plot(data);axis tight;

slope=[];%б�ʣ������õ�1xYYYY-1
derivative=[];%б�ʵĵ����������õ�1xYYYY-2
%---------------��λR����ģ��start----------------------------------
dataLength=size(data,2);

%����������һ���б��
for i=1:dataLength-1
    slope(end+1)=data(1,i+1)-data(1,i);
end

%figure(7);plot(abs(slope));axis tight;title('abs slope');
% figure(8);plot((slope));axis tight;title('slope');

for i=1:dataLength-2
    derivative(end+1)=slope(1,i+1)-slope(1,i);%derivative�ǳ�����һ������һ������е��б�ʵĵ���
end

%���־���

derivative=derivative';
opts = statset('Display','final');
% [IDX_derivative,cluster_center2]=kmeans(derivative,2,'emptyaction','drop');
[IDX_derivative,cluster_center2]=kmeans(derivative,2,'emptyaction','drop','Replicates',5,'Options',opts,'Start','sample');%������������
%����۲�һ��
outputCluster_center2=cluster_center2;
IDX_derivative=IDX_derivative';
IDX_derivative=IDX_derivative-1;%IDX��1��0,��СΪ1xYYYY-2


% figure(2);subplot(2,1,2);%  ��ͼ����IDX�󲿷���0
% plot(IDX_derivative);axis tight;legend('derivative');


absslope=abs(slope);
absslope=absslope';
slope=slope';

[IDX_slope1,cluster_center1]=kmeans(absslope,2,'emptyaction','drop');

% data=data';
% [IDX_slope1,cluster_center1]=kmeans(data,2,'emptyaction','drop');
% data=data';
IDX_slope1=IDX_slope1';
IDX_slope1=IDX_slope1-1;



%-----------------------------------------------------------------
% figure(2);plot(IDX_slope1);axis tight;legend('slope');
%----------------------------------------------------------------------




bound=0;
if sum(IDX_derivative)<size(IDX_derivative,2)
    bound=1;%bound��R����������
end
Rsharp=[];%Rwave,1xYYY,��¼R���������ǵڼ����㣬��Rwave(1,1)=30,��Ӧdata�ĵ�31����

%����б�ʶ�λR���ȽϿ���

%---------------��λR����ģ��end-------------------------------
%��ѧ���ķ���
bound=0;
if sum(IDX_slope1)<size(IDX_slope1,2)/2
    bound=1;
end;
flag=[];
siz=size(IDX_slope1,2)-1;
i=1;
a=0; % ��¼�����ġ�0��������bound==0��
b=0; % ��¼�����ġ�1��������bound==0��
for k=2:siz-1
    if IDX_slope1(k)==bound
        if IDX_slope1(k-1)==1-bound && IDX_slope1(k+1)==bound
            flag(i,1)=1;
            flag(i,2)=k;
            if i>2
                flag(i-1,3)=b;
                b=0;
                flag(i-2,3)=a;
                a=0;
            end;
            i=i+1;
        else
            if IDX_slope1(k-1)==bound && IDX_slope1(k+1)==1-bound
                flag(i,1)=-1;
                flag(i,2)=k;
                i=i+1;
            end;
        end;
        a=a+1;
    end;
    if i>2 && IDX_slope1(k)==1-bound  
        b=b+1;
    end;
end;


%---------------------��һ�μ���-------------------------------------
f=flag(1,1);
loc=flag(1,2);
Rl_border=[];Rr_border=[];
cycle=500;%���ȷ��һ���������ڵĳ��ȣ�
for k=1:size(flag,1)
    if(flag(k,2)-loc>cycle*9/24)
        Rl_border(end+1)=loc;
        Rr_border(end+1)=flag(k-1,2);
        loc=flag(k,2);
    end;
end;
Rl_border(end+1)=loc;
Rr_border(end+1)=flag(k,2);
% figure(1);hold on;plot(Rl_border,data(Rl_border),'rx');plot(Rr_border,data(Rr_border),'rs');
%�۲�ͼ���֪���¶����ˣ�������1800��֮ǰ����ƫ��
R_peak=[];maxR=0;maxloc=0;
for k=1:size(Rl_border,2)
    maxR=-1;maxloc=Rl_border(1,1);
    for i=Rl_border(1,k):Rr_border(1,k)
        if data(1,i)>maxR
            maxR=data(1,i);
            maxloc=i;
        end
    end
     R_peak(end+1)=maxloc;%R_peak 1x40
end
sumR_peakData=0;
for k=1:size(R_peak,2)
    sumR_peakData=sumR_peakData+data(R_peak(1,k));
end
averageR_hight=sumR_peakData/size(R_peak,2);%������R���ľ�ֵ������ڶ��μ������R������������
fprintf('sumR_peakData %f size(R_peak,2) %d ',sumR_peakData,size(R_peak,2));
%-----------------------��һ�μ��� end------------------------------------



%----------------------����ƽ�����ں��ټ���һ��------------------------------
sumRR=0;averageRR=0;
for k=2:size(R_peak,2) %����ƽ��RR�����Ϊ����
    sumRR=sumRR+R_peak(k)-R_peak(k-1);
end
tempRinterval=size(R_peak,2);
fprintf('R_peak= %d ',tempRinterval);
if size(R_peak,2)<1
    temp=1;
end
averageRR=sumRR/tempRinterval;
f=flag(1,1);
loc=flag(1,2);
Rl_border=[];Rr_border=[];
cycle=500;%���ȷ��һ���������ڵĳ��ȣ�
for k=1:size(flag,1)
    if(flag(k,2)-loc>2/3*averageRR)  %-------------------�˴�ֵ����ȶ-------------
        Rl_border(end+1)=loc;
        Rr_border(end+1)=flag(k-1,2);
        loc=flag(k,2);
    end;
end;
Rl_border(end+1)=loc;
Rr_border(end+1)=flag(k,2);
% figure(1);hold on;plot(Rl_border,data(Rl_border),'rx');plot(Rr_border,data(Rr_border),'rs');
%�۲�ͼ���֪���¶����ˣ�������1800��֮ǰ����ƫ��
clear R_peak;
R_peak=[];maxR=0;maxloc=0;
for k=1:size(Rl_border,2)
    maxR=averageR_hight*5/6;%maxloc=Rl_border(1,1); %---------------ƽ����R�������-----------����������������
    maxloc=0;
    for i=Rl_border(1,k):Rr_border(1,k)
        if data(1,i)>maxR
            maxR=data(1,i);
            maxloc=i;
        end
    end
    if maxloc ~= 0
         R_peak(end+1)=maxloc;%R_peak 1x40
    end
    
end

%----------------------����ƽ�����ں��ټ���һ�� end--------------------------

%����averageR_hight��Rl_border��Rr_borderҲ��Ҫ���¼������ƺ�����


%----------------------------------------------------------------------------
figure(1);hold on;plot(R_peak,data(R_peak),'ro');
%----------------------------------------------------------------------------



%-----------���P��S----------------------------
%Ŀǰ����R���߽粻���S��������ȥ������ʹ����R������ǰ����������ȣ�б��һ��һ���ĵ㣩
%ǰ����ȥ���㷨�㹻�ã�û��ë��
%ȥ��б��ͼ�е�ë��
%��ΪQ����������֤������ʹ��P�����S���ȣ�ʹ��P_peak,S_trough��ʾ
% P���壺R����֮ǰ��б������ת������֤5�����б�ʶ�����Ȼ��֮��5�����б�ʶ��Ǹ���ѡȡ��ߵ�
% R����֮ǰ5/12���ڵ�����б��һ��һ���ĵ�ȡ�����Ǹ�����ʱ�������RR������
newslope=correctBaseline(1,slope,500);
% figure(9);plot(newslope);axis tight;title('corrected slope')
sumRR=0;averageRR=0;
for k=2:size(R_peak,2) %����ƽ��RR�����Ϊ����
    sumRR=sumRR+R_peak(k)-R_peak(k-1);
end
tempRinterval=size(R_peak,2);
fprintf('R_peak= %d ',tempRinterval);
if size(R_peak,2)<1
    temp=1;
end
averageRR=sumRR/tempRinterval;
%Ѱ��P_peak
tempR=0;startP=0;maxPdata=0;maxPi=0;
P_peak=[];% ��¼P����
for i=1:size(R_peak,2)
    tempR=R_peak(1,i);
    endP=tempR-averageRR/12;
    endP=round(endP);
    endP=max(endP,1);
    startP=max(tempR-averageRR/3,0);%��ֹR����ǰ1/3���ڳ���0��ͬ��������Ҫ���ǳ���data��ĩβ
    startP=round(startP);
    endP=max(endP,startP+2);
    %----------------��������һ��
    %endP=max(tempR-averageRR/12,startP+2);
    %-------------------------
    maxPdata=0;maxPi=startP+2;
    
%     if((k-1)<=0 || k>size(slope,2))
%         error(['��λR�������k�͵�ǰ�ļ� k=',num2str(k)...
%             ,'  averageRR/12=',num2str(averageRR/12)...
%             ,'  startP=',num2str(startP)...
%              ,'  endP=',num2str(endP)...
%             ,'  sizeof slope=',num2str(size(slope,1))]);
%         
%     end
    %for k=startP+2:tempR-averageRR/12 %����󻻳������
    for k=startP+2:endP
        if slope(k-1)>=0&&slope(k)<=0
            if maxPdata<data(k)
                maxPi=k;
                maxPdata=data(k);
            end
        end
    end
    P_peak(end+1)=maxPi;
end
 %�鿴���  
 
 
 
 
%----------------------------------------------------------------------------
 figure(1);hold on;plot(P_peak,data(P_peak),'rx'); %����׼ȷ���ܵ�ȥ��Ч����Ӱ��
%----------------------------------------------------------------------------
 
 
 
 
 
 %Ѱ��S��
 tempR=0;endS=0;minSdata=0;minSi=0;
 S_trough=[];
 for i=1:size(R_peak,2)
     tempR=R_peak(1,i);
     endS=min(tempR+averageRR/2,size(data,2));% S�������δ�Լ��һ��֮�ڣ�Ϊ�˱��ⲡ�������ȡ������RR�����ڵ���Сֵ
     minSdata=0;minSi=endS;
     for k=tempR:endS
         if minSdata>data(k)
             minSdata=data(k);
             minSi=k;
         end
     end
     S_trough(end+1)=minSi;
 end
 
 
 
%---------------------------------------------------
figure(1);hold on;plot(S_trough,data(S_trough),'r^');  %����׼ȷ
%------------------------------------------------------------------------
  
  
  
%-----------���P��S end-----------------
collection=[];RR=[];SP=[];RS=[];
switch extractway
    case 1
        
        
        %��֮ǰ�Ĳ�ͬ���²��źŵ���β����һ������R������һ������P,S��,
        %������R����֮��Ϊһ�����ڽ���ͳ�ƣ�
        %PS��һ��RR����ڵľ��룬RS��S���뿿ǰ��R����֮��ľ���
        for k=1:size(R_peak,2)-1
            RR(end+1)=R_peak(k+1)-R_peak(k);
            SP(end+1)=P_peak(k+1)-S_trough(k);
            RS(end+1)=S_trough(k+1)-R_peak(k);
            collection=[RR;SP;RS];%��һ��䲻�����ǰ����RR,SP,RS������һ��
        end

end

%Ȼ����ʲô����,���һ����м򵥵ķ�����ѵ��


% clear data;
% clear dataLength derivative IDX_derivative;
% clear absslope data slope;
% clear IDX_slope Rl_border Rrborder;
% clear R_peak maxR maxloc;
% clear newslope tempRinterval averageRR;
% clear sumRR P_peak tempR;
% clear startP maxPdata maxPi;
% clear endS minSdata minSi;
% clear S_trough RR SP;
% clear RS extractway;
% 
% 




 beats=5;
 oneSignalFeature = averageFeature(beats,collection);
%Ȼ����ʲô����,���һ����м򵥵ķ�����ѵ��



% end
% end
