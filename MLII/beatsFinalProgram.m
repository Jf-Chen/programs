function beatsFinalProgram(startBeats,endBeats)
%BEATSFINALPROGRAM �˴���ʾ�йش˺�����ժҪ
%   ����������ȡ1-15�γ�ѵ�����ͷ�����
leadway=2;
dataPath='E:\icbeb\TrainingSet';
for i=startBeats:endBeats
    beats=i;
    finalProgram(leadway,dataPath,beats);
end


end

