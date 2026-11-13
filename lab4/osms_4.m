function [mas,x,y]=gen_sequence(x,y,length)
    fprintf(" ___________________________________\n");
    fprintf("| Шаг |    X     |    Y     | Выход |\n");
    fprintf("|_____|__________|__________|_______|\n");

    mas=zeros(1,length);

    for i=1:length
        out_x=x(5);
        out_y=y(5);
        result=bitxor(out_x,out_y);

        mas(i)=result;

        fprintf("| %2d  |  ", i);
        fprintf("%d", x);
        fprintf("   |  ");
        fprintf("%d", y);
        fprintf("   |   %d   |\n", result);

        new_bit_x=bitxor(x(4),x(5));
        new_bit_y=bitxor(y(2),y(5));

        x(2:5)=x(1:4);
        y(2:5)=y(1:4);

        x(1)=new_bit_x;
        y(1)=new_bit_y;
    end
    fprintf("|_____|__________|__________|_______|\n");
end

function R=correlation(a, b, lenght)
    R=zeros(1,lenght+1);
    shift=zeros(1,lenght);

    for s=0:lenght
        for j=1:lenght
            shift(j)=b(mod(j-1+s,lenght)+1);
        end

        sum=0;
        for j=1:lenght
            if a(j)==shift(j)
                sum=sum+1;
            else
                sum=sum-1;
            end
        end
        R(s+1)=sum/lenght;
    end
end


length=10;

x =[0 1 0 0 0];
y =[0 1 1 1 1];
x2=[0 1 0 0 1];
y2=[0 1 0 1 0];

fprintf("Первая последовательность\n");
[mas,x,y]=gen_sequence(x,y,length);

fprintf("\nПоследовательность: ");
fprintf("%d", mas);
fprintf("\n\n\n");

fprintf("Вторая последовательность\n");
[mas2,x2,y2]=gen_sequence(x2,y2,length);

fprintf("\nПоследовательность: ");
fprintf("%d", mas2);
fprintf("\n");


R1=correlation(mas,mas,length);
R2=correlation(mas2,mas2,length);
R3=correlation(mas,mas2,length);
R4=correlation(mas2,mas,length);
lags2=0:length;
lags3=0:length;

fprintf("\n\nАвтокорреляция первой:\n");
[ac,lags]=autocorr(mas,'NumLags',length-1); 
T=table(lags(:), ac(:), R1(1:numel(lags)).','VariableNames', {'Сдвиг','Autocorr','Моя'});
disp(T);

fprintf("\n\nАвтокорреляция второй:\n");
[ac,lags]=autocorr(mas,'NumLags',length-1); 
T=table(lags(:), ac(:), R2(1:numel(lags)).','VariableNames', {'Сдвиг','Autocorr','Моя'});
disp(T);


figure;
plot(lags,ac,DisplayName="autocorr");
hold on;
plot(lags3,R1,DisplayName="Моя")
title('Автокорреляция первой');
xlabel('Сдвиг');
ylabel('Значение');
legend();
grid on;




[ac,lags]=autocorr(mas2,'NumLags',length-1); 

figure;
plot(lags,ac,DisplayName="autocorr");
hold on;
plot(lags3,R2,DisplayName="Моя")
title('Автокорреляция второй');
xlabel('Сдвиг');
ylabel('Значение');
legend();
grid on;


fprintf("\n\nВзаимная корреляция первой от второй:\n");
[c,lags]=xcorr(mas,mas2,'coeff');
idx=(lags>=0)&(lags<=length);
c_vals=c(idx);
lags_vals=lags(idx);
T=table(lags_vals(:),c_vals(:),R3(1:numel(lags_vals)).','VariableNames',{'Сдвиг', 'xcorr','Моя'});
disp(T);

figure;
plot(lags_vals,c_vals,DisplayName="xcorr");
hold on;
plot(lags2,R3,DisplayName="Моя")
title('Взаимная корреляция: первая от второй');
xlabel('Сдвиг');
legend();
ylabel('Значение');
grid on;

fprintf("\n\nВзаимная корреляция второй от первой:\n");
[c,lags]=xcorr(mas2,mas,'coeff');
idx=(lags>=0)&(lags<=length);
c_vals=c(idx);
lags_vals=lags(idx);
T=table(lags_vals(:),c_vals(:),R4(1:numel(lags_vals)).','VariableNames',{'Сдвиг', 'xcorr','Моя'});
disp(T);

figure;
plot(lags_vals,c_vals,DisplayName="xcorr");
hold on;
plot(lags2,R4,DisplayName="Моя")
title('Взаимная корреляция: вторая от первой');
xlabel('Сдвиг');
legend();
ylabel('Значение');
grid on;
