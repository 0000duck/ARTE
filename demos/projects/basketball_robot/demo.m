%{
COMPONENTES DEL GRUPO:
- Mario P�rez Checa
- Jaime Sempere Ruiz
- Carlos Pina L�pez
%}


%%%% Pasos previos a la ejecuci�n de la demo:

   %% Introducir el valor deseado de xr (distancia de la base del robot a
    % la canasta, 4 metros por defecto) en la l�nea 70 del parameters.m
    % adjunto en la carpeta, sustituir dicho archivo por el parameters.m
    % del 3dofplanar de la librer�a ARTE (Es necesario sustituir, ya que
    % si �nicamente se adjunta a la carpeta con otro nombre y se ejecuta no funciona.
    
   %% Cargar el robot 3dofplanar con el parameters.m modificado y elegir
    % los par�metros iniciales de la simulaci�n: xr, teta, teta0 y wmax
    
   %% Ejecutar demo.m
robot = load_robot('example', '3dofplanar');
Proyecto
representacion