%% Estimate as a function of feedback
% This function keeps the prior the same while varying the likelihood.
% Incidentally this is the same that would happen if we had two likelihoods
% only then we should use the name likelihood instead of prior
close all
x=-10:0.1:10 % the range used for calculations
feedbacks=-8:.2:8 % potential places for visual feedback

% auditory likelihood
% here we assume that the auditory stimulus is always straight ahead
muA=0;
sigmaA=1.5;
pA=exp(-(x-muA).^2/(2*sigmaA^2));
pA=pA/sum(pA);


% influence of vision as function of visual stimulus
for i=1:length(feedbacks) % vary the positions where feedback may be given
    plot(x,pA,'g'); % plot the prior
    hold on
    
    %choose a feedback position and plot the likelihood
    muV=feedbacks(i);
    sigmaV=1;
    pV=exp(-(x-muV).^2/(2*sigmaV^2));  %this is Gaussian apart from a constant
    pV=pV/sum(pV);  % probabilities must add up to 1
    plot(x,pV,'r');
    
    %calculate the posterior and plot it
    posterior=pA.*pV;
    posterior=posterior/(sum(posterior));
    meanPosterior(i)=sum(posterior.*x);
    plot(x,posterior,'y');
    
    hold off
    pause(0.2); % have a little break so we can see what happens
end
figure
plot(feedbacks,meanPosterior)
xlabel('feedback position');
ylabel('best estimate');
