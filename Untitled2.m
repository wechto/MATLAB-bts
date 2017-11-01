
%% varibale
clc
clear all
close all

n=1000;n_display=10;
b=randi(1,n);
f1=1;f2=2; ffsk_neg=f2;
t=0:1/30:1-1/30;
dt=1/30;
T=n;
df=1/T; N=T/dt;
f=(-N/2:N/2-1)*df;

%% 方便根据信噪比计算误码率------将信号能量转化为单位能量
%% 2ASK
sa_pos=sin(2*pi*f1*t);
E1=sum(sa_pos.^2);
sa_pos=sa_pos/sqrt(E1); %
sa_neg=0*sin(2*pi*f1*t);
%% 2FSK
sf_neg=sin(2*pi*f1*t);
E=sum(sf_neg.^2);
sf_neg=sf_neg/sqrt(E);
sf_pos=sin(2*pi*f2*t);
E=sum(sf_pos.^2);
sf_pos=sf_pos/sqrt(E);
%% 2PSK
sp_neg=-sin(2*pi*f1*t)/sqrt(E1);
sp_pos=sin(2*pi*f1*t)/sqrt(E1);

%% 调制
ask_signal=[];psk_signal=[];fsk_signal=[];
for i=1:n
    if b(i)==1
        ask_signal=[ask_signal sa_pos];
        psk_signal=[psk_signal sp_pos];
        fsk_signal=[fsk_signal sf_pos];
    else
        ask_signal=[ask_signal sa_neg];
        psk_signal=[psk_signal sp_neg];
        fsk_signal=[fsk_signal sf_neg];
    end
end
%% 10个码元序列-----用于波形显示
figure(1)
subplot(4,1,1)
stairs(0:n_display,[b(1:n_display) b(n_display)],'linewidth',1.5)
axis([0 n_display -0.5 1.5]); grid on
subplot(4,1,2)
tb=0:1/30:10-1/30;
plot(tb, ask_signal(1:10*30),'b','linewidth',1.5)
title('2ASK');grid on
subplot(4,1,3)
plot(tb, fsk_signal(1:10*30),'r','linewidth',1.5)
title('2FSK');grid on
subplot(4,1,4)
plot(tb, psk_signal(1:10*30),'k','linewidth',1.5)
title('2PSK');grid on
%% 对全部码元序列计算PSD
figure(2) 
subplot(3,1,1)
pask_signal=(abs(T/N*fftshift(fft(ask_signal(1:T*30)))).^2)/T;
pfsk_signal=(abs(T/N*fftshift(fft(fsk_signal(1:T*30)))).^2)/T;
ppsk_signal=(abs(T/N*fftshift(fft(psk_signal(1:T*30)))).^2)/T;

subplot(3,1,1); plot(f,pask_signal,'linewidth',1.5);axis([-ffsk_neg*2,ffsk_neg*2,0,max(pask_signal)]);
title('2ASK 功率谱');grid on
subplot(3,1,2); plot(f,pfsk_signal,'linewidth',1.5);axis([-ffsk_neg*2,ffsk_neg*2,0,max(pfsk_signal)]);
title('2FSK 功率谱');grid on
subplot(3,1,3); plot(f,ppsk_signal);axis([-ffsk_neg*2,ffsk_neg*2,0,max(ppsk_signal)]);
title('2PSK 功率谱');grid on


%% 添加高斯白噪声计算误码率
biterror_ask=zeros(1,21);
biterror_fsk=zeros(1,21);
biterror_psk=zeros(1,21);
for snr=0:20
    askn=awgn(ask_signal,snr);
    pskn=awgn(psk_signal,snr);
    fskn=awgn(fsk_signal,snr);


    A = zeros(1,n);
    F = zeros(1,n);
    P = zeros(1,n);
    for i=1:n
        if sum(sa_pos.*askn(1+30*(i-1):30*i))>0.5  %相干解调和抽样判决，没有加带通滤波器
            A(i)=1;
        end
        if sum(sf_pos.*fskn(1+30*(i-1):30*i))>0.5
            F(i)=1;
        end
        if sum(sp_pos.*pskn(1+30*(i-1):30*i))>0
            P(i)=1;
        end
    end
    errA=0;errF=0; errP=0;
    for i=1:n
        if A(i)~=b(i)
            errA=errA+1;
        end
        if F(i)~=b(i)
            errF=errF+1;
        end
        if P(i)~=b(i)
            errP=errP+1;
        end
    end
    biterror_ask(snr+1)=errA/n;
    biterror_fsk(snr+1)=errF/n;
    biterror_psk(snr+1)=errP/n;
end
%%
figure(3)
semilogy(0:20,biterror_ask, 'b','linewidth',2)
%plot(0:20,biterror_ask, 'b','linewidth',2)
grid on;
hold on
semilogy(0:20,biterror_fsk,'r','linewidth',2)
semilogy(0:20,biterror_psk, 'k','linewidth',2)
title('biterror rate & S/N')
legend('ASK','FSK','PSK');