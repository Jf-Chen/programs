function correctedData = correctBaseline(correctway,data,frequency)
%CORRECTBASELINE ����ȥ������Ư�ƣ����ѡ��ȥ�뷽ʽ��ѡ��
%   correctway������ѡ��ȥ�뷽ʽ�Ĳ�����ѡ��1Ϊ��ֵ�˲��ķ�ʽȥ��
%   data��ѡ������ʽ������ĵ���60s�źŵ�ĳһ�������ź�����
%   frequency ���źŵĲ���Ƶ��
% frequency=500;
% load data0011.mat;
% correctway=2;

D_1=[];
D_2=[];
D_passed=[];
switch correctway
    case 1
        D_1=medfilt1(data,0.144*frequency);%200ms
        D_2=medfilt1(D_1,0.432*frequency);%600ms��ֵ�˲�
        D_passed=data-D_2;%ȥ�����ź�
        D_passed=medfilt1(D_passed,10);
          correctedData=D_passed;
    case 2
        D_1=medfilt1(data,0.144*frequency);%200ms
        D_2=medfilt1(D_1,0.432*frequency);%600ms��ֵ�˲�
        D_passed=data-D_2;%ȥ�����ź�
        D_passed=medfilt1(D_passed,30);
        %D_passed=D_1;
        
        D_21=medfilt1(data,0.12*frequency);%200ms
        D_22=medfilt1(D_21,0.36*frequency);%600ms��ֵ�˲�
        D_passed2=data-D_22;%ȥ�����ź�
        
%         figure(30);
%         subplot(2,1,1);plot(D_passed);axis tight;
%         subplot(2,1,2);plot(D_passed2);axis tight;%���������Ч����һ��
        correctedData=D_passed;
    case 4  %��ȫ���ܿ�,������Ҫ����
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
        S2=waverec(re_c,L,'sym8');%���Ǹ�L
        correctedData=S2;
end

 %figure(2);plot(correctedData);axis tight;


end

