%%load data
load stevensonV2
%% Remove all times where speeds are very slow
isGood=find(handVel(1,:).^2+handVel(2,:).^2>.015)
handVel=handVel(1:2,isGood);
handPos=handPos(1:2,isGood);
spikes=spikes(:,isGood);
time=time(isGood);
angle=atan2(handVel(1,:),handVel(2,:));
sumFR = 0;
TCspikes = [];
%% Plot Raw Data - PASCAL? %%
nNeuron=193%193
clf
hold on % plotted points will stay on the screen
plot(angle,spikes(nNeuron,:)+0.2*randn(size(spikes(nNeuron,:))),'r.')
%% Now plot a tuning curve
angles=-pi:pi/8:pi;
for i=1:length(angles)-1
% calculate the average firing rate for when the angle is withing the
% corresponding angles bin
    TCspikes = [TCspikes mean(spikes(nNeuron, find(angle >= angles(i) & angle <angles(i+1))))];
end
%make sure to plot the results
plot(angles(1:end-1), TCspikes);