%% ONRT circle test
% 采用显示Euler法求解微分方程
clear;clc;close all
% global GZ_curve
% load GZ_curve;
ts=0;           % 仿真开始时间
te=300;         % 仿真结束时间
dt=0.01;        % 时间间隔
t=ts:dt:te;
x=zeros(length(t),6);                       % 状态变量存储
rudder=35;                                  % 舵角
rpm=550;                                    % 螺旋桨转速 rpm
x(1,:)=[1.1 0 0 0 0 rudder/180*pi];         % 状态变量初值
for i=2:length(t)
    x_dot=ONRT(x(i-1,:),rpm/60);
    x(i,1:4)=x(i-1,1:4)+x_dot(1:4)*dt;
    x(i,5)=x(i-1,5)+(x(i-1,3)+x(i,3))*dt/2;
    x(i,6)=rudder/180*pi;
end
%% plot
% trajectory
traj_x=zeros(length(t),1);
traj_y=zeros(length(t),1);
psi=zeros(length(t),1);
for i=2:length(t)
    psi(i)=psi(i-1)+(x(i-1,4)+x(i,4))*dt/2;             % 首向角
    u_bar=(x(i-1,1)+x(i,1))/2;
    v_bar=(x(i-1,2)+x(i,2))/2;
    traj_x(i)=traj_x(i-1)+u_bar*dt*cos(psi(i-1))-v_bar*dt*sin(psi(i-1));
    traj_y(i)=traj_y(i-1)+u_bar*dt*sin(psi(i-1))+v_bar*dt*cos(psi(i-1));
end
% 绘制状态变量时历曲线
figure('units','normalized','position',[0.1 0.3 0.4 0.5])
plot(t,x(:,1),'r',t,x(:,2),'g',t,x(:,4),'b',t,x(:,5),'c:','linewidth',1.2);
grid on
legend('u','v','r','\Phi')
title('state variables')
% 绘制运动轨迹
figure('units','normalized','position',[0.5 0.3 0.4 0.5])
plot(traj_x,traj_y,'linewidth',1.5);grid on;axis equal
title('trajectory')


