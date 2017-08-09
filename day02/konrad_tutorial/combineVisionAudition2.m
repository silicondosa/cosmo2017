%% Bayesian integration with Gaussians
%More specifically MLE estimation

clf

%axis
x=-8:0.1:8

%visual likelihood
muV=-1;
sigmaV=.5;
pV=exp(-(x-muV).^2/(2*sigmaV^2));
pV=pV/sum(pV);
plot(x,pV,'g');

%auditory likelihood
muA=3;
sigmaA=1.5;
pA=exp(-(x-muA).^2/(2*sigmaA^2));
pA=pA/sum(pA);
hold on
plot(x,pA,'r');

%joint estimation
posterior=pV.*pA;
posterior=posterior/(sum(posterior));
plot(x,posterior,'y');
hold off