function  predictClasstManyMat()
%PREDICCLASSTMANYMAT 读取多个文件，输出结果到
%E:\icbeb\programs\MLII\9beats\result.txt ，按照列排序
%   此处显示详细说明
%   filePaths是一个1xYYY的矩阵？看VS选择多个文件的结果吧


%默认值
modelPath='E:\icbeb\programs\MLII\9beats\';
leadway=2;
correctway=1;
extractway=1;
frequency=500;



alltype=[];
%读取文件,第一行表示下面有多少行，然后逐行读取
filePath='E:\graduate_design\MFCApplication2\MFCApplication2\manyVSPath.txt';
fid1=fopen(filePath);
line_ex = fgetl(fid1);
linenum=str2num(line_ex);

filePath=cell(1,linenum);

for i=1:linenum
    tempPath=fgetl(fid1);
    filePath{1,i}=tempPath;
end
fclose(fid1);


for k=1:size(filePath,2)
    dataOriginPath=filePath{1,k};
    [TypeResult,predictLabel,allresult,finalResult] = predictClass(dataOriginPath,modelPath,leadway,frequency,correctway,extractway);
    alltype(end+1)=TypeResult;
end

%-------------将alltype存储到E:\graduate_design\MFCApplication2\MFCApplication2\typeResult.txt
fid2=fopen('E:\graduate_design\MFCApplication2\MFCApplication2\typeResult.txt','w');
for k=1:linenum
    fprintf(fid2,'%d\r\n',alltype(1,k));
end
fclose(fid2);


end

