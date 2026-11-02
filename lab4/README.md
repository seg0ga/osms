# Лабораторная работа №4

## Задачи практической работы
1) Напишите программу на языке С/С++ для генерации последовательности Голда, используя схему, изображенную на рисунке 4.4, если ваша группа с четным номером и 4.5 – если с нечетным, и порождающие полиномы x и y, при этом x – это ваш порядковый номер в журнале в двоичном формате (5 бит), а y – это x+7 (5 бит). Например, ваш номер 22, значит:
 x = 1 0 1 1 0, y = 1 1 1 0 1.
<img width="462" height="253" alt="image" src="https://github.com/user-attachments/assets/b425f9a5-1ad1-4ec7-bd68-2f35d3c37e7a" /> <img width="462" height="251" alt="image" src="https://github.com/user-attachments/assets/25187c8e-ccca-4be6-b75c-d58bd5f23373" />
 
2) Выведите получившуюся последовательность на экран.

3) Сделайте поэлементный циклический сдвиг последовательности и посчитайте автокорреляцию исходной последовательности и сдвинутой. Сформируйте таблицу с битовыми значениями последовательностей, в последнем столбце которой будет вычисленное значение автокорреляции, как показано в примере ниже.
 
4) Сформируйте еще одну последовательность Голда, используя свою схему (рис.4.4 или 4.5), такую что x=x+1, а y= у-5.

5) Вычислите значение взаимной корреляции исходной и новой последовательностей и выведите в терминал.

6) Проделайте шаги 1-5 в Matlab. Используйте функции xcorr() и autocorr() для вычисления соответствующих корреляций. Сравните результаты, полученные в Matlab и C/C++. 

7) Выведите на график в Matlab функцию автокорреляции в зависимости от величины задержки (lag).

8) Составьте отчет. Отчет должен содержать титульный лист, содержание, цель и задачи работы, теоретические сведения, исходные данные, этапы выполнения работы, сопровождаемые скриншотами и графиками, демонстрирующими успешность выполнения, и промежуточными выводами, результирующими таблицами, ответы на контрольные вопросы, и заключение и ссылка в виде QR-кода на репозиторий с кодом (git).


## Результаты
1) Написал программу на языке С/С++ для генерации последовательности Голда, используя схему, изображенную на рисунке 4.5, так как моя группа с нечетным номером, и порождающие полиномы x и y, при этом x – это мой порядковый номер в журнале в двоичном формате (5 бит), а y – это x+7 (5 бит).
 Мой номер 8, значит:
x = 0 1 0 0 0
y = 0 1 1 1 1
<div align="center">
  <img width="462" height="252" alt="image" src="https://github.com/user-attachments/assets/e31c4c99-86f1-4cc5-8a14-323987052847" />
</div>

``` cpp
#include <stdio.h>
#include <stdlib.h>

int main() {
    int x[5]={0,1,0,0,0};
    int y[5]={0,1,1,1,1};
    
    int length=10;
    int* mas=(int*)malloc(length*sizeof(int));
    printf(" ___________________________________\n");
    printf("| Шаг |    X     |    Y     | Выход |\n");
    printf("|_____|__________|__________|_______|\n");
    
    for (int i=1;i<=length;i++){
        int out_x=x[4];
        int out_y=y[4];
        int result=out_x^out_y;
        
        mas[i-1]=result;
        
        printf("| %2d  |  ", i);

        for (int i=0;i<5;i++){
            printf("%d",x[i]);}

        printf("   |  ");

        for (int i=0;i<5;i++){
            printf("%d",y[i]);}

        printf("   |   %d   |\n",result);
        

        int new_bit_x=x[3]^x[4];
        int new_bit_y=y[1]^y[4];
        
        for (int i=4;i>0;i--){
            x[i]=x[i-1];
            y[i]=y[i-1];}
        
        x[0]=new_bit_x;
        y[0]=new_bit_y;}
    printf("|_____|__________|__________|_______|\n");

    printf("\nИтоговая последовательность: ");
    for (int i=0;i<length;i++){
        printf("%d",mas[i]);}
    printf("\n");
    
    free(mas);
}

```

2) Вывел получившуюся последовательность на экран.

<div align="center">
  <img width="413" height="243" alt="image" src="https://github.com/user-attachments/assets/1df70d52-9978-47a7-98b3-b606d29a5b84" />
</div>

