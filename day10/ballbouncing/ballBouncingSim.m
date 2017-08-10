%% BALL BOUNCING SIMULATION FUNCTION
function [ContactAcc,t,v]=ballBouncingSim(initialVelocity, period, A, alpha, perturbation, delay)

switch nargin
    case 4
        perturbation=0;delay=0;
    case 5
        delay=0;
end

%% FUNCTION INPUTS
% 
%  initialVelocity = initial take off velocity (m/s) after first contact
%  period = period of racket oscillation (s)
%  A = amplitude of racket oscillation (m)
%  alpha = coefficient of restitution
%% FUNCTION OUTPUTS
%  ContactAcc = racket acceleration at contact
%  t = time of contact
%  v = ball velocity after contact
%% RACKET PARAMETERS
%
%  omega = angular frequency of racket oscillation (rad/s)
%  g = acceleration of gravity (m/s^2)

omega = 2*pi/period;
g = 9.81; 


%% BISECTION PARAMETERS
%
%  initialStep = inital step for bisection method (s)
%  tolerance = tolerance for bisection search of root (s)
initialStep = .02;
tolerance = 0.01; 

%% SIMULATION PARAMETERS
%
%  N = number of racket-ball contacts to generate in the simulation
%  v = ball velocity vector (m/s)
%  y = racket position vector (m)
%  t = time of contact vector (s)
N = 50; 
v = zeros(1,N); v(1)=initialVelocity;
y = zeros(1,N); 
t = zeros(1,N); 

%% SIMULATION LOOP
%
%  for each contact N, 
%       (1) find the next contact time using the bisection method
%       (2) find the racket position and velocity at next contact time
%       (3) stop loop if time between contacts is too small
%  end

BreakPoint=N;
for k = 1:N-1
    
    %%%% FIND NEXT CONTACT TIME - BISECTION METHOD %%%%
    
        % set initial time step
        timeStep = initialStep; 

        % set initial value of contact time 
        contactTime = t(k) + timeStep; 

        % difference between racket and ball positions at initial value of 
        % contact time
        deltaOld = -A*sin(omega*contactTime)+A*sin(omega*t(k))+v(k)*(contactTime-t(k))-g/2*(contactTime-t(k))^2;

        % continue to search for contact time when difference between racket
        % and ball positions is less than tolerance
        while abs(deltaOld) > tolerance

            % set new guess of contact time 
            contactTime = contactTime + timeStep;  

            % difference between racket and ball positions at new value contact
            % time
            deltaNew = -A*sin(omega*contactTime)+A*sin(omega*t(k))+v(k)*(contactTime-t(k))-g/2*(contactTime-t(k))^2; 

            % if product of new and old differences is negative, step in 
            % opposite direction with half previous step size
            if (deltaOld*deltaNew < 0) 
                timeStep = -timeStep/2;  
            end

            % set old difference to turrent difference between racket and ball
            % position
            deltaOld = deltaNew; 
        end
    
    %%%% END BISECTION SEARCH OF NEXT CONTACT TIME %%%%

    % set time of k contact
    t(k+1)=contactTime; 
    
    % set ball velocity after k contact
    v(k+1)=(1+alpha)*A*omega*cos(omega*(t(k+1)-delay))-alpha*v(k)+g*alpha*(t(k+1)-t(k));
    
    % add perturbation to racket velocity at first contact
    if k == 1 
        v(k+1)=v(k+1)+perturbation; 
    end

    % set racket position of k contact
    y(k+1)=A*sin(omega*t(k+1));
    
    % exit loop if time interval between contacts is too small
    if (t(k+1)-t(k) < 2*initialStep) 
        BreakPoint=k;
        disp(sprintf('Simulation stopped after %d contact because time interval too small', k));
        break
    end
    
end 

%% SIMULATION RESULTS
%

if(delay ~=0)
    figure(20)
else
    figure(21)
end
% subplot(2, 1, 1);

hold on;

% plot racket position
time = 0:.02:t(k+1);
plot(time,A*sin(omega*time), 'k', 'LineWidth', 2);

% plot ball position for between each contact
for k=1:N-1 
    time = t(k):.02:t(k+1);
    pos = A*sin(omega*t(k))+v(k)*(time-t(k))-g/2*(time-t(k)).*(time-t(k));
    plot([time t(k+1)],[pos y(k+1)],'g','LineWidth', 2);    
end

hold off;

% subplot(2, 1, 2);
% hold on;
% for k=1:N-1
%     plot(t(k+1), y(k+1)*-omega.^2+.5, 'b*', 'LineWidth', 2);
% end
% set(gca, 'XLimMode', 'manual', 'XLim', [22 26.5]);
% hold off;
%% calculate contact racket acceleration
Time = 0:.001:period;
Pos=A*sin(Time*omega);
acc=diff(diff(Pos)/.001)/.001;
Acc=[acc(1),acc,acc(end)];


for K=1:BreakPoint
        contact(K)=rem(t(K),period)/period;
        ContactAcc(K)=Acc(round(contact(K)*(period/.001))+1); 
        
end
