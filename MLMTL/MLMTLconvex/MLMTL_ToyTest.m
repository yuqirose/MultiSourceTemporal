
folds = [3,3];
nTasks = prod(folds);
X = cell(1, nTasks);
Y = cell(1, nTasks);

nDim = 50;
r_convex =[];
r_mixture =[];
nSample = 20; 
% loop_var = logspace(-3,3,30);
loop_var = 3:1:50;


W = zeros(nDim, nTasks);

for i = 1:nTasks
    X{i}=rand(nDim,nSample);
    W(:,i) = rand(1,nDim);
    Y{i}=X{i}'*W(:,i);
end
    
modesDim = [nDim,folds];
beta = 1e-2;
lambda = 1e-3;
outerNiTPre = 50;



[ W_r_convex tensorW_r_convex ] = MLMTL_Convex( X, Y, modesDim, beta, lambda, outerNiTPre);

for innerNiTPre = loop_var
[ W_r_mixture tensorW_r_mixture ] = MLMTL_Mixture( X, Y, modesDim, beta, lambda,innerNiTPre,outerNiTPre);

e_convex = norm(W_r_convex- W,'fro')/(nDim*nTasks);
e_mixture = norm(W_r_mixture- W,'fro')/(nDim*nTasks);
r_convex = [r_convex,e_convex];
r_mixture = [r_mixture, e_mixture];
fprintf('frobenius norm error Convex: %d Mixture:  %d\n ',e_convex,e_mixture);

end


%%
plot(loop_var,r_convex.*1/(nDim*nTasks),'b'); hold on;
plot(loop_var,r_mixture.*1/(nDim*nTasks),'r'); hold off;


xlabel('Coordinate Descent Iter');
ylabel('Frobenius Norm Error');
legend('Overlap Method [Romera-ParedesICML13]','Latent Method');