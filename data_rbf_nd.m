function [dataset, label] = data_rbf_nd(num, dim)

dataset = [num, dim];
label = [num, 1];
marg = 100;
X = marg * rand(num, dim);
for index = 1 : num
    Z = 0;
    for j = 1 : dim
        Z = Z + (X(index, j) - 50) ^ 2;
    end
    if Z > 50 ^ 2
        for j = 1 : dim
            dataset(index, j) = X(index, j);
        end
        label(index) = 1;
    else
        for j = 1 : dim
            dataset(index, j) = X(index, j);
        end
        label(index) = -1;
    end
end