3) Сделал поэлементный циклический сдвиг последовательности и посчитал автокорреляцию исходной последовательности и сдвинутой. Сформировал таблицу с битовыми значениями последовательностей, в последнем столбце которой вычисленное значение автокорреляции.
``` cpp
    int* shift=(int*)malloc(length*sizeof(int));
    
    printf(" _______");
    for (int i=0;i<length;i++){printf("_______");}
    printf("_________________\n");
    
    printf("| Сдвиг |");
    for (int i=1;i<=length;i++){printf(" бит%-2d|",i);}
    printf(" Автокорреляция |\n");
    
    printf("|_______|");
    for (int i=0;i<length;i++){printf("______|");}
    printf("________________|\n");
    
    for (int s=0;s<length+1;s++){
        for (int j=0;j<length;j++){
            shift[j]=mas[(j+s)%length];}
        
        int sum=0;
        for (int j=0;j<length;j++){
            if (mas[j]==shift[j]){sum+=1;}
            else {sum-=1;}}
        double R=(double)sum/length;
        
        printf("|  %3d  |",s);
        for (int j=0;j<length;j++){printf("   %d  |",shift[j]);}
        printf("  %5.2f (%2d/%2d) |\n",R,sum,length); }
    
    printf("|_______|");
    for (int i=0;i<length;i++){printf("______|");}
    printf("________________|\n");
    
    free(shift);
    free(mas);
}
```

<div align="center">
  <img width="501" height="186" alt="image" src="https://github.com/user-attachments/assets/ae829e2f-7fa1-4b82-88ac-65445b432c2c" />
</div>

4) Сформировал еще одну последовательность Голда, используя свою схему, такую что x=x+1, а y= у-5.
``` cpp
#include <stdio.h>
#include <stdlib.h>

void gen_sequence(int x[5], int y[5], int length, int* mas){
    printf(" ___________________________________\n");
    printf("| Шаг |    X     |    Y     | Выход |\n");
    printf("|_____|__________|__________|_______|\n");
    
    for (int i=1;i<=length;i++){
        int out_x=x[4];
        int out_y=y[4];
        int result=out_x^out_y;
        
        mas[i-1]=result;
        
        printf("| %2d  |  ", i);

        for (int i=0;i<5;i++){
            printf("%d",x[i]);}

        printf("   |  ");

        for (int i=0;i<5;i++){
            printf("%d",y[i]);}

        printf("   |   %d   |\n",result);
        

        int new_bit_x=x[3]^x[4];
        int new_bit_y=y[1]^y[4];
        
        for (int i=4;i>0;i--){
            x[i]=x[i-1];
            y[i]=y[i-1];}
        
        x[0]=new_bit_x;
        y[0]=new_bit_y;}
    printf("|_____|__________|__________|_______|\n");
}

int main() {
    int x[5]={0,1,0,0,0};
    int y[5]={0,1,1,1,1};
    int x2[5]={0,1,0,0,1};
    int y2[5]={0,1,0,1,0};
    
    int length=10;
    int* mas=(int*)malloc(length*sizeof(int));\
    int* mas2=(int*)malloc(length*sizeof(int));

    printf("Первая последовательность\n");
    gen_sequence(x,y,length,mas);

    printf("\nПоследовательность: ");
    for (int i=0;i<length;i++){
        printf("%d",mas[i]);}
    printf("\n\n\n");

    printf("Вторая последовательность\n");
    gen_sequence(x2,y2,length,mas2);

    printf("\nПоследовательность: ");
    for (int i=0;i<length;i++){
        printf("%d",mas2[i]);}
    printf("\n");
}
```

<div align="center">
  <img width="269" height="250" alt="image" src="https://github.com/user-attachments/assets/9e20a0d3-5402-40b0-807a-3489856587da" />
</div>

