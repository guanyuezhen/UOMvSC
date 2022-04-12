function [A_x, A_h, runtime1] = PreProcess(fea, num_cluster)
tic
knn0 = 15;
cfea = [];
for t=1:length(fea)
    cfea = [fea{t}, cfea];
end
fea{t+1} = cfea;
num_view = length(fea);
A_h = cell(1, num_view);
A_x = cell(1, num_view);
for t=1:num_view
    fea{t} = (mapminmax(fea{t}', 0, 1))';
    affn = constructW_PKN(fea{t}', knn0);
    [H, ~, A_x{t}] = spectral_embedding(affn, num_cluster);
    A_x{t} = full(A_x{t});
    Hn = H./sqrt(sum(H.^2, 2));
    affn = constructW_PKN(Hn', knn0);
    [~, ~, A_h{t}] = spectral_embedding(affn, num_cluster);
end
A_x = cat(3, A_x{:, :});
A_h = cat(3, A_h{:, :});
runtime1 = toc;
end

