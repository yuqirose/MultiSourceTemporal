function [err, normerr] = prediction(series, Sol, b, index)

funcList = {'Gaussian','Gumbel', 'Logistic'};
nType = length(series);
nVar = size(series{1}, 1);
nLag = size(Sol, 2)/nVar;
T = length(index);

err = zeros(nType, 1);
normerr = err;

for i = 1:nType
    % For each type
    mu = b(nVar*(i-1)+1:nVar*i)*ones(1, T);
    for ll = 1:nLag
        mu = mu + Sol(nVar*(i-1)+1:nVar*i, nVar*(ll-1)+1:nVar*ll)*series{i}(:, index-ll);
    end
    pred = linkglm(mu, funcList{i});
    err(i) = norm(pred - series{i}(:, index), 'fro')/T/nVar;
    normerr(i) = norm(pred - series{i}(:, index), 'fro')/norm(series{i}, 'fro');
end