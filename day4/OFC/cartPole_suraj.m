%% 
clear all
close all
%% Initialization
    % constants
    m1 = 1; % Mass of the cart
    m2 = 1; % Mass of the point-sized weight at the end of the pole
    l = 0.3; % length of the pole
    g = 9.81; % Acceleration due to gravity
    delT = 0.001;
    T = 5;
    
    k = 0.001;
    k1 = 0;
    k2 = 0;
    k3 = 0;
    k4 = 0;
    
    % variables
    F = 0; % Force being applied to the cart
    x = 0;
    theta = pi-0.04;
    dotTheta = 0;
    dotX = 0.3;
    cost = cos(theta(end)) + k*F*F;
%% Euler Integration of cart-pole dynamics
    %this is the function cartPoleDynamics( X, dotX,m1,m2,g,F,l)
i = 1;
for t = 0:delT:T
    dotdotX = cartPoleDynamics( [x(i), theta(i)], [dotX(i), dotTheta(i)] , m1,m2,g,F,l);
    dotX = [dotX, dotX(i) + (delT*dotdotX(1))];
    dotTheta = [dotTheta, dotTheta(i) + (delT*dotdotX(2))];
    x = [x, x(i) + (delT*dotX(i))];
    theta = [theta, theta(i) + (delT*dotTheta(i))];
    
    i=i+1;
end
subplot(2,1,1);
hold on;
title("Linear Component");
plot(dotX)
plot(x)
legend("X dot", "X");

subplot(2,1,2);
hold on;
title("Angular Component");
plot(dotTheta)
plot(theta)
legend("Theta dot", "Theta");
