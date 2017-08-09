V_vis = -10:0.01:10;
sig_v = 1;
mu_v = 0.5;
Tview = 50; % Number of evidence steps
fL= @(v)(normpdf(v,-mu_v,sig_v));
fR= @(v)(normpdf(v,mu_v,sig_v));
plot(V_vis,fL(V_vis),V_vis,fR(V_vis)); % Look at the likelihoods

%%
pR = 0.5;
prior = [pR 1-pR]; % The prior - equally weighted

%%%% simulate an observer
%%% Part 1:  Integrate incoming evidence over time

Nsim = 1000; % Number of trials we run through
for trial = 1:Nsim,
    % The next few lines will simulate the experiment
    %% SAMPLE the STIMULI
    LorR = rand<prior(1);% generate true direction
    if LorR,
        v_obs = normrnd(mu_v,sig_v,[1 Tview]);
    else
        v_obs = normrnd(-mu_v,sig_v,[1 Tview]);
    end
    
    %% EVALUATE THE OBSERVER MODEL 
    % brute force updating
    for t = 1:Tview
        % v_obs_t = v_obs(1:t); % Use samples up to t
        % integrating across time is equivalent to multiplying the
        % likelihoods at each time point
        liklihood_R = prod(fR(v_obs_t)); % Get prod likelihood on those samples
        liklihood_L = prod(fL(v_obs_t));
        % EVIDENCE is defined as log likelihood ratio - this is what is
        % typically modeled in Drift Diffusion Models
        LR =  log(liklihood_R) - log(liklihood_L); % Take log odds - compute evidence for right
        % However, the bayesian posterior works in probability space, which
        % is useful for decision theory
        post = liklihood_R*prior(1)/(liklihood_R*prior(1)+liklihood_L*prior(2)); % Find posterior for right|data
        P_t(t,trial) = post;  % collect posterior as function of time for all
        LR_t(t,trial) = LR;
    end
    Hypothesis(trial) = LorR; % True answer - left or right (right = 1).
end

%% Evidence
figure(1)
plot(LR_t)
xlabel('time')
ylabel('Evidence')
title('Typical Drift Diffusion evidence plot')

%% Probabilities
% make a matrix which has the correct LR label for every trial and time
% step
HypothesisByTime = repmat(Hypothesis,[Tview 1]);

figure(2);
subplot(1,2,1)
imagesc(P_t(1:30,1:100)')
xlabel('time')
ylabel('trial number')
colorbar
title('Pevidence for Right')
subplot(1,2,2)
imagesc(HypothesisByTime(1:30,1:100)')
xlabel('time')
ylabel('trial number')
colorbar
title('Left Right values')

figure(3);
% compute an overall posterior for the correct answer by flipping and
% combining the Left and Right trials.  

Pcomb_t = HypothesisByTime.*P_t + (1-HypothesisByTime).*(1-P_t);

subplot(1,3,1);
plot(Pcomb_t) % Simulated Evidence in probability space 
subplot(1,3,2);

plot(mean(Pcomb_t,2)) % Average posteriors

%%% MAKE A DECISION
%  When should we stop?  what should we choose?  
%  One of the key theoretical results is that the best time to
% stop takes the form of a threshold rule.  For cost function based solely
% on performance, thresholding the posterior allows the decision maker to 
% stop when performance reaches the threshold performance level.  This
% yields the desired performance level on average, and the minimum time to
% reach this performance.  
%%  1) If your loss function is P_correct, find a threshold 
%%  rule that yields average performance of .95, but apply this to the evidence
%%  2) How do you need to change the rule if 70% of trials are left?
figure(4)

postRgX = 0.95;
thresh = log(postRgX) - log(postRgX); % Threshold for evidence
R = abs(LR_t)>thresh; % Whether evidence goes above threshold (1 = yes).
PossibleTimes = repmat((1:Tview)',[1,Nsim]); % Possible response times - for each trial
PostCriteriaTimes = R.*PossibleTimes;  
PostCriteriaTimes(PostCriteriaTimes==0)=NaN;
reaction_times = nanmin(PostCriteriaTimes); % Find response time
subplot(1,3,1);
plot(LR_t)
xlabel('time')
ylabel('Evidence')
title('Typical Drift Diffusion evidence plot')

subplot(1,3,2);
hist(reaction_times);
title('Reaction Time Distribution');

% for comparison, here's what should match 
subplot(1,3,3);
p_crit = 0.95; % Thresold for posteriors
R_post = Pcomb_t>p_crit; % Whether posterior is above threshold (1=yes)
PostCriteriaTimes_post = R_post.*PossibleTimes; PostCriteriaTimes_post(PostCriteriaTimes_post==0)=NaN;
reaction_times_post = nanmin(PostCriteriaTimes_post);
hist(reaction_times_post);
title('Reaction Time Distribution, thresholding posterior');

%% 3) NOW INCORPORATE A LOSS FUNCTION ON TIME AS IN THE LECTURE
%  compute the expected loss on average for a cost function of the form
% cost(t) = 1./(alpha*t+T) Let T = 5 and alphat = .1
alphat = 0.1; T = 5;
C_t = 1./(alphat*(1:Tview) + T );
C_t = C_t/max(C_t);

% Compute the expected cost
J = mean(Pcomb_t,2)'.*C_t;
plot((1:Tview),mean(Pcomb_t,2)',(1:Tview),C_t/max(C_t),(1:Tview),J)
legend({'Posterior'; 'Time cost'; 'J = Overall cost' })
xlabel('time')
title('Computing the expected cost')
%  Is it possible to find a threshold rule on postior probability that yields minimal
%  cost? HINT - analytically minimize J, solve for time, plug time into the
% expected posterior and find the corresponding probability.   

%  Changing the cost per unit time alpha shifts the optimal RT and
%  performance - what happens with alpha_t = 0.5?  0.01?

