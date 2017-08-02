function [params]=fitExponential(dataX,dataY) % simple routine to fit an exponential function.
options=optimset('MaxFunEvals',100000,'MaxIter',100000); % make sure it can really find the minimum.
params=fminsearch(@fitExponentialHelper,[dataY(end) 0.5*(dataY(1)-dataY(end)) -1/(max(dataX))],options,dataX,dataY)

function value=fitExponentialHelper(params,dataX,dataY) % calculate the goodness of fit

value=sum((dataY-params(1)-params(2)*exp(dataX*params(3))).^2);
