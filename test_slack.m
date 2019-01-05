%% clean all
clear all;
close all;
clc
%% generate train dataset and test dataset
num = 800;
dataset = 100 * rand(1000, 2);
trainset = dataset(1 : 800, :);
testset = dataset(801 : 1000, :);

X1 = trainset(:, 1);
X2 = trainset(:, 2);
Z1 = testset(:, 1);
Z2 = testset(:, 2);
% label trainset
for i = 1 : 800
    if (X1(i) - 50) ^ 2 + (X2(i) - 50) ^ 2 > 40 ^ 2
        if X2(i) > 50
            X2(i) = X2(i) + 5;
        else
            X2(i) = X2(i) - 5;
        end
        label(i) = -1;
    else
        label(i) = 1;
    end
end
% label testset
for i = 1 : 200
    if (Z1(i) - 50) ^ 2 + (Z2(i) - 50) ^ 2 > 40 ^ 2
        if Z2(i) > 50
            Z2(i) = Z2(i) + 5;
        else
            Z2(i) = Z2(i) - 5;
        end
        Zlabel(i) = -1;
    else
        Zlabel(i) = 1;
    end
end
%% kernel matrix
sup_vec_num = zeros(3,1);
sigma = 15;
ksize = size(trainset, 1);
K = zeros(ksize, ksize);
for i = 1 : ksize
    for j = 1 : ksize
        K(i, j) = kernel_rbf(trainset(i, :), trainset(j, :), sigma);
    end
end
%% CVX toolbox
C = [1, 10, 25];
for slack_index = 1 : 3
    cvx_begin
        cvx_precision best
        variable alfa(num);
        maximize (ones(num, 1)' * alfa - 0.5 * quad_form(label' .* alfa, K));
        alfa >= 0;
        alfa <= C(slack_index);
        label * alfa == 0;
    cvx_end
    %% find essential parameters

    [sup_vec, w, b] = param_rbf(alfa, trainset, label, num, sigma);

    %% plot
    figure,
    % judge every pixel
    marg = 110;
    class = zeros(marg, marg - 10);
    for i = 1 : marg
        for j = 1 : marg - 10
            class(i, j) = 0;
            for m = 1 : num
                class(i, j) = class(i, j) + alfa(m) * label(m) * kernel_rbf([j, i], trainset(m, :), sigma);
            end
            if (class(i, j) + b > 0)
                class(i, j) = 1;
            else
                class(i, j) = -1;
            end
        end
    end
    p = pcolor(1 : marg - 10, 1 : marg, class(1 : marg, 1 : marg - 10));
    shading flat
    colormap([0,0,1; 1,0,0]);
    alpha(p, 0.1)
    hold on;
    for i = 1 : num
        if (label(i) == 1)
            plot(trainset(i, 1), trainset(i, 2), 'ro');
            hold on;
        else
            plot(trainset(i, 1), trainset(i, 2), 'bo');
            hold on;
        end
    end

    sup_vec_points = scatter(sup_vec(:, 1), sup_vec(:, 2), 'yo', 'filled');
    legend(sup_vec_points, 'supporting vectors');
    hold off;

    title ('RBF kernel for SVM');
    xlabel('X');
    ylabel('Y');
    %% test
    figure,
    p = pcolor(1 : marg - 10, 1 : marg, class(1 : marg, 1 : marg - 10));
    shading flat
    colormap([0,0,1; 1,0,0]);
    alpha(p, 0.1)
    hold on;
    for i = 1 : 200
        if (Zlabel(i) == 1)
            plot(testset(i, 1), testset(i, 2), 'ro');
            hold on;
        else
            plot(testset(i, 1), testset(i, 2), 'bo');
            hold on;
        end
    end
    hold off;

    title ('test result with different slack');
    xlabel('X');
    ylabel('Y');
end