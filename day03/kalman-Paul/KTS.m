%%
% Adapted from Kording, Tenembaum, and Shadmehr 2007.
%

%% Joint parameters - initialize transition and observation matrices across all examples.
% Construct these matrices
states=30; %how many hidden states to use - we want 30 here
taus=exp(-linspace(log(0.000003),log(0.5),states)); %calculate the timescales for the states.

A =  % the transition matrix A - diagnal matrix using equation (1) (matrix M from appendix)
C =  % the observation matrix C - matrix H from appendix.
Q =  % the state noise matrix Q - matrix Q from appendix

Q=0.000001475*Q/sum(Q(:)); % this trick with normalizing makes it easier
                         % to experiment with other power laws for Q
                         % This way c=0.001 but its easy to play with the
                         % parameters

R =  % the observation noise R - sigma_w^2 from appendix

initx = zeros(states,1); %system starts out in unperturbed state
initV = diag(1e-6*ones(states,1)); %% rough estimate of variance

% Note that there are 30 memory states (30 'disturbances'), which will produce the error. The gain is implicit - error is always
% assumed to be around 0 (i.e. errors are addative). So we're not solving a multiplicative gain, but an addative offset.

% We are trying to find the states that when summed equal the error.
% ypred = C*xpred, which can be compared to any y

%% Improve estimate of initV
% This is just to get a better estimate of initV, and shows an example of
% the use of sample_lds and kalman_filter.
T = 40000;
[x0,y0] = sample_lds(A, C, Q, R, initx, T);
[xfilt, Vfilt, VVfilt, loglik, xpred] = kalman_filter(y0, A, C, Q, R, initx, initV);
initV=Vfilt(:,:,end);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Replicate Hopp and Fuchs
% These reproduce figure 2b - simulates the data (sample_lds) and then perform inference on them.
%{
In these experiments, subjects had to make a 10 degree saccade (to a particular target),
but then (after 200 ‘practice’ trials) the target moves during the saccade.
The subject eventually adapts by reducing the gain on the saccade (for an overshot).
Then at trial 1400, the target stops moving, and the subject adapts back to the original location.
%}

T = 4200; % Timescale of experiment, ie number of trials.
% INSERT CODE
% Simulate the unperturbed plan using sample_lds, and then purturb it:
[x0,y0] = sample_lds(A, C, Q, R, initx, T);

% external perturbation on y - from 1200 to 2600, produce a 30% disturbance
y(1201:2600)=y(1201:2600)-0.3;

% Then run the filtration on it, producing xpred to be used below.
[xfilt, Vfilt, VVfilt, loglik, xpred] = kalman_filter(y, A, C, Q, R, initx, initV);

a=sum(xpred(:,1001:end)); % first 1000 trials are just to ensure initV doesnt matter much
% We weigh all the hidden states equally, so just sum across all of them
% to get the resulting gain, and then subtract the observations and reverse
% the external perturbation.
b=a-y0(1001:end); % Subjectract the gain y from the predicted values x.
b(201:1600)=b(201:1600)-0.3; %transform back because we want to plot the actual gain


%% Produce figure 2b, given xpred and y.
figure(1);
subplot(2,1,1)
plot(1+b,'.') % Plot the 'trials'
[paras]=fitExponential([1:1400],b(201:1600)); % Fit an exponential to the trial data
[paras2]=fitExponential([1:1600],b(1601:3200));
hold on
plot([201:1600],1+paras(1)+paras(2)*exp(paras(3)*[1:1400]),'r'); % Plot the exponentials
plot([1601:3200],1+paras2(1)+paras2(2)*exp(paras2(3)*[1:1600]),'r');b
xlabel('time (saccades)')
ylabel('relative size of saccade');
title('Replication of standard target jump paradigm')
subplot(2,1,2)
imagesc(xpred(:,1001:end),[-1 1]*max(abs(xpred(:)))); % Plot the values of the hidden states.
colorbar
xlabel('time (saccades)')
ylabel('log timescale (2-33000)');
title('Inferred disturbances for all timescales');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Replicate Kojima faster second time
% This replicates figure 3c.
%{
Double adaptation experiments. Following an initial set of trials,
there is positive perturbation of the target by 35% for 800 trials,
followed by a 35% negative perturbation of the target (from the initial position).
This continues until the gain is back to neutral (i.e. the subject correctly saccades to the initial position),
at which time the target is (again) positively perturbed by 35%.
This second positive perturbation is followed by a quicker adaptation towards the new target position,
indicating that some memory remains of the previous positive perturbation.
%}

