
function model=Create_Select_Model(map_select,map_complexity,startPos,goalPos,n)

if map_select==1
    H = imread('ChrismasTerrain.tif');
    H (H < 0) = 0;
    zmin = 100;
    zmax = 200;

     if map_complexity==1
        % 基础障碍配置
        R1=50;  % Radius
        x1 = 400; y1 = 500; z1 = 200; % center

        R2=40;  % Radius
        x2 = 600; y2 = 200; z2 = 200; % center

        R3=50;  % Radius
        x3 = 500; y3 = 350; z3 = 200; % center
        threats = [x1 y1 z1 R1;x2 y2 z2 R2; x3 y3 z3 R3];
        
    elseif map_complexity==2
        % 中等障碍配置
        R1=50;  % Radius
        x1 = 400; y1 = 500; z1 = 200; % center

        R2=40;  % Radius
        x2 = 600; y2 = 200; z2 = 200; % center

        R3=50;  % Radius
        x3 = 500; y3 = 350; z3 = 200; % center

        R4=40;  % Radius
        x4 = 350; y4 = 200; z4 = 200; % center

        R5=40;  % Radius
        x5 = 700; y5 = 550; z5 = 200; % center

        R6=50;  % Radius
        x6 = 650; y6 = 750; z6 = 150; % center
        threats = [x1 y1 z1 R1;x2 y2 z2 R2; x3 y3 z3 R3; x4 y4 z4 R4; x5 y5 z5 R5;x6 y6 z6 R6];
    
    elseif map_complexity==3
        % 通道式障碍布局
        R1=60;  % Radius
        x1 = 300; y1 = 300; z1 = 200; % center

        R2=60;  % Radius
        x2 = 500; y2 = 300; z2 = 200; % center

        R3=60;  % Radius
        x3 = 700; y3 = 300; z3 = 200; % center

        R4=50;  % Radius
        x4 = 300; y4 = 600; z4 = 200; % center

        R5=50;  % Radius
        x5 = 500; y5 = 600; z5 = 200; % center

        R6=50;  % Radius
        x6 = 700; y6 = 600; z6 = 200; % center

        R7=40;  % Radius
        x7 = 400; y7 = 450; z7 = 200; % center

        R8=40;  % Radius
        x8 = 600; y8 = 450; z8 = 200; % center
        threats = [x1 y1 z1 R1;x2 y2 z2 R2;x3 y3 z3 R3;...
                   x4 y4 z4 R4;x5 y5 z5 R5;x6 y6 z6 R6;...
                   x7 y7 z7 R7;x8 y8 z8 R8];
               
    elseif map_complexity==4
        % 交叉障碍布局
        R2=55;  % Radius
        x2 = 600; y2 = 400; z2 = 200; % center

        R3=55;  % Radius
        x3 = 400; y3 = 600; z3 = 200; % center

        R4=55;  % Radius
        x4 = 600; y4 = 600; z4 = 200; % center

        R6=60;  % Radius
        x6 = 350; y6 = 350; z6 = 200; % center

        R7=60;  % Radius
        x7 = 650; y7 = 350; z7 = 200; % center

        R8=45;  % Radius
        x8 = 350; y8 = 650; z8 = 200; % center

        R9=45;  % Radius
        x9 = 650; y9 = 650; z9 = 200; % center

        R10=50; % Radius
        x10 = 250; y10 = 250; z10 = 150; % center
        threats = [x2 y2 z2 R2;x3 y3 z3 R3;x4 y4 z4 R4;...
                  x6 y6 z6 R6;x7 y7 z7 R7;x8 y8 z8 R8;...
                  x9 y9 z9 R9;x10 y10 z10 R10];
                  
    elseif map_complexity==5
        % 中等难度配置1：交叉通道
        R1=60;  % Radius
        x1 = 700; y1 = 350; z1 = 200; % center

        R2=60;  % Radius
        x2 = 300; y2 = 650; z2 = 200; % center

        R3=60;  % Radius
        x3 = 700; y3 = 650; z3 = 200; % center

        R4=50;  % Radius
        x4 = 400; y4 = 200; z4 = 200; % center

        R5=50;  % Radius
        x5 = 600; y5 = 200; z5 = 200; % center

        R6=50;  % Radius
        x6 = 400; y6 = 800; z6 = 200; % center

        R7=50;  % Radius
        x7 = 600; y7 = 800; z7 = 200; % center

        R8=45;  % Radius
        x8 = 550; y8 = 500; z8 = 200; % center

        R9=45;  % Radius
        x9 = 450; y9 = 500; z9 = 200; % center
        threats = [x1 y1 z1 R1;x2 y2 z2 R2;x3 y3 z3 R3;...
                   x4 y4 z4 R4;x5 y5 z5 R5;x6 y6 z6 R6;...
                   x7 y7 z7 R7;x8 y8 z8 R8;x9 y9 z9 R9];
       
 
    elseif map_complexity==6
          R1=50;  x1=100; y1=400; z1=200; % 障碍1
        R2=60;  x2=350; y2=200; z2=200; % 障碍2
        R3=40;  x3=600; y3=500; z3=200; % 障碍3
        R4=55;  x4=800; y4=300; z4=200; % 障碍4
        threats = [x1 y1 z1 R1; x2 y2 z2 R2; x3 y3 z3 R3; x4 y4 z4 R4];
end

end
MAPSIZE_X = size(H,2); % x index: columns of H
MAPSIZE_Y = size(H,1); % y index: rows of H
[X,Y] = meshgrid(1:MAPSIZE_X,1:MAPSIZE_Y);

xmin= 1;
xmax= MAPSIZE_X;
ymin= 1;
ymax= MAPSIZE_Y;



% 参数整定到model方便管理
model.start=startPos;
model.end=goalPos;
model.n=n;
model.xmin=xmin;
model.xmax=xmax;
model.zmin=zmin;
model.ymin=ymin;
model.ymax=ymax;
model.zmax=zmax;
model.MAPSIZE_X = MAPSIZE_X;
model.MAPSIZE_Y = MAPSIZE_Y;
model.X = X;
model.Y = Y;
model.H = H;
model.threats = threats;


PlotModel(model);
end
