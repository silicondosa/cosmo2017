load datasetStart   %just reloading in case someone forgot to load it.
x=-20:1:100; % when using the hist function it is good to always define where 
% the histogram bins are at 
subplot(2,1,1); % subplot plots several things into one graph
hL=hist(neuronL,x);
bar(hL);
xlabel('firing rate [sp/s]');
ylabel('number');
title('histogram, firing rates for left movements');
subplot(2,1,2);
hR=hist(neuronR,x);
bar(hR);
xlabel('firing rate [sp/s]');
ylabel('number');
title('histogram, firing rates for right movements');

warning('off','MATLAB:dispatcher:InexactMatch');  %turn of case match warning