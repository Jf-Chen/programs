%% ʾ������
% ʾ��Ŀ��ժҪ

%% �� 1 ����
% first �����˵��


%% �� 2 ����
% second �����˵��

% function saveModel()
load trainFeatures.mat;
load testFeatures.mat

function saveModel()
%�γ�9*8/2����������
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

%---------------�γ��ܵķ���ģ�� end-----------------------

end

% end