T=4200;
for i=1:5 % We do this 5 times, just to get some good estimates we later plot.
    % INSERT CODE
    % First, simulate the plant

    % Then produce positive perturbation from 1001 till 1800, and then negative perturbation till the end.
    % positive perturbation (of 35%)

    % negative perturbation until gain=1 (of -35%)

    % Then run the Kalman filter on this perturbation.

    nG=find(sum(xpred)<sum(xpred(:,1001)));
    % Now, figure out when the gain nG goes back to normal:
    bord ; % Replace with equation...
    % And then produce the positive perturbation again starting at that point - remember the negative perturbation.
    % switch back to positive - account for the initial negative.

    % Now run the kalman filter again...

    % And produce a linear fit on the first and second positive perturbation.
    [parasF]=fitLinear([1:200],sum(xpred(:,1001:1200))-y0(1001:1200));
    [parasS]=fitLinear([1:200],sum(xpred(:,bord:bord+199))-y0(bord:bord+199));
    first(i)=parasF(2); % Save these fits for plotting.
    second(i)=parasS(2);
end

%% Produces figure 3c - need xpred = state predicted and y0 = observation
figure(2);
subplot(2,1,1);
a=sum(xpred(:,801:end));
b=a-y0(801:end);
b(201:1000)=b(201:1000)+0.35; % remove perturbation to report standard gains
b(1001:bord-800)=b(1001:bord-800)-0.35;
b(bord-800:end)=b(bord-800:end)+0.35;
plot(1+b,'.');
[paras]=fitLinear([1:200],b(201:400)); % Fit linear functions to the resulting data.
[paras2]=fitLinear([1:200],b(bord-800:bord-800+199));
hold on
plot([201:800],1+paras(1)+paras(2)*[1:600],'r');
plot([bord-800:bord+599-800],1+paras2(1)+paras2(2)*[1:600],'r');
xlabel('time (saccades)')
ylabel('relative size of saccade');
title('adaptation, up down and up again');
subplot(2,1,2)
imagesc(xpred(:,1001:end),[-1 1]*max(abs(xpred(:))));
xlabel('time (saccades)')
ylabel('log timescale (2-33000)');
title('inferred disturbances for all timescales');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Replicate Kojimas change in the dark experiment
% Figure 3g
%{
Here we have a period with no information - after the gain resets following a reversal,
the subject is blinded (so no information) and then a positive perturbation is produced.
Note that the subject ?lost? some of the recent negative adaptation and showed spontaneous recovery
(in the original graph).
%}
T=4200;
% INSERT CODE
% Simulate the unperturbed plant:

% Produce positive perturbation:

% negative perturbation until gain=1

% Run a Kalman Filter:


nG=find(sum(xpred)<sum(xpred(:,1001)));
%figure out when the gain is back to normal

y0(bord:end)=y0(bord:end)+0.7; %switch back to positive
% Now run the kalman filter, but set the isObserved to zero for the dark periods (check kalman_filter.m)
% The monkey has no observations for this time period, after the gain comes back to 0 for 500 time points.
% We use a time of 500 to represent 'darkness'

% Sum all the hidden states and convert back:
a=sum(xpred);
b=y0-a;
b(1001:1800)=b(1001:1800)-0.35;
b(1801:bord)=b(1801:bord)+0.35;
b(bord+1:end)=b(bord+1:end)-0.35;

