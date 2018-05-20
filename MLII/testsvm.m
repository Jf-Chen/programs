%% 示例标题
% 示例目标摘要

%% 节 1 标题
% first 代码块说明


%% 节 2 标题
% second 代码块说明

testTrType1Type2Label=[2;2;2;2;5];
testTrtype1type2=[1;1;1;1;-1];
testmodel=svmtrain(testTrType1Type2Label,testTrtype1type2,'-c 1 -g 16');

testTe2typeLabel=[2;2;2;5;2];
testTe2type=[1;1;1;1;-1];
[testpredictLabel,testaccuracy,testdec_values]=svmpredict(testTe2typeLabel,testTe2type,testmodel);
