function [x,y] = sample_lds(A, C, Q, R, init_state, T, G, u)
% SAMPLE_LDS Simulate a run of a (switching) stochastic linear dynamical system.
% [x,y] = switching_lds_draw(A, C, Q, R, init_state, models, G, u)
% 
%   x(t+1) = A*x(t) + w(t),  w ~ N(0, Q),  x(0) = init_state
%   y(t) =   C*x(t) + v(t),  v ~ N(0, R)
%
% Input:
% A(:,:) - the transition matrix 
% C(:,:) - the observation matrix 
% Q(:,:) - the transition covariance 
% R(:,:) - the observation covariance 
% init_state(:) - the initial mean 
% T - the num. time steps to run for
%
% Output:
% x(:,t)    - the hidden state vector at time t.
% y(:,t)    - the observation vector at time t.


[os ss] = size(C);
state_noise_samples = sample_gaussian(zeros(length(Q),1), Q, T)';
obs_noise_samples = sample_gaussian(zeros(length(R),1), R, T)';

x = zeros(ss, T);
y = zeros(os, T);

x(:,1) = init_state(:);
y(:,1) = C*x(:,1) + obs_noise_samples(:,1);

for t=2:T
  x(:,t) = A*x(:,t-1)+ state_noise_samples(:,t);
  y(:,t) = C*x(:,t)  + obs_noise_samples(:,t);
end
