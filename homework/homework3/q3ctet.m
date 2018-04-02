account = 0;
Acc = 0;
for i = 1:length(testIdx)
    if (testIdx(i) - testY(i)) == 0
        account = account+1;
    end
end
Acc = account/length(testIdx);