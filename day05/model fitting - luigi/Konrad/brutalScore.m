function score = brutalScore(paras, X, dotX,m1,m2,g,l)
%% now lets simulate this
deltaT=0.01; %crappy simulation. Who cares. Sue me.
duration=2;

for i=1:duration/deltaT
    F=-paras(1)*(X(2)-pi)-paras(2)*dotX(2)-paras(3)*(X(2)-pi).^3; 
    Fstore(i)=F;
    %first term wants to be right, second wants to take out speed
    dotdotX=cartPoleDynamics( X, dotX,m1,m2,g,F,l)';
    dotX=dotX+deltaT*dotdotX;
    X=X+deltaT*dotX;
    Xstore(:,i)=X;
    if abs(X(2))>50
        paras
    end
end
%plot(Xstore') 
%hold on
%drawnow

% now lets score this. I want it up. So <- cos X> is score, higher =better
score=-mean(cos(Xstore(2,:)))-0.000000001*sum(Fstore.^2);
%but fminsearch says smaller=better
score=-score;

end

