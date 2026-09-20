t=0:0.001:1;
f=10;
y= @(t) sin(2*pi*f*t)+sin(8*pi*f*t);


figure;
y=y(t);
plot(t,y,"r");
title('Лаб 1');
xlabel('x');
ylabel('f(x)');
grid on;
hold on;

disp("Максимальная частота в спектре данного сигнала - 40 Гц");
disp("Минимальная необходимая частота дискретизации полученного сигнала - 80 Гц");

y= @(t) sin(2*pi*f*t)+sin(8*pi*f*t);
f=80;
t=0:1/f:1;
masx=t;
masy=y(t);

%disp(masy);

f=320;
t=0:1/f:1;
masx2=t;
masy2=y(t);

plot(masx,masy,"go","MarkerSize",10, "MarkerFaceColor","g");
plot(masx,masy,"b")
plot(masx2,masy2,"wo","MarkerSize",5, "MarkerFaceColor","w");
plot(masx2,masy2,"y")
grid on;
legend("Исходный график", "Точки при f=80","Восстановленный при f=80","Точки при f=320","Восстановленный при f=320");

N=length(masy);
fs=80;
Y=fft(masy);
f=(0:N-1);
A=abs(Y)/N;
A=A(1:floor(N/2)+1);
fp=f(1:floor(N/2)+1);
A(2:end-1)=2*A(2:end-1);

disp("Обьем памяти для хранения массива в байтах при f=80: ")
disp(length(masy)*8)

N2=length(masy2);
fs2=320;
Y2=fft(masy2);
f2=(0:N2-1)*(fs2/N2);
A2=abs(Y2)/N2;
A2=A2(1:floor(N2/2)+1);
fp2=f2(1:floor(N2/2)+1);
A2(2:end-1) = 2*A2(2:end-1);

disp("Обьем памяти для хранения массива в байтах при f=320: ")
disp(length(masy2)*8)

figure;
subplot(2,1,1);
stem(fp,A,"R")
subplot(2,1,2);
stem(fp2,A2,"G")
