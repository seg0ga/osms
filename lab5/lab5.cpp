#include <iostream>
#include <cstdio>


using namespace std;

void packet(int data[], int N, int G[], int kadr[]){
    int copy[512];
    for (int i=0;i<N+6;i++){
        if (i>=N){copy[i]=0;}
        else copy[i]=data[i];
    };

    for (int i=0;i<N;i++){
        if (copy[i]==1){
            for (int j=0;j<7;j++){
                copy[i+j] ^= G[j];}}}

    int crc[6];

    printf("CRC:");
    for (int i=0; i<6;i++){
        crc[i]=copy[N+i];
        cout << crc[i];
    }
    cout <<endl;

    for (int i=0;i<N+6;i++){
        if (i>=N){kadr[i]=crc[i-N];}
        else kadr[i]=data[i];
    };

    int check[512];
    for (int i=0;i<N+6;i++) check[i]=kadr[i];
    for (int i=0;i<N;i++){
        if (check[i]==1){
            for (int j=0;j<7;j++) check[i+j] ^=G[j];}}

    int error=0;
    printf("Остаток при проверке: ");
    for (int i=0;i<6;i++){
        cout <<check[N+i];
        if (check[N+i]==1) error=1;
    }
    cout <<endl;
    if (error) printf("Ошибка обнаружена :(\n");
    else printf("Ошибок нет :)\n");
}

int main(){
    int G[7]={1,1,1,1,1,1,1};
    int N=20+8;
    int data[40];
    int kadr[40];

    printf("Пакет данных длиной 28 бит\n\n");

    printf("Введите 28 бит через пробел: ");
    for (int i=0;i<N;i++){
        cin >> data[i];}
    
    packet(data,N,G,kadr);


    int N250=250;
    int data250[260];
    int kadr250[260];

    printf("\n\nПакет данных длиной 250 бит\n\n");


    printf("Сгенерированный пакет данных: ");
    for (int i=0;i<N250;i++){
        data250[i]=rand()%2;
        printf("%d",data250[i]);}
    cout <<endl;
    
    packet(data250,N250,G,kadr250);
    

    printf("\n\nИскажение по одному биту в пакете данных длиной 250+CRC бит\n\n");
    int error_y=0;
    int error_n=0;
    int check[260];

    for (int b=0;b<N250+6;b++){
        for (int i=0; i<N250+6;i++){
            check[i]=kadr250[i];
        }
        check[b] ^=1;

        for (int i=0;i<N250;i++){
            if (check[i]==1){
                for (int j=0;j<7;j++){
                    check[i+j] ^= G[j];}}}
        
        int err=0;
        for (int i=0;i<6;i++){
            if (check[N250+i]==1) {
                err=1;}}
        
        if (err) error_y++;
        else error_n++;
    }

    printf("Ошибок обнаружено: %d\n",error_y);
    printf("Ошибок не обнаружено: %d\n",error_n);
}