
%   INVERSE KINEMATICS FOR KUKA LBR IIWA ROBOT
%
%   Solves the inverse kinematic problem in position/orientation.
%   A Jacobian based method is used.
%   The method tries to reach the given position/orientation while,
%   
%   q0: starting initial solution
%   Tf--> final position/orientation wanted, expressed 
% as a homogeneous matrix
function q = inversekinematics_kuka_lbr_iiwa(robot, Tf, q0)
% Obtain thea matriz de posici�n/orientaci�n en Quaternion representation
Qf = T2quaternion(Tf);
Pf = Tf(1:3,4);
q=q0;
step_time = 0.01 ;%robot.parameters.step_time;
stop_iterations = 1500;
qs = [];
i=0;
%this is a gradient descent solution based on moore-penrose inverse
while i < stop_iterations
    fprintf('\nIteration number: %d', i)
    % current position/orientation
    Ti = directkinematic(robot, q);
    % Convert Ti to a quaternion
    Qi = T2quaternion(Ti);
    Pi = Ti(1:3,4);
   
    %compute linear speed and angular speed to reach Tf
    v0 = compute_high_level_action_kinematic_v(Pf, Pi); %1m/s 
    w0 = compute_high_level_action_kinematic_w(Qf, Qi); %1rad/s
    Vref = [v0' w0']'
    
    
    % La cinematica directa: Vref = J*qd
    % La cinematica inversa qd = pinv(J)*qd, donde pinv es la pseudoinversa
    % Moore penrose.
    
    % tu algoritmo debe:
    %a) calcular qd
    %b) integrar qd
    %c) decidir cuando terminar
    %d) animar todos las q por las que ha pasado usando animate(robot, qs)
    
    % if |Vref|=0 --> we have reached our destination
    if norm(Vref) < 0.001
        fprintf('INVERSE KINEMATICS SUCCESS: REACHED epsilonXYZ AND epsilonQ\n')
        drawrobot3d(robot, q)
        animate(robot, qs)
        return;
    end
    % compute inverse Moore-Penrose Jacobian
    J = manipulator_jacobian(robot, q);
    qd = pinv(J)*Vref;
    manip = det(J*J')
    % actually move the robot.
    q = q + qd*step_time;
    q = atan2(sin(q), cos(q));
    qs = [qs q];
    % uncomment to observe evolution of the algorithm
    i=i+1;
end
fprintf('INVERSE KINEMATICS FAILED: COULD NOT REACH POSITION/ORIENTATION\n')

q = atan2(sin(q), cos(q));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%En base a la posici�n y orientaci�n final, calcular cu�les deben ser las
%velocidades...
% Esto es diferente a calcular la velocidades cuando ya hay contacto y se
% trata de un problema de control... pero es parecido
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [v] = compute_high_level_action_kinematic_v(Pf, Pi)
% compute a constant linear speed till target
v = (Pf-Pi);
v = v(:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%En base a la posici�n y orientaci�n final, calcular cu�les deben ser las
%velocidades...
% Esto es diferente a calcular la velocidades cuando ya hay contacto y se
% trata de un problema de control... pero es parecido
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [w] = compute_high_level_action_kinematic_w(Qf, Qi)
% compute a constant angular speed till target
% asume the movement is performed in 1 second
w = angular_w_between_quaternions(Qi, Qf, 1);
w = w(:);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute angular speed w that moves Q0 into Q1 in time total_time.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function w = angular_w_between_quaternions(Q0, Q1, total_time)
%below this number, the axis is considered as [1 0 0]
%this is to avoid numerical errors
%this is the actual error allowed for w
epsilon_len = 0.001;
%Let's first find quaternion q so q*q0=q1 it is q=q1/q0 
%For unit length quaternions, you can use q=q1*Conj(q0)
Q = qprod(Q1, qconj(Q0));

%To find rotation velocity that turns by q during time Dt you need to 
%convert quaternion to axis angle using something like this:
len=sqrt(Q(2)^2 + Q(3)^2 + Q(4)^2);

if len > epsilon_len
    angle=2*atan2(len, Q(1));
    axis=[Q(2) Q(3) Q(4)]./len;
else
    angle=0;
    axis=[1 0 0];
end
w=axis*angle/total_time;



