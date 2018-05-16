function correctedData = correctBaseline(correctway,data,frequency)
%CORRECTBASELINE 用于去除基线漂移，添加选择去噪方式的选项
%   correctway是用于选择去噪方式的参数，选择1为中值滤波的方式去噪
%   data是选择导联方式后输入的单个60s信号的某一导联的信号数据
%   frequency 是信号的采样频率
% frequency=500;
% load data0011.mat;
% correctway=2;

D_1=[];
D_2=[];
D_passed=[];
switch correctway
    case 1
        D_1=medfilt1(data,0.144*frequency);%200ms
        D_2=medfilt1(D_1,0.432*frequency);%600ms中值滤波
        D_passed=data-D_2;%去噪后的信号
        D_passed=medfilt1(D_passed,10);
          correctedData=D_passed;
    case 2
        D_1=medfilt1(data,0.144*frequency);%200ms
        D_2=medfilt1(D_1,0.432*frequency);%600ms中值滤波
        D_passed=data-D_2;%去噪后的信号
        D_passed=medfilt1(D_passed,30);
        %D_passed=D_1;
        
        D_21=medfilt1(data,0.12*frequency);%200ms
        D_22=medfilt1(D_21,0.36*frequency);%600ms中值滤波
        D_passed2=data-D_22;%去噪后的信号
        
%         figure(30);
%         subplot(2,1,1);plot(D_passed);axis tight;
%         subplot(2,1,2);plot(D_passed2);axis tight;%看起来这个效果好一点
        correctedData=D_passed;
    case 4  %完全不能看,至少需要调整
        data=data';
        [C,L]=wavedec(data,8,'sym8');
        cA1=appcoef(C,L,'sym8',1);
        cA2=appcoef(C,L,'sym8',2);
        cA3=appcoef(C,L,'sym8',3);
        cA4=appcoef(C,L,'sym8',4);
        cA5=appcoef(C,L,'sym8',5);
        cA6=appcoef(C,L,'sym8',6);
        cA7=appcoef(C,L,'sym8',7);
        cA8=appcoef(C,L,'sym8',8);
        cD8=detcoef(C,L,8);
        cD7=detcoef(C,L,7);
        cD6=detcoef(C,L,6);
        cD5=detcoef(C,L,5);
        cD4=detcoef(C,L,4);
        cD3=detcoef(C,L,3);
        cD2=detcoef(C,L,2);
        cD1=detcoef(C,L,1);
%         [cD8 cD7 cD6 cD5 cD4 cD3 cD2 cD1]=detcoef(C,L,[8 7 6 5 4 3 2 1]);
        cA8(:,1)=0;
        cD1(:,1)=0;
        cD2(:,1)=0;
        cD3(:,1)=0;
        re_c=[cA8;cD8;cD7;cD6;cD5;cD4;cD3;cD2;cD1];
        S2=waverec(re_c,L,'sym8');%这是个L
        correctedData=S2;
end

 %figure(2);plot(correctedData);axis tight;


end

