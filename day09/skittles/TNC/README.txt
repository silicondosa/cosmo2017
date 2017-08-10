README.TXT

To test the programs, run below in MATLAB.

clear all
close all

% Generate the solution manifold first.
% It will take several minutes to generate the solution manifold.
generateSM

% Alternatively, you can load SM.mat, the solution manifold.
% load('SM.mat')


load('AVDdemo.mat','AVD2')
AVD = AVD2;

[Actual Ideal Cost] = toleranceCost(0,AVD,D);
Cost
figure(1)
hold on
plot(Actual(:,1),Actual(:,2),'ok','markerfacecolor','k')
plot(Ideal(:,1),Ideal(:,2),'or')

[Actual Ideal Cost] = noiseCost(0,AVD,0.6, 1.5);
Cost
figure(1),
hold on
plot(Ideal(:,1),Ideal(:,2),'og')

[Actual Ideal Cost] = covariationCost(0,AVD,0.6, 1.5);
Cost
figure(1),
hold on
plot(Ideal(:,1),Ideal(:,2),'ob')

To customize the codes to your own model,
modify execution2result_polar.m
There is another m-file, execution2result_Cartesian.m,
but don't worry about this. Just set the first input argument zero,
and you won't use this m-file at all.
This package was designed for two different coordinate systems,
which is unnecessary for most analyses.

Please send an email to s.park@neu.edu if you have any questions.
