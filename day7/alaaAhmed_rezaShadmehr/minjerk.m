function[tme,r,v,a]=minjerk(ro,rf,tm,dt)
% MINJERK Usage: minjerk(ro,rf,tm,dt) ro,rf are (x,y)
% initial and final positions
% tm is the movement time dt is time increment.
% Returns (x,y) positions through trajectory in r,
% velocities in v, acceleration in a 
% and time in tme


tme=[0:dt:tm];
ts=tme/tm;
xo=ro(1,1);
yo=ro(1,2);
xf=rf(1,1);
yf=rf(1,2);

t2=ts.*ts;
t3=t2.*ts;
t4=t3.*ts;
t5=t4.*ts;


r=ones(size(ts'))*ro+(15*t4-6*t5-10*t3)'*(ro-rf);
v=((60*t3-30*t4-30*t2)/tm)'*(ro-rf);
a=((180*t2-120*t3-60*ts)/(tm*tm))'*(ro-rf);
tme=tme';






