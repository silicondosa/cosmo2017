%%load data
close all;
clear all;
load stevensonV2
%% Remove all times where speeds are very slow
isGood=find(handVel(1,:).^2+handVel(2,:).^2>.015)
handVel=handVel(1:2,isGood);
handPos=handPos(1:2,isGood);
spikes=spikes(:,isGood);
time=time(isGood);
angle=atan2(handVel(1,:),handVel(2,:));

%% Plot Raw Data %%
nNeuron=193%193
clf
hold on
plot(angle,spikes(nNeuron,:)+0.2*randn(size(spikes(nNeuron,:))),'r.')

%% Make a simple tuning curve
angles=-pi:pi/8:pi;
for i=1:length(angles)-1
    angIndices=find(and(angle>angles(i),angle<=angles(i+1)));
    nSpikes(i)=mean(spikes(nNeuron,angIndices));
end
plot(angles(1:end-1)+pi/16,nSpikes,'g','LineWidth', 2)

%% PART I: KONRAD
%% bootstrap error bars
angles=-pi:pi/8:pi;
for k=1:1000
    inds=1+floor(rand(size(angle))*length(angle));
    for i=1:length(angles)-1
        angIndices=inds(and(angle(inds)>angles(i),angle(inds)<=angles(i+1)));
        nS(i,k)=mean(spikes(nNeuron,angIndices));
    end
end
nSS=sort(nS')
U=nSS(25,:);
L=nSS(975,:);
M=mean(nS')
errorbar(angles(1:end-1)+pi/16,M,M-L,U-M)
%advanced exercise: do this for all neurons. Do they actually have cosine
%tuning as indicated by the research?

%% PART II: KONRAD
%% fit arbitrary functions
%fit a model
alpha_t = 0.8*pi;
param_m = 1;
param_b = 0.1;
k1 = 0.1; % param_m*cos(alpha_t)
k2 = 0.1; % param_m*sin(alpha_t)
YourInitialGuess = [param_b, k1, k2];
[bestParas,fvalCosExp(i)] = fminsearch(@myEvaluateScoreCosExp, YourInitialGuess,[],spikes(nNeuron,:),angle);


%Now plot it. 
%Here you need the function that you are actually fitting to see how the
%fit relates to the spikes
% myTuningCurve = [];
% lambda_optimized = [];
% for i=1:length(angles)-1
%     lambda_optimized = [lambda_optimized, exp(bestParas(1) + bestParas(2)*cos(angles(i)) + bestParas(2)*sin(angles(i)))];
%     myTuningCurve = [myTuningCurve, exp(-lambda_optimized(end))*(lambda_optimized(end)^k)/factorial(i)];
% end
lambda_optimized = exp(bestParas(1) + bestParas(2)*cos(angles) + bestParas(3)*sin(angles));
plot(angles, lambda_optimized,'b', 'LineWidth', 2);
