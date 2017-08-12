%% refresh MATLAB and load dataset
clear all;
clc;
% load dataset (if any) here
load groupData_fig1f_zhang.mat

%% Initialization
nTrials = 100;
trialType = -2.*ones(1, nTrials);
    % trialType = -1 : Baseline/Start state
    % trialType =  0 : Trainging state
    % trialType =  1 : Exposure state
    % trialType =  2 : Exit state
% The above variable controls state transitions and must be fully
% initialized to ensure proper operation of the FSM

%% Run FSM
for i = 1:nTrials
    % Set mealy transition parameters 
    transitionParams = mealyTransition(i, i-1);
    
    % Run FSM controller
    FSMcontrol(transitionParams);
end % end of FSM loop

% end of file