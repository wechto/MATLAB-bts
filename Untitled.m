
%% variable 
clc
clear all

A0=1;A1=1; A2=1;
dt=0.0001;  T=3; 
df=1/T; N=T/dt;
f=(-N/2:N/2-1)*df;
f1=1; w1=2*pi*f1;
f2=10; w2=2*pi*f2;
fc=f2; fs=1/dt;

x=0:dt:(T-dt);
y1=A1*sin(w1.*x);
y2=A2*cos(w2.*x);
%% m(t)  c(t)
figure(1)
subplot(2,1,1); plot(x,y1,'linewidth',1.5); grid on
title('m(t)');
subplot(2,1,2); plot(x,y2,'linewidth',1.5); grid on
title('c(t)');
figure(2)

%% AM
yAM=(A0+y1).*y2;                                 % AM 

pAM=fft(yAM); pAM=T/N*fftshift(pAM);  % fft&shift 
pAM=(abs(pAM).^2)/x(end);

subplot(2,3,1); plot(x,yAM); axis([x(1),x(N),1.2*min(yAM),1.2*max(yAM)]); grid on 
title('AM');
subplot(2,3,4); plot(f,pAM); axis([-1.5*f2,1.5*f2,0,max(pAM)]); grid on
title('功率谱');
%% DSB
yDSB=y1.*y2;                                 % DSB 

pDSB=fft(yDSB); pDSB=T/N*fftshift(pDSB);  % fft&shift 
pDSB=(abs(pDSB).^2)/x(end);

subplot(2,3,2); plot(x,yDSB);  axis([x(1),x(N),1.2*min(yDSB),1.2*max(yDSB)]); grid on 
title('DSB');
subplot(2,3,5); plot(f,pDSB); axis([-1.5*f2,1.5*f2,0,max(pDSB)]); grid on
title('功率谱');
%% SSB
ySSB=real(hilbert(y1).*exp(1i*2*pi*f2*x));

pSSB=fft(ySSB); pSSB=T/N*fftshift(pSSB);  % fft&shift 
pSSB=(abs(pSSB).^2)/x(end);

subplot(2,3,3); plot(x,ySSB);  axis([x(1),x(N),1.2*min(ySSB),1.2*max(ySSB)]); grid on 
title('SSB');
subplot(2,3,6); plot(f,pSSB); axis([-1.5*f2,1.5*f2,0,max(pSSB)]); grid on
title('功率谱');

demod_am=demod(yAM,fc,fs,'am');
demod_dsb=demod(yDSB,fc,fs,'amdsb-sc');
demod_ssb=demod(ySSB,fc,fs,'amssb');
%% 解调
figure(3)

subplot(3,1,1); plot(x,demod_am,x,y1,'r');grid on
title('AM相干解调')
subplot(3,1,2); plot(x,demod_dsb,x,y1,'r');grid on
title('DSB相干解调')
subplot(3,1,3); plot(x,demod_ssb,x,y1,'r');grid on
title('SSB相干解调')