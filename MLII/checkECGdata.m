%% ʾ������
% ʾ��Ŀ��ժҪ

%% �� 1 ����
% first �����˵��


%% �� 2 ����
% second �����˵��

load E:\icbeb\TrainingSet1\A0011.mat;
figure(1);
subplot(4,1,1);plot(ECG.data(1,:));
subplot(4,1,2);plot(ECG.data(2,:));
subplot(4,1,3);plot(ECG.data(3,:));
subplot(4,1,4);plot(ECG.data(4,:));

figure(2);
subplot(4,1,1);plot(ECG.data(1+4,:));
subplot(4,1,2);plot(ECG.data(2+4,:));
subplot(4,1,3);plot(ECG.data(3+4,:));
subplot(4,1,4);plot(ECG.data(4+4,:));

figure(3);
subplot(4,1,1);plot(ECG.data(1+4*2,:));
subplot(4,1,2);plot(ECG.data(2+4*2,:));
subplot(4,1,3);plot(ECG.data(3+4*2,:));
subplot(4,1,4);plot(ECG.data(4+4*2,:));