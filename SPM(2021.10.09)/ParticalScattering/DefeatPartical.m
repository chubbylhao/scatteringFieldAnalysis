%% 说明：
% 表面粒子的散射比较均匀，并且存在一个比较奇怪的现象
% 在镜反射方向上散射量很微弱，但在入射方向上存在较大值！！！
clear;clc;

%% 定义基本量
n_sph = 1.59;
n = (n_sph/1.0)^2;
lambda = 550e-9;
a = 100e-9;          % 粒子尺度要远小于入射光波长（此处为粒子半径）
M = zeros(37,11);
theta_i = 70;

%% 计算仿真
for phi_s = 0:10:360
     for theta_s = 0:10:90
            
            alpha = exp(2*a*cosd(theta_i)*1i*2*pi/lambda);
            beta = exp(2*a*cosd(theta_s)*1i*2*pi/lambda);
            rp_theta_i = (n^2*cosd(theta_i)-sqrt(n^2-(sind(theta_i))^2))/...
                (n^2*cosd(theta_i)+sqrt(n^2-(sind(theta_i))^2));
            rp_theta_s = (n^2*cosd(theta_s)-sqrt(n^2-(sind(theta_s))^2))/...
                (n^2*cosd(theta_s)+sqrt(n^2-(sind(theta_s))^2));
            rs_theta_i = (cosd(theta_i)-sqrt(n^2-(sind(theta_i))^2))/...
                (cosd(theta_i)+sqrt(n^2-(sind(theta_i))^2));
            rs_theta_s = (cosd(theta_s)-sqrt(n^2-(sind(theta_s))^2))/...
                (cosd(theta_s)+sqrt(n^2-(sind(theta_s))^2));
            
            % 计算散射因子Q
            qss = abs((1+beta*rs_theta_s)*(1+alpha*rs_theta_i)*cosd(phi_s));
            qsp = abs(-(1-beta*rp_theta_s)*(1+alpha*rs_theta_i)*cosd(theta_s)*sind(phi_s));
            qps = abs(-(1+beta*rs_theta_s)*(1-alpha*rp_theta_i)*cosd(theta_i)*sind(phi_s));
            qpp = abs((1+beta*rp_theta_s)*(1+alpha*rp_theta_i)*sind(theta_i)*sind(theta_s)-...
                (1-beta*rp_theta_s)*(1-alpha*rp_theta_i)*cosd(theta_s)*cosd(theta_i)*cosd(phi_s));
            Q = (qss^2+qsp^2+qps^2+qpp^2)/2;

            % 计算BRDF值
            BRDF = (16*pi^4/lambda^4)*((n_sph^2-1)/(n_sph^2+2))^2*(a^6/(cosd(theta_s*cosd(theta_i))))*Q;
            M(phi_s/10+1,theta_s/10+1) = BRDF;
     end
end
 
%% 可视化
CylindricalPlot(10,10,M);

% exportgraphics(gcf,'论文插图5.png','Resolution',300);