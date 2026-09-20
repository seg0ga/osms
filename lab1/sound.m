[y, Fs] = audioread('ОСМС.wav');
info=audioinfo('ОСМС.wav');


fprintf('Частота дискретизации (автоматическая) Fs= %d \n', Fs);

Fs2=length(y)/info.Duration;
fprintf('Частота дискретизации (вручную посчитанная) Fs= %d \n' , Fs2);
fprintf('Длина аудозаписи: %.3f с \n', info.Duration)

y1 = downsample(y,10);
zvuk=audioplayer(y1,Fs/10);
play(zvuk);

figure();
subplot(2,1,1)
plot(y)
subplot(2,1,2)
plot(y1);

N=length(y);
Y=fft(y);
f=(0:N-1)*(Fs/N);
A=abs(Y)/N;
A=A(1:floor(N/2));
f_half=f(1:floor(N/2));

N1=length(y1);
Y1=fft(y1);
Fs1=Fs/10;
f1=(0:N1-1)*(Fs1/N1);
A1=abs(Y1)/N1;
A1=A1(1:floor(N1/2));
f1_half=f1(1:floor(N1/2));

figure;
plot(f_half, A, 'b'); 
hold on;
plot(f1_half, A1, 'r');
title('Спектры');
xlabel('Частота, Гц'); 
ylabel('Амплитуда');
grid on;
legend('Оригинал','Прореженный');
xlim([0 2500]);

figure;
for b=[3 4 5 6]
    yq=quant(y,b);

    subplot(2,2,b-2);
    plot(y, 'b'); 
    hold on;
    plot(yq, 'r');
    title(sprintf('%d бит', b));
    grid on;
    
    err = mean(abs(y - yq));
    fprintf('%d бит: ошибка = %.6f\n', b, err);
end

figure;

for b=[3 4 5 6]
    yq=quant(y,b);
    
    Yq=fft(yq);
    Aq=abs(Yq)/N;
    Aq=Aq(1:floor(N/2));
    
    subplot(2,2,b-2);
    plot(f_half, A, 'b'); 
    hold on;
    plot(f_half, Aq, 'r');
    title(sprintf('%d бит', b));
    xlabel('Частота, Гц'); 
    ylabel('Амплитуда');
    grid on;
    xlim([0 2500]);
end


function yq = quant(y, bit)
    y_norm = (y + 1) / 2;
    l=2^bit-1;
    yd=round(y_norm*l);
    
    yd(yd>l)=l;
    yd(yd<0)=0;
    
    yq=(yd/l)*2-1; 
end
