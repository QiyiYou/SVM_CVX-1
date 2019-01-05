function [dataset, label] = data_linear_nd(num, dim)

dataset = [num, dim];
label = [num, 1];
marg = 100;
X = marg * rand(num, dim);
for index = 1 : num
    Z = 0;
    for j = 1 : dim
        Z = Z + X(index, j);
    end
    if Z > dim * 50
% separable
        dataset(index, 1) = X(index, 1) + marg / 20;
% non-separable
%         dataset(index, 1) = X(index, 1) - marg / 20;
        for j = 2 : dim
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
        
    
