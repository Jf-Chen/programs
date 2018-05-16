function [model,accuracy] = oneclassifer(type1,type2,trainFeatures,testFeatures)
%ONECLASSIFER 由输入的参数决定是哪两个类型之间的分类器
%   此处显示详细说明
%   type1,type2是类型，数值是1--9
%   trainFeatures是训练特征数据

trainMatrix1=trainFeatures{1,type1};% 直接得到矩阵1000x15 double
trainMatrix2=trainFeatures{1,type2};
Trtype1type2=[trainMatrix1;trainMatrix2];
[Trtype1type2,PSr] = mapminmax(Trtype1type2);
TrType1Type2Label=zeros(size(Trtype1type2,2));
TrType1Type2Label(1:size(trainMatrix1,1),1)=1;
TrType1Type2Label(size(trainMatrix1,1)+1:end,1)=-1;

%1000x15维不知道对不对需要验证一下，写一个testOneclassifer进行验证
model=svmtrain(TrType1Type2Label,Trtype1type2,'-c 1 -g 16');


%测试一下准确率
testMatrix1=testFeatures{1,type1};
testMatrix2=testFeatures{1,type2};
Te2type=[testMatrix1;testMatrix2];
[Te2type,PSe]=mapminmax(Te2type);
Te2typeLabel=zeros(size(Te2type,2));
Te2typeLabel(1:size(testMatrix1,1),1)=1;
Te2typeLabel(size(testMatrix1,1)+1:end,1)=-1;


[predictLabel,accuracy,dec_values]=svmpredict(Te2typeLabel,Te2type,model);




end

