clear all
close all

%by Felipe Fava de Lima
%felipefavadelima@usp.br


%Example of force platform data conversion
%from the AMTI 0R6-7-1000 + MSA-6 Amplifier (Gain 4k) - Serial Number 4281
%force platform

%Load Raw data example
load('FP_OR67_Raw_Data_sample');

Raw_Data =[Fx_V Fy_V Fz_V Mx_V My_V Mz_V];

%Convert raw data in Volt units to N(Forces) N.m(Moments) units
[N_Nm_Data] = Raw2N_Nm_OR67(Raw_Data);

%Convert N(Forces) N.m(Moments) to COP(x,y) (mm)
COPxy_mm = N_Nm2COP_OR67(N_Nm_Data);

%Plot Stabilogram
dt_s = 1/Fs_Hz;
Time_s = 0:dt_s:(length(COPxy_mm)*dt_s)-dt_s;
figure;
subplot(2,1,1);
plot(Time_s,COPxy_mm(:,1));
xlabel('Time (s)');
ylabel('COPx (mm)');
ylim([-150 100]);
subplot(2,1,2);
plot(Time_s,COPxy_mm(:,2));
xlabel('Time (s)');
ylabel('COPy (mm)');
ylim([-150 100]);

