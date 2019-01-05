%% clean all
clear all;
close all;
clc
%% generate problem
num = 500;
% separable condition
[dataset, label] = data_linear(num);
% non_separable condition
% [dataset, label] = data_linear_nonseparable(num);
%% kernel matrix
K = kernel_linear(dataset);
%% CVX toolbox
C = 10;
cvx_begin
    cvx_precision best
    variable alfa(num);
    maximize (ones(num, 1)' * alfa - 0.5 * quad_form(label' .* alfa, K));
    alfa >= 0;
    alfa <= C;
    label * alfa == 0;
cvx_end
%% find essential parameters
[sup_vec, w, b] = param_linear(alfa, dataset, label, num);
%% plot
figure,
% judge every pixel
marg = 110;
class = zeros(marg, marg);
for i = 1 : marg
    for j = 1 : marg
        class(i, j) = [i, j] * w' + b;
        if (class(i, j) > 0)
            class(i, j) = 1;
        else
            class(i, j) = -1;
        end
    end
end
p = pcolor(1 : marg, 1 : marg, class);
shading flat
colormap([0,0,1; 1,0,0]);
alpha(p, 0.1)
hold on;
for i = 1 : num
    if (label(i) == 1)
        plot(dataset(i, 1), dataset(i, 2), 'ro');
        hold on;
    else
        plot(dataset(i, 1), dataset(i, 2), 'bo');
        hold on;
    end
end

sup_vec_points = scatter(sup_vec(:, 1), sup_vec(:, 2), 'yo', 'filled');
legend(sup_vec_points, 'supporting vectors');
hold off;

title ('linear kernel for SVM');
xlabel('X');
ylabel('Y');





