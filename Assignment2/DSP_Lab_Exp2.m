close all;clear;

fc=.15;
wc=2*pi*fc;
hd=zeros(5,512);H=zeros(5,512);
N=[8 64 512];

for il=1:3
    figure;
    h=zeros(1,512); n=1:1:512;size_n=size(n);
    w=-pi:pi/N(1,il):pi-pi/N(1,il);
    k1 =floor((N(1,il)-1)/2);
    for k=1:N(1,il)-1
        if k==k1
            h(1,k)=wc/pi;
        else
            h(1,k)= sin(wc*(n(1,k)-k1))/(pi*(n(1,k)-k1));title('Sinc Function');
        end
    end
    plot(h);
    
    for count=1:5
        if count==1
            for i=1:size_n(1,2)
                if n(1,i)<N(1,il)-1
                    H(count,i)=1;
                else
                    H(count,i)=0;
                end
            end
            
            figure;
            hd(count,:)= h.*H(count,:);
            freqz(hd(count,:),1,w);title('Rectangular Window');
        end
        
        if count==2
            for i=1:size_n(1,2)
                if n(1,i)<N(1,il)-1
                    H(count,i)=1-2*(n(1,i)-(N-1)/2)/(N-1);
                else
                    H(count,i)=0;
                end
                
            end
            
            figure;
            hd(count,:)= h.*H(count,:);
            freqz(hd(count,:),1,w);title('Triangular Window');
        end
        
        if count==3
            for i=1:size_n(1,2)
                if n(1,i)<N(1,il)-1
                    H(count,i)=0.5-0.5*cos(2*pi*n(1,i)/(N(1,il)-1));
                else
                    H(count,i)=0;
                end
            end
            
            figure;
            hd(count,:)= h.*H(count,:);
            freqz(hd(count,:),1,w);title('Hanning Window');
        end
        
        if count==4
            for i=1:size_n(1,2)
                if n(1,i)<N(1,il)-1
                    H(count,i)=0.54-.46*cos(2*pi*n(1,i)/(N(1,il)-1));
                    
                else
                    H(count,i)=0;
                end
            end
            
            figure;
            hd(count,:)= h.*H(count,:);
            freqz(hd(count,:),1,w);title('Hamming Window');
        end
        
        if count==5
            for i=1:size_n(1,2)
                if n(1,i)<N(1,il)-1
                    H(count,i)=0.42-0.5*cos(2*pi*n(1,i)/(N(1,il)-1))+0.08*cos(4*pi*n(1,i)/(N(1,il)-1));
                else
                    H(count,i)=0;
                end
            end
            
            figure;
            hd(count,:)= h.*H(count,:);
            freqz(hd(count,:),1,w);title('Blackman Window');
            
        end
    end
end

tm= 1:512;
sig= sin(0.05*2*pi*tm)+ sin(0.2*2*pi*tm);
sig1= sin(0.05*2*pi*tm);
fsig1= fft(sig1);
fsig= fft(sig);

figure;
plot(-pi:pi/256:pi*255/256,fftshift(abs(fsig)));
title('Frequency spectrum of Signal');
xlabel('Frequency ( in radian )');
ylabel('AMPLITUDE');

ar= zeros(1,512);
ns= 0.5-rand(1,512);
nwsig = sig+ns;
nwsig1 = sig1+(0.5-rand(1,512));
fnsig1= fft(nwsig1);
fnwsig= fft(nwsig);
rs=ar;
nrs=ar;
inrs=nrs;

inp_snr= (rms(sig1)/rms(ns))^2;
op_snr=zeros(1,5);
irs=rs;

for i=1:5
    ar=fft(hd(i,:));
    rs= ar.*fsig;
    nrs1= fnsig1.*ar;
    nrs= fnwsig.*ar;
    inrs=ifft(nrs1);
    resl=fsig1-nrs1;
    op_snr(1,i)= (rms(fsig1)/rms(resl))^2;
    
    figure;
    subplot(2,1,1);
    plot(-pi:pi/256:pi*255/256,fftshift(abs(rs)));
    
    if(i==1)
        title(' Frequency spectrum of Output of Rectangular window');
    end
    
    if(i==2)
        title('Frequency spectrum of Output of Triangular window');
    end
    
    if(i==3) 
        title('Frequency spectrum of Output of Hanning window');
    end
    
    if(i==4)
        title('Frequency spectrum of Output of Hamming window');
    end
    
    if(i==5) 
        title('Frequency spectrum of Output of Blackman window');
    end
    
    xlabel('Frequency ( in radian )');
    ylabel('AMPLITUDE');
    
    irs= ifft(rs);
    subplot(2,1,2);
    
    plot(-pi:pi/256:pi*255/256,fftshift(abs(nrs)));
    
    if(i==1) 
        title(' Frequency spectrum of Output of Rectangular window of Noisy Signal');
    end
    
    if(i==2) 
        title('Frequency spectrum of Output of Triangular window of Noisy Signal');
    end
    
    if(i==3)
        title('Frequency spectrum of Output of Hanning window of Noisy Signal');
    end
    
    if(i==4)
        title('Frequency spectrum of Output of Hamming window of Noisy Signal');
    end
    
    if(i==5)
        title('Frequency spectrum of Output of Blackman window of Noisy Signal');
    end
    
    xlabel('Frequency ( in radian )');
    ylabel('AMPLITUDE');
    
end

disp('Input SNR is');
disp(10*log10(inp_snr));
disp('Output snr is');
disp(10*log10(op_snr));