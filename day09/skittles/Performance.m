
function Performance(sub,block,traj,resolution)

% subnum: subject number, between (1,8)
% block: block number, between (1,4)
% traj:trjactory on/off. 1:on, 0:off.
% resolution (optional): resolution of the figure


switch nargin
    case 1
        grain=61;block=3;traj=0;
    case 2
        grain=61;traj=0;
    case 3
        grain=61;
    case 4
        grain=resolution;
end

xtarget=-.6;ytarget=.6;
R=linspace(1,0,256).^2;
G=linspace(1,0,256).^5;
B=linspace(1,0,256).^7;
CLUT=[R' G' B'];
    

load ([sub,'.mat']);

h=figure;

for day=1:3
    data = Data{day,block}(:,2:4);
    angle =    linspace(20, 160, grain); % units = degrees
    velocity = linspace(-600,0, grain); % units = degrees/sec
    [X,Y]=meshgrid(angle,velocity);   %creates 2 matrices of size(angle)x size(velocity)
    D = zeros(grain);
    for ang=1:grain 
        for vel=1:grain
            [D(ang, vel),hitPost(ang,vel)]=MinDist(angle(ang),velocity(vel),xtarget,ytarget); 
        end
    end
  
    d = abs(D)';
    figure(h);subplot(1,3,day);
    title(['Day ',num2str(day),' Block ',num2str(block),' Subject ',sub]);hold on;
    pcolor(X,Y,d*100);
    axis ij;hold on;   
    shading interp
    xlabel('Release Angle (deg)')
    ylabel('Release Velocity (deg/s)')

    colormap(CLUT);
    colorbar;
if traj==1
    ReleaseIndex=Data{day,block}(:,1);
    load(sprintf([sub,'/',sub,'_%d_%d','.mat'],day,block));
 
Delay=400;
 for trial=1:length(ReleaseIndex)
    if ReleaseIndex(trial)-Delay<=0
        Angle=angle(1:ReleaseIndex(trial)+Delay);
        Velocity=velocity(1:ReleaseIndex(trial)+Delay);
    elseif ReleaseIndex(trial)+Delay>=length(angle)
        Angle=angle(ReleaseIndex(trial)-Delay:end);
        Velocity=velocity(ReleaseIndex(trial)-Delay:end);
    else
        Angle=angle(ReleaseIndex(trial)-Delay:ReleaseIndex(trial)+Delay);
        Velocity=velocity(ReleaseIndex(trial)-Delay:ReleaseIndex(trial)+Delay);
    end
    
    Angle(Angle>=250)=Angle(Angle>=250)-360;
    figure(h);subplot(1,3,day);hold on;
    plot(Angle,Velocity,'b','linewidth',1);hold on;
 end

end
    
     figure(h);subplot(1,3,day);hold on;
     scatter(data(:,1),data(:,2),30,'g','filled','MarkerEdgeColor','k');
     xlim([20,160]);ylim([-600,0]);hold on;

end



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
