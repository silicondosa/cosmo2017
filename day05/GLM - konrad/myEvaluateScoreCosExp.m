function [ score ] = evaluateScoreCosExp(paras, spikes, angle)
%function [ score ] = evaluateScoreCosExp(paras, spikes, angle)
% returns a score (which will be minimized), takes as input the parameters, and also spikes and angles 

% for making the predictions, keep in mind that we can change the baseline
% (add a constant), scale the cosine, and shift the cosine
%so the predictions are some kind of a function of the parameters and the
%angle
    b = paras(1);
    k1 = paras(2);
    k2 = paras(3);
    predictedF = exp(b + k1*cos(angle) + k2*sin(angle));
    %to score we can just calculate the log probability
    %we now need to calculate the probability or better logP (poisson
    %equation)

    %use Poisson equation
    logP = spikes.*log(predictedF) - (predictedF) - log(factorial(spikes));

    %we want to maximize the log probability
    score=-sum(logP); % by default matlab will minimize
    
    %subplot(2,1,2)
    hold on;
    %plot(
end

