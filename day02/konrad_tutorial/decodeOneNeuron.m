x=20:1:100;
muL=mean(neuronL);
muR=mean(neuronR);
stdL=std(neuronL);
stdR=std(neuronR);
subplot(3,1,1)              % Left movements
hold on                     % we are plotting over the bar graphs
pNgL=exp(-(x-muL).^2/(2*stdL^2)); %equation for the Gaussian
pNgL=pNgL/sum(pNgL);        %probabilities must sum to one 
plot(x,pNgL,'r');           %now plot it
title('probability of spikes given left') 
hold off

subplot(3,1,2)              %right movements
hold on                     %plot over existing plot
pNgR=exp(-(x-muR).^2/(2*stdR^2)); %equation for the Gaussian
pNgR=pNgR/sum(pNgR);        %probabilities mus sum to one
plot(x,pNgR,'r');           %now plot it
title('probability of spikes given right') 
hold off                    %remove the plotover function


subplot(3,1,3)              %decoding assuming left and right are each p=.5

pLgS=(.5*pNgL)./(.5*pNgL+.5*pNgR);
plot(x,pLgS);
xlabel('firing rate');
ylabel('p(L|S)');
title('decoding from a single neuron');


