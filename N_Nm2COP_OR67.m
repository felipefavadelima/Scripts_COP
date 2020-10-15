%by Felipe Fava de Lima
%felipefavadelima@usp.br

% Script to convert N(Forces)[Fx, Fy, Fz] and N.m(Moments)[Mx, My,Mz] from a 
%   AMTI 0R6-7-1000 + MSA-6 Amplifier (Gain 4k) - Serial Number 4281
% to a COP location data

% Input:
%           N_Nm_Data = Array, coluns names [Fx,Fy,Fz,Mx,My,Mz],
%                                                 units [N,N,N,N.m,N.m,N.m]

%Output:    
%           COPxy_mm = Array, coluns names [COPx,COPy],
%                                                 units [mm,mm]
function COPxy_mm = N_Nm2COP_OR67(N_Nm_Data)

%Location (in meters) of the center of the force plate 
%from calibration certificate
%C0 = [x0 y0 z0]
C0 = [0.375e-3 -0.155e-3 -43.577e-3];


%COP equations:
%Reference:
%Lafond, D., Duarte, M., & Prince, F. (2004). Comparison of
%three methods to estimate the center of mass during balance 
%assessment. Journal of biomechanics, 37(9), 1421-1426.

%COPx = ((-My + Fx.Z0)/Fz) + X0 
COPx = ((-N_Nm_Data(:,5) + N_Nm_Data(:,1).* C0(3))./N_Nm_Data(:,3)) + C0(1);

%COPy = ((Mx + Fy.Z0)/Fz) + Y0 
COPy = ((N_Nm_Data(:,4) + N_Nm_Data(:,2).* C0(3))./N_Nm_Data(:,3)) + C0(2);

%m To mm
COPxy_mm = [COPx COPy] .*1000;


end