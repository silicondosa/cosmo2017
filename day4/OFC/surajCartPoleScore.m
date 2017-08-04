function costValue = surajCartPoleScore(params, k, delT,T, m1,m2,g,fInst,l,x,dotX,theta,dotTheta)
    t = 0:delT:T;
    k2 = params(1);
    k3 = params(2);
    k4 = params(3);
    
    % LQG example (afternoon)
    q = 0.01;
    r = 0.01;
   lcost = zeros(size(T));
    %% Euler Integration
    for i = 2:length(t)
        %% Dynamics roll-out
        dotdotX = cartPoleDynamics( [x(end), theta(end)], [dotX(end), dotTheta(end)] , m1,m2,g,fInst,l);
        dotX = [dotX, dotX(end) + (delT*dotdotX(1))];
        dotTheta = [dotTheta, dotTheta(end) + (delT*dotdotX(2))];
        x = [x, x(end) + (delT*dotX(end))];
        theta = [theta, theta(end) + (delT*dotTheta(end))];
        
        %% Force/Cost roll-out
        fInst = (k2*(theta(end)-pi)) + k3*dotTheta(end) + (k4*((theta(end)-pi)^3));
        % lcost(i) = cos(theta(end)) - k*(fInst^2); % morning session - brute force
        lcost = lcost + (q*theta(end) + r*
        %%Instantaneous plot
        %subplot(2,1,1);
%         hold on;
%         scatter(t(i), theta(end));
%         xlim([0,T]);
%         ylim([-2*pi, 2*pi]);
%         drawnow
    end
    hold on;
    plot(t, theta);
    drawnow
    costValue = -mean(lcost)
end