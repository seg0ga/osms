%% 1
string=input("Введите имя и фамилию латиницей: ","s");

%% 2
ascii_codes=double(string);

fprintf("Введенная строка: %s\n",string);
fprintf("ASCII коды:\n");

fprintf(" ___________________________ \n")
fprintf("| Символ | ASCII |   Биты   |\n");
fprintf("|________|_______|__________|\n")

bits=[];
for i=1:length(string)
    byte=dec2bin(ascii_codes(i), 8);
    fprintf("|    %c   |  %3d  | %8s |\n",string(i),ascii_codes(i),byte);
    bits=[bits,byte-'0'];
end
fprintf("|________|_______|__________|\n")


L=length(bits);
fprintf("\nБитовая последовательность: \n");
fprintf("%d",bits);

figure();
stairs(1:L, bits, 'LineWidth', 1.5);
ylim([-0.2 1.2])
xlabel('Номер бита');
ylabel('Значение');
title("Визуализация последовательности")
grid on;

%% 3
G=[1 1 1 1 1 1 1];
M=length(G)-1;

copy=[bits,zeros(1,M)];

for i=1:L
    if copy(i)==1
        copy(i:i+M)=bitxor(copy(i:i+M),G);
    end
end

crc=copy(L+1:L+M);
kadr=[bits,crc];

fprintf("\nCRC: ");
fprintf("%d",crc);
fprintf("\n");

%% 4
G=31;
x=[0 1 0 0 0];
y=[0 1 1 1 1];
gold=zeros(1,G);

for i=1:G
    gold(i)=bitxor(x(5), y(5));
    
    new_bit_x=bitxor(x(4),x(5));
    new_bit_y=bitxor(y(2),y(5));
    
    x(2:5)=x(1:4);
    y(2:5)=y(1:4);
    
    x(1)=new_bit_x;
    y(1)=new_bit_y;
end

kadr=[gold,kadr];

fprintf("\nПоследовательность Голда:");
fprintf("%d",gold);
fprintf("\nИтоговый кадр длиной %d символа:",length(kadr));
fprintf("%d",kadr);
fprintf("\n");

figure();
stairs(1:length(kadr), kadr, 'LineWidth', 1.5);
ylim([-0.2 1.2])
xlabel('Номер бита');
ylabel('Значение');
title("Визуализация последовательности c CRC и синхронизацией")
grid on;

%% 5
N=10;
signal=repelem(kadr,N);
fprintf("\nДлина массива отсчетов: %d",length(signal))

fprintf("\nМассив временных отсчетов сигнала: ");
fprintf("%d",gold);
fprintf("\n");

figure();
stairs(1:length(signal), signal, 'LineWidth', 1.5);
ylim([-0.2 1.2])
xlabel('Номер отсчета');
ylabel('Амплитуда');
title("Временные отсчеты сигнала (10 отсчетов на бит)");
grid on;

%% 6

len_signal=length(signal);
Signal=zeros(1,2*len_signal);

fprintf("\nВведите сдвиг от 0 до %d: ",len_signal);
shift=input("");
Signal(shift+1:shift+len_signal)=signal;

figure();
stairs(1:length(Signal), Signal, 'LineWidth', 1.5);
ylim([-0.2 1.2])
xlabel('Номер отсчета');
ylabel('Амплитуда');
title("Временные отсчеты сигнала со сдвигом");
grid on;

%% 7

fprintf("\nВведите sigma для шума: ");
sigma=input("");

noise=sigma*randn(1,length(Signal));
signal_noise=Signal+noise;

figure();
stairs(1:length(signal_noise), signal_noise, 'LineWidth', 1.5);
ylim([-0.2 1.2])
xlabel('Номер отсчета');
ylabel('Амплитуда');
title("Принятый сигнал с шумом:");
grid on;

%% 8

gold_samples=repelem(gold,N);

[c,lags]=xcorr(signal_noise,gold_samples);

idx=lags>=0;
corr_vals=c(idx);
lags_pos=lags(idx);

[~,max_pos]=max(corr_vals);
start_idx=lags_pos(max_pos)+1;
Signal_sync=signal_noise(start_idx:end);

fprintf("\nНайденный индекс начала синхронизации: %d\n", start_idx);

%% 9

P=N/2;

rx_bits=zeros(1,length(kadr));

for i=1:length(kadr)
    idx_start=(i-1)*N+1;
    idx_end=i*N;
    acc=sum(Signal_sync(idx_start:idx_end));

    if acc>P
        rx_bits(i)=1;
    else
        rx_bits(i)=0;
    end
end

fprintf("\nПринятые биты: ");
fprintf("%d", rx_bits);
fprintf("\n");

errors=sum(rx_bits~=kadr);
fprintf("Бит переданных неправильно: %d \n",errors);
fprintf("\n");

%% 10

rxdatacrc=rx_bits(G+1:end);

fprintf("\nПринятая последовательность без Голда:");
fprintf("%d",rxdatacrc);
fprintf("\n");

%% 11

