% 绘圆函数，R为半径，cx为圆心横坐标，cy为圆心纵坐标
function circle(R,cx,cy)
alpha=0:pi/2000:2*pi;
x=R*cos(alpha)+cx;
y=R*sin(alpha)+cy;
plot(x,y,'LineWidth',10);
axis equal;
end