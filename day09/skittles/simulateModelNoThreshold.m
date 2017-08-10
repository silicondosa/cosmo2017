function [e, a, x] = simulateModelNoThreshold(threshold,variance, B, Bamp)
    r = randn(2639,1);
    a(1)=sqrt(variance);
    x(1) = 83;
    xT = 82.44;
    
    for t = 1:2639
        e(t) = x(t)-xT; 
        if (abs(e(t)) > threshold(t))
            I = 0;
        else
            I = 1;
        end
        x(t+1) = x(t)-B*e(t)+a(t)*r(t);
        a(t+1) = (1-(1-I)*Bamp)*a(t);
    end
    x(t+1) = x(t)-B*e(t)+a(t)*r(t);
    e(t+1) = x(t)-xT; 
end