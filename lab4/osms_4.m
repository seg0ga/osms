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

fprintf("\n\nАвтокорреляция первой:\n");
[ac,lags]=autocorr(mas,'NumLags',length-1); 
T=table(lags(:),ac(:),'VariableNames',{'Сдвиг','Автокорреляция'});    
disp(T);

figure;
plot(lags,ac);
title('Автокорреляция');
xlabel('Сдвиг');
ylabel('Значение');
grid on;

fprintf("\n\nВзаимная корреляция первой от второй:\n");
[c,lags]=xcorr(mas,mas2,'coeff');
idx=(lags>=0)&(lags<=length);
c_vals=c(idx);
lags_vals=lags(idx);
T=table(lags_vals(:),c_vals(:),'VariableNames',{'Сдвиг', 'Взаимная корреляция'});
disp(T);

figure;
plot(lags_vals,c_vals);
title('Взаимная корреляция: первая от второй');
xlabel('Сдвиг');
ylabel('Значение');
grid on;

fprintf("\n\nВзаимная корреляция второй от первой:\n");
[c,lags]=xcorr(mas2,mas,'coeff');
idx=(lags>=0)&(lags<=length);
c_vals=c(idx);
lags_vals=lags(idx);
T=table(lags_vals(:),c_vals(:),'VariableNames',{'Сдвиг', 'Взаимная корреляция'});
disp(T);

figure;
plot(lags_vals,c_vals);
title('Взаимная корреляция: вторая от первой');
xlabel('Сдвиг');
ylabel('Значение');
grid on;