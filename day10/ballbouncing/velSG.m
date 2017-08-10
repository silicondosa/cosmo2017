function [Xoriginal_smooth, FDerivative] = velSG(Xoriginal,Fsam)
% Savitzky-Golay filtering
% programmed by Tjeerd Dijkstra
% modified by Se-Woong Park
% input
% 1. Xoriginal: a vector to be filtered.
% 2. Fsam: sampling frequency.
% output
% 1. Xoriginal_smooth: smoothed vector
% 2. FDerivative: first derivative of the original vector
%
% adjust parameters (polynomial order and window length)
% for the best results.
%
% example:
% ParSavGol.SGorder = 2; 
% ParSavGol.SGwinlen = 7;

ParSavGol.SGorder = 2; 
ParSavGol.SGwinlen = 15;

Ndata = length(Xoriginal);

% instantaneous frequency by Savitzky-Golay filtering
SGorder = ParSavGol.SGorder;			% order of polynomial fit
SGwinlen = ParSavGol.SGwinlen;			% window length
[b_sg, g_sg] = sgolay(SGorder, SGwinlen);

Xoriginal_smooth = ones(size(Xoriginal));
vel = ones(size(Xoriginal));


HalfWin  = (SGwinlen+1)/2 - 1; 
SGIndex = (SGwinlen+1)/2:Ndata-(SGwinlen+1)/2;
for i_sam = SGIndex,
    Xoriginal_smooth(i_sam) = dot(g_sg(:, 1), Xoriginal(i_sam - HalfWin: i_sam + HalfWin));

    vel(i_sam) = dot(g_sg(:, 2), Xoriginal(i_sam - HalfWin: i_sam + HalfWin));
end
%FDerivative(SGIndex) = (vel(SGIndex)*Fsam);
FDerivative = (vel*Fsam);