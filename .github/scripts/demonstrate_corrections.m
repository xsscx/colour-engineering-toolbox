repository_root = fileparts(fileparts(fileparts(mfilename('fullpath'))));
before_root = getenv('CET_BASELINE_ROOT');

assert(~isempty(before_root) && isfolder(before_root), ...
    'ColourEngineeringToolbox:workflow:MissingBaseline', ...
    'The workflow must create the original implementation worktree first.');

before = measure_results(before_root);
after = measure_results(repository_root);

fprintf('CIE94: before %.15f, after %.15f\n',before.cie94,after.cie94);
fprintf('d(65): before %s [%g %g %g]\n', ...
    before.illuminant_name,before.illuminant_xyz);
fprintf('d(65): after %s [%g %g %g]\n', ...
    after.illuminant_name,after.illuminant_xyz);
fprintf('lookup3d valid input: before rejected %d, after rejected %d\n', ...
    before.lookup_rejected,after.lookup_rejected);
fprintf('CIECAM02 ac: before %.12f, expected %.12f, after %.12f\n', ...
    before.ac,before.expected_ac,after.ac);

assert(abs(before.cie94 - 1.379995536663367) < 1e-12);
assert(abs(after.cie94 - 1.395038867858738) < 1e-12);
assert(isequal(before.illuminant_name,'A'));
assert(isequal(after.illuminant_name,'D65'));
assert(before.lookup_rejected);
assert(~after.lookup_rejected);
assert(abs(before.ac - before.expected_ac) > 1e-4);
assert(abs(after.ac - after.expected_ac) < 1e-12);

function results = measure_results(repository_root)
restoredefaultpath;
addpath(genpath(fullfile(repository_root,'ColourEngineeringToolbox')));
rehash;
clear d cie94 create3dlut lookup3d xyz2cam02

[results.illuminant_xyz,results.illuminant_name] = d(65);
results.cie94 = cie94([50 2.6772 -79.7751],[50 0 -82.7485]);

try
    results.lookup = lookup3d([0.25 0.50 0.75],create3dlut(3));
    results.lookup_rejected = false;
catch
    results.lookup = [];
    results.lookup_rejected = true;
end

cam = xyz2cam02([19.01 20 21.78],[95.04 100 108.89],318.31,20,'average');
results.ac = cam(6);
results.expected_ac = cam(2) * cosd(cam(3));
end
