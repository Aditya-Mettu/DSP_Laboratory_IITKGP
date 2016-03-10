%%%%%%%%%%%%%% PART 1 %%%%%%%%%%%%%%
% Code for Sampling of a Sinusoidal Waveform 
f=12000;% Sampling with 12KHz

x= linspace(0,1,f);
% given function and samples
y= 10*cos(2*pi*1000*x)+6*cos(2*2*pi*1000*x)+2*cos(4*2*pi*1000*x);%frequecy = 1Khz

% Computed 64,128,256 point DFT
a1=abs(fft(y(1:64)));
a2=abs(fft(y(1:128)));
a3=abs(fft(y(1:256)));

figure;
subplot(2,2,1);

p=strcat('sampling freq ',num2str(f));
annotation('textbox',[0.85 0.8 0.08 0.08],'String',strcat(num2str(f),' Hz'));
stem(0:2*pi/64:2*pi*63/64,a1);
xlabel('Angular frequency');
ylabel('Amplitude- 64 point DFT');

subplot(2,2,2);
stem(0:2*pi/128:2*pi*127/128,a2);
ylabel('Amplitude- 128 point DFT');
xlabel('Angular frequency');
subplot(2,2,3);
stem(0:2*pi/256:2*pi*255/256,a3);

ylabel('Amplitude- 256-point DFT');
xlabel('Angular Frequency');

%%%%%%%%%%%%%% PART 2 %%%%%%%%%%%%%%
% Code for Sampling at below Nyquist rate and effect of aliasing
arr=[8001,5001,4001];

for i=1:3
% Sampling with 12KHz,8KHz, 5KHz, 4 KHz frequency
x= linspace(0,1,arr(i));
% given function and samples
y= 10*cos(2*pi*1000*x)+6*cos(2*2*pi*1000*x)+2*cos(4*2*pi*1000*x);%frequecy = 1Khz
% Computed 64,128,256 point DFT

a1=abs(fft(y(1:64)));
a2=abs(fft(y(1:128)));
a3=abs(fft(y(1:256)));

figure;
title('Sampling at below Nyquist rate and effect of aliasing');
subplot(2,2,1);
p=strcat('sampling freq ',num2str(arr(i)-1));
annotation('textbox',[0.85 0.8 0.08 0.08],'String',strcat(num2str(arr(i)-1),' Hz'));
stem(0:2*pi/64:2*pi*63/64,a1);
xlabel('Angular frequency');
ylabel('Amplitude- 64 point DFT');

subplot(2,2,2);
stem(0:2*pi/128:2*pi*127/128,a2);
ylabel('Amplitude- 128 point DFT');
xlabel('Angular frequency');

subplot(2,2,3);
stem(0:2*pi/256:2*pi*255/256,a3);
ylabel('Amplitude- 256-point DFT');
xlabel('Angular Frequency');

end

%%%%%%%%%%%%%% PART 3 %%%%%%%%%%%%%%
%Code for Spectrum of a Square Wave
% Sampling of square wave of T=1 ms with sampling frequency 20kHz

ys=linspace(0,1,20001);
xsq= square(2*pi*1000*ys);%frequecy = 1Khz
xsqs= xsq(1,1:256);
z= fftshift(abs(fft(xsqs)));

figure;
plot(-128*2*pi/256:pi/128:127*pi/128,z,'r');
title('Spectrum of a Square Wave');
xlabel('Digital Frequency');
ylabel('AMPLITUDE');

%Code for Interpolation or Up sampling
% first Sampling frequency 12 KHz and then upsampling factor 2

% find the error
x=linspace(0,1,12001);
y= 2*sin(2*pi*2000*x)+3*cos(2*pi*3000*x)+5*cos(2*pi*5000*x);
y1=fft(y,256);

subplot(2,1,1);
stem(-pi:2*pi/256:127*2*pi/256,fftshift(abs(y1)));
title('Original Sequence DFT');

y2=y(1:257);
y3=zeros(1,513);
for i=1:257
 y3(1,2*i-1)=y2(i);
end
% notice that size of y3 is 513, not 512

subplot(2,1,2);
stem(-pi:2*pi/512:255*2*pi/512,fftshift(abs(fft(y3,512))));
title('DFT after padding Zeros');

y4=fft(y3,512);
y4(1,129:385)=zeros(1,257);
yi4= ifft(y4);
x=0:1/24000:1/24;
z1= 2*sin(2*pi*2000*x)+ 3*cos(2*pi*3000*x)+ 5*cos(2*pi*5000*x);
z1s= z1(1:512);

figure;

subplot(2,2,1);
stem(1:512,z1s); title('Original sequence sampled at 24 KHz');

subplot(2,2,2);
stem(1:512,yi4); title('Upsampled sequence');

subplot(2,2,3);
stem(1:512,z1s-2*yi4);title('Error');



%%%%%%%%%%%%%% Additional Question %%%%%%%%%%%%%%
xlabel('Time ------>');ylabel('Magnitude ------>');t=0:1/20000:10;
s=square(2*pi*1000*t);
S=fft(s,256);
sz=S;
sz(1,36:39)=[0 0 0 0];
sz(1,217:220)=[0 0 0 0];
szr= ifft(sz);
s_abs=abs(S);
s1=ifft(S);

error=s(1:256)-s1;

subplot(2,2,1);
plot(t(1:256),s(1:256));
xlabel('Time ------>');ylabel('Amplitude ------>');
title('Original Signal: Square Wave Sampled at 20KhZ');
axis([0 .01 -2 2]);

subplot(2,2,2);
plot((-128:127)*10/128,fftshift(s_abs));
xlabel('Frequency (in KHz)------>');ylabel('Magnitude ------>');
title('DFT of Square Wave');

subplot(2,2,3);
plot(t(1:256),s1);axis([0 .01 -2 2]);
xlabel('Time ------>');ylabel('Amplitude ------>');
title('Recovered Signal');

subplot(2,2,4);
plot(1:256,error);
xlabel('Time ------>');ylabel('Magnitude ------>');
title('Error between Original Signal and Recovered Signal');

figure;
plot(t(1:256),szr);
axis([0 0.01 -2 2]);
title('Square wave after removing 3KHz component');
xlabel('time------>');
ylabel('Amplitude------>');

ms=rms(error);