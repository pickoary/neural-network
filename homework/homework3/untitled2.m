for i = 1:100
        subplot(10,10,i);
        imshow(reshape(w(i,:),[28 28]));
end