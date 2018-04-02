function w = som(data,m,n,iteration)

[row,column] = size(data);
neurons = m*n;
w = rand(neurons,column);
%eta0 = 0.1;
eta0 = 0.6;
eta = eta0;
[I,J] = ind2sub([m,n],1:neurons); %the positions of neurons in the som
sigma0 = 3;
sigma = sigma0;

for t = 1:iteration
	for i = 1:row
		[~,winIdx] = min(dist(data(i,:),w'));
		[winrow,wincolumn] = ind2sub([m,n],winIdx);
		win = [winrow,wincolumn];
		d = exp(-sum(([I(:) J(:)] - repmat(win,neurons,1)).^2,2)/(2*sigma^2));
		for j = 1:neurons
			w(j,:) = w(j,:) + eta*d(j).*(data(i,:) - w(j,:));
		end
	end
	eta = eta0*exp(-t/1000);
	sigma = sigma0*exp(-t/1000);
%   sigma = sigma0*exp(-t*log10(sigma0)/iteration);
% 	eta = eta0*exp(-t/600);
% 	sigma = sigma0*exp(-t/600);
end
