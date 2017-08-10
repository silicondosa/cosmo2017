function [x1, y1] = shrinkCloud(xm, ym, x, y, Sindex)
%shinkCloud is used to shink data cloud for a step, which is prepared to
%calculate the Noise part of new TNC calculation.
%the median of the data cloud is set as the center of the cloud.
%Input:
%xm, ym: mean of data cloud, revised by Se-Woong Park
%x, y: original data vector. N*1 respectively.
%Sindex: the shrink amount. Sindex: [0, 1]. when Sindex is larger than 1,
%then it will expand the data cloud.
%Output:
%x1, y1: shrinked data vector. N*1 respectively.
%
%V1.0.0. June 15th, 2007. By X.Hu


%Use fixed mean point as a center of shrinking.
xtemp = x - xm;
ytemp = y - ym;
%transfer to poler coordinates
[theta,ro] = cart2pol(xtemp,ytemp);
%shrink the cloud.
ro1 = ro * Sindex;
%transfer back to cartesian coordiantes
[xtemp2,ytemp2] = pol2cart(theta,ro1);
%get the shrinked data. 
x1 = xtemp2 + xm;
y1 = ytemp2 + ym;
