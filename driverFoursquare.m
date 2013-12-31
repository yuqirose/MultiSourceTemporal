clear;
clc;
addpath(genpath('./'))
global verbose
verbose = 1;


%%
load 'venue_checkin_daily.mat';
load 'venue_loc.mat';
load 'venue_IDs.mat';


series = venue_checkin_counts;
Loc(:,1) = venue_IDs;
Loc(:,2:3) = venue_loc;

N = 1000;


TLam = 100;
lambda = [1, 1e-5];
nLag = 5;
T = size(series, 2);
Ttest = 10;
index{1} = nLag+1:T-Ttest;
index{2} = T-Ttest+1:T;
Lambda_2 = lambda(2);
%%
grad = {@gradPoisson, 'Poisson'};
[Sol, err, normerr] = sparseGLARP(series(1:N,:), Lambda_2, nLag, index, grad);
%%

[pp1, pp2] = locationSimilarity(Sol, Loc(1:N,:));
