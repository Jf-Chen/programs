function [collection,outputCluster_center2] = getFea4(data,extractway)
%GETFEA 与getFeature类似，添加了T波峰特征，如果可以，函数名由getFea变成getFeature
%   collection在extractway==1时是X x YY的矩阵，X=4，代表四种间隔，加入了RT间隔
%   RR是RR间隔 1xYY,SP是P波峰和S波谷间隔,RS是R波峰S波谷间隔
%   leadway参数范围是1-12，代表12种导联方式，这里以MLII为示例
%   inputPath是输入路径，末尾包含'\',outputPath同理
%   data是经过correctBaseline的数据，代表一个信号的一个导联,data格式必须是1xYYYY
%   extractway是提取方式,如1是提取三个特征
  
end

