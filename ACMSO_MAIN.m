function results = ACMSO_MAIN()
%ACMSO_MAIN Run the ACMSO three-dimensional UAV path-planning example.
%
%   RESULTS = ACMSO_MAIN() uses the same model, objective function, and
%   optimization parameters as the research workspace. The historical
%   implementation filename IMSO.m is retained unchanged for traceability.

clc;
close all;

repoRoot = fileparts(mfilename('fullpath'));
sourceDir = fullfile(repoRoot, 'src');
dataDir = fullfile(repoRoot, 'data');
addpath(sourceDir, dataDir);

terrainFile = fullfile(dataDir, 'ChrismasTerrain.tif');
if ~isfile(terrainFile)
    fprintf('Terrain data is not installed. Downloading the pinned upstream file...\n');
    setup_terrain();
end

originalFolder = pwd;
restoreFolder = onCleanup(@() cd(originalFolder));
% The unchanged model loader reads ChrismasTerrain.tif by filename.
cd(dataDir);

global VarMax

%% Problem definition (unchanged from the research example)
startPos = [200 100 150];
goalPos = [800 800 150];
map_select = 1;
map_complexity = 4;
flight_num = 10;

model = Create_Select_Model( ...
    map_select, map_complexity, startPos, goalPos, flight_num);

%% Search bounds (unchanged)
VarMin.x = model.xmin;
VarMax.x = model.xmax;
VarMin.y = model.ymin;
VarMax.y = model.ymax;
VarMin.z = model.zmin;
VarMax.z = model.zmax;

VarMax.r = 2 * norm(model.start-model.end) / flight_num;
VarMin.r = 0;

AngleRange = pi/4;
VarMin.psi = -AngleRange;
VarMax.psi = AngleRange;

dirVector = model.end - model.start;
phi0 = atan2(dirVector(2), dirVector(1));
VarMin.phi = phi0 - AngleRange;
VarMax.phi = phi0 + AngleRange;

[lb, ub, dim, fobj] = Get_Spherical_details( ...
    VarMax, VarMin, model, flight_num);

%% ACMSO parameters (unchanged)
SearchAgents_no = 100;
Max_iteration = 1000;

%% Run ACMSO
[curve, bestCost, bestPosition] = IMSO( ...
    lb, ub, dim, fobj, SearchAgents_no, Max_iteration, model);

fprintf('--- ACMSO completed ---\n');
fprintf('Best path cost: %.15g\n', bestCost);

results.algo = {'ACMSO'};
results.Curve = curve;
results.Chorm = bestPosition;
results.bestCost = bestCost;
results.model = model;
results.parameters = struct( ...
    'startPosition', startPos, ...
    'goalPosition', goalPos, ...
    'mapComplexity', map_complexity, ...
    'waypointCount', flight_num, ...
    'populationSize', SearchAgents_no, ...
    'maxIterations', Max_iteration);

Draw_results(results, model);

clear restoreFolder
end
