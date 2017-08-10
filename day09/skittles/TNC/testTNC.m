clear;
load AB.mat
load D.mat;
xtarget=-.6;ytarget=.6;
grain = 1801;
angle =    linspace(0, 180, grain); % units = degrees
velocity = linspace(-800, 0, grain); % units = degrees/sec
[X,Y]=meshgrid(angle,velocity);
d = D';
X = X(1:grain,1:grain);
Y = Y(1:grain,1:grain);
h=figure;

pcolor(X,Y,d*100) %in centimeters
shading interp

xlabel('Angle (deg)')
ylabel('Velocity (deg/s)')

R=linspace(1,0,256).^2;
G=linspace(1,0,256).^5;
B=linspace(1,0,256).^7;
CLUT=[R' G' B'];

colormap(CLUT)
colorbar

AVD = Data{2,1}(:,2:4);

[Actual, Ideal, Cost] = toleranceCost(0,AVD,D);
Cost
figure(h);axis ij;
hold on
plot(Actual(:,1),Actual(:,2),'ok','markerfacecolor','k');hold on;
plot(Ideal(:,1),Ideal(:,2),'or')
%%

[Actual, Ideal, Cost] = noiseCost(0,AVD,xtarget,ytarget);
Cost
figure(h)
hold on
plot(Ideal(:,1),Ideal(:,2),'og')

[Actual, Ideal, Cost] = covariationCost(0,AVD,xtarget,ytarget);
Cost
figure(h)
hold on
plot(Ideal(:,1),Ideal(:,2),'ob')