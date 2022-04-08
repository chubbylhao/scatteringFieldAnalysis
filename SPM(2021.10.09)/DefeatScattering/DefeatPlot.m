%% 划痕与麻点建模
clear;clc;

%% 定义常量
w = 0.5e-6;
d = 200e-9;
l = 5e-6;
x = linspace(-l/2,l/2,100);
y = x;
[X,Y] = meshgrid(x);
Z1 = zeros(size(100));
Z2 = Z1;
theta = -60;

%% 数值积分
% % V-划痕缺陷
% for i=1:100
%     for j=1:100
%         if (abs(x(j)*cosd(theta)+y(i)*sind(theta))<=w/2)
%             Z1(i,j) = d*(2*abs(x(j)*cosd(theta)+y(i)*sind(theta))/w-1);
%         else
%             Z1(i,j) = 0;
%         end
%     end
% end

% 矩形-划痕缺陷
for i=1:100
    for j=1:100
        if (abs(x(j)*cosd(theta)+y(i)*sind(theta))<=w/2)
            Z2(i,j) = -d;
        else
            Z2(i,j) = 0;
        end
    end
end

% % 麻点缺陷
% for i=1:100
%     for j=1:100
%         if (sqrt(x(j)^2+y(i)^2)<=w/2)
%             Z2(i,j) = d*(2*sqrt(x(j)^2+y(i)^2)/w-1);
%         else
%             Z2(i,j) = 0;
%         end
%     end
% end

%% 绘图
figure('Name','划痕模型图窗','Color','white');
surf(X,Y,Z2);axis equal;axis off;shading interp;view(0,90);
% subplot(121),surf(X,Y,Z1);shading interp;view(0,90);axis equal;axis off;
% subplot(122),surf(X,Y,Z2);shading interp;view(0,90);axis equal;axis off;
colormap('jet');
exportgraphics(gcf,'矩形划痕缺陷建模.png','Resolution',600);