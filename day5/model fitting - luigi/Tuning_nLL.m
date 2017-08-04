function [ nLL ] = Tuning_nLL(params, spikes, angle, tuningFun)
%TUNING_NLL Negative log likelihood function for arbitrary tuning curve.

% Compute tuning curve
predictedF = tuningFun(params, angle);
% predictedF = exp(params(1)+params(2)*cos(angle-params(3)));
    
% Compute Poisson probability for each data point
% logP = spikes .* log(predictedF) - predictedF - log(factorial(spikes));
logP = spikes .* log(predictedF) - predictedF - gammaln(spikes + 1);

% Return summed negative log likelihood
nLL = -sum(logP) + 100*randn();

end

