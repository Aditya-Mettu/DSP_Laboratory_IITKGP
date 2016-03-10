close all;
clc;

Num=input('Enter a number','s');
Num = strtrim(Num);

omega1=0;omeg2=0;
if(Num=='1' || Num=='2' || Num=='3' || Num=='A')
    omega1=697;
end
if(Num=='4' || Num=='5' || Num=='6' || Num=='B')
    omega1=770;
end;
if(Num=='7' || Num=='8' || Num=='9' || Num=='C')
    omega1=852;
end;
if(Num=='*' || Num=='0' || Num=='#' || Num=='D')
    omega1=941;
end;


if(Num=='1' || Num=='4' || Num=='7' || Num=='*')
    omega2=1209;
end
if(Num=='2' || Num=='5' || Num=='8' || Num=='0')
    omega2=1336;
end;
if(Num=='3' || Num=='6' || Num=='9' || Num=='#')
    omega2=1477;
end;
if(Num=='A' || Num=='B' || Num=='C' || Num=='D')
    omega2=1633;
end;

res=zeros(1,8);
tim=linspace(0,1,8192);
n=tim;
signal=cos(2*pi*omega1*tim)+cos(2*pi*omega2*tim);
flist=0:10:2000;
for i=1:201
    Wc=2*pi*flist(1,i);
    b=2;
    
    h=b*cos(Wc*n);
    x=conv(h,signal);
    
    res(1,i)=max(abs(fft(x)));
end
plot(flist,res);grid on;
title(strcat('DTMF decoded frequency spectrum for ', num2str( Num),' '));xlabel('Frequency-------->');ylabel('Magnitude -------->');