5) Вычислил значение взаимной корреляции исходной и новой последовательностей и вывел в терминал.
``` cpp
#include <stdio.h>
#include <stdlib.h>

void correlation(int* a, int* b, int length){

    int* shift=(int*)malloc(length*sizeof(int));

    printf(" _______");
    for (int i=0;i<length;i++){printf("_______");}
    printf("_________________\n");
    
    printf("| Сдвиг |");
    for (int i=1;i<=length;i++){printf(" бит%-2d|",i);}
    printf(" Автокорреляция |\n");
    
    printf("|_______|");
    for (int i=0;i<length;i++){printf("______|");}
    printf("________________|\n");
    
    for (int s=0;s<length+1;s++){
        for (int j=0;j<length;j++){
            shift[j]=b[(j+s)%length];}
        
        int sum=0;
        for (int j=0;j<length;j++){
            if (a[j]==shift[j]){sum+=1;}
            else {sum-=1;}}

        double R=(double)sum/length;
        
        printf("|  %3d  |",s);
        for (int j=0;j<length;j++){printf("   %d  |",shift[j]);}
        printf("  %5.2f (%2d/%2d) |\n",R,sum,length); }
    
    printf("|_______|");
    for (int i=0;i<length;i++){printf("______|");}
    printf("________________|\n");
    free(shift);

}

int main() {
    int x[5]={0,1,0,0,0};
    int y[5]={0,1,1,1,1};
    int x2[5]={0,1,0,0,1};
    int y2[5]={0,1,0,1,0};
    
    int length=10;
    int* mas=(int*)malloc(length*sizeof(int));\
    int* mas2=(int*)malloc(length*sizeof(int));

    printf("Первая последовательность\n");
    gen_sequence(x,y,length,mas);

    printf("\nПоследовательность: ");
    for (int i=0;i<length;i++){
        printf("%d",mas[i]);}
    printf("\n\n\n");

    printf("Вторая последовательность\n");
    gen_sequence(x2,y2,length,mas2);

    printf("\nПоследовательность: ");
    for (int i=0;i<length;i++){
        printf("%d",mas2[i]);}
    printf("\n");

    printf("\n\nАвтокорреляция первой:\n");
    correlation(mas, mas, length);

    printf("\n\nВзаимная корреляция первой от второй:\n");
    correlation(mas, mas2, length);

    printf("\n\nВзаимная корреляция второй от первой:\n");
    correlation(mas2, mas, length);

    free(mas);
}
```
<div align="center">
  <img width="501" height="404" alt="image" src="https://github.com/user-attachments/assets/fcc0f9cf-39b8-4ca7-83d5-08263462fb05" />
</div>

6) Проделал шаги 1-5 в Matlab. Использовал функции xcorr() и autocorr() для вычисления соответствующих корреляций. Сравнил результаты, полученные в Matlab и C/C++. 
``` matlab
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


fprintf("\n\nВзаимная корреляция первой от второй:\n");
[c,lags]=xcorr(mas,mas2,'coeff');
idx=(lags>=0)&(lags<=length);
c_vals=c(idx);
lags_vals=lags(idx);
T=table(lags_vals(:),c_vals(:),'VariableNames',{'Сдвиг', 'Взаимная корреляция'});
disp(T);


fprintf("\n\nВзаимная корреляция второй от первой:\n");
[c,lags]=xcorr(mas2,mas,'coeff');
idx=(lags>=0)&(lags<=length);
c_vals=c(idx);
lags_vals=lags(idx);
T=table(lags_vals(:),c_vals(:),'VariableNames',{'Сдвиг', 'Взаимная корреляция'});
disp(T);
```
<div align="center">
  <img width="170" height="315" alt="image" src="https://github.com/user-attachments/assets/d0d8c276-0a52-4a1d-ac69-8d3b83c3cb51" /> <img width="299" height="315" alt="image" src="https://github.com/user-attachments/assets/6c8c85a5-1dbd-4c95-b1a7-75cf9317d532" />
</div>

<div align="center">
  <img width="191" height="779" alt="image" src="https://github.com/user-attachments/assets/cdf728a4-30d2-4d29-bd89-9cb9305de182" /><img width="408" height="780" alt="image" src="https://github.com/user-attachments/assets/933dbd23-0b47-44c0-bf10-75db3d9c6c8f" />
</div>

7) Вывел на график в Matlab функцию автокорреляции в зависимости от величины задержки (lag).
``` matlab
figure;
plot(lags,ac);
title('Автокорреляция');
xlabel('Сдвиг');
ylabel('Значение');
grid on;

figure;
plot(lags_vals,c_vals);
title('Взаимная корреляция: первая от второй');
xlabel('Сдвиг');
ylabel('Значение');
grid on;

figure;
plot(lags_vals,c_vals);
title('Взаимная корреляция: вторая от первой');
xlabel('Сдвиг');
ylabel('Значение');
grid on;
```

<div align="center">
  <img width="501" height="330" alt="image" src="https://github.com/user-attachments/assets/50983ec7-d8bc-4505-b2aa-e41214145042" />
</div>

<div align="center">
  <img width="501" height="325" alt="image" src="https://github.com/user-attachments/assets/83985760-0d9b-4dc0-b7d3-8343e3e96601" />
</div>

<div align="center">
  <img width="501" height="336" alt="image" src="https://github.com/user-attachments/assets/765718bd-ac43-426f-97df-60e3e78a19c1" />
</div>

## Заключение
