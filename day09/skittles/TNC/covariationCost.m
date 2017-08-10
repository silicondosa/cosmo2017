function [M1 M C] = covariationCost(VXY, AVD, xtarget, ytarget)
%
%
% Covariation cost calculation
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
% M1: Original data cloud
% M: Ideal data cloud
% c: C-cost
%

%
%
% Sort trials according to error
% keep M1, the original, for comparison
M1 = sortrows(AVD, 3); 
% M will be modified
M = M1; 
cycles = 0; swaps = 0;

% This WHILE loop will stop IF (cycle>0 && swaps==0)
while cycles == 0 || (cycles > 0 && swaps > 0)
    
    swaps = 0;

    for i = length(M):-1:2
        for j = i-1:-1:1
            if ~VXY,
                % Genarate swapped data points in the polar coordinate
                new1 = execution2result_polar(M(i,1), M(j,2), xtarget, ytarget);
                new2 = execution2result_polar(M(j,1), M(i,2), xtarget, ytarget);
            else
                % Genarate swapped data points in the Cartesian coordinate
                new1 = execution2result_Cartesian(pi./180*M(i,1), pi./180*M(j,2), xtarget, ytarget);
                new2 = execution2result_Cartesian(pi./180*M(j,1), pi./180*M(i,2), xtarget, ytarget);
            end
            % Take the swapped data points if the errors of them are smaller than
            % the errors of the original data points
            if new1 + new2 < M(i,3) + M(j,3)
                temp = M(i,2);
                M(i,2:3) = [M(j,2) new1];
                M(j,2:3) = [temp new2];
                swaps = swaps + 1;
            end
        end
    end

    cycles = cycles + 1;
    M = sortrows(M,3);
end

% C-cost = (Actual Error) - (Ideal Error)
C = mean(M1(:,3)) - mean(M(:,3));