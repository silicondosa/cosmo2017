function mse = cosmoFitCausal( paras, muVs,muRs)
%calculates goodness of causal inference fit

    %all the values that the subject could have perceived
    x=-10:0.1:10; %we always need to integrate over unobserved signal in brain
    clf
    subplot(2,1,1); 
     
    %I can haz prior
    muP=0;
    sigmaP=1; %does not change anything as only ratios matter
    pP=exp(-(x-muP).^2/(2*sigmaP^2));
    pP=pP/sum(pP);
    plot(pP);
    
      %I can haz visual likelihood function
    sigmaV=paras(1);
    
    %Loop over stimulus parameters (visual perturbation)
    for i=1:length(muVs)
        muV=muVs(i);
        pV=exp(-(x-muV).^2/(2*sigmaV^2));  %this is Gaussian apart from a constant
        pV=pV/sum(pV);  % probabilities must add up to 1
        plot(pV); hold on;
        drawnow
        %I can has p(causal)
        C=1; %turns out this has effectively the same effect as third para
        pCommon=exp(-(muV).^2/(2*sigmaV^2))./(exp(-(muV).^2/(2*sigmaV^2))+C);   
        
        %combine
        posterior=pCommon*(pV.*pP)/sum(pV.*pP)+(1-pCommon)*pP;
        plot(posterior); % all the estimates that the subject could have seen
        drawnow
        meanPosterior(i)=sum(posterior.*x);
        scaling=paras(2);
        prediction(i)=scaling*meanPosterior(i);
        meanDeviation=muRs(i)-prediction(i);
    end

    subplot(2,1,2)
    plot(muVs, muRs); hold on
    plot(muVs, prediction);
    drawnow
    mse=mean((muRs-prediction).^2); %assuming gaussian noise.
end

