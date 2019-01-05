function [sup_vec, w, b] = param_linear(alfa, dataset, label, num)
% w
w = [0, 0];
for i = 1 : num
    w = w + alfa(i) * label(i) * dataset(i, :);
end

% support vector
sup_vec = [];
index = 1;
sup_vec_alfa = max(alfa);
sup_vec_index = 0;
b = 0;
sorted_alfa = sort(alfa);
for i = 1 : num
    if alfa(i) >= sorted_alfa(num - 8)
        sup_vec(index, :) = dataset(i, :);
        b = b + 1 / label(i) - dataset(i, :) * w';
        index = index + 1;
    end
    if alfa(i) == sup_vec_alfa
        sup_vec_index = i;
    end
end

% b
b = b / (index - 1);
