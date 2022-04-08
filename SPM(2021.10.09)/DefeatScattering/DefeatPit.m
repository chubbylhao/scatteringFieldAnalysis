% 函数说明：计算划痕缺陷的SPSD
function [SPSD] = DefeatPit(fx,fy)
    w = 3e-6;               % 此处有点特殊，需要特别留心（取对数绘图时为3）
    d = 20e-9;
    l = 4e-6;
    x = linspace(-l/2,l/2,100);
    y = x;
    Z = zeros(size(100));
    integral = Z;

    for i=1:100
        for j=1:100
            if (sqrt(x(j)^2+y(i)^2)<=w/2)
                Z(i,j) = d*(2*sqrt(x(j)^2+y(i)^2)/w-1);
                integral(i,j) =  Z(i,j)*exp(1i*2*pi*(x(j)*fx+y(i)*fy))*(l/100)^2;
            else
                Z(i,j) = 0;
                integral(i,j) =  0;
            end
        end
    end

    SPSD = (abs(sum(integral,'All')))^2/l^2;
end