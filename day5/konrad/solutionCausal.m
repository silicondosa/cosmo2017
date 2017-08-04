        drawnow
        %I can has p(causal)
        C=1; %turns out this has effectively the same effect as third para
        pCommon=exp(-(muV).^2/(2*sigmaV^2))./(exp(-(muV).^2/(2*sigmaV^2))+C);   
        
        %combine
        posterior=pCommon*(pV.*pP)/sum(pV.*pP)+(1-pCommon)*pP;
