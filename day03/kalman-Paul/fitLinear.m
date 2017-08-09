 function [params]=fitLinear(dataX,dataY)
 options=optimset('MaxFunEvals',100000,'MaxIter',100000); % make sure it converges 
 params=fminsearch(@fitLinearHelper,[0 0],options,dataX,dataY)
 
 function value=fitLinearHelper(params,dataX,dataY) % calculate goodness of fit
 value=sum((dataY-params(1)-params(2)*dataX).^2);
 