function drawCorrectedData()
%DRAWORIGINSIGNAL �˴���ʾ�йش˺�����ժҪ  ��ԭʼͼ��
%   �˴���ʾ��ϸ˵��
leadway=2;
correctway=1;
frequency=500;

filePath='E:\graduate_design\MFCApplication2\MFCApplication2\oneVSPath.txt';
fid3=fopen(filePath);
loadPath = fgetl(fid3);
fclose(fid3);
filename=loadPath(end-8:end-4);

eval(['load(loadPath);']);
eval(['origindata=ECG.data(',num2str(leadway),',:);']);

correctedData = correctBaseline(correctway,origindata,frequency);
 
figure(22);plot(correctedData);title([filename,' correctedData']);axis tight;



end

