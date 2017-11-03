clear all
figure
a=[3 4 1];
b=[1 1];
n=0:30;
x=(n==0);
h=filter(b,a,x);
stem(n,h)

clear
a=[2.5 6 10];b=[1];
h=filter(b,a,delta);
figure;stem(h);
x=ones(1,4);
n=0:9;
h=(7/8).^n;
figure;
stem(conv(x,h));

% 
% n1=-3:3;
% x=[3,11,7,0,-1,4,2];
% n2=-1:4;
% h=[2,3,0,-5,2,1];
% n3=(min(n1)+min(n2)):(max(n1)+max(n2));
% stem(n3,conv(x,h));
