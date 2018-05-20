%% 示例标题
% 示例目标摘要

%% 节 1 标题
% first 代码块说明


%% 节 2 标题
% second 代码块说明

% function saveModel()
load trainFeatures.mat;
load testFeatures.mat

function saveModel()
%形成9*8/2个个分类器
allAccuracy=zeros(8,9);
for k=1:8
    for i=k+1:9
        type1=k;
        type2=i;
        modelname=['model',num2str(type1),num2str(type2)];
        modelFileName=['E:\icbeb\programs\MLII\Models\model',num2str(type1),num2str(type2),'.mat'];
        
        eval(['[',modelname,',accuracy]=oneclassifer(type1,type2,trainFeatures,testFeatures);']);
        eval('save(modelFileName,modelname);');
        allAccuracy(k,i)=accuracy;
    end
    
end
save E:\icbeb\programs\MLII\Models\allAccuracy.mat allAccuracy;

%---------------形成总的分类模型 end-----------------------

end

% end