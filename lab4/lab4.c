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
    
    int length=512;
    int* mas=(int*)malloc(length*sizeof(int));
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

    // printf("\n\nАвтокорреляция первой:\n");
    // correlation(mas, mas, length);

    // printf("\n\nВзаимная корреляция первой от второй:\n");
    // correlation(mas, mas2, length);

    // printf("\n\nВзаимная корреляция второй от первой:\n");
    // correlation(mas2, mas, length);

    free(mas);
    free(mas2);
}