%% produces figure 3g
figure(3)
clf
subplot(2,1,1)
plot(-b(1,1001:end).*[ones(1,bord-1-1000),zeros(1,501),ones(1,4200-bord-500)],'.')
xlabel('time (saccades)')
ylabel('relative size of saccade');
title('adaptation, up down, darkness, and up again');
subplot(2,1,2)
imagesc(xpred(:,1001:end),[-1 1]*max(abs(xpred(:))));
xlabel('time (saccades)')
ylabel('log timescale (2-33000)');
title('inferred disturbances for all timescales');
clear first second

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Replicate Kojimas no-ISS experiment  - no perturbation after darkness
% Figure 3h
%{
This experiment is the same as the previous,
but instead of a positive perturbation after the dark period,
there is no perturbation (so the perturbation is set back to 0).
Note here that there is no spontaneous recovery.
%}

T=4200;

% simulate the plant
% positive perturbation of 35%
% negative perturbation of 35% until gain=1
% Run kalman filter

nG=find(sum(xpred)<sum(xpred(:,1001)));
% figure out when the gain is back to normal (gain = 1)
% switch perturbation to 0 after that point
% Run the kalman filter, with unobserved 'darkness' after the 0 point and for 500.

a=sum(xpred); % Average across all hidden states to find the adaptation gain
b=y-a; % Subtract the resulting averaged gain again from the evidence, and revert the perturbations back to 0.
b(1001:1800)=b(1001:1800)-0.35;
b(1801:bord)=b(1801:bord)+0.35;


%% Plot figure 3h
figure(6)
subplot(2,1,1)
plot(1-b(1,1001:end).*[ones(1,bord-1-1000),zeros(1,501),ones(1,4200-bord-500)],'.')
xlabel('time (saccades)')
ylabel('relative size of saccade');
title('up, down adaptation followed by darkness and no-ISS trials');
subplot(2,1,2)
imagesc(xpred(:,1001:end),[-1 1]*max(abs(xpred(:))));
xlabel('time (saccades)')
ylabel('log timescale (2-33000)');
title('inferred disturbances for all timescales');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Robinson - memory over multiple days with darkness.
% Figure 2c
%{
In these experiments, subjects went through the adaptation training (with an offset of 50%) over multiple days,
each day having 1500 trials and being blindfolded for the rest of the time.
Note that on each day subject's rates of learning is faster, till finally they almost achieve instant adaptation.
%}
T = 5*3000; % Produce adaptations for 5 days (1500 trials each).

% Simulate the plant

% Perturb the plant by 50%


% Set the observability (isObserved) to be 1 for the 'day' and 0 for 'night'.
% Set each day/night to be 1500 timesteps each.

% Run the kalman filter once more!

% Now subtract the observations from the summed predictions, accounting for
% the perturbations.
r=sum(xpred)-y;
r=r-0.5;

%% produce figure 2c - fitting exponentials to each day.
figure(4)
for i=0:4
    subplot(2,1,1)
    hold on
    plot(i*1500+1500+(1:1500),1+r(i*3000+1500+(1:1500)),'ko');
    [x4(i+1,:)]=fitExponential([1:1500]/1000,1+r(i*3000+1500+(1:1500)));
    plot(i*1500+1500+(1:1500),x4(i+1,1)+x4(i+1,2)*exp(x4(i+1,3)*(1:1500)/1000),'r');
end
xlabel('time (saccades during the experiment)')
ylabel('relative size of saccade');
title('adaptation interleaved with nights in the dark');

subplot(2,1,2)
hold on
imagesc(xpred,[-1 1]*max(abs(xpred(:))));
xlabel('time (saccades, including those simulated in the dark)')
ylabel('log timescale (2-33000)');
title('inferred disturbances for all timescales');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
