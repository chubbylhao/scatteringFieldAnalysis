%% 研究phi_s=0的情形下，各散射接收角度theta_s的BRDF最大值随入射角度theta_i的变化
clc;clear;close all;

%% 定义常量
n1 = 1.0;
n2 = 1.51630;
theta_s = 1:1:90;
phi_s = 0;
lambda = 550e-9;
sigma = 55e-9;
l = 1e-6;
C = zeros(90,1);
epsilon = (n2/n1)^2;
x = epsilon-1;
xs = (epsilon-(sind(theta_s)).^2).^0.5;

%% 计算仿真
for theta_i = 1:1:90
    xi = (epsilon-(sind(theta_i))^2)^0.5;
    
    qss = abs(x./((cosd(theta_i)+xi)*(cosd(theta_s)+xs)));
    qpp = abs(x*(xi*xs-epsilon*sind(theta_i)*sind(theta_s))./...
            ((epsilon*cosd(theta_i)+xi)*(epsilon*cosd(theta_s)+xs))); 
    Qss = qss.^2;
    Qpp = qpp.^2;
    Q = 1/2*(Qss+Qpp);
    
    fx = (sind(theta_s)-sind(theta_i))/lambda;
    A = 2*pi*sigma^2*l^2;
    B = 2*pi*l;
    PSD = A./(1+(B*fx).^2).^1.5;
    
    BRDF = (16*pi^2/lambda^4)*cosd(theta_i)*cosd(theta_s).*Q.*PSD;
    
    C(theta_i) = max(BRDF);
end

%% 完善绘图
C = C/max(C);
plot(C,'-^b','MarkerIndices',1:5:length(C),'LineWidth',2,'MarkerFaceColor',[0,0,1]);
xlabel('The incident angle \theta_{i}') ;
ylabel('The normalized BRDF(\theta_{s})_{max}');
title('The maximal BRDF value of \theta_{s} vary with \theta_{i} from 0~\pi/2');
% exportgraphics(gcf,'3.png','Resolution',600);