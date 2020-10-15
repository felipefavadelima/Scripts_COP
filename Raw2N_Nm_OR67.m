%by Felipe Fava de Lima
%felipefavadelima@usp.br
%Date: 23/06/2015

% Script to convert raw data from a Force Platform
%   AMTI 0R6-7-1000 + MSA-6 Amplifier (Gain 4k) - Serial Number 4281
% to N_Nm units
% Input:
%           Raw_Data  = Array, coluns names [Fx,Fy,Fz,Mx,My,Mz],
%                                                       units [V,V,V,V,V,V]
% Output:
%           N_Nm_Data = Array, coluns names [Fx,Fy,Fz,Mx,My,Mz],
%                                                 units [N,N,N,N.m,N.m,N.m]

% Warning:
% This script is specific to the force platform
%   %AMTI 0R6-7-1000 + MSA-6 Amplifier (Gain 4k) - Serial Number 4281

function [N_Nm_Data] = Raw2N_Nm_OR67(Raw_Data)

% MSA-6 amplifier gains from calibration certificate
Gamp = [3932.5 3993.6 3967.9 3952.6 3963.0 3985.1];

% Excitation Voltage from calibration certificate
Vex_V = 9.996;

%Cross sensitivites from calibration certificate
%Columns [Vfx Vfy Vfz Vmx Vmy Vmz] [uV/Vex]
%Rows [Fx Fy Fz Mx My Mz] [N | N.m]
Mcross = ...
    [ 1.4986022e+000 -1.4075694e-002  1.8938981e-003 -1.0656861e-002 -4.2947399e-003  2.9438939e-003
    2.1194203e-002  1.4938096e+000 -2.1304525e-002 -6.7583966e-003 -4.9192672e-003 -1.9838748e-003
    -6.3343242e-003  2.9568222e-002  5.8424711e+000  7.4428464e-003  1.1379570e-002 -9.0328686e-004
    -8.2093500e-005 -1.0044002e-003  9.0054030e-004  5.8807506e-001 -1.0316445e-003 -1.5473596e-003
    -9.9069517e-004 -3.3921768e-004  2.1664691e-003  7.5373214e-004  5.8803088e-001 -3.0305171e-003
    -2.5320119e-003  9.7095233e-004  2.7871162e-003 -1.9253959e-003  5.7539318e-005  3.0277889e-001 ];

%R bridge OR6-7
%Check AMTI 0R6-7-1000 + MSA-6 Amplifier  User Manual
R = [700 700 350 700 700 700];

%Force platform cable length
%Check AMTI 0R6-7-1000 + MSA-6 Amplifier User Manual
Cable_m = 10;
Cable_ft = Cable_m * 3.28084;

%Cable voltage drop Standard 28 gauge 10V
%Check AMTI 0R6-7-1000 + MSA-6 Amplifier User Manual
%3.707e-3V / ft @350 Ohms
%1.854e-3V / ft @700 Ohms
%0.927e-3V / ft @1400 Ohms
Vexs_V = [];
for nCh=1:6
    if(R(nCh) == 700)
        Vexs_V(nCh) =   Vex_V - Cable_ft*1.854e-3;
    elseif (R(nCh) == 350)
        Vexs_V(nCh) =   Vex_V - Cable_ft*3.707e-3;
    elseif (R(nCh) == 1400)
        Vexs_V(nCh) =   Vex_V - Cable_ft*0.927e-3;
    end
end

%Make data
Data = Raw_Data;

%Apply gain to data
Data = Data*(diag(1./Gamp));
%Transform V to uV
Data = Data * 1e6;
%Apply Platform Excitation Voltage equation
Data = Data * diag(1./Vexs_V);
%Apply Cross sensitivites equation
Data = Data * Mcross';

N_Nm_Data = Data;

end