%% CoSMo 2017, Day 5 -- Model fitting & optimization tutorial with Luigi Acerbi

% Prepare data, from Konrad's tutorial

% Load data
load M1_Stevenson_Binned

% Remove all times where speeds are very slow
isGood=find(handVel(1,:).^2+handVel(2,:).^2>.015);
handVel=handVel(1:2,isGood);
handPos=handPos(1:2,isGood);
spikes=spikes(:,isGood);
time=time(isGood);
angle=atan2(handVel(1,:),handVel(2,:));

% Plot Raw Data
nNeuron = 193  %193
clf
hold on
plot(angle,spikes(nNeuron,:)+0.2*randn(size(spikes(nNeuron,:))),'r.')

%% Part I: Model fitting
% Fix random seed for reproducibility
rng(1);

% Define exponential-cosine tuning curve
tuningFun = @(params, angle) exp(params(:,1) + params(:,2).*cos(angle-params(:,3)));

%alternative tuning curve, rectifiued cosine
% tuningFun = @(params, angle) max(params(:,1)+params(:,2).*cos(angle-params(:,3)),1e-4);

% define handle to negative log likelihood function
nLLfun = @(params) Tuning_nLL(params, spikes(nNeuron,:), angle, tuningFun);

% hard bounds
LB = [0, 0.001, -10*pi];
UB = [20, 50, 10*pi];

% Probable bounds (typically used for initial points)
PLB = [0,0.01,-2*pi];
PUB = [3,2,2*pi];

nvars = numel(LB);
x0 = PLB + (PUB - PLB).*rand(1,nvars);

options.Display = 'iter';

[bestParams, fvalCosExp] = fminsearchbnd(nLLfun, x0, LB, UB, options);

% Define exponential-cosine tuning curve

% Define optimization starting point and bounds

% Randomize initial starting point inside plausible box

%% Fit with (bounded) fminsearch first
[bestParams2, fvalCosExp2] = fminsearchbnd(nLLfun, x0, LB, UB, options);

%% Fit with fmincon (may get stuck!)
[bestParams3, fvalCosExp3] = fmincon(nLLfun, x0, [], [], [], [], LB, UB, [], [], options);
plotProfile(nLLfun, x0, LB, UB);

%% Fit with BADS (download from: https://github.com/lacerbi/bads)
options.UncertaintyHandling = true;
[bestParams4, fvalCosExp4] = bads(nLLfun, x0, LB, UB, PLB, PUB, [], options);
plotProfile(nLLfun, x0, LB, UB);
