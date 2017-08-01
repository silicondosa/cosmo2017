%% real neurons
% This is a dataset from a monkey moving in a real experiment done to test
% decoding. Thanks to Lee  Miller and Jim Rebesco
close;
clear all;
load datasetReal;

%%
imagesc([X y*100]);
colorbar
title('raw data, last column=direction')

%% sort L and R
mnL = [];
stdL = [];
mnR = [];
stdR = [];
pNgL = [];
pNgR = [];

for i = 1:size(X, 2)
    mnT = mean(X(:,i));
    stdT = std(X(:,i));
    pNgT = exp(-(X(:,i)-mnT).^2/(2*stdT^2));
    if(y(i) == 0)
        pNgL = [pNgL pNgT];
    else
        pNgR = [pNgR pNgT];
    end
end