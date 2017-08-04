function [ nLL ] = DriftingTuning_nLL(params, spikes, angle, time, tuningFun)
%TUNING_NLL Negative log likelihood function for arbitrary tuning curve.

b0 = params(1);
b1 = params(2);
theta0 = cumsum(params(3:end));

% Single theta, equal to no drift
if isscalar(theta0); theta0 = [theta0,0]; end

npivots = numel(theta0);
tpivots = linspace(time(1), time(end), npivots);

params_list = zeros(numel(spikes), 3);

params_list(:,1) = b0;
params_list(:,2) = b1;
params_list(:,3) = interp1(tpivots, theta0, time, 'pchip');

% Compute tuning curve
predictedF = tuningFun(params_list, angle(:));
    
% Compute Poisson probability for each data point
logP = spikes(:) .* log(predictedF) - predictedF - gammaln(spikes(:) + 1);

% Return summed negative log likelihood
nLL = -sum(logP);

%--------------------------------------------------------------------------
% Only for plotting
debug_plot = 1;

if debug_plot
    hold off;
    plot(time, mod(params_list(:,3), 2*pi), 'k', 'LineWidth', 1);
    hold on;
    for i = 1:npivots
        plot(tpivots(i)*[1 1], [0 2*pi], 'k:', 'LineWidth', 0.5);
    end
    plot(tpivots,mod(theta0,2*pi),'ko','MarkerFaceColor','k');
    ylim([0 2*pi]);
    xlabel('Time (s)');
    ylabel('Preferred direction (radians)');
    set(gca,'TickDir','out'); box off; set(gcf,'Color','w');
    drawnow;
end
%--------------------------------------------------------------------------

end
