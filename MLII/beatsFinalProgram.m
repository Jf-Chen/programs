function beatsFinalProgram(startBeats,endBeats)
%BEATSFINALPROGRAM 此处显示有关此函数的摘要
%   按照心跳数取1-15形成训练集和分类器
leadway=2;
dataPath='E:\icbeb\TrainingSet';
for i=startBeats:endBeats
    beats=i;
    finalProgram(leadway,dataPath,beats);
end


end

