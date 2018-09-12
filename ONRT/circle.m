% plot
clear;clc;close all
u=0.8;v=-0.15;
t=0:0.13:2*pi;
trajx=zeros(length(t),1);
trajy=zeros(length(t),1);
for i=2:length(t)
    trajx(i)=trajx(i-1)+u*cos(t(i))-v*sin(t(i));
    trajy(i)=trajy(i-1)+u*sin(t(i))+v*cos(t(i));
end
scatter(trajx,trajy,'.');
axis equal