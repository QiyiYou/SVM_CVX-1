function [dataset, label] = data_rbf(num)

dataset = [num, 2];
label = [num, 1];
marg = 100;
X1 = marg * rand(num, 1);
X2 = marg * rand(num, 1);
for index = 1 : num
    if (abs(X1(index) - marg / 2) + (X2(index) - marg / 2) > marg / 3)
        dataset(index, :) = [X1(index), X2(index) + marg / 10];
        label(index) = 1;
    else
        dataset(index, :) = [X1(index), X2(index)];
        label(index) = -1;
    end
end