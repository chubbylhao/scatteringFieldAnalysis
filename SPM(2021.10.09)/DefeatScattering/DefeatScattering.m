%% 划痕与麻点缺陷散射的热力图
clear;clc;

%% 定义基本量
n_air = 1.0;            % 空气折射率
n_surf = 1.51630;       % K9玻璃折射率
lambda = 550e-9;        % LED白光光源波长
M = zeros(37,11);      % BRDF值存储矩阵
epsilon = (n_surf/n_air)^2;
X = epsilon-1;
theta_i = 45;

%% 计算BRDF值
 for phi_s = 0:10:360
     for theta_s = 0:10:90
         
             xi = (epsilon-(sind(theta_i))^2)^0.5;
             xs = (epsilon-(sind(theta_s))^2)^0.5;
            
            % 计算散射因子Q
            qss = abs(X*cosd(phi_s)/((cosd(theta_i)+xi)*(cosd(theta_s)+xs)));
            qsp = abs(X*xs*sind(phi_s)/((cosd(theta_i)+xi)*(epsilon*cosd(theta_s)+xs)));
            qps = abs(X*xi*sind(phi_s)/((epsilon*cosd(theta_i)+xi)*(cosd(theta_s)+xs)));
            qpp = abs(X*(xi*xs*cosd(phi_s)-epsilon*sind(theta_i)*sind(theta_s))/...
                ((epsilon*cosd(theta_i)+xi)*(epsilon*cosd(theta_s)+xs)));
            Q = (qss^2+qsp^2+qps^2+qpp^2)/2;

            fx = (sind(theta_s)*cosd(phi_s)-sind(theta_i))/lambda;
            fy = sind(theta_s)*sind(phi_s)/lambda;
            
%             % 划痕
%             SPSD = DefeatScratch(fx,fy,30);
            
            % 矩形划痕
            SPSD = DefeatScratchRectangle(fx,fy,30);
            
%             % 麻点
%             SPSD = DefeatPit(fx,fy);
            
            % 计算BRDF值
            BRDF = (16*pi^2/lambda^4)*cosd(theta_i)*cosd(theta_s)*Q*SPSD;
            M(phi_s/10+1,theta_s/10+1) = BRDF;
     end
 end
 
 %% 可视化
CylindricalPlot(10,10,M);    % 需要显示colorbar时输入第4个参数

% exportgraphics(gcf,'矩形划痕5.png','Resolution',300);