%% 研究表面粗糙度对散射的影响（表面越粗糙，散射越明显）
clear;clc;close all;

%%
n1 = 1.0;   
n2 = 1.51630;   
sigma = 1e-9;    
l = 1e-6;           
theta_s = 1:0.1:90;     
phi_s = 0;             
epsilon = (n2/n1)^2;
x = epsilon-1;
xs = (epsilon-(sind(theta_s)).^2).^0.5;
str = {'-s' '-o' '-^' '-+' '-d' '-x' '-*'};
A = 2*pi*sigma^2*l^2;
B = 2*pi*l;

%%
for i=0:6
    lambda = 400e-9+i*60e-9;
    theta_i = 45;     
    xi = (epsilon-(sind(theta_i))^2)^0.5;   
    
    % 计算偏振因子Q
    qss = abs(x./((cosd(theta_i)+xi)*(cosd(theta_s)+xs)));
    qpp = abs(x*(xi*xs-epsilon*sind(theta_i)*sind(theta_s))./...
            ((epsilon*cosd(theta_i)+xi)*(epsilon*cosd(theta_s)+xs)));
    Qss = qss.^2;
    Qpp = qpp.^2;
    Q = 1/2*(Qss+Qpp);
    
    % k相关模型拟合SPSD
    fx = (sind(theta_s)-sind(theta_i))/lambda;
    SPSD = A./(1+(B*fx).^2).^1.5;
    
    % 计算BRDF值
    BRDF = (16*pi^2/lambda^4)*cosd(theta_i)*cosd(theta_s).*Q.*SPSD;
    
    % 可视化
    plot(theta_s,BRDF,str{i+1},...
        'LineWidth',1.5,...
        'MarkerIndices',1:20:length(BRDF),...
        'MarkerSize',6);
    legend_str{i+1} = ['\lambda =' num2str(lambda*1e9) 'nm'];
    hold on;
end

%%
plot([45,45],[0,10.18e-4],'--k','LineWidth',1);
plot([0,45],[2.85e-4,2.85e-4],'--k','LineWidth',1);
plot(45,2.85e-4,'ro','LineWidth',3);
text(30,5e-4,'\lambda=550nm','FontSize',12);
annotation('textarrow',[0.52,0.35],[0.3,0.4],'LineWidth',0.75);
dim = [0.18 0.5 0.6 0.3];
str = {'Visible spectrum','\lambda=400~760nm'};
annotation('textbox',dim,'String',str,'Linestyle','--','FitBoxToText','on','FontSize',12);
legend(legend_str);
xlim([25 65]);
xlabel('scattering zenith angle \theta_{s}');
ylabel('BRDF value');
% title('BRDF value vary with \lambda ');
exportgraphics(gcf,'波长对散射的影响.png','Resolution',300);