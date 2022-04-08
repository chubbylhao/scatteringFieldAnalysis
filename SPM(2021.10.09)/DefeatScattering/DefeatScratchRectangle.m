% 函数说明：计算矩形划痕缺陷的SPSD
function [SPSD] = DefeatScratchRectangle(fx,fy,theta)
    w = 400e-9;        % 针对晶圆检测所提出的要求（空间分辨率≤40nm）（取对数绘图时为40）
    d = 20e-9;        % 缺陷深度
    l = 4e-6;         % 扫描区域4×4（μm）
    x = linspace(-l/2,l/2,100);
    y = x;
    Z = zeros(size(100));
    integral = Z;

    for i=1:100
        for j=1:100
            if (abs(x(j)*cosd(theta)+y(i)*sind(theta))<=w/2)
                Z(i,j) = -d;
                integral(i,j) =  -d*exp(-1i*2*pi*(x(j)*fx+y(i)*fy))*(l/100)^2;
            else
                Z(i,j) = 0;
                integral(i,j) = 0;
            end
        end
    end

    SPSD = (abs(sum(integral,'All')))^2/l^2;
end