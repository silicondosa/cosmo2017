function CupTaskModelPlots(kh,bh)
% Parameters:

% Mass
mc = 2.4;           % cup mass, kg
mb = 0.6;           % ball mass, kg
% mb=1;


% Stiffness
g = 9.81;           % m/s^2; 10 to keep the numbers simple?
l = 0.45;          % meters
%l=.3;
wb = (g/l)^0.5;     % pendulum undamped natural frequency, rad/sec
fb = wb/(2*pi);     % pendulum undamped natural frequency, Hz

kg = mb*g*l;        % linearized gravitational stiffness, N-m/rad

% Sanity check:
wc = (kg/(mb*l*l))^0.5;   % rad/sec
fc = wc/(2*pi);     % cycles/sec (Hz)

M = [mc + mb mb*l; mb*l mb*l*l];    % mass (inertia) tensor

% Resonant frequency with zero human impedance
me = (mc*mb*l*l)/(mc + mb);           % effective mass, antiphase mode
we = (kg/me)^0.5;   % antiphase resonance, radian frequency
fe = we/(2*pi);     % antiphase resonace, Hz

% Human impedance (guesstimate)
% Mass of human hand is ignored, assumed "lumped" with mass of cup
fh =1;           % neuro-muscular bandwidth, Hz
wh = 2*pi*fh;       % neuro-muscular bandwidth, rad/sec
%kh = mc*wh^2;       % linearized neuro-muscular stiffness, N/m
% kh=200;

%kh = 70;  % temporarily remove neuro-muscular stiffness

K = [kh 0; 0 kg];            % stiffness matrix

% Check the eigenstructure of the undamped modes.
F = inv(M)*K;       % undamped natural frequency matrix
[V,w_sq] = eig(F);
FHz = w_sq.^0.5/(2*pi); % undamped natural frequencies, Hz

% Damping
% Q-factor = 1/2*zeta; zeta = b/2*sqrt(m*k); hence b
zeta_h = .2;       % guesstimated neuro-muscular damping ratio
Q_b = 100;          % lightly-damped pendulum
zeta_b = 1/(2*Q_b);
%bh = 2*sqrt(mc*kh)*zeta_h;      % translational damping [N/m/s]
% bh=15;
bb = 2*sqrt(mb*l*l*kg)*zeta_b ; % rotational damping [N-m/rad/s]
 
%bh = 6; % temporarily remove neuro-muscular damping
% only relevant if kh /= 0; if kh = 0, computed bh = 0 too.
%bb = 0; % temporarily remove pendulum damping

B = [bh 0; 0 bb];    % damping tensor
% B = zeros(2,2); % temporarily remove ALL damping; NOT recommended
%save impedanceMeasures kh bh

% State-determined model:
% State variables: [x_cup theta_ball v_cup omega_ball]'

S = [1 0]';         % input weighting matrix
A1 = [zeros(2,2) eye(2,2); -inv(M)*K -inv(M)*B];
B1 = [zeros(2,1); inv(M)*S];
C1 = [0 1 0 0];     % pendulum angle output [rad, CW]
D1 = 0;
sys_1 = ss(A1,B1,C1,D1);

% Bode plots with Hz axes
% % figure
% % subplot(1,3,1)
% % h = bodeplot(sys_1);
% % setoptions(h,'FreqUnits','Hz')
% % xlim([0.5 5])
% % grid
% % title({'Model Frequency Response'; 'Pendulum Angle/Input Force'})

% Change output ...
C2 = [1 0 0 0];     % cup displacement output [m]
sys_2 = ss(A1,B1,C2,D1);

% figure(2)
% % subplot(1,3,2)
% % h = bodeplot(sys_2);
% % setoptions(h,'FreqUnits','Hz')
% % xlim([0.5 5])
% % grid
% % title({'Model Frequency Response'; 'Cup Displacement/Input Force'})

% Change output again to compute applied force
% If zero human immpedance, applied force is input force
% Otherwise f_applied = f_input - f_impedance





% figure(3)
% % subplot(1,3,3)
% % h = bodeplot(sys_3);
% % setoptions(h,'FreqUnits','Hz')
% % xlim([0.5 5])
% % grid
% % title({'Model Frequency Response'; 'Applied Force/Input Force'})


%% It should be possible to customize this plot ...
if(1)
    f = logspace(log10(0.2),log10(3),10000);
    [mag,phs] = bode(sys_1,f*2*pi);
    figure
    subplot(2,2,1)
    % semilogx
    plot(f,(mag(:,:)),'LineWidth',2)
    xlim([0.2 2])
    % ylim([0 1])
    title('Ball Motion')
    ylabel({'Pendulum Angle/';'Input Force (rad/N)'})
    grid
    set(gca,'FontSize',20)
    set(gca,'FontName','Calibri')
    
    xlim([0 2])
    
    % xlim([10^3 1.5*10^4])
    subplot(2,2,3)
    hold on
    % semilogx
    plot(f,(phs(:,:)),'LineWidth',2)
    % human data
    %****% plot(freqIF', phaseBall', '*')
    % ylim([-360 10])
    xlabel('Frequency (Hz)')
    ylabel('Phase Lag (degrees)')
    grid
    set(gca,'FontSize',20)
    set(gca,'FontName','Calibri')
    
    xlim([0 2])
    
    
    % figure(5)
    [mag,phs] = bode(sys_2,f*2*pi);
    subplot(2,2,2)
    % semilogx
    plot(f,(mag(:,:)),'LineWidth',2)
    % ylim([0 0.06])
    title('Cup Motion')
    ylabel({'Cup Displacement/';'Input Force (m/N)'})
    grid
    set(gca,'FontSize',20)
    set(gca,'FontName','Calibri')
    
    xlim([0 2])
    
    
    subplot(2,2,4)
    hold on;
    % semilogx
    plot(f,(phs(:,:)),'LineWidth',2)
    % human data
    %****%plot(freqIF', wrapTo360(phaseCup)'-360, '*')
    % ylim([-180 10])
    xlabel('Frequency (Hz)')
    ylabel('Phase Lag (degrees)')
    grid
    set(gca,'FontSize',20)
    set(gca,'FontName','Calibri')
    
    xlim([0 2])
    
    
        set(gcf,'color','white')

    
    
end