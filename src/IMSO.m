function [yy, fitnesszbest, zbest] = IMSO(lb, ub, dim, fobj, SearchAgents_no, Max_iteration, model)
% 改进的IMSO算法用于无人机路径规划
% 输入:
%   lb: 下界(球坐标)
%   ub: 上界(球坐标)
%   dim: 维度
%   fobj: 适应度函数
%   SearchAgents_no: 种群大小
%   Max_iteration: 最大迭代次数
%   model: 环境模型
%
% 输出:
%   yy: 每次迭代的最佳适应度值
%   fitnesszbest: 全局最佳适应度值
%   zbest: 全局最佳位置(球坐标)

    % 参数初始化
    PopSize = SearchAgents_no;
    MaxIter = Max_iteration;
    gbests = inf;  % 全局最佳适应度值
    yy = zeros(1, MaxIter);  % 迭代曲线
    
    % 初始化种群 (球坐标)
    pos = zeros(PopSize, dim);
    for i = 1:PopSize
        for j = 1:dim
            pos(i,j) = lb(j) + (ub(j)-lb(j))*rand();
        end
    end
    
    % 计算初始适应度 (转换为笛卡尔坐标)
    pops = inf(PopSize, 1);
    for i = 1:PopSize
        pops(i) = fobj(SphericalToCart(pos(i,:), model));
        if gbests > pops(i)
            gbests = pops(i);
            gbest = pos(i, :);
        end
    end
    
    iter = 0;
    nfes = PopSize;  % 函数评估次数计数器
    
    while iter < MaxIter
        iter = iter + 1;
        ac = randperm(PopSize-1) + 1;
        
        % 雅可比椭圆函数衰减控制搜索范围
        t = iter / MaxIter;
        [~, cn] = ellipj(0.5 * pi * t, 0.9);
        cv = ceil((PopSize * 2/3) * cn);
        
        %% 高级搜索 (Superior mirage search)
        for j = ac(1:cv)
            cosx = pos(j, :);
            for k = 1:dim
                h = (gbest(k) - pos(j, k)) * rand();
                
                % 动态调整系数 (指数衰减)
                coeff_initial = 5;
                coeff_final = 2;
                coeff = coeff_final + (coeff_initial - coeff_final) * exp(-5*iter/MaxIter);
                
                % 边界处理
                cmax = 1;
                if h > coeff * atanh(-(iter/MaxIter) + 1) + cmax
                    h = coeff * atanh(-(iter/MaxIter) + 1) + cmax;
                end
                if h < cmax
                    h = cmax;
                end
                
                zf = randi(2)*2 - 3;
                a = rand()*20;
                b = rand()*(45 - a/2);
                z = randi(2);
                
                % 三种情况处理
                if z == 1  % 情况1
                    C = b + 90;
                    D = 180 - C - a;
                    B = 180 - 2*D;
                    A = 180 - B + a - 90;
                    dx = (sind(B)*h*sind(C))/(sind(D)*sind(A));
                elseif z == 2 && a < b  % 情况2
                    C = 90 - b;
                    D = 90 + a - b;
                    B = 180 - 2*D;
                    A = 180 - B - a - 90;
                    dx = (sind(B)*h*sind(C))/(sind(D)*sind(A));
                elseif z == 2 && a > b  % 情况3
                    C = 90 - b;
                    D = 180 - C - a;
                    B = 180 - 2*D;
                    A = 180 - B - 90 + a;
                    dx = (sind(B)*h*sind(C))/(sind(D)*sind(A));
                else
                    dx = 0;
                end
                
                % 添加钙离子振荡扰动
                ca2 = 0.5*(1 + sin(2*pi*rand() + iter/10));
                dx = dx * zf + 0.18 * (ca2 - 0.5) * (ub(k)-lb(k))/sqrt(iter+1);
                cosx(k) = pos(j, k) + dx;
            end
            
            % 边界约束处理
            cosx = max(cosx, lb);
            cosx = min(cosx, ub);
            
            % 计算适应度 (转换为笛卡尔坐标)
            cos_fit = fobj(SphericalToCart(cosx, model));
            nfes = nfes + 1;
            
            % 更新全局最优
            if cos_fit < gbests
                gbests = cos_fit;
                gbest = cosx;
            end
            
            % 添加到种群
            pos = [pos; cosx];
            pops = [pops; cos_fit];
        end
        
        % 选择最优个体更新种群
        [~, idx] = sort(pops);
        idx = idx(1:PopSize);
        pos = pos(idx, :);
        pops = pops(idx);
        
        %% 低级搜索 (Inferior mirage search)
        for j = 1:PopSize
            if ~isequal(gbest, pos(j, :))
                hh = (gbest - pos(j, :));
            else
                hh = ones(1, dim) * 0.05 * (randi(2)*2 - 3);
            end
            
            zf = sign(hh);
            hh = abs(hh .* rand(1, dim));
            gama = rand(1, dim) .* 90 * ((MaxIter - iter) / MaxIter);
            amax = atand(1 ./ (2 * tand(gama)));
            amin = atand((sind(gama) .* cosd(gama)) ./ (1 + (sind(gama)).^2));
            fai = (amax - amin) .* rand() + amin;
            omg = asind(rand() .* sind(fai + gama));
            x = (hh ./ tand(gama)) - ((((hh ./ sind(gama)) - (hh .* sind(fai)) ./ (cosd(fai + gama))) .* cosd(omg)) ./ cosd(omg - gama));
            
            % 50%概率使用差分变异策略
            if rand() > 0.5
                cosx = pos(j, :) + x .* zf;
            else
                % 拓扑邻域扰动策略
                k = randi(3); 
                neighbors = circshift(1:PopSize, [0, -j]);
                topo = neighbors(1:k);
                r1 = randi(PopSize);
                r2 = randi(PopSize);
                while r2 == r1
                    r2 = randi(PopSize);
                end
                cosx = pos(j,:) + 0.5*(mean(pos(topo,:)) - pos(j,:)) + 0.5*(pos(r1,:)-pos(r2,:));
            end
            
            % 边界约束处理
            cosx = max(cosx, lb);
            cosx = min(cosx, ub);
            
            % 计算适应度 (转换为笛卡尔坐标)
            cos_fit = fobj(SphericalToCart(cosx, model));
            nfes = nfes + 1;
            
            % 更新全局最优
            if cos_fit < gbests
                gbests = cos_fit;
                gbest = cosx;
            end
            
            % 添加到种群
            pos = [pos; cosx];
            pops = [pops; cos_fit];
        end
        
        % 选择最优个体更新种群
        [~, idx] = sort(pops);
        idx = idx(1:PopSize);
        pos = pos(idx, :);
        pops = pops(idx);
        
        % 记录当前迭代的最佳适应度
        yy(iter) = gbests;
    end
    
    % 设置最终输出
    fitnesszbest = gbests;
    zbest = gbest;
end