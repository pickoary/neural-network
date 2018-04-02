function [pcaA,V]=fastPCA(A,k,mA)

[m,n]=size(A);
Z=(A-repmat(mA,m,n));
T=Z*Z';
[V,D]=eigs(T,k);
V=Z'*V;

for i=1:k 
    l=norm(V(:,i));
    V(:,i)=V(:,i)/l;
end
pcaA=Z*V;
end