%%% Parameter for video display
videoSpeed = 1; % if you want to play the motion slower/faster than real time

%%% Interpolate data to remove "jerkiness" in display
dt = 0.03 * videoSpeed;
tnew = [0:dt:tsimu];
X_interp = interp1(X.Time,X.Data,tnew);
theta_interp = interp1(theta.Time,theta.Data,tnew);
Finter_interp = interp1(Finter.Time,Finter.Data,tnew);

%%% Create plot with black background
screen = get(0,'ScreenSize') 
figure('position', [0.5*(screen(3)-0.8*screen(3)) 0.5*(screen(4)-0.2*screen(3)) 0.8*screen(3) 0.2*screen(3)]);
hold on;
set(gca,'Color','k');
title('Time: 0s');
xlabel('Position (m)');

cupScalingFactor = 0.0225/d;    % Scale the size of the cup (which depends on the pendulum length) to fit within the target blocks
cupWidth = 2*d*cupScalingFactor;
axis([-A-cupWidth A+cupWidth 0.15*(-A-cupWidth) 0.35*(A+cupWidth)]);

%%% Create interaction force visualization
Fmax = 15.;      % Approximate max value, to scale the displayed force
force_bar_vertical_position = 0.032;
force_bar_width = 0.004;
force_bar_max_position = A+0.5*cupWidth;
rectangle('Position', [-A-cupWidth force_bar_vertical_position-0.5*force_bar_width 2*(A+cupWidth) force_bar_width], 'FaceColor', [1 1 1]);
text(-0.01, force_bar_vertical_position + 2 * force_bar_width, 'Interaction Force', 'Color', [1 1 1]);  
text(0, force_bar_vertical_position + force_bar_width, '0 N', 'Color', [1 1 1]);    
text(-force_bar_max_position, force_bar_vertical_position + force_bar_width, strcat('-', num2str(Fmax), ' N'), 'Color', [1 1 1]);
text(force_bar_max_position, force_bar_vertical_position + force_bar_width, strcat('+', num2str(Fmax), ' N'), 'Color', [1 1 1]);

%%% Draw target blocks
rectangle('Position', [-A-0.5*cupWidth 0 cupWidth 0.5*cupWidth], 'FaceColor', [0 0.8 0]);
rectangle('Position', [A-0.5*cupWidth 0 cupWidth 0.5*cupWidth], 'FaceColor', [0 0.8 0]);

time_sec = 0;
for i=1:numel(tnew),
    %%% Draw cup
    cupPosition = X_interp(i);
    cup = plot(cupPosition + 0.5*cupWidth*sin(linspace(-pi/2, pi/2, 100)), 0.5*cupWidth - 0.5*cupWidth*cos(linspace(-pi/2, pi/2, 100)), 'y', 'LineWidth', 4);

    %%% Draw ball
    pendulumAngle = theta_interp(i);
    ball = plot(cupPosition + 0.43*cupWidth*sin(pendulumAngle), 0.4*cupWidth*(1-cos(pendulumAngle))+0.05*cupWidth, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 14);

    %%% Draw representation of interaction force 
    %%% (Bar is blue when force is low, and goes to red when force approaches Fmax)
    x = linspace(0, Finter_interp(i)/Fmax*force_bar_max_position, 10);
    y = force_bar_vertical_position * ones(size(x));
    z = zeros(size(x));
    col = abs(x);
    caxis([0 force_bar_max_position]);              
    colormap(jet);
    force = surface([x;x],[y;y],[z;z],[col;col], 'FaceColor','no','EdgeColor','interp','LineWidth',10);  
    
    %%% Update displayed time every second
    if tnew(i) > time_sec + 1;
        title(strcat('Time: ', num2str(round(tnew(i))), 's'));
    end;
    
    pause((tnew(min(i+1, numel(tnew)))-tnew(i)) / videoSpeed);
    
    %%% Erase previous ball and cup
    delete(cup);
    delete(ball);
    delete(force);
end;

%%% Plot last position
cup = plot(cupPosition + 0.5*cupWidth*sin(linspace(-pi/2, pi/2, 100)), 0.5*cupWidth - 0.5*cupWidth*cos(linspace(-pi/2, pi/2, 100)), 'y', 'LineWidth', 4);
ball = plot(cupPosition + 0.4*cupWidth*sin(pendulumAngle), 0.4*cupWidth*(1-cos(pendulumAngle)), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 14);
