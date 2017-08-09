% inverted_pendulum.m
close all
clear
clc
%% system parameters
M = .5;
m = 0.2;
b = 0.1;
I = 0.006;
g = 9.8;
l = 0.3;

% state:  xstate_t = [x x_dot theta theta_dot]


%% Matrices for state equations
% x_t+1 = A*x_t + B*u + e_x   with e_x ~ N(0,Sigma_x) 

p = I*(M+m)+M*m*l^2; %denominator for the A and B matrices

A = [0      1              0           0;
     0 -(I+m*l^2)*b/p  (m^2*g*l^2)/p   0;
     0      0              0           1;
     0 -(m*l*b)/p       m*g*l*(M+m)/p  0];
B = [     0;
     (I+m*l^2)/p;
          0;
        m*l/p];

 % state noise - only goes into x_dot and theta_dot
e_x_xvariance = (0.00)^2;
e_x_xdotvariance = (0.01)^2;
e_x_thetavariance = (0.00)^2;
e_x_thetadotvariance = (0.01)^2;
Sigma_x = diag([e_x_xvariance e_x_xdotvariance e_x_thetavariance e_x_thetadotvariance]);
% we can sample multivariate gaussians using mvnrnd
% try:   help mvnrnd,  e_x = mvnrnd([0 0 0 0],Sigma_x)'
%% simulate system
dT = 0.0001;
x(:,1)=[0 0 0.1 0];  % system has been linearized around the "up" position
for i = 1:4000, 
    e_x = mvnrnd([0 0 0 0],Sigma_x)';
    x(:,i+1)=(eye(4)+dT*A)*x(:,i)+e_x;
    
end
figure; plot(x')
%  EVEN TINY NOISE CAN MAKE THE PENDULUM FALL

%%%%%% SET UP THE ADDITIONAL MODEL COMPONENTS
%% MODEL THE OBSERVER

%  observe only position and angle
H = [[0 1 0 0]; [0 0 1 0]];

% observation noise - only goes into x and theta
e_y_xvariance = (0.01)^2;
e_y_thetavariance = (0.01)^2;
Sigma_y = diag([e_y_xvariance e_y_thetavariance]);

%%%% NOW ADD OBSERVER TO THE SIMULATION LOOP
dT = 0.0001;
x(:,1)=[0 0 0.1 0];  % system has been linearized around the "up" position
e_y = mvnrnd([0 0],Sigma_y)';
y(:,1) = H*x(:,1) + e_y;

Niter = 4000;
for i = 1:Niter, 
    e_x = mvnrnd([0 0 0 0],Sigma_x)';
    x(:,i+1)=(eye(4)+dT*A)*x(:,i)+e_x;
    %put observer here, call it y
    e_y = mvnrnd([0 0],Sigma_y)';
    y(:,i+1) = H*x(:,i+1) + e_y;
end
figure; plot(y')
%%%%%%%  Now we model our costs!  Not the same as before, linearized we
%%%%%%%  won't worry about anything but keep state close to goal - 
%%%%%%% what's the goal in the linearized form?  
%%%%%%% cost_t = R*u_t^2 + Q*linearized_theta^2
%%%%%%%  HOWEVER, the standard form for LQG is to do this via matrices
%%% so that cost_t = u_t'*R*u_t + x_t'*Q*x_t
R = 0.001;
Q = diag([0 0 1 0]);
%%%% write a evaluation function like before
%%%%% try to solve your control policy using brute force!!  

% brute force simulation here - 
for i=1:Niter
    
end

%%%% NOW WE USE KALMAN LQG
%%% we will use 
%% kalman_lqg( A,B,H, Sigma_x, Sigma_y, Q,R, X1,S1  [NSim,Init,Niter] )
%
%%%%%%%% Finally, we can program up the full LQG code and run
% % u(t)    = -L(t) x(t)
% x(t+1)  = A x(t) + B u(t) + e_x,   with e_x ~ N(0,Sigma_x) 
% y(t)    = H x(t) + e_y,            with e_y ~ N(0,Sigma_y)
% xhat(t+1) = A xhat(t) + B u(t) + K(t) (y(t) - H xhat(t))
% x(1)    ~ mean X1, covariance S1
%
% cost(t) = u(t)' R u(t) + x(t)' Q(t) x(t)
%
% NSim    number of simulated trajectories (default 0)  (optional)
% Init    0 - open loop; 1 (default) - LQG; 2 - random  (optional)
% Niter   iterations; 0 (default) - until convergence   (optional)
%
% K       Filter gains
% L       Control gains
% Cost    Expected cost (per iteration)
% Xa      Expected trajectory
% XSim    Simulated trajectories
% CostSim Empirical cost

X1 = [0 0 0 0]';
S1 = Sigma_x;
% only difference here is that the Q matrix can be made a function of time,
% which helps model different goal situations
Q = repmat(Q,[1 1 Niter]);
NSim = 100;
As = expm(A*dT);

[K,L,Cost,Xa,XSim,Xhat,CostSim] = Kalman_lqg( As,B, H, Sigma_x, Sigma_y, Q,R, X1,S1,100,1,100); 
%  here's a plot of the simulated angles!
 plot(1:Niter,permute(XSim(3,:,:),[3,2,1]))
% here's the average behavior
 plot(1:Niter,Xa(:,3))
%  And here's where the state estimator THINKS the system is
plot(1:Niter,permute(Xhat(3,:,:),[3,2,1]))
 

