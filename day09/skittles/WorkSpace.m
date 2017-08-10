function WorkSpace (xtarget,ytarget,angle,velocity,parameter,Post)

% xtarget: x-position of target, between (-1,1)
% ytarget: y-position of target, between (-1,1)
% angle: release angle, between (-180, 180)
% velocity: release velocity, between (-800, 800)
% parameter (optional): physical system parmeter, [m,k,c], mass, spring constant, damping rate
% Post: post position, post(1) between (-0.75,0.75),post(2) between (-0.75,0.75), not overlap with xtarget and ytarget

switch nargin
    case 4
        parameter=[0.1,1,0.01];
        Post=[0,0];
    case 5
        Post=[0,0];
end
 
[D,~,xtime,ytime]=MinDist(angle,velocity,xtarget,ytarget,Post,parameter); 
               
figure;hold on;

plot(xtime,ytime,'k','LineWidth',3);
if abs(D)<=0.011
rectangle('Position',[xtarget-.05,ytarget-.05,.05*2,.05*2],'Curvature',[1 1],'FaceColor',[0 1 0]);hold on;
else

rectangle('Position',[xtarget-.05,ytarget-.05,.05*2,.05*2],'Curvature',[1 1],'FaceColor',[1 1 0]);hold on;
end
rectangle('Position',[-.25+Post(1) -.25+Post(2) .5 .5],'Curvature',[1 1],'FaceColor',[1 0 0]);hold on;




line('XData', [0 .4*-cosd(angle)],'YData', [-1.5 -1.5+.4*sind(angle)],'LineWidth', 3,'Color',[1 0 1]); hold on;
rectangle('Position',[0-.02,-1.5-.02,.01*2,.02*2],'Curvature',[1,1],'FaceColor',[1 1 1]);hold on;

axis equal;xlim([-1.5 1.5]);ylim([-2 2])
end

function [mindist,hitPost,xtime,ytime] = MinDist(a,v,xtarget,ytarget,Post,parameter)
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
        xtime=xtime(1:find(xydistCP<rc,1));
        ytime=ytime(1:find(xydistCP<rc,1));
    else
        mindistTime = find(xydist == min(xydist));
        mindistPoint=[xtime(mindistTime),ytime(mindistTime)];
        mindist = xydist(mindistTime);
    end
end









