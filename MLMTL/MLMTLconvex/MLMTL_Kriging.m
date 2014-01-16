function [ W tensorW ] = MLMTL_Kriging( X, Y, indicators, beta, lambda,outerNiTPre, thresholdPre,innerNiTPre)
%MLMTL_KRIGING: incorporating geospatial information into the model
% Added an additional penalization term on the objective function

global verbose;


outerNiT=1000;

if nargin>5 && ~isempty(outerNiTPre)
    outerNiT=outerNiTPre;
end
if nargin>6 && ~isempty(thresholdPre)
    threshold=thresholdPre;
end

nTotalTasks=length(Y);
nAttrs=getNAttrs(X);
nModes=length(indicators);

innerNiT = 2*nModes;

if nargin>7 && ~isempty(innerNiTPre)
    innerNiT = innerNiTPre;
end

if nTotalTasks~=prod(indicators(2:end))
    [nTotalTasks prod(indicators(2:end))]
    error('There are inconsistencies between the indicators and the number of tasks.');
end

XX_plus_betaNI=cell(1,nTotalTasks)
XY=cell(1,nTotalTasks);
for t=1:nTotalTasks
    if isempty(X{t})
        XX_plus_betaNI{t}=beta*eye(nAttrs);
        XY{t}=0;
    else
        XX_plus_betaNI{t}=1/lambda*(X{t}*X{t}')+beta*eye(nAttrs); % remove nMode
        XY{t}=X{t}*Y{t};
    end
end

% A=cell(1,nModes);
A = tenzeros(indicators);
B = cell(1,nModes);
for n=1:nModes
%     A{n}=tenzeros(indicators);
    B{n}=tenzeros(indicators);
end
% sumA=tenzeros(indicators); 
sumB=tenzeros(indicators); 

oldW=Inf(nAttrs, nTotalTasks);
oit=0;


while true  
%     fprintf('Iter # %d\n',oit);
    oit=oit+1;
    % Optimizing over W
    matSumAux=tenmat(A, 1) + beta/nModes*tenmat(sumB, 1);
    matSumAux=matSumAux.data;
    matW=zeros(nAttrs, nTotalTasks);
    for t=1:nTotalTasks
        matW(:,t)=(XX_plus_betaNI{t})\(1/lambda*XY{t} + matSumAux(:,t));
    end
    W=tensor(reshape(matW, indicators));

    % ADD iteration over NModes
    for iter = 1: innerNiT
        
         
        for n=1:nModes
    %         [oit n]
            % Optimizing over B
            matW=tenmat(W, n);
            matW=matW.data;
            matA=tenmat(A,n);
            matA=matA.data;
            sumNB = sumB-B{n};
            matsumNB = tenmat(sumNB,n);
            matsumNB = matsumNB.data;
            shrink_target = nModes*matW - 1/beta*nModes*matA - matsumNB;
            matB = shrink(shrink_target,nModes^2/beta);

            BTensor=tensor(reshape(matB, [indicators(n), indicators(1:n-1), indicators(n+1:end)]));
            B{n}=permute(BTensor, [2:n, 1, n+1:nModes]);
            sumB = sumNB+B{n};

        end
        
        
    end
    % Optimizing over A (C in the supp)
    A=A-beta*(W-1/nModes*sumB);
          
    Wmat=tenmat(full(W), 1);
    Wmat=Wmat.data;

    if oit>outerNiT %norm(Wmat(1:end)-oldW(1:end))<threshold
        break
    end
    if( norm(oldW-W,'fro')/prod(indicators) < threshold)
        fprintf('Weight Converge\n');
        break;
    end
    oldW=Wmat;
    
    
    
end

% disp('L_Inf');
for i=1:nModes
    mat=tenmat(W, i);
    [u sigma v]=mySVD(mat.data);
    max(diag(sigma));
end
% norm(mat.data, 'fro');

tensorW=W;
W=tenmat(full(W), 1);
W=W.data;
end


