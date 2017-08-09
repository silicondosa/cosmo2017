%% Setup
clc;
close all;
clear all;

%% Initialization
alpha = 1000;
gamma = 1;
b = 10;
d = 1;
m = 1;
Tmax = 3;
T = 0:0.01:Tmax;

%% Find the parameters of J
% function retVal = evaluateJ(alpha, b, m, d, gamma, t)

% Baseline
J = evaluateJ(alpha, b, m, d, gamma, T);
plot(T, J,'K');
max_pos = find(max(J) == J);
hold on;
plot(T(max_pos), J(max_pos), 'k*','LineWidth', 2);

% Double reward alpha
J = evaluateJ(2*alpha, b, m, d, gamma, T);
plot(T, J,'r');
max_pos = find(max(J) == J);
hold on;
plot(T(max_pos), J(max_pos), 'r*','LineWidth', 2);

% Double effort b
J = evaluateJ(alpha, 2*b, m, d, gamma, T);
plot(T, J,'g');
max_pos = find(max(J) == J);
hold on;
plot(T(max_pos), J(max_pos), 'g*','LineWidth', 2);

% Double mass m
J = evaluateJ(alpha, b, 2*m, d, gamma, T);
plot(T, J,'b');
max_pos = find(max(J) == J);
hold on;
plot(T(max_pos), J(max_pos), 'b*','LineWidth', 2);

% Double impulsivity gamma
J = evaluateJ(alpha, b, m, d, 2*gamma, T);
plot(T, J,'y');
max_pos = find(max(J) == J);
hold on;
plot(T(max_pos), J(max_pos), 'y*','LineWidth', 2);
