%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Max manipulability index ALONG A LINE.
% Use stomp like to optimize along a surface/line
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function experiment1B_K20_N30
close all;
global parameters

%STOMP PARAMETERS
%number of particles
K = 20;

%repeat experiment number of times
parameters.n_repeat = 3;
parameters.experiment_name = 'experiment1B_K20_N30.mat';
parameters.experiment_number = 1;
parameters.animate = 0;

%repeat the experiment E times
random_manips=[];
Gout = [];
tic;
ela = []
for i=1:parameters.n_repeat
    close all
    tic;
    [pk, final_manip] = path_planning_SCO_4DOF(K);
    Gout{i}=pk;
    random_manips = [random_manips; final_manip];
    elapsed = toc;
    ela = [ela elapsed];
    save(parameters.experiment_name)
end
%elapsed = toc;
%fprintf('TIC TOC: %g\n', elapsed/parameters.n_repeat);
ela
fprintf('TIC TOC mean: %g\n', mean(ela));
fprintf('TIC TOC cov: %g\n', cov(ela));
fprintf('TIC TOC 2sigma: %g\n', 2*sqrt(cov(ela)));

'ended'
parameters.experiment_name
 