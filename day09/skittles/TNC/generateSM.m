% generateSM.m
% script to genarate the solution manifold as a matrix

% Rajal Cohen, Action Lab, Kinesiology Dept,Pennsylvania State University
% (now in Psychology, University of Idaho)
% Modified by Se-Woong Park, Northeastern University
% function to compute and save the solution manifold for a given target
% calls execution2result_polar

% xtarget = .05; ytarget = 1.055;
xtarget =- .6; ytarget = .6;
% xtarget = .05; ytarget = 1.058 % xiaogang's target locations, for comparison
%ball = .05; target = .05; post = .25;

grain = 1801;

% 1 if you already have the SM
already_computed = 0;

% solution manifold if you already have
% fileName = 'SM.mat';
 
% Create vectors of angles and velocities in upper left quadrant
%angle =    linspace(-180, -0, grain); % units = degrees
angle =    linspace(0, 180, grain); % units = degrees
%velocity = linspace(-800, -200, grain); % units = degrees/sec
velocity = linspace(-800, 0, grain); % units = degrees/sec

%angle =    linspace(0, 800, grain); % units = degrees
%velocity = linspace(-800, 800, grain); % units = degrees/sec

%creates 2 matrices of size(angle)x size(velocity)
[X,Y]=meshgrid(angle,velocity);

if already_computed == 0
    disp('calculating distances')
    D = zeros(grain);
    for ang=1:grain %loop through many possible angles and velocities and test each
        % show progress 
        if rem(ang,60) == 0
            disp(strcat('angle=',num2str(ang)));
        end
        % calculate the solution manifold
        for vel=1:grain
            % D is the solution manifold
            D(ang, vel)=execution2result_polar(angle(ang),velocity(vel),xtarget,ytarget);
        end
    end
    %toc % end calculating distance
    

        
else % manifold is already computed and just needs to be plotted

    load(fileName);
 
end
% the matrix is transposed for a visualization purpose
d = D';
% shrink X and Y to account for smoothing
X = X(1:grain,1:grain);
Y = Y(1:grain,1:grain);

figure

%plot using a function 'pcolor'
pcolor(X,Y,d*100) %in centimeters
shading interp

xlabel('Angle (deg)')
ylabel('Velocity (deg/s)')

% create the colormap here
R=linspace(1,0,256).^2;
G=linspace(1,0,256).^5;
B=linspace(1,0,256).^7;
CLUT=[R' G' B'];

colormap(CLUT)
colorbar