G=[1 1 1 1 1 1 1];
copyrx=rxdatacrc;

for i=1:L
    if copyrx(i)==1;
        copyrx(i:i+M)=bitxor(copyrx(i:i+M),G);
    end
end

ost=copyrx(L+1:L+M);
fprintf("\nОстаток от деления CRC: ");
fprintf("%d",ost);
fprintf("\n");

if sum(ost)==0
    fprintf("Ошибок при приеме не обнаружено\n")
else 
    fprintf("Обнаружена ошибка при приеме\n")
end

%% 12

if sum(ost)==0
    rxdata=rxdatacrc(1:L);

    num_chars=L/8;
    decodedstr='';

    for i=1:num_chars
        byte_bits=rxdata((i-1)*8+1:i*8);
        ascii_code=bin2dec(char(byte_bits+'0'));
        decodedstr(i)=char(ascii_code);
    end

    fprintf("\nВосстановленный текст: %s",decodedstr);
    fprintf("\n")
else
    fprintf("\nДекодирование не возможно из-за ошибок\n");
end

%% 13

fs=1000;

len_s=length(Signal);
half_s=floor(len_s/2)+1;
f=linspace(0,fs/2,half_s);

fft_tx=abs(fft(Signal))/len_s;
fft_rx=abs(fft(signal_noise))/len_s;

spec_tx=fft_tx(1:half_s);
spec_rx=fft_rx(1:half_s);

figure();
subplot(2,1,1);
plot(f,spec_tx,'LineWidth', 1.2);
xlabel('Частота, Гц');
xlim([-20 250])
ylabel('Амплитуда');
title('Спектр передаваемого сигнала');
grid on;

subplot(2,1,2);
plot(f,spec_rx,'LineWidth', 1.2);
xlabel('Частота, Гц');
xlim([-20 250])
ylabel('Амплитуда');
title('Спектр принимаемого (зашумленного) сигнала');
grid on;

sig_short=repelem(kadr,N/2);
sig_med=repelem(kadr,N);
sig_long=repelem(kadr,N*2);

half_short=floor(length(sig_short)/2)+1;
half_med=floor(length(sig_med)/2)+1;
half_long=floor(length(sig_long)/2)+1;

f_short=linspace(0,fs/2,half_short);
f_med=linspace(0,fs/2,half_med);
f_long=linspace(0,fs/2,half_long);

spec_short=abs(fft(sig_short))/length(sig_short);
spec_med=abs(fft(sig_med))/length(sig_med);
spec_long=abs(fft(sig_long))/length(sig_long);

spec_short=spec_short(1:half_short);
spec_med=spec_med(1:half_med);
spec_long=spec_long(1:half_long);

figure();
plot(f_short,spec_short, 'r','LineWidth', 1.2); 
hold on;
plot(f_med,spec_med,'g','LineWidth', 1.2);
plot(f_long,spec_long,'b','LineWidth', 1.2);
hold off;
xlim([-20 250])
xlabel('Частота, Гц');
ylabel('Амплитуда');
title('Сравнение спектров сигналов с разной длительностью символа');
legend('Короткие (N/2)', 'Средние (N)', 'Длинные (2*N)');
grid on;


%% Доп 1
sigma=0:0.01:2;
BER=zeros(size(sigma));
for s=1:length(sigma)
    noise=sigma(s)*randn(1,length(Signal));
    signal_noise=Signal+noise;
    
    [c,lags]=xcorr(signal_noise,gold_samples);
    corr_vals=c(idx);
    lags_pos=lags(idx);
    
    [~,max_pos]=max(corr_vals);
    start_idx=lags_pos(max_pos)+1;
    Signal_sync=signal_noise(start_idx:end);

    rx_bits=zeros(1,length(kadr));
    for i=1:length(kadr)
        idx_start=(i-1)*N+1;
        idx_end=i*N;
        acc=sum(Signal_sync(idx_start:idx_end));
        rx_bits(i)=acc>P;
    end
    BER(s)=sum(rx_bits~=kadr)/length(kadr);
end

figure();
plot(sigma,BER);
grid on;
xlabel("sigma");
ylabel("BER");
title("BER от сигма");

%% Доп 2

N=[2 10 100];
sigma=0:0.01:5;
corrrrrrr=zeros(length(N),length(sigma));

for n=1:length(N);
    N_cur=N(n);

    kadr_cur=kadr;
    signal_cur=repelem(kadr_cur,N_cur);

    for s=1:length(sigma)
        noise=sigma(s)*randn(1,length(signal_cur));
        signal_noise=signal_cur+noise;
        
        R=xcorr(signal_cur,signal_noise,0,'coeff');
        corrrrrrr(n,s) =R;
    end
end


figure();
plot(sigma,corrrrrrr(1,:));
hold on;
plot(sigma,corrrrrrr(2,:));
plot(sigma,corrrrrrr(3,:));
grid on;
xlabel("sigma");
ylabel("Корреляция");
title("Корреляция от sigma")
legend('N=2','N=10','N=100');

