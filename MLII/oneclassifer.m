function [model,accuracy] = oneclassifer(type1,type2,trainFeatures,testFeatures)
%ONECLASSIFER ������Ĳ�������������������֮��ķ�����
%   �˴���ʾ��ϸ˵��
%   type1,type2�����ͣ���ֵ��1--9
%   trainFeatures��ѵ����������

trainMatrix1=trainFeatures{1,type1};% ֱ�ӵõ�����1000x15 double
trainMatrix2=trainFeatures{1,type2};
Trtype1type2=[trainMatrix1;trainMatrix2];
[Trtype1type2,PSr] = mapminmax(Trtype1type2);
TrType1Type2Label=zeros(size(Trtype1type2,2));
TrType1Type2Label(1:size(trainMatrix1,1),1)=1;
TrType1Type2Label(size(trainMatrix1,1)+1:end,1)=-1;

%1000x15ά��֪���Բ�����Ҫ��֤һ�£�дһ��testOneclassifer������֤
model=svmtrain(TrType1Type2Label,Trtype1type2,'-c 1 -g 16');


%����һ��׼ȷ��
testMatrix1=testFeatures{1,type1};
testMatrix2=testFeatures{1,type2};
Te2type=[testMatrix1;testMatrix2];
[Te2type,PSe]=mapminmax(Te2type);
Te2typeLabel=zeros(size(Te2type,2));
Te2typeLabel(1:size(testMatrix1,1),1)=1;
Te2typeLabel(size(testMatrix1,1)+1:end,1)=-1;


[predictLabel,accuracy,dec_values]=svmpredict(Te2typeLabel,Te2type,model);




end

