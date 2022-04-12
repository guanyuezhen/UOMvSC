function Y = idx2pm(y)
% translate a idx or label to a partition matrix
[a,~,c] = unique(y(:));
nSmp = length(c);
nClass = length(a);
Y = sparse(1:nSmp, c, 1, nSmp, nClass, nSmp);
Y = full(Y);