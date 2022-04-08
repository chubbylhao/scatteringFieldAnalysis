%% 热力图表示（比较直观、综合）
clear;clc;

%% 定义基本量
n_air = 1.0;            % 空气折射率
n_surf = 1.51630;       % K9玻璃折射率
lambda = 550e-9;        % LED白光光源波长
sigma = 1e-9;          % 表面粗糙度
length = 1e-6;          % 相关长度           （高斯模型规定的是一个比值）
M = zeros(361,91);      % BRDF值存储矩阵
epsilon = (n_surf/n_air)^2;
X = epsilon-1;

% K相关模型的三个可调参数ABC
C = 3;
B = 2*pi*length;
A = sigma^2*B^2*(C-2)/(2*pi);

%% BRDF值是theta_i、theta_s和phi_s的函数
for theta_i = 10:10:40
    for phi_s = 0:1:360
        for theta_s = 0:1:90
            xi = (epsilon-(sind(theta_i))^2)^0.5;
            xs = (epsilon-(sind(theta_s))^2)^0.5;
            
            % 计算散射因子Q
            qss = abs(X*cosd(phi_s)/((cosd(theta_i)+xi)*(cosd(theta_s)+xs)));
            qsp = abs(X*xs*sind(phi_s)/((cosd(theta_i)+xi)*(epsilon*cosd(theta_s)+xs)));
            qps = abs(X*xi*sind(phi_s)/((epsilon*cosd(theta_i)+xi)*(cosd(theta_s)+xs)));
            qpp = abs(X*(xi*xs*cosd(phi_s)-epsilon*sind(theta_i)*sind(theta_s))/...
                ((epsilon*cosd(theta_i)+xi)*(epsilon*cosd(theta_s)+xs)));
            Q = (qss^2+qsp^2+qps^2+qpp^2)/2;
            
            % 使用K相关模型拟合SPSD
%             fx = (sind(theta_s)*cosd(phi_s)-sind(theta_i))/lambda;
%             fy = sind(theta_s)*sind(phi_s)/lambda;
%             f = (fx^2+fy^2)^0.5;
%             SPSD = A/(1+(B*f)^2)^(C/2);
            
            % 使用高斯分布微粗糙表面（另一种表面模型）
            fx = (sind(theta_s)*cosd(phi_s)-sind(theta_i))/lambda;
            fy = sind(theta_s)*sind(phi_s)/lambda;
            SPSD = pi*sigma^2*length^2*exp(-pi^2*length^2*(fx^2+fy^2));
            
            
            % 计算BRDF值
            BRDF = (16*pi^2/lambda^4)*cosd(theta_i)*cosd(theta_s)*Q*SPSD;
            M(phi_s+1,theta_s+1) = BRDF;
        end
    end


%% 可视化
theta = 0:1:360;
rho = 0:1:90;
[x,y,z] = pol2cart(deg2rad(theta.'),rho,M);
subplot(1,4,theta_i/10);
h = surf(x,y,z);hold on;
colormap('jet');
% c = colorbar;
c.Label.String = 'The Value（BRDF）';
axis off;
axis equal;         % 刻度以等长方式显示
shading interp;     % 投影法绘制热力图
view(0,90);
end
% exportgraphics(gcf,'粗糙度散射热图1.png','Resolution',300);