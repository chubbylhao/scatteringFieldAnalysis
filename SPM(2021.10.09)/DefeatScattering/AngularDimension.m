% 角度标注函数
function AngularDimension(R,cx,cy,angle,color,linewidth)
    alpha=0:pi/2000:deg2rad(angle);
    x=R*cos(alpha)+cx;
    y=R*sin(alpha)+cy;
    plot(x,y,color,'LineWidth',linewidth);
end