function [x, V, VV, loglik,xpred] = kalman_filter(y, A, C, Q, R, init_x, init_V, varargin)
% Kalman filter.
% [x, V, VV, loglik] = kalman_filter(y, A, C, Q, R, init_x, init_V, ...)
%
% INPUTS:
% y(:,t)   - the observation at time t
% A - the system matrix
% C - the observation matrix
% Q - the system covariance
% R - the observation covariance
% init_x - the initial state (column) vector
% init_V - the initial state covariance
%
% OPTIONAL INPUTS (string/value pairs [default in brackets])
% 'isObserved'     - defines which data points are actually observed [ all]
%
% OUTPUTS (where X is the hidden state being estimated)
% x(:,t) = E[X(:,t) | y(:,1:t)]
% V(:,:,t) = Cov[X(:,t) | y(:,1:t)]
% VV(:,:,t) = Cov[X(:,t), X(:,t-1) | y(:,1:t)] t >= 2
% loglik = sum{t=1}^T log P(y(:,t))
%

[os T] = size(y);
ss = size(A,1); % size of state space

% set default params
B = [];
ndx = [];
isObserved=ones(1,T);
args = varargin;
nargs = length(args);
for i=1:2:nargs
    switch args{i}
        case 'isObserved', isObserved=args{i+1};
        otherwise, error(['unrecognized argument ' args{i}])
    end
end
isObserved(find(isObserved==0))=1000; % this needs to be much larger than the normal variances
isObserved(find(isObserved==1))=0;

x = zeros(ss, T);
xpred=zeros(ss,T);

loglik = 0;
for t=1:T
    % deal with initialization
    if t==1 % Provide an initial value, start at 1
        prevx = init_x;
        prevV = init_V;
        initial = 1;
    else
        prevx = x(:,t-1);
        prevV=V;
        initial = 0;
    end
    % Below: a single kalman_update call, using the A, C, Q, and R matrices, given one timestep of evidence y.
    % Here is included the ['initial', initial] argument, along with previous x and V estimates.
    % Remember; we want the updated estimate of state x_t, V_t, and a prediction for x_t+1
    % R = R + isObserved, to produce the error that comes from NOT having observations.
    [x(:,t), V, LL, VV, xpred(:,t)] = ...
        kalman_update(A(:,:), C(:,:), Q(:,:), R(:,:)+isObserved(t), y(:,t), prevx, prevV, 'initial', initial);

    loglik = loglik + LL;
end

% Being able to compute the log likelihood allows us to do model fitting.
