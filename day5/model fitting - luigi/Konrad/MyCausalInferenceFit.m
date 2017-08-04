%% Estimate as a function of feedback
% This function keeps the prior the same while varying the likelihood.
% Incidentally this is the same that would happen if we had two likelihoods
% only then we should use the name likelihood instead of prior
close all
x=-10:0.1:10 % the range used for calculations
feedbacks=[ -8    -4    -2    -1     0     1     2     4     8];
deviationsL1=-[0.4656    0.4957    0.2224    0.1225   -0.0924   -0.2891   -0.3129   -0.3790   -0.2207];
plot(pert,deviationLag1);
title('Typical subject from Wei & Kording J Neurophys, 2009')
xlabel('position of visual feedback [cm]');
ylabel('size of adaptation on next trial [cm]');

%% now optimize this!

[bestParas,MSE]=fminsearch(@cosmoFitCausal,[2.1 1],[],feedbacks, deviationsL1);
