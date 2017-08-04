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
tuningFun = @(params,angle) exp(params(:,1)+params(:,2).*cos(angle-params(:,3)));

% Alternative tuning curve, rectified cosine
% tuningFun = @(params,angle) max(params(:,1)+params(:,2).*cos(angle-params(:,3)),1e-4);   % Why did I put 1e-4 and not 0?

% Define handle to negative log likelihood function
nLLfun = @(params) Tuning_nLL(params, spikes(nNeuron,:), angle, tuningFun);

% Define optimization starting point and bounds
LB = [-20,0,0];     % Lower bound
UB = [20,10,2*pi];  % Upper bound
PLB = [-3,0,0];     % Plausible lower bound
PUB = [3,3,2*pi];   % Plausible upper bound

% Randomize initial starting point inside plausible box
x0 = rand(size(PLB)).*(PUB - PLB) + PLB;

%% Fit with (bounded) fminsearch first
options.Display = 'iter';
options.OutputFcn = @(x, optimValues, state) plotProfile(nLLfun,x,PLB,PUB,[],{'b_0','b_1','\theta_0'});

[bestParams,fvalCosExp] = fminsearchbnd(nLLfun,x0,LB,UB,options);
% plot(-pi:pi/80:pi, exp(bestParams(1)+bestParams(2)*cos((-pi:pi/80:pi)-bestParams(3))))
fvalCosExp


%% Fit with fmincon (may get stuck!)
% [bestParams,fvalCosExp] = fmincon(nLLfun,x0,[],[],[],[],LB,UB,[],options);
% plot(-pi:pi/80:pi, exp(bestParams(1)+bestParams(2)*cos((-pi:pi/80:pi)-bestParams(3))))
% fvalCosExp


%% Fit with BADS (download from: https://github.com/lacerbi/bads)

options.Display = 'iter';
options.UncertaintyHandling = false;    % Log likelihood is exact
options.PeriodicVars = 3;               % Preferred direction is periodic

[bestParams,fvalCosExp,exitflag,output] = bads(nLLfun,x0,LB,UB,PLB,PUB,[],options);
% plot(-pi:pi/80:pi, exp(bestParams(1)+bestParams(2)*cos((-pi:pi/80:pi)-bestParams(3))))
fvalCosExp

%% MCMC via slice sampling

N = 2e3;
smpl_options = [];

[samples,fvals,exitflag,output] = slicesamplebnd(@(x) -nLLfun(x),x0,N,[],LB,UB,smpl_options);
cornerplot(samples,{'b_0','b_1','\theta_0'},[],[PLB;PUB]);

%% Part II: Fitting Drifting Tuning Curves

rng(1);
npivots = 10;

% Define optimization starting point and bounds
LB = [-20,0,0,-2*pi*ones(1,npivots-1)];     % Lower bound
UB = [20,10,2*pi,2*pi*ones(1,npivots-1)];  % Upper bound
PLB = [-3,0,0,-pi*ones(1,npivots-1)];     % Plausible lower bound
PUB = [3,3,2*pi,pi*ones(1,npivots-1)];   % Plausible upper bound

x0 = rand(size(PLB)).*(PUB - PLB) + PLB;

nLLfun = @(params) DriftingTuning_nLL(params, spikes(nNeuron,:), angle, time, tuningFun);

% [bestParams,fvalCosExp] = fminsearchbnd(nLLfun,x0,LB,UB,options);

% Fit with BADS (https://github.com/lacerbi/bads)

options.Display = 'iter';
options.UncertaintyHandling = false;    % Log likelihood is exact
options.PeriodicVars = 3;       % Preferred directions are periodic
options.OutputFcn = [];
% @(x, optimValues, state) plotProfile(nLLfun,x,PLB,PUB);

[bestParams,fvalCosExp,exitflag,output] = bads(nLLfun,x0,LB,UB,PLB,PUB,[],options);
%plot(-pi:pi/80:pi, exp(bestParams(1)+bestParams(2)*cos((-pi:pi/80:pi)-bestParams(3))))
fvalCosExp




%% MCMC via slice sampling

N = 8e3;
smpl_options = [];

[samples,fvals,exitflag,output] = slicesamplebnd(@(x) -nLLfun(x),x0,N,[],LB,UB,smpl_options);
cornerplot(samples,[],[],[PLB;PUB]);

