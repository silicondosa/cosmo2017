%% Bayesian integration with Gaussians

clf

x=-10:0.1:10
muV=-10:0.1:10;
for i=1:length(muV)
  sigmaV=1.5;
  pV(i,:)=1/(sqrt(2*pi)*sigmaV)*exp(-(x-muV(i)).^2/(2*sigmaV^2)); %Gaussian likelihood
end

imagesc(x,muV,pV);

xlabel('position of stimulus');
ylabel('visual percept');
title('probability')
