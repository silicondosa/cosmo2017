%% Time
clear all;
close;
TEnd = 1000;
t = 1:1:TEnd;
T = [175 13];
%% Construct impulse input
delT = 1;
impulseShift = 100;
impulseIn = zeros(size(t));
impulseIn(1+impulseShift :delT+impulseShift ) = 1/delT;


%% Construct step input
delT = 1;
impulseShift = 100;
stepIn = zeros(size(t));
stepIn(1+impulseShift :end ) = 1;

%% Instantiation
x = zeros(size(t));
dx = zeros(size(t));
y = zeros(size(t));
dy = zeros(size(t));

%% Construct a resettable integrator


%% Construct PI control
in2 = zeros(size(t));
I_in2 = zeros(size(t));
in2(1)  = T(1)*impulseIn(1);
for i = 2:(length(t))
    I_in2(i) = I_in2(i-1) + impulseIn(i);
    in2(i)  = T(1)*impulseIn(i) + I_in2(i);
end
plot(t, I_in2)

%% Construct stage 1
for i = 1:(length(t)-1)
    x(i+1)  = dx(i) + x(i);
    dx(i+1) = (-x(i) + impulseIn(i))/T(1);
end
subplot(2,1,1);
hold on
plot(t,impulseIn/1000.0);
plot(t,x)
plot(t,dx)
legend("Stage 1 input", "stage 1 position", "stage 1 velocity");
%% Construct stage 2
for i = 1:(length(t)-1)
    y(i+1)  = dy(i) + y(i);
    dy(i+1) = (-y(i) + x(i))/T(2);
end
subplot(2,1,2);
hold on
plot(t,impulseIn/1000.0);
plot(t,x)
plot(t,y)
plot(t,dy)
legend("Impulse Input", "Stage 2 input", "stage 2 position (impulse response)", "stage 2 velocity");

