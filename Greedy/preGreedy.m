clc
clear

addpath(genpath('../'))
load('../data/climateP17.mat')
load('../data/climateP17_missIdx.mat')
% load('../data/climateP4.mat')
% load('../data/synth/datasets/synth200_9.mat')
% load('../data/Foursquare/norm_4sq.mat')

% For Euclidian
% sigma = 2;
% mu = 18.3486;
% For Harversine
sigma = 0.1;  % Should be selected in a way that effectively few neighbors get weights
mu = 5;
% nTask = length(series);
[nLoc, tLen] = size(series{1});

global verbose
verbose = 1;
global evaluate
evaluate = 2;


% sim =  euclidSim(locations, sigma);
sim = haverSimple(locations, sigma);
sim = sim/(max(sim(:)));       % The goal is to balance between two measures

nLag = 3;
nTask = length(series);
tTrain = floor(0.9*tLen);
tTest = tLen - tTrain;


%% Create the matrices
A = zeros(nLoc, nLoc*nLag, nTask);
X = cell(nTask, 1);
Y = cell(nTask, 1);
test.X = cell(nTask, 1);
test.Y = cell(nTask, 1);
for i = 1:nTask
    Y{i} = series{i}(:, nLag+1:tTrain);
    X{i} = zeros(nLag*nLoc, (tTrain - nLag));
    for ll = 1:nLag
        X{i}(nLoc*(ll-1)+1:nLoc*ll, :) = series{i}(:, nLag+1-ll:tTrain-ll);
    end
    test.Y{i} = series{i}(:, tTrain-nLag+1:tLen);
    for ll = 1:nLag
        test.X{i}(nLoc*(ll-1)+1:nLoc*ll, :) = series{i}(:, tTrain-nLag+1-ll:tLen-ll);
    end
end

mu = 1e-10;
max_iter = 200;
[~, qualityGreedy] = solveGreedyOrth(Y, X, mu, max_iter, A, test);
save('qualityFor4Sq.mat', 'qualityGreedy')
save('KrigingOrthoMultiIndex.mat', 'quality')
% save('krigingOrtho.mat', 'quality')

