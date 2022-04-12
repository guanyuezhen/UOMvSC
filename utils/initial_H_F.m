function [H_star, F, Y] = initial_H_F(A_star, num_cluster)
[H_star] = eig1(A_star, num_cluster);
stream = RandStream.getGlobalStream;
reset(stream);
H_normalized = H_star ./ sqrt(sum(H_star .^ 2, 2));
label = kmeans(H_normalized, num_cluster, 'maxiter', 1000, 'replicates', 20, 'emptyaction', 'singleton');
Y = idx2pm(label);
F = Y * (Y' * Y + eps * eye(num_cluster)) ^ ( - 0.5);
end

