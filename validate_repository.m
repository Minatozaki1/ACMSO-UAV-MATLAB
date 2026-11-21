function validation = validate_repository()
%VALIDATE_REPOSITORY Perform a static, non-experimental repository check.

repoRoot = fileparts(mfilename('fullpath'));
sourceDir = fullfile(repoRoot, 'src');
dataDir = fullfile(repoRoot, 'data');
addpath(repoRoot, sourceDir, dataDir);

requiredFiles = {
    'ACMSO_MAIN.m'
    'setup_terrain.m'
    fullfile('src', 'IMSO.m')
    fullfile('src', 'CostFunction.m')
    fullfile('src', 'Create_Select_Model.m')
    fullfile('src', 'DistP2S.m')
    fullfile('src', 'Draw_results.m')
    fullfile('src', 'Get_Spherical_details.m')
    fullfile('src', 'PlotModel.m')
    fullfile('src', 'SphericalToCart.m')
    };

forbiddenAlgorithms = {
    'MSO.m', 'PSO.m', 'BWO.m', 'DBO.m', 'NRBO.m', ...
    'SABO.m', 'SSA.m', 'WOA.m', 'GWO.m', 'HHO.m'
    };

missingFiles = requiredFiles(~cellfun(@(name) ...
    isfile(fullfile(repoRoot, name)), requiredFiles));

allFiles = dir(fullfile(repoRoot, '**', '*'));
allNames = {allFiles(~[allFiles.isdir]).name};
presentForbidden = forbiddenAlgorithms(ismember(forbiddenAlgorithms, allNames));

validation = struct();
validation.matlabRelease = version('-release');
validation.requiredFilesPresent = isempty(missingFiles);
validation.missingFiles = missingFiles;
validation.comparisonAlgorithmsAbsent = isempty(presentForbidden);
validation.presentForbiddenAlgorithms = presentForbidden;
validation.curveFittingToolboxAvailable = exist('csaps', 'file') == 2;
validation.terrainInstalled = isfile( ...
    fullfile(dataDir, 'ChrismasTerrain.tif'));
validation.entryPointResolved = ~isempty(which('ACMSO_MAIN'));
validation.algorithmResolved = ~isempty(which('IMSO'));

matlabFiles = dir(fullfile(repoRoot, '**', '*.m'));
codeAnalyzerMessages = 0;
for index = 1:numel(matlabFiles)
    messages = checkcode(fullfile(matlabFiles(index).folder, ...
        matlabFiles(index).name), '-id');
    codeAnalyzerMessages = codeAnalyzerMessages + numel(messages);
end
validation.codeAnalyzerMessages = codeAnalyzerMessages;

validation.staticChecksPassed = ...
    validation.requiredFilesPresent && ...
    validation.comparisonAlgorithmsAbsent && ...
    validation.entryPointResolved && ...
    validation.algorithmResolved;

fprintf('ACMSO repository static validation\n');
fprintf('  Required files present:       %s\n', yesNo(validation.requiredFilesPresent));
fprintf('  Comparison algorithms absent: %s\n', yesNo(validation.comparisonAlgorithmsAbsent));
fprintf('  Entry point resolved:         %s\n', yesNo(validation.entryPointResolved));
fprintf('  ACMSO implementation resolved:%s\n', yesNo(validation.algorithmResolved));
fprintf('  Curve Fitting Toolbox found:  %s\n', yesNo(validation.curveFittingToolboxAvailable));
fprintf('  Terrain already installed:    %s\n', yesNo(validation.terrainInstalled));
fprintf('  Code Analyzer messages:       %d\n', validation.codeAnalyzerMessages);

if validation.staticChecksPassed
    fprintf('STATIC VALIDATION PASSED\n');
else
    error('ACMSO:RepositoryValidationFailed', ...
        'One or more repository structure checks failed.');
end

if ~validation.terrainInstalled
    fprintf('Note: ACMSO_MAIN will run setup_terrain on first use.\n');
end
if ~validation.curveFittingToolboxAvailable
    fprintf('Warning: Draw_results requires csaps from Curve Fitting Toolbox.\n');
end
end

function answer = yesNo(value)
if value
    answer = 'yes';
else
    answer = 'no';
end
end
