function  predictClasstManyMat()
%PREDICCLASSTMANYMAT ��ȡ����ļ�����������
%E:\icbeb\programs\MLII\9beats\result.txt ������������
%   �˴���ʾ��ϸ˵��
%   filePaths��һ��1xYYY�ľ��󣿿�VSѡ�����ļ��Ľ����


%Ĭ��ֵ
modelPath='E:\icbeb\programs\MLII\9beats\';
leadway=2;
correctway=1;
extractway=1;
frequency=500;



alltype=[];
%��ȡ�ļ�,��һ�б�ʾ�����ж����У�Ȼ�����ж�ȡ
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

%-------------��alltype�洢��E:\graduate_design\MFCApplication2\MFCApplication2\typeResult.txt
fid2=fopen('E:\graduate_design\MFCApplication2\MFCApplication2\typeResult.txt','w');
for k=1:linenum
    fprintf(fid2,'%d\r\n',alltype(1,k));
end
fclose(fid2);


end

