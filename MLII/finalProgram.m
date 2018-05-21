function  finalProgram(leadway,dataPath,beats)
%FINALPROGRAM 该函数每次只处理一个存储文件的信号，即A0001.mat，得出一个输出结果，命名为Result0001.mat，
%首先经过correctBaseline去噪，之后经过getFeature得到特征（RR,QR,QS）
%
%   leadway参数范围是1-12，代表12种导联方式，这里以MLII为示例
%   dataPath是文件夹，添加上foldernum是完整的文件夹路径，末尾不包含'\',
%  
%   

%测试时默认值

leadway=2;
frequency=500;
dataPath='E:\icbeb\TrainingSet';
inputPath=[dataPath];
csvPath='E:\icbeb\REFERENCE.csv';
share=11; %每种取1/11作为测试集，10/11作为训练集，如果要进行交叉验证用10折交叉验证




%获取目录下所有文件,取得fileNames大小
fileFolder=fullfile(inputPath);
dirOutput=dir(fullfile(fileFolder,'*.mat'));
fileNames={dirOutput.name}';% fileNames是2000x1cell，内容为A0001.mat等等,可以用char()转化
filename=char(fileNames(1,1));
allFileNum=size(fileNames,1);

%---------------加载专家注释---------------
%每种取1/11作为测试集，10/11作为训练集，如果要进行交叉验证用10折交叉验证
[annotation,testSet,trainSet] = newSeparate(csvPath,share); %所有的注释，测试集和训练集
TeSetName=['E:\icbeb\programs\MLII\',num2str(beats),'beats\TeSets.mat',];
TrSetName=['E:\icbeb\programs\MLII\',num2str(beats),'beats\TrSets.mat',];
testSetName='testSet';
trainSetName='trainSet';
eval('save(TeSetName,testSetName);');
eval('save(TrSetName,trainSetName);');
%---------------加载专家注释end------------------

%---------------进行10折交叉验证--------------------------------------
%不验证了，写在oneclassifer里
%---------------进行10折交叉验证 end-------------------------------

%---------------形成总的分类模型---------------------------
%变量名为trainFeatures5beats，但是存储在按心跳分开的文件夹中，且命名为为5beats\trainFeatures5beats.mat
trainFeaturesFileName=['E:\icbeb\programs\MLII\',num2str(beats),'beats\trainFeatures',num2str(beats),'beats.mat'];
trainFeaturesName=['trainFeatures',num2str(beats),'beats'];
testFeaturesFileName=['E:\icbeb\programs\MLII\',num2str(beats),'beats\testFeatures',num2str(beats),'beats.mat'];
testFeaturesName=['testFeatures',num2str(beats),'beats'];
%[trainFeatures,trBeReplacedFile] = combineFeature(trainSet,leadway,beats);
eval(['[',trainFeaturesName,',trBeReplacedFile] = combineFeature(trainSet,leadway,beats);']);
eval(['[',testFeaturesName,',teBeReplacedFile] = combineFeature(testSet,leadway,beats);']);
eval('save(trainFeaturesFileName,trainFeaturesName);');
% save('trainFeatures.mat','trainFeatures');
% save testFeatures.mat testFeatures

%----------------形成9*8/2个个分类器---------------------------------------
eval(['saveModel(',trainFeaturesName,',',testFeaturesName,',beats);']);
%----------------形成9*8/2个个分类器 end------------------------------------


%---------------形成总的分类模型 end-----------------------

end

