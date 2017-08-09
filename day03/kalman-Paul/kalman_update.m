function [xnew, Vnew, loglik, VVnew,xpred] = kalman_update(A, C, Q, R, y, x, V, varargin)
% KALMAN_UPDATE Do a one step update of the Kalman filter
% [xnew, Vnew, loglik] = kalman_update(A, C, Q, R, y, x, V, ...)
%
% INPUTS:
% A - the system matrix
% C - the observation matrix
% Q - the system covariance
% R - the observation covariance
% y(:)   - the observation at time t
% x(:) - E[X | y(:, 1:t-1)] prior mean
% V(:,:) - Cov[X | y(:, 1:t-1)] prior covariance
%
% OPTIONAL INPUTS (string/value pairs [default in brackets])
% 'initial' - 1 means x and V are taken as initial conditions (so A and Q are ignored) [0]
% 'u'     - u(:) the control signal at time t [ [] ]
% 'B'     - the input regression matrix
%
% OUTPUTS (where X is the hidden state being estimated)
%  xnew(:) =   E[ X | y(:, 1:t) ]
%  Vnew(:,:) = Var[ X(t) | y(:, 1:t) ]
%  VVnew(:,:) = Cov[ X(t), X(t-1) | y(:, 1:t) ]
%  loglik = log P(y(:,t) | y(:,1:t-1)) log-likelihood of innovatio
%
% P(x_t | x_t-1) = N(A*x_t-1, Q) - prediction
% P(y_t | x_t )  = N(H x_t, R) - likelihood
% P(x_t-1 | Y )  = N(x_t-1, V) - posterior
% Predict then Update estimate.
%
% Written by Kevin Murphy, simplified and republished by Konrad Kording
% 2006.
% Ruined by Dominic Mussack 2016.


% set default params
u = [];
B = [];
initial = 0;

args = varargin;
for i=1:2:length(args)
  switch args{i}
   case 'u', u = args{i+1};
   case 'B', B = args{i+1};
   case 'initial', initial = args{i+1};
   otherwise, error(['unrecognized argument ' args{i}])
  end
end

%  xpred(:) = E[X_t+1 | y(:, 1:t)]
%  Vpred(:,:) = Cov[X_t+1 | y(:, 1:t)]

%% Prediction step:
if initial
  % If this is the first step of a kalman filter,
  % use the initial estimates of x and V.
  xpred = x;
  Vpred = V;
else
  % Otherwise, use the state transition model to produce
  % an estimate of xpred and Vpred
  xpred = A*x;
  Vpred = A*V*A' + Q;
end

%% Update step
% compute innovation (error) e:
e =
% compute innovation covariance S
S =
% Compute log likelihood
loglik = gaussian_prob(e, zeros(1,length(e)), S, 1);
% Compute the optimal Kalman gain matrix K
K =

% Update a posteriori state estimate xnew
xnew =
% Update a posteriori covariance estimate Vnew
Vnew =

% Update covariance change VVnew (see above).
VVnew = 
