%% 擦伤缺陷的散射热图（实际上就是更粗糙（大于波长量级）的表面）
clear;clc;

%% 定义基本量
% 预定义BRDF存储矩阵
M = zeros(37,11);
% 擦伤部分的粗糙度
sigma = 1e-6;
% 入射天顶角
theta_i =80; 
% 入射方位角
phi_i = 180;

%% 计算BRDF值
 for phi_s = 0:10:360
     for theta_s = 0:10:90
         
         % 计算两个中间量
         beta = acosd(cosd(theta_i)*cosd(theta_s)+sind(theta_i)*...
             sind(theta_s)*cosd(phi_s-phi_i))/2;
         
         theta = acosd((cosd(theta_i)+cosd(theta_s))/(2*cosd(beta)));
         
         % PD为微面元方位（法向）的概率分布函数
         PD = exp(-(tand(theta))^2/(2*(sigma)^2))/...
             (4*pi*(sigma)^2*(cosd(theta))^3);
         
         % G为遮蔽因子
         G = min([1,2*cosd(theta)*cosd(theta_s)/cosd(beta),...
             2*cosd(theta)*cosd(theta_i)/cosd(beta)]);
         
         % 计算BRDF值
         BRDF = (1/cosd(theta))*(PD/(cosd(theta_i)*cosd(theta_s)))*G;
         
         % 存储BRDF值
         M(phi_s/10+1,theta_s/10+1) = BRDF;
     end
 end
 
 %% 可视化
 % 需要显示colorbar时输入第4个参数
CylindricalPlot(10,10,M);    

%% 导出图像
% exportgraphics(gcf,'擦伤缺陷4.png','Resolution',300);