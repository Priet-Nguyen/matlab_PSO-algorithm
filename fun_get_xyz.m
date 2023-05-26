%a script to get x, y, z from simulink
%function [x,y,z]=get_x_y_z(c) % c is vector of coefficients

%initial conditions
x0 = 6;
y0 = 1.4;
z0 = 1;

%
%c=[4.7500   -3.6200  -12.7400  -16.6900   19.4600   1.4300   -5.1000    4.8000  -11.3200]
%Growth Function Param
g_x = c(1)/20;
g_y = c(2)/20;
g_z = c(3)/20;

%INTERACTION Constants
d_xy = c(4)/20;
d_xz = c(5)/20;

d_yx = c(6)/20;
d_yz = c(7)/20;

d_zx = c(8)/20;
d_zy = c(9)/20;

dxy=d_xy;
dxz=d_xz;
dyx=d_yx;
dyz=d_yz;
dzx=d_zx;
dzy=d_zy;
gx=g_x;
gy=g_y;
gz=g_z;

%Theoretical equilibrium point
x_nume = -d_xy * d_yz * g_z - d_xz * d_zy * g_y + d_yz * d_zy * g_x;
y_nume = -d_xz * d_yz * g_z + d_xz * d_zx * g_y - d_yz * d_zx * g_x;
z_nume = d_xy * d_yz * g_z - d_xy * d_zx * g_y - d_yz * d_zy * g_x;

eq_deno = (d_xy * d_yz * d_zx + d_xz * d_yz * d_zy);

x_eq = x_nume / eq_deno;
y_eq = y_nume / eq_deno;
z_eq = z_nume / eq_deno;

%INPUT signal

mu_y = 1;
mu_x_c24 = -d_zy/d_zx * mu_y  ;% case 1
mu_x= 0.9*mu_x_c24;
mu_x_c31 = d_zy/d_zx * mu_y; % case 3

% x_d = x0;
% y_d = y0;
% z_d = z0;

ts = 1e-3;

x_beta = 1;
alpha = 1; % constant for 1/2 Sz^2
phi = 0.25; % constant for tanht

% %run simulink
% simOut=sim('Lodka_Volterra_20220830');
% x=x_simout;
% y=y_simout;
% z=z_simout;
x=zeros(1,2);
y=zeros(1,2);
z=zeros(1,2);




for i=1:2
    simOut=sim('Lodka_Volterra_20220830');
    x_curr=x_simout;
    y_curr=y_simout;
    z_curr=z_simout;
    x(i)=x_simout(500);
    y(i)=y_simout(500);
    z(i)=z_simout(500);
    %INPUT SIGNAL
    %change c after each iteration of i
    c=c+0.01;
    %Growth Function Param
    %need to normalize coefficients!!!
    g_x = c(1)/20;
    g_y = c(2)/20;
    g_z = c(3)/20;
    
    %INTERACTION Constants
    d_xy = c(4)/20;
    d_xz = c(5)/20;
    
    d_yx = c(6)/20;
    d_yz = c(7)/20;
    
    d_zx = c(8)/20;
    d_zy = c(9)/20;
       
    %Theoretical equilibrium point
    x_nume = -d_xy * d_yz * g_z - d_xz * d_zy * g_y + d_yz * d_zy * g_x;
    y_nume = -d_xz * d_yz * g_z + d_xz * d_zx * g_y - d_yz * d_zx * g_x;
    z_nume = d_xy * d_yz * g_z - d_xy * d_zx * g_y - d_yz * d_zy * g_x;
    
    eq_deno = (d_xy * d_yz * d_zx + d_xz * d_yz * d_zy);
    
    x_eq = x_nume / eq_deno;
    y_eq = y_nume / eq_deno;
    z_eq = z_nume / eq_deno;
    
    %INPUT signal
    
    mu_y = 1;
    mu_x_c24 = -d_zy/d_zx * mu_y  ;% case 1
    mu_x= 0.9*mu_x_c24;%check this?
    mu_x_c31 = d_zy/d_zx * mu_y; % case 3
    fprintf('i=%d\n',i)
end

               