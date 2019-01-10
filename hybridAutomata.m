% This code looks at a hybrid automata where switching may leads to unstable
% behaviour

%% System characteristics
epsilon = 0.1;
% Two LTI systems dxdt = A1*x and dxdt = A2*x
A1 = [-epsilon 1;
        -2  -epsilon];
A2 = [-epsilon 2;
        -1  -epsilon];

f1 = @(t,x)(A1*x); % dxdt = f1
f2 = @(t,x)(A2*x); % dxdt = f2

%% Solver for the systems (Backward Difference)
% One step solver
dt = 0.001; % Time step
y1 = @(x)(inv(eye(2)-A1*dt)*x); % outputs the next step state for system 1
y2 = @(x)(inv(eye(2)-A2*dt)*x); % outputs the next step state for system 2
y = @(x)([y1(x) y2(x)]); % Combine the outputs

%% Solving the Hybrid Automata (Algorithm 1)
% Unstable Hybrid
% Less robust to error in state

N = 10000; % Number of iterations
x0 = -1 + 2.*rand(2,1); % Initial condition (chosen randomly)
x = x0;
X = [x]; % Storing the states in a fat matrix
n = randi(2); % The system's equations that initially are obeyed. (Chosen randomly)
Y = y(x);
for i = 1:N
    Y = y(x);
    x = Y(:,n);
    X = [X x];
    % Switching Algorithm for Unstable system
    if abs(x(1))<1e-2 % A metric to measure how close to zero the state is
        n = 2;
    elseif abs(x(2))<1e-2
        n = 1;
    else 
        n = n;
    end
end

%%
% |Comments: The algorithm is not robust because if we wanted to simulate 
% the stable hybrid system, then as as our trajectory contracts our metric
% (e.g. 1e-2) will fail to capture the switching as we would have our 
% states themselves - a order of magnitude (say) 1e-5. 
% Thus, the system will just obey one of the dynamics rather than switching.|

%%
% (!) Wrong approach but helpful for thinking
% |A possible solution: You can keep track of two step ahead trajectories. 
% Like Y = y(x) ,Yplus = y(Y), Yplus = Yplus(:,[1 4]) and now consider 
% Ydiff = Yplus-Y, Now just check if the x1 component has negative sign 
% or if x2 has negative sign. Thus, we can easily check if the trajectory 
% has crossed any of the axes.
% *It would be easier to compare Y directly to [x x], in this case a new computation is saved.|
% Just considering differences is wrong, we need to include zero 
% e.g. x(1) < 0  < y(1)
% 
% (!!) Correct Method
% we need to see products of quantities to see if anything has crossed zero


%% Solving the Hybrid Automata (Algorithm 2)
% Unstable hybrid
% More robust to error in state

N = 10000; % Number of iterations
x0 = -1 + 2.*rand(2,1); % Initial condition (chosen randomly)
x = x0;
X = [x]; % Storing the states in a fat matrix
n = randi(2); % The system's equations that initially are obeyed. (Chosen randomly)

for i = 1:N
    Y = y(x);
    prod = Y.*[x x];
    x = Y(:,n);
    X = [X x];
    % Switching Algorithm for Unstable system
    if prod(1,n) < 0 % A metric to measure if states have crossed zero
        n = 2; % Represents the dynamics followed in the loop
    elseif prod(2,n)<0
        n = 1;
    else 
        n = n;
    end
end

%% Solving the Hybrid Automata (Algorithm 3)
% Stable Hybrid

N = 10000; % Number of iterations
x0 = -1 + 2.*rand(2,1); % Initial condition (chosen randomly)
x = x0;
X = [x]; % Storing the states in a fat matrix
n = randi(2); % The system's equations that initially are obeyed. (Chosen randomly)

for i = 1:N
    Y = y(x);
    prod = Y.*[x x];
    x = Y(:,n);
    X = [X x];
    % Switching Algorithm for Unstable system
    if prod(1,n) < 0 % A metric to measure if states have crossed zero
        n = 1; % Represents the dynamics followed in the current for loop
    elseif prod(2,n)<0
        n = 2;
    else 
        n = n;
    end
end

%% Plotting the trajectory
close all
plot(X(1,:),X(2,:))
hold on
plot(x0(1),x0(2),'r*','LineWidth',1.4)
plot(x(1),x(2),'b*','LineWidth',1.4)
legend('Trajectory','Start point','End point')
