%% 研究随着入射角变化，散射能量的集中问题（入射角越大，散射越明显）
clc;clear;close all;

%%  定义常量
n1 = 1.0;
n2 = 1.51630;
theta_s = 1:0.1:90;
phi_s = 0;
lambda = 550e-9;
sigma = 1e-9;
l = 1e-6;
% 简化表达式用常量
epsilon = (n2/n1)^2;
x = epsilon-1;
xs = (epsilon-(sind(theta_s)).^2).^0.5;
% 绘图线型用元胞
str = {'-s' '-o' '-^' '-+' '-d'};
% K相关模型的三个可调参数ABC
A = 2*pi*sigma^2*l^2;
B = 2*pi*l;

%% 计算仿真
for i = 1:5
    theta_i = 15*i;
    xi = (epsilon-(sind(theta_i))^2)^0.5;
    
    qss = abs(x./((cosd(theta_i)+xi)*(cosd(theta_s)+xs)));
    qpp = abs(x*(xi*xs-epsilon*sind(theta_i)*sind(theta_s))./...
            ((epsilon*cosd(theta_i)+xi)*(epsilon*cosd(theta_s)+xs)));
    Qss = qss.^2;
    Qpp = qpp.^2;
    Q = 1/2*(Qss+Qpp);
    
    fx = (sind(theta_s)-sind(theta_i))/lambda;
    PSD = A./(1+(B*fx).^2).^1.5;
    
    BRDF = (16*pi^2/lambda^4)*cosd(theta_i)*cosd(theta_s).*Q.*PSD;
    
    plot(theta_s-theta_i,BRDF,str{i},...
        'LineWidth',1.5,...
        'MarkerIndices',1:15:length(BRDF),...
        'MarkerSize',6);
    legend_str{i} = ['\theta =' num2str(theta_i) '\circ'];  % 绘制图例（如何添加变量）
    hold on;
end

%% 完善绘图
xlim([-15 15]);
plot([0,0],[0,4.27e-4],'--k','LineWidth',1);
plot([-15,15],[2e-4,2e-4],'--k','LineWidth',1);
annotation('textarrow',[0.3,0.3],[0.6,0.5],'LineWidth',0.75);
annotation('textarrow',[0.2,0.2],[0.6,0.5],'LineWidth',0.75);
text(-13,3e-4,'lobe growing','FontSize',12);
legend(legend_str);
xlabel('dispersive angle（\circ）') ;
ylabel('BRDF value');
% title('Degree of angular dispersion vary with incident angle');
% exportgraphics(gcf,'入射角对散射的影响.png','Resolution',300);
% exportgraphics(gcf,'入射角对散射的影响2.png','Resolution',600);
% exportgraphics(gcf,'入射角对散射的影响3.png','Resolution',1200);