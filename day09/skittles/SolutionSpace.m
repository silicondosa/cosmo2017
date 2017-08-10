function SolutionSpace(xtarget,ytarget,parameter,Post,resolution)

% xtarget: x-position of target, between (-1,1)
% ytarget: y-position of target, between (-1,1)
% parameter (optional): physical system parmeter, [m,k,c], mass, spring constant, damping rate
% Post (optional): post position, post(1) between (-0.75,0.75),post(2) between (-0.75,0.75), not overlap with xtarget and ytarget
% resolution (optional): resolution of the figure

switch nargin
    case 2
        grain = 241;
        Post=[0,0];
        parameter=[0.1,1,0.01];
    case 3
        grain = 241;
        Post=[0,0];
    case 4
        grain = 241;
    case 5
        grain=resolution;
end

angle =    linspace(-180, 180, grain); % units = degrees
velocity = linspace(-800, 800, grain); % units = degrees/sec
[X,Y]=meshgrid(angle,velocity);   %creates 2 matrices of size(angle)x size(velocity

disp('Start to create solution space')
        D = zeros(grain);
        for ang=1:grain %loop through many possible angles and velocities and test each
            if rem(ang,60) == 0
                disp(strcat('complete ',num2str(ang/(grain-1)*100),'%'));
            end
            for vel=1:grain
                [D(ang, vel),~] = MinDist(angle(ang),velocity(vel),xtarget,ytarget,Post,parameter);
            end
        end
        
    d=abs(D);
    d = d';
    
    figure;



    pcolor(X,Y,d*100) 
    shading interp


    xlabel('Angle (deg)')
    ylabel('Velocity (deg/s)')



    R=linspace(1,0,256).^2;
    G=linspace(1,0,256).^5;
    B=linspace(1,0,256).^7;
    CLUT=[R' G' B'];

    colormap(CLUT)
    colorbar
end

function [mindist,hitPost] = MinDist(a,v,xtarget,ytarget,Post,parameter)
% both a v are deg
switch nargin
    case 4
    m=0.1; %mass
    k=1; %spring constant
    c=0.01;   %viscus damping
    Post=[0,0];
    case 5
    m=0.1; %mass
    k=1; %spring constant
    c=0.01;   %viscus damping
    case 6
    m=parameter(1);k=parameter(2);c=parameter(3);
end
    

hitPost=0;
T=(2*m/c);    %relaxation time
w=sqrt(abs((k/m)-((1/T)^2))); %frequency
rc=0.25; %radius of center post
xp0=0;   %rotation point of paddle
yp0=-1.5;
l=0.4; %length of arm

a=a*pi/180;
v=v*pi/180;
xr=xp0-l*cos(a);
yr=yp0+l*sin(a);
vx0=(v*l)*sin(a);
vy0=(v*l)*cos(a);
Ax=sqrt((xr)^2+((vx0/w)+(xr/T)/w)^2);
Ay=sqrt((yr)^2+((vy0/w)+(yr/T)/w)^2);
if Ax~=0
    u=(1/Ax)*((vx0/w)+((xr/T)/w));
    phasex=acos(u);
else
    phasex=0;
end

if xr<0
    phasex=-phasex;
end

if Ay~=0
    u=(1/Ay)*((vy0/w)+((yr/T)/w));
    phasey=acos(u);
else
    phasey=0;
end
if yr<0
    phasey=-phasey;

end

time = linspace(0,1.6,1601);
xtime=Ax.*sin(w.*time+phasex).*exp(-time/T);
ytime=Ay.*sin(w.*time+phasey).*exp(-time/T);
xydistCP = sqrt((xtime-Post(1)).^2+(ytime-Post(2)).^2);
xydist = sqrt((xtime-xtarget).^2+(ytime-ytarget).^2);
    if ~isempty(find(xydistCP<rc))
        hitPost=1;
        mindist = 1;
    else
        mindistTime = find(xydist == min(xydist));
        mindistPoint=[xtime(mindistTime),ytime(mindistTime)];
        mindist = xydist(mindistTime);
    end
end

