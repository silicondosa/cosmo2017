x=1:1:100; % when using the hist function it is good to always define where 
% the histogram bins are at 
figure(1);
clf;
subplot(2,1,1); % subplot plots several things into one graph
hL=hist(neuronL,x);
bar(hL/sum(hL));
xlabel('firing rate [sp/s]');
ylabel('probability');
title('probability distribution of firing rates for left movements');
subplot(2,1,2);
hR=hist(neuronR,x);
bar(hR/sum(hR));
xlabel('firing rate [sp/s]');
ylabel('probability');
title('probability distribution for firing rates for right movements');

