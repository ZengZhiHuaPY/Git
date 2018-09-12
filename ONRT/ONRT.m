%% ONRT ��ģ  MMGģ��
function x_dot=ONRT(x,n)
% x=[u v p r phi delta]
% ������ת�� rps
% global GZ_curve
% ������Ϣ
u=x(1);
v=x(2);
p=x(3);
r=x(4);
phi=x(5);       % ��ҡ��   rad
delta=x(6);     % ���     rad

rho=1000;           % ˮ�ܶ�
g=9.81;
ship_resistance=4.6169;  % Fr=0.2ʱ�ľ�ˮֱ������
% ���Ͳ���ֵ
L=3.147;            B=0.384;            D=0.266;            d=0.112;
W=72.6;             GM=0.0424;          A_R=0.012*2;        C_b=0.535;
K_xx=0.444*B;       K_yy=0.246*L;       K_zz=0.246*L;       D_p=0.1066;
y_G=0.156; % ���ĸ߶ȣ�����������
S_0=1.5;   % ����ʪ�����
I_x=W*K_xx^2;
I_z=W*K_zz^2;
% ˮ����ϵ���Ͷ�ϵ��
epsilong=1.;        gamma_R=0.7;        l_R=-1.0*L;         t_R=0.3;
alpha_H=0.25;       z_HR=0.854*d;       x_H=-0.45*L;        m_x=0.01307;
X_vv=-0.08577;      X_vr=0.052212;      X_rr=-0.02126;      m_y=0.10901;
Y_v=-0.30015;       Y_r=-0.08316;       Y_vvv=-1.77272;     Y_vvr=0.261986;
Y_vrr=-0.79966;     Y_rrr=0.173916;     Y_phi=-0.00051;     J_xx=4.1e-5;
z_H=0.852;          K_p=-0.2429;        K_phi=0.000626;     J_zz=0.00789;
N_v=-0.09323;       N_r=-0.05494;       N_vvv=-0.53235;     N_vvr=-0.62895;
N_vrr=-0.13897;     N_rrr=-0.00446;     N_phi=-0.00511;     t_p=0;
w_p=0;
K_temp=z_H*[Y_r,Y_v,Y_rrr,Y_vrr,Y_vvr,Y_vvv];
K_r=K_temp(1);
K_v=K_temp(2);
K_rrr=K_temp(3);
K_vrr=K_temp(4);
K_vvr=K_temp(5);
K_vvv=K_temp(6);
% ����
lambda_R=1.5;       % ���չ�ұ�
x_R=-0.5*L;            % ���������������������ĵľ���
w_R=0;              % ��İ�������
% ���㷨�����
u_p=(1-w_p)*u;
elta=2/3;
kappa=0.6/epsilong;
f_alpha=6.13*lambda_R/(lambda_R+2.25);
J=(1-w_p)*u/(n*D_p);
K_T_S=0.62702-0.26467*J-0.09665*J^2;
K_T_P=0.64111-0.27016*J-0.09319*J^2;
K_T=K_T_S+K_T_P;
u_R=epsilong*u_p*sqrt(elta*(1+kappa*(sqrt(1+8*K_T/pi/J^2)-1))^2+1-kappa);
v_R=-gamma_R*(v+l_R*r);
U_R=sqrt(u_R^2+v_R^2);
alpha_R=delta-gamma_R*v_R/u_R;
F_N=1/2*rho*A_R*f_alpha*U_R^2*sin(alpha_R);
% ��������
X_R=-(1-t_R)*F_N*sin(delta);
Y_R=-(1+alpha_H)*F_N*cos(delta)*cos(phi);
K_R=z_HR*(1+alpha_H)*F_N*cos(delta);
N_R=-(x_R+alpha_H*x_H)*F_N*cos(delta)*cos(phi);
% ��������������
T=(1-t_p)*rho*n^2*D_p^4*K_T;
% ���������ٸ��������͸��ӹ��Ծ�
m_x=m_x*1/2*rho*L^2*d;
m_y=m_y*1/2*rho*L^2*d;
J_x=J_xx*1/2*rho*L^4*d;
J_z=J_zz*1/2*rho*L^4*d;
% ����GZ
phi_d=abs(phi*180/pi);
% ��ϵĳ����Ը�����
GZ_full=6.061*sin(0.01683*phi_d+1.117)+6.184*sin(0.02267*phi_d+4.152)+0.7097*sin(0.06305*phi_d-0.2555)+...
    0.06261*sin(0.1597*phi_d-7.114)+0.02889*sin(0.2135*phi_d-5.881)+0.004875;
if abs(phi_d)>180
    error('Phi_d is more than 180 degree.');
end
% GZ_full=spline(GZ_curve(:,1),GZ_curve(:,2),phi_d);
GZ=sign(phi)*GZ_full/48.94;
% ����״̬��������
u_dot=(T-ship_resistance+X_rr*r^2+X_vr*v*r+X_vv*v^2+X_R+(W+m_y)*v*r)/(W+m_x);
v_dot=(Y_r*r+Y_v*v+Y_phi*phi+Y_rrr*r^3+Y_vrr*r^2*v+Y_vvr*v^2*r+Y_vvv*v^3+Y_R-(W+m_x)*u*r)/(W+m_y);
p_dot=(m_x*z_H*u*r+K_r*r+K_p*p+K_v*v+K_phi*phi-W*g*GZ+K_rrr*r^3+K_vrr*v*r^2+K_vvr*v^2*r...
    +K_vvv*v^3+K_R)/(I_x+J_x);
r_dot=(N_r*r+N_v*v+N_phi*phi+N_rrr*r^3+N_vrr*r^2*v+N_vvr*r*v^2+N_vvv*v^3+N_R)/(I_z+J_z);
% ���״̬��������ֵ
x_dot=[u_dot v_dot p_dot r_dot];
end
