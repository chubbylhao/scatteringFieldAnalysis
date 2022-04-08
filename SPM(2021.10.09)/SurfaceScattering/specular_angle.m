%% 研究散射极值问题（镜反射方向有散射极大值）
clear;clc;close all;

%% 定义常量
n1 = 1.0;   % 空气折射率
n2 = 1.51630;   % 粗糙表面所在物体的折射率
lambda = 550e-9;    % 入射光波长
sigma = 1e-9;    % 粗糙表面的粗糙度值（需远小于入射光波长）
l = 1e-6;           % 相关长度（精密光学表面：1~100μm）
theta_s = 1:0.1:90;     % 散射天顶角
phi_s = 0;              % 散射方位角
% 为简化表达式而设的常量
epsilon = (n2/n1)^2;
x = epsilon-1;
xs = (epsilon-(sind(theta_s)).^2).^0.5;
% 创建一个“绘图线型”的元胞数组
str = {'-s' '-o' '-^' '-+' '-d'};
% K相关模型的三个可调参数ABC
A = 2*pi*sigma^2*l^2;
B = 2*pi*l;

% C = zeros(90,1);

%% 计算仿真
for i = 1:15
    theta_i = 5*i;     % 选择5个角度研究：15°、30°、45°、60°、75°
    xi = (epsilon-(sind(theta_i))^2)^0.5;   % 为简化表达式而设的常量
    
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
    plot(theta_s,BRDF,'--','LineWidth',0.75);
%     plot(theta_s,BRDF,str{i},...
%         'LineWidth',1.5,...
%         'MarkerIndices',1:20:length(BRDF),...
%         'MarkerSize',6);
%     legend_str{i} = ['\theta =' num2str(theta_i) '\circ'];  % 绘制图例（如何添加变量）
    hold on;
end

% 绘制包络曲线用
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
plot(C,'-b','LineWidth',1.5);
annotation('textarrow',[0.6,0.5],[0.7,0.6],'LineWidth',0.75);
annotation('textarrow',[0.6,0.7],[0.7,0.5],'LineWidth',0.75);
annotation('textarrow',[0.6,0.35],[0.7,0.75],'LineWidth',0.75);
dim = [0.6 0.57 0.6 0.3];
str = {'The blue one is','envelope curve of','maximum BRDF'};
h = annotation('textbox',dim,'String',str,'Linestyle','--');
h.FontSize = 11;h.LineWidth = 0.75;h.FitBoxToText = 'on';
xlabel('scattering zenith angle \theta_{s}（0~90\circ）');
ylabel('maximum BRDF value');
exportgraphics(gcf,'BRDF包络曲线.png','Resolution',300);

%% 完善绘图
% plot([30,30],[0,3.55e-4],'--k','LineWidth',1);
% annotation('textarrow',[0.4,0.5],[0.6,0.7],'LineWidth',0.75);
% text(44,3.3e-4,'Specular beam','FontSize',12);
% dim = [0.16 0.74 0.2 0.1];
% annotation('rectangle',dim,'LineWidth',1,'Color','red','FaceColor',[0,1,0],'FaceAlpha',.2);
% annotation('textarrow',[0.3,0.5],[0.8,0.8],'LineWidth',0.75);
% text(44,3.85e-4,'Specular lobe','FontSize',12);
% legend(legend_str);
% xlabel('scattering zenith angle \theta_{s}（0~90\circ）');
% ylabel('BRDF value');
% % title('BRDF value vary with \theta_{i} ');
% exportgraphics(gcf,'镜反射方向散射最强.png','Resolution',300);