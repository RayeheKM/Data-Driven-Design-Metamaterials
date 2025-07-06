function y=Mutate(x, mu, nmat, nEle, allowedMaterials)

    nVar=numel(x);
    
    nmu=ceil(mu*nVar);
    
    j=randsample(nVar,nmu);
    
    y=x;
    % matNumArray = randi([1 nmat], [nEle, 1]);
    % allowedMaterials = [1, 10, 15];
    matNumArray = allowedMaterials(randi(length(allowedMaterials), [nEle, 1]));

    y(j)=matNumArray(j);

end