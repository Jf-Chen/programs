%% 示例标题
% 示例目标摘要

%% 节 1 标题
% first 代码块说明


%% 节 2 标题


% load trainFeatures.mat;
% load testFeatures.mat

function saveModel(trainFeatures,testFeatures,beats)
%形成9*8/2个个分类器
allAccuracy=zeros(8,9);
for k=1:8
    for i=k+1:9
        type1=k;
        type2=i;
        modelname=['model',num2str(type1),num2str(type2)];
        modelFileName=['E:\icbeb\programs\MLII\',num2str(beats),'beats\model',num2str(type1),num2str(type2),'.mat'];
        eval(['[',modelname,',accuracy]=oneclassifer(type1,type2,trainFeatures,testFeatures);']);
        eval('save(modelFileName,modelname);');
        allAccuracy(k,i)=accuracy;
    end
    
end
% save E:\icbeb\programs\MLII\Models\allAccuracy.mat allAccuracy;
allAccuracyFileName=['E:\icbeb\programs\MLII\',num2str(beats),'beats\allAccuracy.mat']
allAccuracyName='allAccuracy';
eval('save(allAccuracyFileName,allAccuracyName);');

end

