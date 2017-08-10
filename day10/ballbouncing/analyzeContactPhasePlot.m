

clear; clc; close all;
% sampling freq = 300;
% Load competition data
load('sampleBBData.mat');
    
for trial = 1
    
    % interpolate time sequence as time stamps are uneven
    tSeq{trial} = linspace(0,data{trial}.time(end), length(data{trial}.time));
    Rac{trial} = interp1(data{trial}.time,data{trial}.racket,tSeq{trial},'linear');
    Ball{trial} = interp1(data{trial}.time,data{trial}.ball,tSeq{trial},'linear');
    
    Fsam = length(data{trial}.time)./data{trial}.time(end);
    
    % differentiation using a smoothing filter
    [~,Vel{trial}] = velSG(Rac{trial},Fsam);
    [~,Acc{trial}] = velSG(Vel{trial},Fsam);

    % Plot data for each trial in a separate figure 
    figure(trial)
    hold on;
    plot(tSeq{trial}, Ball{trial}, 'k');
   	plot(tSeq{trial}, Rac{trial}, 'r');
    plot(tSeq{trial}, 0.01*Acc{trial},'g')
    plot(tSeq{trial}, ones(1,length(tSeq{trial})),'b')
    xlim([0.5 39.5])
    xlabel('Time (s)')
    ylabel('Position (m)');
    title(sprintf('Data for Trial %d', trial));
    legend('Ball','Racket','Racket Acc X 0.01','target')
    % Find all racket peaks (One racket cycle is defined as time between two racket peaks)
    [maxRacketHeights, rLocs] = findpeaks(Rac{trial});
    
    % Plot racket peaks
    plot(tSeq{trial}(rLocs), Rac{trial}(rLocs), 'r*');
    
    % Find all ball maximums using find peaks
    [maxBallHeights, bMaxs] = findpeaks(Ball{trial});
    
    % Find all ball minimums using find peaks (Ball-racket contacts occur at ball minimums)
    [minBallHeights, bLocs] = findpeaks(-Ball{trial});
    
    
    % Plot ball minima
    plot(tSeq{trial}(bLocs), Ball{trial}(bLocs), 'k*');
    
    % For each racket cycle, determine it contains a ball minimum
    % If so, calculate phase of contact for that bounce: 
    % phase = (ballMin-racketPeak(i))/(racketPeak(i+1)-racketPeak(i))
    
    rLocs = rLocs(1,:);
    
    for i=1:length(rLocs)-1
        indexLoc = find(bLocs > rLocs(i) & bLocs < rLocs(i+1), 1);
        if ~isempty(indexLoc)
            phase(i) = (tSeq{trial}(bLocs(indexLoc))-tSeq{trial}(rLocs(i)))/(tSeq{trial}(rLocs(i+1))-tSeq{trial}(rLocs(i)));
            phaseComplex(i) = exp(sqrt(-1)*phase(i)*2*pi);
        else
            phase(i) = inf;
            phaseComplex(i) = inf;
        end
    end
    %phase(find(phase == inf)) = []; 
    phaseComplex(find(phaseComplex == inf)) = []; 
    % Get mean phase for each trial
    %meanPhase(trial) = mean(phase)*100;
    meanPhase(trial) = mean(phaseComplex);
    
    
    figure(trial+10)
    plot(Rac{trial},Vel{trial})
    hold on
    plot(Rac{trial}(bLocs),Vel{trial}(bLocs),'or')
    axis([-0.2 0.2 -1 1])
%     plot(phaseComplex,'o')
%     line([0 0],[-1 1],'color','k','linewidth',2)
%     line([-1 1],[0 0],'color','k','linewidth',2)
%     xlabel('Real');
%     ylabel('Imaginary');
%     title(sprintf('Phase at Contact for Trial %d', trial));
% 
%     axis([-1 1 -1 1])
%     axis square
%     
    % acceletation at contact
    accelAtContact = Acc{trial}(bLocs);
    meanAAC(trial) = mean(accelAtContact);
    
    % unsigned error (=distance from target)
    errorBall = maxBallHeights - 1;
    meanError(trial) = mean(abs(errorBall));
    
end

figure(trial+2)
bar(meanAAC)
title('Mean Acceleration')
ylabel('Acceleration (m/s^2)')
xlabel('Trial')

figure(trial+3)
bar(meanError)
title('Mean Error')
ylabel('Distance from Target (m)')
xlabel('Trial')