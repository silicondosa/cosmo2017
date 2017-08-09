x=-20:1:100;
plotProbability % we need this plot to be there as we want to compare
muL=mean(neuronL);
muR=mean(neuronR);
stdL=std(neuronL);
stdR=std(neuronR);
subplot(2,1,1)              % Left movements
hold on                     % we are plotting over the bar graphs
pNgL=exp(-(x-muL).^2/(2*stdL^2)); %equation for the Gaussian
pNgL=pNgL/sum(pNgL);        %probabilities must sum to one 
plot(x,pNgL,'r');           %now plot it
hold off

subplot(2,1,2)              %right movements
hold on                     %plot over existing plot
pNgR=exp(-(x-muR).^2/(2*stdL^2)); %equation for the Gaussian
pNgR=pNgR/sum(pNgR);        %probabilities mus sum to one
plot(x,pNgR,'r');           %now plot it
hold off                    %remove the plotover function
