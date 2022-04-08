% 函数说明：绘制柱坐标下的曲面，再通过投影得到热力图
function CylindricalPlot(phis_deg,thetas_deg,matrix,colorbar_name)
    if nargin < 3
        error('输入参数的数目不足！');
    end
    
    theta = 0:phis_deg:360;         % 在考虑计算机内存与算力的情况下，步长不宜太小
    rho = 0:thetas_deg:100;
    [x,y,z] = pol2cart(deg2rad(theta.'),rho,matrix);
    
    % 提醒错误
    if ~isequal(size(matrix),size(theta.'*rho))
        error('储值矩阵的维度错误！');
    end
    
    figure('Name','热力图图窗','Color','white');
    surf(x,y,z);        % z(matrix)的维度需满足size(theta.'*rho)
    colormap('jet');
    
    if nargin == 4      % 控制colorbar的绘制
        c = colorbar;
        c.Label.FontSize = 10;
        c.Label.String = colorbar_name;
    elseif 4 < nargin
        error('输入参数的数目过多！');
    end
    
    grid off;
    axis off;
    axis equal;
    shading interp;
    view(0,90);
    hold on;
    
%     % 额外绘制（第一张热力示意图）
%     CirclePlot(30,0,0);
%     CirclePlot(60,0,0);
%     CirclePlot(90,0,0);
%     AngularDimension(30,0,0,120,'--r',2.5);
%     AngularDimension(60,0,0,30,'--y',2.5);
%     X1 = -45:0.1:0;
%     X2 = 0:0.1:45;
%     X3 = -45*sqrt(3):0.1:45*sqrt(3);
%     Y1 = -sqrt(3)*X1;
%     Y2 = -sqrt(3)*X2;
%     Y3 = sqrt(1/3)*X3;
%     plot(X1,Y1,'-r','LineWidth',2.5);
%     plot(X2,Y2,'--r','LineWidth',2.5);
%     plot(X3,Y3,'--y','LineWidth',2.5);
%     plot([-90,0],[0,0],'--w');
%     plot([0,90],[0,0],'-r','LineWidth',2.5);
%     plot([0,0],[-90,90],'--w');
%     text(0,-5,'0\circ','Color','w','FontSize',14);
%     text(-30,-5,'30\circ','Color','w','FontSize',14);
%     text(-60,-5,'60\circ','Color','w','FontSize',14);
%     text(-90,-5,'90\circ','Color','w','FontSize',14);
%     text(5,40,'\phi_{s}=120\circ','Color','r','FontSize',16);
%     text(65,20,'\theta=30\circ','Color','y','FontSize',16);
end