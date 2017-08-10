function [AVD, IdealAVD, N_cost]=noiseCost(VXY, AVD, xtarget, ytarget)
%
%
% Noise cost calculation
% Programmed by the Action Lab (Northeastern University)
% For questions, contact Se-Woong Park (s.park@neu.edu)
%
% Inputs
% VXY: coordinate system (0: polar, 1: Cartesian)
% AVD: N X 3 matrix (N: # of trials, 1st col: angles in degree, 2nd col:
%                    angular velocities in deg/s,3rd: Error)
%                   
% xtarget, ytarget: position of target
%
% Outputs
% AVD: Original data cloud
% IdealAVD: Ideal data cloud
% N_cost: N-cost
%
%

%
% number of trials
R = size(AVD,1);                        

% number of shrink steps
ShrinkStep = linspace(1,0,501);

% a matrix of distance error (trial X Shrink step)
Dist = zeros(R, length(ShrinkStep));


% set the center of shrinking at the MEDIAN
xm = median(AVD(:,1));
ym = median(AVD(:,2));

% set the center of shrinking at the MEAN
% xm = mean(AVD(:,1));
% ym = mean(AVD(:,2));

% number of shrink steps
for StepIn = 1:length(ShrinkStep) 
    %shrink the cloud step by step.
    [ang, velo] = shrinkCloud(xm, ym, AVD(:, 1), AVD(:, 2), ShrinkStep(StepIn));

    % number of trials
    for m = 1:R
        if ~VXY
            % calculate distance at each shrink step (polar coordinate)
            Dist(m, StepIn) = execution2result_polar(ang(m), velo(m), xtarget, ytarget);
            
        else
            % calculate distance at each shrink step (Cartesian coordinate)
            Dist(m, StepIn) = execution2result_Cartesian(pi./180.*ang(m), pi./180.*velo(m), xtarget, ytarget);
        
        end
    end
    
end

MeDist = mean(Dist); %overall score for each StepIn

% get the ideal shrinking result and the index
[IdealMeDist IdealStep] = min(MeDist);

%get the ideal step of shrinking (=first minimum)
IdealStep = IdealStep(1);

% retrieve angle and angular velocity at the ideal step of shrinking
[bestA, bestV] = shrinkCloud(xm, ym, AVD(:, 1), AVD(:, 2), ShrinkStep(IdealStep));
IdealAVD = [bestA, bestV, Dist(:,IdealStep)];

% actual distance(=error)
ActualDist = mean(AVD(:,3));

% N-cost = (ideal error) - (actual error)
N_cost = ActualDist - IdealMeDist;