function [mindist] = execution2result_Cartesian(vx,vy,xtarget,ytarget)
% function [mindist] = execution2result_Cartesian(vx,vy,xtarget,ytarget)
%
% This function calculates the trajectory for a given release angle(a) and
% release velocity(v) for the skittles task; it then calculates the minimun
% distance from target for that trajectory, and returns this value. 
% For post hits, it returns "1".
% 
% Please note that the definition of this particular coordinate system
% was described in Cohen & Sternad (2009) Variability in motor learning:
% relocating, channeling and reducing noise. Exp Brain Res 193:69?83.
%
% Input: vx (x-component of release velocity)
%        vy (y-component of release velocity)
%        xtarget (x-axis of the target)
%        ytarget (y-axis of the target)
%        unit of vx: rad/s, unit of vy: rad/s (Be careful!)
% Output: mindist (minimum distance error, i.e., the result variable)

%parameters:
m=0.1; %mass
k=1; %spring constant
c=0.01;   %viscus damping
T=(2*m/c);    %relaxation time
w=sqrt(abs((k/m)-((1/T)^2))); %frequency
x0=0;   %rest positon of pendulum
y0=0;
rc=0.25; %radius of center post
xp0=0;   %rotation point of paddle
yp0=-1.5;
l=0.4; %length of arm
rb=0.05; %radius of ball
rt=0.05; %radius of target

%find release coordinates (xr,yr)

vx=-vx;
a=atan2(vx,vy); %watch the order

xr=xp0-l*cos(a);
yr=yp0+l*sin(a);

%find release velocity components <vxo, vyo>
%release velocity positive when clockwise; negative when count. clockwise

vx0=vx*l;
vy0=vy*l;

%find mechanical energy at release in x and y directions (Ex, Ey)

%Ex=(m*vx0^2+k*xr^2)/2;  %not needed for now
%Ey=(m*vy0^2+k*yr^2)/2;  %not needed for now

%find amplitude in x and y directions (Ax, Ay)

Ax=sqrt((xr)^2+((vx0/w)+(xr/T)/w)^2);
Ay=sqrt((yr)^2+((vy0/w)+(yr/T)/w)^2);

%find phase in x and y directions (phasex, phasey)

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

% create time vector
%time=linspace(0,2,300);
time = linspace(0,2,201);
% equations of motion
xtime=Ax.*sin(w.*time+phasex).*exp(-time/T);
ytime=Ay.*sin(w.*time+phasey).*exp(-time/T);
xydistCP = sqrt(xtime.^2+ytime.^2);
xydist = sqrt((xtime-xtarget).^2+(ytime-ytarget).^2);

% if there is at least one data point that distance is less than rc,
% "hit center post"

%TempV = find(xydistCP<rc);
if ~isempty(find(xydistCP<rc)),
    mindist = 1;
else
    mindistTime = find(xydist == min(xydist));
    mindist = xydist(mindistTime);


    %minRange = find(xydist == min(xydist));
    clear time xtime ytime xydist xydistCP
    time = linspace((mindistTime-2)./100,(mindistTime+2)./100,200);

    xtime=Ax.*sin(w.*time+phasex).*exp(-time/T);
    ytime=Ay.*sin(w.*time+phasey).*exp(-time/T);
    xydist = sqrt((xtime-xtarget).^2+(ytime-ytarget).^2);
    xydistCP = sqrt(xtime.^2+ytime.^2);

    %TempV = find(xydistCP<rc);
    
    mindistTime = find(xydist == min(xydist));
    mindist = xydist(mindistTime);


    if ~isempty(find(xydistCP<rc)),
        mindist = 1;
    end

end