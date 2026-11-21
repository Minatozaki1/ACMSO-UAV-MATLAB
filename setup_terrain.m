function terrainFile = setup_terrain()
%SETUP_TERRAIN Download the unmodified terrain file from its upstream repo.
%
% The data is intentionally not redistributed in this repository. Running
% this function downloads the exact file from its documented upstream source
% and verifies the pinned SHA-256 digest before installing it under data/.

repoRoot = fileparts(mfilename('fullpath'));
dataDir = fullfile(repoRoot, 'data');
terrainFile = fullfile(dataDir, 'ChrismasTerrain.tif');

sourceUrl = [ ...
    'https://raw.githubusercontent.com/duongpm/SPSO/' ...
    '30bcef24b4cf62d06f50afb0d67368588dd148b4/' ...
    'ChrismasTerrain.tif'];
expectedHash = ...
    '481f16efbea8270a6d609ad5dc147063e8acbd88482ea0bc36d99b1e99bda197';

if ~isfolder(dataDir)
    mkdir(dataDir);
end

if isfile(terrainFile)
    actualHash = sha256File(terrainFile);
    assert(strcmp(actualHash, expectedHash), ...
        ['Existing terrain file failed SHA-256 verification. Remove it ' ...
         'and run setup_terrain again.']);
    fprintf('Terrain data already installed and verified.\n');
    return
end

fprintf(['Downloading terrain data from the pinned third-party source.\n' ...
    'Review SOURCE_AND_LICENSE_REVIEW.md before public redistribution.\n']);

temporaryFile = [tempname(dataDir) '.tif'];
removeTemporaryFile = onCleanup(@() deleteIfPresent(temporaryFile));
websave(temporaryFile, sourceUrl);

actualHash = sha256File(temporaryFile);
assert(strcmp(actualHash, expectedHash), ...
    'Downloaded terrain file failed SHA-256 verification.');

movefile(temporaryFile, terrainFile);
clear removeTemporaryFile
fprintf('Terrain data installed at:\n%s\n', terrainFile);
end

function digest = sha256File(filename)
fid = fopen(filename, 'rb');
assert(fid >= 0, 'Unable to open file for hashing: %s', filename);
closeFile = onCleanup(@() fclose(fid));
bytes = fread(fid, Inf, '*uint8');
clear closeFile

engine = java.security.MessageDigest.getInstance('SHA-256');
engine.update(typecast(bytes(:), 'int8'));
rawDigest = typecast(engine.digest(), 'uint8');
digest = lower(reshape(dec2hex(rawDigest, 2).', 1, []));
end

function deleteIfPresent(filename)
if isfile(filename)
    delete(filename);
end
end
