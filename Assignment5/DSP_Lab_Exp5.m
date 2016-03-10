clc;clear all;close all;

A=2;
fo=2e3; %frequency 
fs=4*fo;
t=1:1/fs:2;

m=A*sin(2*pi*fo*t);
n=0.5*normrnd(0,1,1,length(t));
x=m+n;

figure;plot(n);title('Noise');
figure;
subplot(2,1,1); plot(t,m);title('Signal');
subplot(2,1,2); plot(t,x);title('Signal+Noise');

N=20;
w=zeros(1,N);%suppose N order filters

epsilon=1;%for the loop to iterate once
threshold=10e-8;i=0;mu=10e-4;
while  epsilon>threshold
    w_old=w;
    error(i+1,1)= x(1,i+N+1)-w*(x(N+i:-1:1+i))';
    w=w+mu*x(N+i:-1:1+i)*error(i+1,1);
    epsilon=(norm(w-w_old)/norm(w_old))^2;
    i=i+1;
end

[h, omega] = freqz(fliplr(w), 1, linspace(-pi,pi,1000));
figure;
plot (linspace(-fs/2,fs/2,length(omega)) , fftshift(abs (h)) .^ 2) ;
title(sprintf('Latest Transfer Function of Adaptive filter at frequency, Fo=%d KHz',fo/1000));
xlabel('Frequency (Hz)'),ylabel('Amplitude');

