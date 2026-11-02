TxPowerBS=46;
N_sectors=3;
RxPowerUE=24;
AntGainBS=21;
PenetretionM=15;
IM=1;
f=1800;
BW_UL=10^7;
BW_DL=2*10^7;
NF_BS=2.4;
NF_UE=6;
SINR_DL=2;
SINR_UP=4;
area_macro=100;
area_micro=4;
MIMO_gain=3;
feader_loss=2.9;


ThermalNoiseUL=-174+10*log10(BW_UL);
RxSens_BS=NF_BS+ThermalNoiseUL+SINR_UP;
MAPL_UL=RxPowerUE-feader_loss+AntGainBS+MIMO_gain-IM-PenetretionM-RxSens_BS;

fprintf('Бюджет восходящего канала\n');
fprintf('Чувствительность приемника БС: %.2f дБм\n',RxSens_BS);
fprintf('Максимально допустимые потери MAPL_UL: %.2f дБ\n\n',MAPL_UL);

ThermalNoiseDL=-174+10*log10(BW_DL);
RxSens_UE=NF_UE+ThermalNoiseDL+SINR_DL;
MAPL_DL=TxPowerBS-feader_loss+AntGainBS+MIMO_gain-IM-PenetretionM-RxSens_UE;

fprintf('Бюджет нисходящего канала\n');
fprintf('Чувствительность приемника UE: %.2f дБм\n',RxSens_UE);
fprintf('Максимально допустимые потери MAPL_DL: %.2f дБ\n',MAPL_DL);


d_m=1:1:5000;
d_km=d_m/1000;
hBS=50;
hms=1.2;

% Выбор типа местности:
% 'DU' - Dense Urban (плотная городская застройка)
% 'U' - Urban (городская застройка)
% 'SU' - Suburban (пригород)
% 'RURAL' - Сельская местность
% 'ROAD' - Трасса

env='DU';

if env=="DU"
    a_hms=3.2*(log10(11.75*hms))^2-4.97;
    L_clutter=3;
elseif env=="U"
    a_hms=3.2*(log10(11.75*hms))^2-4.97;
    L_clutter=-0.2;
elseif env=="SU"
    a_hms=(1.1*log10(f))*hms-(1.56*log10(f)-0.8);
    L_clutter=-(2*(log10(7/39))^2+5.4);
elseif env=="RURAL"
    a_hms=(1.1*log10(f))*hms-(1.56*log10(f)-0.8);
    L_clutter=-(4.78*(log10(f))^2-18.33*log10(f)+35.94);
elseif env=="ROAD"
    a_hms=(1.1*log10(f))*hms-(1.56*log10(f)-0.8);
    L_clutter=-(4.78*(log10(f))^2-18.33*log10(f)+40.94);
else
    L_clutter=0;
end


if f>=105 & f<1500
    A=69.55;
    B=26.16;
elseif f>=1500 & f<2000
    A=46.3;
    B=33.9;
else
    A=0;
    B=0;
end

PL_FSPM=20*log10((4*pi*d_m*f*10^6)/(3*10^8));
PL_UMiNLOS=26*log10(f/1000)+22.7+36.7*log10(d_m);
PL_Hata=zeros(size(d_km));
for i=1:length(d_km)
    if d_km(i)>=1
        s_val=44.9-6.55*log10(f);
    else
        s_val=(47.88+13.9*log10(f)-13.9*log10(hBS))/log10(50);
    end
    PL_Hata(i)=A+B*log10(f)-13.82*log10(hBS)-a_hms+s_val*log10(max(d_km(i),0.001))+L_clutter;
end

figure();
hold on;
plot(d_m, PL_UMiNLOS, 'r');
plot(d_m, PL_FSPM, 'b');
plot(d_m, PL_Hata, 'g');
yline(MAPL_UL,'w--','LineWidth',2);
yline(MAPL_DL,'w-.','LineWidth',2);
grid on;
xlabel('Расстояние, м');
ylabel('Потери сигнала PL(d), дБ');
legend('UMiNLOS','FSPM','COST 231 Hata','MAPL UL','MAPL DL','Location','southeast');
title('Зависимость потерь сигнала от расстояния');


[~,idx_UL]=min(abs(PL_Hata-MAPL_UL));
[~,idx_DL]=min(abs(PL_Hata-MAPL_DL));
[~,idx_micro_UL]=min(abs(PL_UMiNLOS-MAPL_UL));
[~,idx_micro_DL]=min(abs(PL_UMiNLOS-MAPL_DL));

d_UL=d_km(idx_UL);
d_DL=d_km(idx_DL);
d_micro_UL_m=d_m(idx_micro_UL);
d_micro_DL_m=d_m(idx_micro_DL);

R_macro=min(d_UL,d_DL);
R_micro_km=min(d_micro_UL_m,d_micro_DL_m)/1000; 


if N_sectors==3
    Area_Site=1.95*(R_macro^2);
    Area_Site_micro=1.95*(R_micro_km^2);
elseif N_sectors==2
    Area_Site=1.73*(R_macro^2);
    Area_Site_micro=1.73*(R_micro_km^2);
elseif N_sectors==6
    Area_Site=2.6*(R_macro^2);
    Area_Site_micro=2.6*(R_micro_km^2);
else
    Area_Site=1.95*(R_macro^2);
    Area_Site_micro=1.95*(R_micro_km^2);
end

Num_BS_micro=ceil(area_micro/Area_Site_micro);
Num_BS_macro=ceil(area_macro/Area_Site);

fprintf('\n\n\n\nРадиус соты и расчет БС (МАКРО)\n');
fprintf('Радиус соты в UL: %.1f м\n',d_UL*1000);
fprintf('Радиус соты в DL: %.1f м\n', d_DL*1000);
fprintf('Итоговый радиус соты R: %.2f км\n',R_macro);
fprintf('Площадь 1 сайта (%d сектора): %.4f кв. км\n', N_sectors,Area_Site);
fprintf('Требуемое количество БС для территории %d кв. км: %d\n',area_macro,Num_BS_macro);

fprintf('\n\n\n\nРадиус соты и расчет БС (МИКРО)\n');
fprintf('Радиус соты в UL: %.1f м\n',d_micro_UL_m);
fprintf('Радиус соты в DL: %.1f м\n',d_micro_DL_m);
fprintf('Итоговый радиус соты R: %.2f км\n',R_micro_km);
fprintf('Площадь 1 сайта (%d сектора): %.4f кв. км\n',N_sectors,Area_Site_micro);
fprintf('Требуемое количество БС для территории %d кв. км: %d\n',area_micro,Num_BS_micro);