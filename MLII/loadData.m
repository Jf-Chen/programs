function [origindata] = loadData(dataPath,datanum,leadway)
%LOADDATA ��E:\icbeb\TrainingSet�м���A0011.mat
%   �˴���ʾ��ϸ˵��
%   origindata�������ĳһ�����ĵ��źţ���СΪ1xYYYYY
%   dataPath���ļ���·��
%   leadway�ǵ�����ʽ���� 2����MLII


%����ʱĬ��ֵ
% dataPath='E:\icbeb\TrainingSet';
% datanum=1;


%���²��ֿ����Ż�������һ���ִ洢�����������ظ�����
dataPath=[dataPath];
%��ȡĿ¼�������ļ�
fileFolder=fullfile(dataPath);
dirOutput=dir(fullfile(fileFolder,'*.mat'));
fileNames={dirOutput.name}';% fileNames��2000x1 cell������ΪA0001.mat�ȵ�,������char()ת��
filename=char(fileNames(datanum,1));
%����ֻ�Ե����ź�
%---------------��������ģ��start----------------------------------
%��һ������Ч��eval(['load(''E:\icbeb\TrainingSet1\A0001.mat'')'])
loadPath=[dataPath,'\',filename];
eval(['load(loadPath);']);% һ����ECG
% origindata=ECG.data(2,:);
 eval(['origindata=ECG.data(',num2str(leadway),',:);']);
end

