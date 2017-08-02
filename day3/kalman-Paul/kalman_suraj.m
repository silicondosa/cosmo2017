%% Clean and load datasest
close all
clear
load kalmanjump.mat;

%% Initialization
mu = zeros(1,1000);

%% Get mean
for i = 1:(length(mu)-1)