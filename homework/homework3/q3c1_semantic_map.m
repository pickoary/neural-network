clc
clear all;
close all;

load('weights.mat');
load('TrData.mat');

x= zeros(size(w));

for m = 1:100
	for n = 1:2400
		d(m,n) = sqrt(sum((TrData(n,:) - w(m,:)).^2));
	end

	[~,p] = min(d(m,:),[],2);
	x(m,:) = TrData(p,:);
end


for i = 1:100
        subplot(10,10,i);
        imshow(reshape(x(i,:),[28 28]));
end