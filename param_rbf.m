function [sup_vec, w, b] = param_rbf(alfa, dataset, label, num, sigma)
% w
w = [0, 0];
sup_vec_alfa = max(alfa);
for i = 1 : num
    if alfa(i) == sup_vec_alfa
        sup_vec_index = i;
    end
end
for i = 1 : num
    w = w + alfa(i) * label(i) * kernel_rbf(dataset(sup_vec_index, :), dataset(i, :), sigma);
end

% support vector
sup_vec = [];
index = 1;
b = 0;
sorted_alfa = sort(alfa);
for i = 1 : num
    if alfa(i) >= 0.01
        sup_vec(index, :) = dataset(i, :);
        b = b + 1 / label(i) - w(1);
        index = index + 1;
    end
end

% b
b = b / (index - 1);