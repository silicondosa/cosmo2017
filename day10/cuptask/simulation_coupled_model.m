clear all;
% close all;
clc;
warning off;

%%% Define model parameters - you can modify
d = 0.45;           % pendulum length (m)
mp = 0.6;           % pendulum mass (kg)
mc = 2.4;           % cart mass (kg)
g = 9.81;           % gravity (m/s^2)

%%% Define trial parameters - you can modify
A = 0.165/2;         % desired amplitude of the cart motion (m)
f = .67;            % frequency of the rhythmic motion (Hz)
K = 100;            % arm stiffness (N/m)
B = 10;             % arm damping (N.s/m)
theta_0 = 0.;       % initial pendulum angle (rad)
omega_0 = 0.;       % initial pendulum angular velocity (rad/s)

%%% Define trial parameters - don't modify
cart_pos_0 = -A; % initial cart position (m)
cart_vel_0 = 0.;    % initial cart velocity (m/s)


%%% Simulate model
tsimu = 30;       % simulation duration (s)
sim('cart_pendulum_coupled_model');

%%% Plot time series
figure;

subplot(2,2,1);
plot(theta);
title({'Pendulum angle time series', 
    strcat('d=', num2str(d), 'm, mc=' ,num2str(mc), 'kg, mp=', num2str(mp), 'kg'),
    strcat('A= ', num2str(A), ' m, f= ', num2str(f), ' Hz, K= ', num2str(K), ' N/m, B= ', num2str(B), ' N.s/m, \theta_0=', num2str(theta_0), 'rad, \omega_0=', num2str(omega_0), 'rad/s')});
xlabel('Time (s)');
ylabel('Pendulum angle (rad)');

subplot(2,2,2);
plot(X, 'b');
hold on;
plot(Xo, 'r');
title({'Cart position time series', 
    strcat('d=', num2str(d), 'm, mc=' ,num2str(mc), 'kg, mp=', num2str(mp), 'kg'),
    strcat('A= ', num2str(A), ' m, f= ', num2str(f), ' Hz, K= ', num2str(K), ' N/m, B= ', num2str(B), ' N.s/m, \theta_0=', num2str(theta_0), 'rad, \omega_0=', num2str(omega_0), 'rad/s')});
xlabel('Time (s)');
ylabel('Cart position (m)');
legend('Actual position', 'Desired position');

subplot(2,2,3);
plot(Finter,'b');
hold on;
plot(Finput, 'r');
title({'Interaction force cart-hand time series', 
    strcat('d=', num2str(d), 'm, mc=' ,num2str(mc), 'kg, mp=', num2str(mp), 'kg'),
    strcat('A= ', num2str(A), ' m, f= ', num2str(f), ' Hz, K= ', num2str(K), ' N/m, B= ', num2str(B), ' N.s/m, \theta_0=', num2str(theta_0), 'rad, \omega_0=', num2str(omega_0), 'rad/s')});
xlabel('Time (s)');
ylabel('Interaction force (N)');
legend('Actual interaction force','Input force');

subplot(2,2,4);
plot(Fpendulum);
title({'Pendulum force on cart time series', 
    strcat('d=', num2str(d), 'm, mc=' ,num2str(mc), 'kg, mp=', num2str(mp), 'kg'),
    strcat('A= ', num2str(A), ' m, f= ', num2str(f), ' Hz, K= ', num2str(K), ' N/m, B= ', num2str(B), ' N.s/m, \theta_0=', num2str(theta_0), 'rad, \omega_0=', num2str(omega_0), 'rad/s')});
xlabel('Time (s)');
ylabel('Pendulum force on cart (N)');

figure;
yyaxis left;plot(theta.Time(150:end),theta.Data(150:end),'linewidth',2);xlabel('Time (s)'); ylabel('Pendulum angle (rad)');hold on;
yyaxis right;plot(X.Time(150:end),X.Data(150:end),'linewidth',2);ylabel('Cart position (m)');hold on;
legend('Pendulum position', 'Cart position');

