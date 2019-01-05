%% clean all
clear all;
close all;
clc
%% generate problem
num = 1000;
dim = 3;
% 3D condition
[dataset, label] = data_rbf_nd(num, dim);
%% kernel matrix
sigma = 30;
ksize = size(dataset, 1);
K = [];
for i = 1 : ksize
    for j = 1 : ksize
        K(i, j) = kernel_rbf(dataset(i, :), dataset(j, :), sigma);
    end
end
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
[sup_vec, w, b, index] = param_rbf_nd(alfa, dataset, label, num, sigma, dim);
%% judge the accuracy rate
correct_num = 0;
Y = zeros(num, 1);
for i = 1 : num
    for j = 1 : num
        Y(i) = Y(i) + alfa(j) * label(j) * kernel_rbf(dataset(i, :), dataset(j, :), sigma);
    end
    if (Y(i) + b > 0)
        Y(i) = 1;
    else
        Y(i) = -1;
    end
    if (Y(i) == label(i))
        correct_num = correct_num + 1;
    end
end
accuracy_rate = correct_num / num;