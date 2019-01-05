function K = kernel_linear(dataset)

ksize = size(dataset, 1);
K = [ksize, ksize];
for i = 1 : ksize
    for j = 1 : ksize
        K(i, j) = dataset(i, :) * dataset(j, :)';
    end
end
