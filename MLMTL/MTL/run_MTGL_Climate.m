clear;
clc;
addpath(genpath('~/Documents/MATLAB/MultiSourceTemporal'));
load 'climateP17';
ratio = 0.1;
lambdas = logspace(-3,3,10);
[Dat_eval , Dat_test] = MTGL_Datpre(series,ratio); 

% fprintf('Running Lasso\n');
% 
% [W,opt_lambda,train_time] = MTGL_Crosval(Dat_eval.X, Dat_eval.Y, 'Lasso',lambdas);
% Quality = MTGL_Test(Dat_test.X, Dat_test.Y, W);
% fprintf('RMSE %d, NRMSE %d, Rank %d, Time %d\n', Quality.RMSE, Quality.NRMSE,Quality.Rank, train_time);
% save('MTGL_Lasso_climateP4.mat','Quality','train_time','opt_lambda','W');
% 
% fprintf('Running L21\n');
% [W,opt_lambda,train_time] = MTGL_Crosval(Dat_eval.X, Dat_eval.Y, 'L21',lambdas);
% Quality = MTGL_Test(Dat_test.X, Dat_test.Y, W);
% fprintf('RMSE %d, NRMSE %d, Rank %d, Time %d\n', Quality.RMSE, Quality.NRMSE,Quality.Rank, train_time);
% save('MTGL_L21_climateP4.mat','Quality','train_time','opt_lambda','W');
% 
% fprintf('Running Dirty\n');
% [W,opt_lambda,train_time] = MTGL_Crosval(Dat_eval.X, Dat_eval.Y, 'Dirty',lambdas);
% Quality = MTGL_Test(Dat_test.X, Dat_test.Y, W);
% fprintf('RMSE %d, NRMSE %d, Rank %d, Time %d\n', Quality.RMSE, Quality.NRMSE,Quality.Rank, train_time);
% save('MTGL_Dirty_climateP4.mat','Quality','train_time','opt_lambda','W');

fprintf('Running CMTL\n');
lambda = 216;
[ W] = MTGL_Train( Dat_eval.X, Dat_eval.Y ,'CMTL',lambda );
% [W,opt_lambda,train_time] = MTGL_Crosval(Dat_eval.X, Dat_eval.Y, 'CMTL',lambdas);
Quality = MTGL_Test(Dat_test.X, Dat_test.Y, W);
fprintf('RMSE %d, NRMSE %d, Rank %d, Time %d\n', Quality.RMSE, Quality.NRMSE,Quality.Rank, train_time);
save('MTGL_CMTL_climateP3.mat','Quality','train_time','opt_lambda','W');

exit;
