clear;clc;close all;
n_air = 1.0;                % 空气折射率
n_surf = 1.51630;           % K9玻璃折射率
lambda = 550e-9;            % LED白光光源波长   
M1 = zeros(91,1);           % BRDF值存储矩阵
M2 = zeros(91,1);           % BRDF值存储矩阵
epsilon = (n_surf/n_air)^2;
X = epsilon-1;
phi_s = 0;          % 设置探测器的较为简单且合理的角度

 for theta_i = 0:1:90       % 研究入射角变化
     for theta_s = 25       % 探测器在15°~30°间比较合理
         
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
            
            % 划痕
            SPSD1 = DefeatScratch(fx,fy,30);
            
            % 麻点
            SPSD2 = DefeatPit(fx,fy);
            
            % 计算BRDF值
            BRDF1 = (16*pi^2/lambda^4)*cosd(theta_i)*cosd(theta_s)*Q*SPSD1;
            BRDF2 = (16*pi^2/lambda^4)*cosd(theta_i)*cosd(theta_s)*Q*SPSD2;
            M1(theta_i+1,1) = log(BRDF1);
            M2(theta_i+1,1) = log(BRDF2);
     end
 end

% 取对数后绘图
% plot(M1,'-d','LineWidth',1.5,'MarkerSize',6);hold on;
plot(M2,'-o','LineWidth',1.5,'MarkerSize',6);hold on;
plot([77 77],[-30,-13],'--','LineWidth',2);
plot([56 56],[-30,-12],'--','LineWidth',2);
% legend('scrathes','pits','indicator1','indicator2');
legend('scrathes','indicator1','indicator2');
text(56,-12,'\rightarrow 56\circ','FontSize',14);
text(77,-13,'\rightarrow 77\circ','FontSize',14);
xlabel('dispersive angle（\circ）') ;
ylabel('log(BRDF) value');
exportgraphics(gcf,'小划痕与小麻点照明角度初选.png','Resolution',300);
% % exportgraphics(gcf,'小划痕与小麻点照明角度初选2.png','Resolution',600);
% % exportgraphics(gcf,'小划痕与小麻点照明角度初选3.png','Resolution',1200);

% 不取对数绘图
% plot(exp(M1),'LineWidth',1.5);hold on;
% plot([25.5 25.5],[0,1.28e-5],'--','LineWidth',1.5);
% plot([0,25.5],[1.28e-5 1.28e-5],'--','LineWidth',1.5);
% legend('scratches','indicator1','indicator2');
% annotation('textarrow',[0.5,0.35],[0.7,0.45],'String','主瓣（镜反射瓣）','FontSize',12);
% annotation('textarrow',[0.52,0.52],[0.4,0.2],'String','第一旁瓣能量峰值','FontSize',12);
% annotation('textarrow',[0.73,0.73],[0.3,0.15],'String','第二旁瓣能量峰值','FontSize',12);
% xlabel('dispersive angle（\circ）') ;
% ylabel('BRDF value');
% exportgraphics(gcf,'小划痕随入射角而变化的散射特性.png','Resolution',300);
% exportgraphics(gcf,'小划痕随入射角而变化的散射特性2.png','Resolution',600);
% exportgraphics(gcf,'小划痕随入射角而变化的散射特性3.png','Resolution',1200);