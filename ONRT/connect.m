%% ONRT ��ģ  MMGģ��
clear;clc;close all
dbstop if error
ts=0;
te=60;
dt=0.01;
t=ts:dt:te;
x=zeros(length(t),6);
rudder=25;                  % ���
x(1,:)=[1.1 0 0 0 0 rudder/180*pi];       % ��ʼ״̬����ֵ
n=538/60;                   % ������ת��
ship_resistance=4.1656;     % Fr=0.2ʱ�ľ�ˮֱ������
iter=1;
for i=2:length(t)
    u=x(i-1,1);
    v=x(i-1,2);
    p=x(i-1,3);
    r=x(i-1,4);
    phi=x(i-1,5);       % ��ҡ��   rad
    delta=x(i-1,6);     % ���     rad
    rho=1000;           % ˮ�ܶ�
    g=9.81;
    U=sqrt(u^2+v^2);    % ���ٶ�
    % ���Ͳ���ֵ
    L=3.147;            B=0.384;            D=0.266;            d=0.112;
    W=72.6;             GM=0.0424;          A_R=0.012*2;        C_b=0.535;
    K_xx=0.444*B;       K_yy=0.246*L;       K_zz=0.246*L;       D_p=0.1066;
    y_G=0.156; % ���ĸ߶ȣ�����������
    S_0=1.5;   % ����ʪ�����
    % ˮ����ϵ���Ͷ�ϵ��
    epsilong=1.;        gamma_R=0.7;        l_R=-1.0*L;         t_R=0.3;
    alpha_H=0.25;       z_HR=0.854*d;       x_H=-0.45*L;        m_x=0.01307;
    X_vv=-0.08577;      X_vr=0.052212;      X_rr=-0.02126;      m_y=0.10901;
    Y_v=-0.30015;       Y_r=-0.08316;       Y_vvv=-1.77272;     Y_vvr=0.261986;
    Y_vrr=-0.79966;     Y_rrr=0.173916;     Y_phi=-0.00051;     J_x=4.1e-5;
    z_H=0.852*d/L;      K_p=-0.2429;        K_phi=0.000626;     J_z=0.00789;
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
    lambda_R=1.1814;       % ���չ�ұ�
    x_R=-0.446*L;            % ���������������������ĵľ���
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
    u_R=epsilong*u_p*sqrt(elta*(1+kappa*(sqrt(1+8*K_T/pi/J^2)-1))^2+1-elta);
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
    % ����������͹��Ծ�
    m=W/(1/2*rho*L^2*d);
    I_x=W*K_xx^2/(1/2*rho*L^4*d);
    I_z=W*K_zz^2/(1/2*rho*L^4*d);
    % ����GZ
    GZ=GM*sin(phi);
    % ����״̬��������
    u_dot=((T-ship_resistance+X_R)/(1/2*rho*L*d)+X_rr*r^2*L^2+X_vr*v*r*L+X_vv*v^2+(m+m_y)*v*r*L)/(L*(m+m_x));
    v_dot=(Y_r*r*L*U+Y_v*v*U+Y_phi*phi*U^2+Y_rrr*r^3*L^3/U+Y_vrr*r^2*v*L^2/U+Y_vvr*v^2*r*L/U+Y_vvv*v^3/U+...
        Y_R/(1/2*rho*L*d)-(m+m_x)*u*r*L)/(L*(m+m_y));
    p_dot=(m_x*z_H*u*r*L+K_r*r*L*U+K_p*p*L*U+K_v*v*U+K_phi*phi*U^2+(K_R-W*g*GZ)/(1/2*rho*L^2*d)+...
        K_rrr*r^3*L^3/U+K_vrr*v*r^2*L^2/U+K_vvr*v^2*r*L/U+K_vvv*v^3/U)/(L^2*(I_x+J_x));
    r_dot=(N_r*r*L*U+N_v*v*U+N_phi*phi*U^2+N_rrr*r^3*L^3/U+N_vrr*r^2*v*L^2/U+N_vvr*r*v^2*L/U+N_vvv*v^3/U+N_R/(1/2*rho*L^2*d))/(L^2*(I_z+J_z));
    % ���״̬��������ֵ
    x_dot=[u_dot v_dot p_dot r_dot];
    zhi(i-1,:)=[x_dot X_R Y_R K_R N_R J];
    % ����
    x(i,1:4)=x(i-1,1:4)+x_dot(1:4)*dt;
    x(i,5)=x(i-1,5)+x(i-1,3)*dt;
    x(i,6)=rudder/180*pi;
    iter=iter+1;
end
%% plot
% trajectory
traj_x=zeros(length(t),1);
traj_y=zeros(length(t),1);
psi=zeros(length(t),1);
for i=2:length(t)
    psi(i)=psi(i-1)+x(i-1,4)*dt;             % �����
    u_bar=x(i-1,1);
    v_bar=x(i-1,2);
    traj_x(i)=traj_x(i-1)+u_bar*dt*cos(psi(i-1))-v_bar*dt*sin(psi(i-1));
    traj_y(i)=traj_y(i-1)+u_bar*dt*sin(psi(i-1))+v_bar*dt*cos(psi(i-1));
end
% ����״̬����ʱ������
figure('units','normalized','position',[0.1 0.3 0.4 0.5])
plot(t,x(:,1),'r',t,x(:,2),'g',t,x(:,4),'b',t,x(:,5),'c:','linewidth',1.2);
grid on
legend('u','v','r','\Phi')
title('state variables')
% �����˶��켣
figure('units','normalized','position',[0.5 0.3 0.4 0.5])
plot(traj_x/L,traj_y/L,'linewidth',1.5);grid on;axis equal;
xlabel('x/L');ylabel('y/L');
title('trajectory')