%%
close all
clear all
clc

%% Initialization
    % constants
    m1 = 1; % Mass of the cart
    m2 = 1; % Mass of the point-sized weight at the end of the pole
    l = 0.3; % length of the pole
    g = 9.81; % Acceleration due to gravity
    delT = 0.001;
    T = 5;
    
    % parmeters
    k = 0.001;
    % k1 = 0;
    k2 = 1.3;
    k3 = 3.7;
    k4 = 2.5;
    
    % variables
    fInst = 0; % Force being applied to the cart
    x = 0;
    theta = pi*0.9;
    dotTheta = 0;
    dotX = 0;
    
%% Optimize for parameters
    % surajCartPoleScore(params, k, delT,T, m1,m2,g,fInst,l,x,dotX,theta,dotTheta)
[bestParams, c] = fminsearch(@surajCartPoleScore, [k2,k3,k4], [], k, delT,T, m1,m2,g,fInst,l,x,dotX,theta,dotTheta)
