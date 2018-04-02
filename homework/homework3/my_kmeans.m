function [Idx,c] = my_kmeans(X,k)

iteration = 20;
[m,n] = size(X);
c = zeros(k,n);
a = randperm(m);
r = X(a,:);
Idx = zeros(m,1);
d = zeros(m,k);
ctemp = c;

for i = 1:k
	c(i,:) = r(i,:);
end

while(iteration>0&&norm(c-ctemp)>0.001)
	for j = 1:m
		for i = 1:k
% 			d(j,i) = dist(X(j,:)',c(i,:));
            d(j,i) = sqrt(sum((X(j,:)-c(i,:)).^2));
		end

		[v,p] = min(d(j,:),[],2);
		Idx(j) = p;

	end

	ctemp = c;

	for i = 1:k
		pos = find(Idx == i);
		c(i,:) = mean(X(pos,:));
    end
    iteration = iteration - 1;
end