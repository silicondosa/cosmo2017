%% using all SI units define the cart/pole thing
m1=1;
m2=1;
g=9.81
l=0.3


deltaT=0.0001;
duration=20;

%% now lets simulate this
X=[0 pi-pi/16]; %pi=up, 0/2pi=down
dotX=[0 0];
F=0;
for i=1:duration/deltaT
    dotdotX=cartPoleDynamics( X, dotX,m1,m2,g,F,l)';
    dotX=dotX+deltaT*dotdotX;
    X=X+deltaT*dotX;
    Xstore(:,i)=X;
end
plot(Xstore')    

% now lets score this. I want it up. So <- cos X> is score, higher =better
score=-mean(cos(Xstore(2,:)))
%% Now lets handoptimize this
% now lets simulate this
X=[0 pi-pi/16]; %pi=up, 0/2pi=down
dotX=[0 0];
for i=1:duration/deltaT
    F=2*(X(2)-pi)+0.4*dotX(2);
    Fstore(i)=F;
    dotdotX=cartPoleDynamics( X, dotX,m1,m2,g,F,l)';
    dotX=dotX+deltaT*dotdotX;
    X=X+deltaT*dotX;
    Xstore(:,i)=X;
end
plot(Xstore')    

%now lets score this. I want it up. So <- cos X> is score, higher =better
score=-mean(cos(Xstore(2,:)))-sum(Fstore.^2)
%% Let us optimize this. Because Konrad is lazy
X=[0 pi-pi/16]; %pi=up, 0/2pi=down
dotX=[0 0];
x0=[1 2 0.01];
LB = [-40,-40,-20];
UB = [40,40,20];
options.Display = 'iter';
lossFun = @(x) brutalScore(x,X,dotX,m1,m2,g,l);

options.OutputFcn = @(x, optimValues, state) plotProfile(lossFun,x,LB,UB,64);
%[bestParas, score]=bads(lossFun,x0,LB,UB,[],[],options);
%[bestParas, score]=fminsearchbnd(lossFun,x0,LB,UB,options);
[bestParas, score]=fminsearch(lossFun,x0,options);




