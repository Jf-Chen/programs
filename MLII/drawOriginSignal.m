function  drawOriginSignal()
%DRAWORIGINSIGNAL �˴���ʾ�йش˺�����ժҪ  ��ԭʼͼ��
%   �˴���ʾ��ϸ˵��
leadway=2;


filePath='E:\graduate_design\MFCApplication2\MFCApplication2\oneVSPath.txt';
fid4=fopen(filePath);
loadPath = fgetl(fid4);
fclose(fid4);
filename=loadPath(end-8:end-4);

eval(['load(loadPath);']);
 eval(['origindata=ECG.data(',num2str(leadway),',:);']);
 
 figure(21);plot(origindata);title([filename,' originData']);axis tight;
end

