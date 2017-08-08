function retVal = evaluateJ(alpha, b, m, d, gamma, t)
    retVal = (alpha - (b*m*d)./t)./(1+(gamma.*t));
end