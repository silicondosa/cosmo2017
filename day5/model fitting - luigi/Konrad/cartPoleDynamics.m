function dotdotX  = cartPoleDynamics( X, dotX,m1,m2,g,F,l)
%function cartPoleDynamics( X, dotX,m1,m2,g,F,l) 
%calculates the second derivative of the state changes as a function of state and its change over
%time

%check out the following for derivation: http://www.matthewpeterkelly.com/tutorials/cartPole/cartPoleEqns.pdf
v=[-g*sin(X(2)) F+m2*l*dotX(2)^2*sin(X(2))]';
M=[cos(X(2)) l;m1+m2 m2*l*cos(X(2))];
dotdotX=pinv(M)*v;



end

