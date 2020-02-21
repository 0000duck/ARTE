% Datos:
% Misil bal�stico: 20.000km/h
% Antimisiles: -> ICBM: >5.500km               15.000km/h
%              -> IRBM: 3.000-5.500 km       Jericho 2
%                                            Apogeo: 300 km
%                                            Empuje en despegue: 610 kN
%                                            Masa total: 22.000 kg
%                                            Alcance m�ximo: 1450 km
%              -> SRBM: 
%�ngulos del misil objetivo
beta = atan2(my,mx);
gamma= atan2((mz-2.100017631),mx);

%Posici�n del efector final para apuntar al misil objetivo
Px=7.5*cos(beta);
Py=7.5*sin(beta);
Pz=7.5*sin(gamma)+2.100017631;

%Posici�n en la matriz T del efecto final para apuntar
T(1,4)=Px;
T(2,4)=Py;
T(3,4)=Pz;

robot.inversekinematic_fn = 'inversekinematic_anti_misiles(robot, T)';
qinv=inversekinematic(robot,T)
drawrobot3d(robot,qinv)


