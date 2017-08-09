%% combining info from two neurons
load datasetCombine

figure(3)
% calculate means and standard deviations for all combinations of the two
% neurons and two directions of movement
muL1=mean(neuronL1);
muR1=mean(neuronR1);
stdL1=std(neuronL1);
stdR1=std(neuronR1);
muL2=mean(neuronL2);
muR2=mean(neuronR2);
stdL2=std(neuronL2);
stdR2=std(neuronR2);

% calculate the probabilities of the spikes given the assumed direction for
% each of the two neurons
pN1gL=exp(-(testSet1-muL1).^2/(2*stdL1^2));   %probability of neuron 1 firing rate given left 
pN1gR=exp(-(testSet1-muR1).^2/(2*stdR1^2)); %probability of neuron 1 firing rate given right 
pN2gL=exp(-(testSet2-muL2).^2/(2*stdL2^2));   %probability of neuron 2 firing rate given left 
pN2gR=exp(-(testSet2-muR2).^2/(2*stdR2^2)); %probability of neuron 2 firing rate given right 

%normalize these so they add up to one
pN1gL=pN1gL/sum(pN1gL);
pN1gR=pN1gR/sum(pN1gR);
pN2gL=pN2gL/sum(pN2gL);
pN2gR=pN2gR/sum(pN2gR);



% Use Bayes rule to calculate the probability of moving left in the two
% cases
pL1=pN1gL./(pN1gL+pN1gR);  % here we are using Bayes rule
pL2=pN2gL./(pN2gL+pN2gR);  % here we are using Bayes rule
pR1=pN1gR./(pN1gL+pN1gR);  % here we are using Bayes rule
pR2=pN2gR./(pN2gL+pN2gR);  % here we are using Bayes rule
subplot(3,1,1)
plot(pL1);
xlabel('trial number');
ylabel('p(L|N1)');
title('decoding from Neuron 1 only');
subplot(3,1,1)

subplot(3,1,2)
plot(pL2);
xlabel('trial number');
ylabel('p(L|N2)');
    title('decoding from Neuron 2 only');

subplot(3,1,3)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculate decoding from both neurons %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here you need to calculate pBoth=function(pN1gL,pN1gR,pN2gL,pN2gR)
% remember pN1gL = probability of Neuron 1 spikes given left movement
% pN1gR = probability of Neuron 1 spikes given right movement
% pN2gL = probability of Neuron 1 spikes given left movement
% pN2gR = probability of Neuron 1 spikes given right movement

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% uncomment the line below to change it %%%%
pLBoth = pN1gL.*pN2gL.*.5./(pN1gL.*pN2gL.*.5 + pN1gR.*pN2gR.*.5)
%%%% end of necessary edits

if exist('pLBoth')
    plot(pLBoth) 
end
xlabel('trial number');
ylabel('p(L|N1,N2)');
title('decoding from both Neurons');

nClassifiedRightWhileLeftN1=sum(pL1(1:100)<.5)
nClassifiedLeftWhileRightN1=sum(pL1(101:200)>.5)
nClassifiedRightWhileLeftN2=sum(pL2(1:100)<.5)
nClassifiedLeftWhileRightN2=sum(pL2(101:200)>.5)
if exist('pLBoth');
    nClassifiedRightWhileLeftBoth=sum(pLBoth(1:100)<.5)
    nClassifiedLeftWhileRightBoth=sum(pLBoth(101:200)>.5)
end
