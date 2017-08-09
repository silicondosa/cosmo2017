% The purpose of this script is to test the kalman_update.m code after it has been
% fixed.

% Let's start with a simple example - here we are tracking a constant (unchanging)
% 1 dimensional state, but with observation noise. Below are the state model and
% observation models below. kalman_filter runs many steps of kalman_update over
% all the timesteps.

% Simple example - constant transfer function with more sensory noise than noise in
% state model.
% To hopefully provide some intuition:
% Imagine that you are playing a rhythm game, and have to tap out a rhythm
% that you hear using some poor quality headphones. The rhythm is constant (with some noise),
% and there is observation noise due to the headphones. Below is a simple model, along with a plot
% showing the true beat (x0), the observation (y0) and the predicted beat (xpred).

A = 1; % the transition matrix A
C = 1;% the observation matrix C
Q = (0.01).^2; % the state noise matrix Q
R = (0.1).^2; % the observation noise R
initx = 4; % Initial value of the state
initV = 1e-6; % Initial estimate of the variance.

T = 40; % Number of timesteps we have.

% sample_lds simulates a stochastic linear dynamics sytem,
% producing a sequence of states x0 and observations y0 given the information above.
[x0,y0] = sample_lds(A, C, Q, R, initx, T);
% the kalman_filter now runs through the evidence y0 to estimate the states, xpred
[xfilt, Vfilt, VVfilt, loglik, xpred] = kalman_filter(y0, A, C, Q, R, initx, initV);

% Plot them to see how well we estimate the actual state.
plot(1:T, x0,'r', 1:T, y0,'g', 1:T, xpred,'b');
