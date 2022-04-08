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
end