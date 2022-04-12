function [H_star, F, A_star, Obj] = UOMvSC(A_x, A_h, num_cluster, lambda)
% Inputs:
%   A_x - normalized similarity graphs constructed from original features, a array, num_sample*num_sample*num_view
%   A_h - normalized similarity graphs constructed from spectral embedding matrices, a array, num_sample*num_sample*num_view
%   num_cluster - number of clusters
%   lambda - hyperparameters for the algorithm
% Outputs:
%   H_star - relaxed indicators, a num_sample*num_cluster array
%   F - indicators, a num_sample*num_cluster array
%   A_star - unified similarity matrix, a num_sample*num_sample array
%   Obj - Objective function values
% Unified One-step Multi-view Spectral Clustering
num_sample = size(A_x, 1);
num_view = size(A_x, 3);
tol = 1e-6;
max_iter = 30;
tol_iter = 2;
% initialization H_star and F
A_star = (1-lambda)*A_x(:,:,num_view)+lambda*A_h(:,:,num_view);
[H_star, F, Y] = initial_H_F(A_star, num_cluster);
% loop
for iter = 1 : max_iter
    fprintf('----processing iter %d--------\n', iter);
    % update alpha
    f1 = zeros(1, num_view);
    for v = 1 : num_view
        f1(v) = trace(H_star' * A_x( : , : , v) * F) + eps;
    end
    alpha = f1./norm(f1, 2);
    % update beta
    f2 = zeros(1, num_view);
    for v = 1 : num_view
        f2(v) = trace(H_star' * A_h( : , : , v) * F) + eps;
    end
    beta = f2./norm(f2, 2);
    % update A_h
    A_h_s = zeros(num_sample, num_sample);
    for v = 1:num_view
        A_h_s = A_h_s + beta(v)*A_h( : , : , v);
    end
    % update S
    A_x_s = zeros(num_sample, num_sample);
    for v = 1:num_view
        A_x_s = A_x_s + alpha(v)*A_x(:,:,v);
    end
    A_star = (1-lambda)*A_x_s + lambda*A_h_s;
    % update H
    [Uh, ~, Vh] = svd(A_star*F, 'econ');
    H_star = Uh * Vh';
    % update F
    G = A_star*H_star;
    Y = update_Y(Y,G, num_sample, num_cluster);
    F = Y*(Y'*Y + eps*eye(num_cluster))^(-0.5);
    % convergence
    Obj(iter) = trace(H_star' * A_star * F);
    if iter > tol_iter &&  abs((Obj(iter) - Obj(iter-1) )/Obj(iter-1))< tol
        break;
    end
end
disp(['iter:', num2str(iter)]);
end
