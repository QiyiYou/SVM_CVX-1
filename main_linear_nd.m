%% clean all
clear all;
close all;
clc
%% generate problem
num = 1000;
dim = 3;
% 3D condition
[dataset, label] = data_linear_nd(num, dim);
%% kernel matrix
K = kernel_linear(dataset);
%% CVX toolbox
C = 25;
cvx_begin
    cvx_precision best
    variable alfa(num);
    maximize (ones(num, 1)' * alfa - 0.5 * quad_form(label' .* alfa, K));
    alfa >= 0;
    alfa <= C;
    label * alfa == 0;
cvx_end
%% find essential parameters
[sup_vec, w, b] = param_linear_nd(alfa, dataset, label, num, dim);
%% judge the accuracy rate
correct_num = 0;
for j = 1 : num
    Y(j) = dataset(j, :) * w' + b;
    if (Y(j) > 0)
        Y(j) = 1;
    else
        Y(j) = -1;
    end
    if (Y(j) == label(j))
        correct_num = correct_num + 1;
    end
end
accuracy_rate = correct_num / num;