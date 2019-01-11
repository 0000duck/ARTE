%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PARAMETERS Returns a data structure containing the parameters of the
%   TX40.
%
%   Author: ABRAHAM SANTOS TORRIJOS
%           JOSE JOAQUIN ESCLAPEZ SEMPERE. Universidad Miguel Hern�ndez de Elche. 
%   email: arturo.gil@umh.es date:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
% Copyright (C) 2012, by Arturo Gil Aparicio
%
% This file is part of ARTE (A Robotics Toolbox for Education).
% 
% ARTE is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% ARTE is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with ARTE.  If not, see <http://www.gnu.org/licenses/>.
function robot = parameters()

robot.name= 'TX40';

%Path where everything is stored for this robot
robot.path = 'robots/staubli/TX40';

robot.DH.theta= '[q(1) q(2)-pi/2 q(3)+pi/2 q(4) q(5) q(6)]';
robot.DH.d='[0.32 0.035 0 0.225 0 0.065]';
robot.DH.a='[0 0.225 0 0 0 0]';
robot.DH.alpha= '[-pi/2 0 pi/2 -pi/2 pi/2 0]';
robot.J='compute_manipulator_jacobian(robot, q)';


robot.inversekinematic_fn = 'inversekinematic_tx40(robot, T)';

%number of degrees of freedom
robot.DOF = 6;

%rotational: 0, translational: 1
robot.kind=['R' 'R' 'R' 'R' 'R' 'R'];

%minimum and maximum rotation angle in rad
robot.maxangle =[deg2rad(-180) deg2rad(180); %Axis 1, minimum, maximum
                deg2rad(-125) deg2rad(125); %Axis 2, minimum, maximum
                deg2rad(-138) deg2rad(138); %Axis 3
                deg2rad(-270) deg2rad(270); %Axis 4: Unlimited (400� default)
                deg2rad(-120) deg2rad(133.5); %Axis 5
                deg2rad(-270) deg2rad(270)]; %Axis 6: Unlimited (800� default)

%maximum absolute speed of each joint rad/s or m/s
robot.velmax = [deg2rad(555); %Axis 1, rad/s
                deg2rad(475); %Axis 2, rad/s
                deg2rad(585); %Axis 3, rad/s
                deg2rad(1035); %Axis 4, rad/s
                deg2rad(1135); %Axis 5, rad/s
                deg2rad(1575)];%Axis 6, rad/s
            
            robot.accelmax=robot.velmax/0.1; % 0.1 is here an acceleration time
            
% end effectors maximum velocity
robot.linear_velmax = 1.0; %m/s

%base reference system
robot.T0 = eye(4);

%INITIALIZATION OF VARIABLES REQUIRED FOR THE SIMULATION
%position, velocity and acceleration
robot=init_sim_variables(robot);

% GRAPHICS
robot.graphical.has_graphics=1;
robot.graphical.color = [250 20 40]./255;
%for transparency
robot.graphical.draw_transparent=1;
%draw DH systems
robot.graphical.draw_axes=1;
%DH system length and Font size, standard is 1/10. Select 2/20, 3/30 for
%bigger robots
robot.graphical.axes_scale=1;
%adjust for a default view of the robot
robot.axis=[-1.5 1.5 -1.5 1.5 0 3.2];
%read graphics files
robot = read_graphics(robot);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%DYNAMIC PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
robot.has_dynamics=1;

%link masses (kg)
%porcentajes de los eslabones:
% 1. 40% --> 10.8 kg
% 2. 20% --> 5.4 kg
% 3. 15% --> 4.05 kg
% 4. 12% --> 3.24 kg
% 5. 8% ---> 2.16 kg
% 6. 5% ---> 1.35 kg
% Total = 100% --> 27 kg
robot.dynamics.masses=[10.8 5.4 4.05 3.24 2.16 1.36];

%consider friction in the computations
robot.dynamics.friction=0;


%COM of each link with respect to own reference system
robot.dynamics.r_com=[0 0 0.15; %(rx, ry, rz) link 1
                      0 0 0.2; %(rx, ry, rz) link 2
                      0 0 0;  %(rx, ry, rz) link 3
                      0 0 0.05;%(rx, ry, rz) link 4
                      0 0.05 0;%(rx, ry, rz) link 5
                      0 0 0.03];%(rx, ry, rz) link 6

%Inertia matrices of each link with respect to its D-H reference system.
% Ixx	Iyy	Izz	Ixy	Iyz	Ixz, for each row
robot.dynamics.Inertia=[1.158 -0.031 -0.224 1.42 -0.038 1.469;
                        7.277 0 0 7.641 0.011 0.671;
                        0.344 0.007 -0.007 0.292 -0.001 0.329;
                        0.14 0.14 0.14 0.14 0.14 0.14;
                        0.1 0.1 0.1 0.1 0.1 0.1;
                        0.03 0.03 0.03 0.03 0.03 0.03];

robot.motors=load_motors([5 5 5 5 5 5]);
%Speed reductor at each joint
robot.motors.G=[265 190 20 70 37 14];