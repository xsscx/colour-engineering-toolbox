function tests = test_utility_calculations
tests = functiontests(localfunctions);
end

function setupOnce(~)
repository_root = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(fullfile(repository_root,'ColourEngineeringToolbox')));
end

function test_standard_illuminants(test_case)
illuminants = {
    50,[96.42 100 82.49],'D50';
    55,[96.68 100 92.14],'D55';
    65,[95.04 100 108.89],'D65';
    75,[94.96 100 122.62],'D75'
};

for row = 1:size(illuminants,1)
    [actual,name] = d(illuminants{row,1});
    verifyEqual(test_case,actual,illuminants{row,2},'AbsTol',1e-12);
    verifyEqual(test_case,name,illuminants{row,3});
end

[actual,name] = d('a');
verifyEqual(test_case,actual,[109.85 100 35.8],'AbsTol',1e-12);
verifyEqual(test_case,name,'A');

[actual,name] = d('c');
verifyEqual(test_case,actual,[98.07 100 118.23],'AbsTol',1e-12);
verifyEqual(test_case,name,'C');

verifyError(test_case,@() d(60), ...
    'ColourEngineeringToolbox:d:InvalidIlluminant');
end

function test_xyy_to_xyz_reference_values(test_case)
white_xyz = xyy2xyz([0.3127 0.3290]);
verifyEqual(test_case,white_xyz,[95.045592705167 100 108.905775075988], ...
    'AbsTol',1e-10);

primaries = [
    0.64 0.33
    0.30 0.60
    0.15 0.06
];
actual = xyy2xyz(primaries,[0.3127 0.3290]);
expected = [
    41.239079926563 21.263900587292  1.933081871449
    35.758430581777 71.516861163555 11.919476860592
    18.048082196827  7.219232878731 95.053216343947
];
verifyEqual(test_case,actual,expected,'AbsTol',1e-5);
end

function test_hue_geometry(test_case)
actual = hue_angle([1 0 -1 0],[0 1 0 -1]);
verifyEqual(test_case,actual,[0 90 180 270],'AbsTol',1e-12);
verifyEqual(test_case,angle_diff([10 350 90],[350 10 270]), ...
    [20 20 180],'AbsTol',1e-12);
end

function test_euclidean_distance(test_case)
actual = euclidist([0 0 0;1 2 3],[3 4 0;1 2 3]);
verifyEqual(test_case,actual,[5;0],'AbsTol',1e-12);

verifyError(test_case,@() euclidist(ones(2,3),ones(2,2)), ...
    'ColourEngineeringToolbox:euclidist:DimensionMismatch');
verifyError(test_case,@() euclidist(ones(2,4),zeros(2,4)), ...
    'ColourEngineeringToolbox:euclidist:UnsupportedDimensions');
end

function test_identity_3d_lookup(test_case)
table = create3dlut(3);
input = [
    0.00 0.00 0.00
    0.25 0.50 0.75
    1.00 1.00 1.00
];

actual = lookup3d(input,table);

verifyEqual(test_case,actual,input,'AbsTol',1e-12);
verifyError(test_case,@() lookup3d([-0.01 0.5 0.5],table), ...
    'ColourEngineeringToolbox:lookup3d:InputOutOfRange');

scaled_input_table = table .* repmat([2 4 8],size(table,1),1);
actual = lookup3d([0.5 2 6],table,scaled_input_table);
verifyEqual(test_case,actual,[0.25 0.50 0.75],'AbsTol',1e-12);
end

function test_ciecam02_round_trip(test_case)
xyz = [
    19.01 20.00 21.78
    57.06 43.06 31.96
];
white = d(65);

for surround = {'average','dim','dark'}
    cam = xyz2cam02(xyz,white,318.31,20,surround{1});
    actual = jch2xyzcam02(cam(:,1:3),white,318.31,20,surround{1});
    verifyEqual(test_case,actual,xyz,'AbsTol',2e-3);
    verifyEqual(test_case,cam(:,6),cam(:,2).*cosd(cam(:,3)), ...
        'AbsTol',1e-12);
    verifyEqual(test_case,cam(:,7),cam(:,2).*sind(cam(:,3)), ...
        'AbsTol',1e-12);
end

default_cam = xyz2cam02(xyz);
explicit_default_cam = xyz2cam02(xyz,d(50));
verifyEqual(test_case,default_cam,explicit_default_cam,'AbsTol',1e-12);

numeric_surround = [0.69 1 1];
cam = xyz2cam02(xyz,white,318.31,20,numeric_surround);
actual = jch2xyzcam02(cam(:,1:3),white,318.31,20,numeric_surround);
verifyEqual(test_case,actual,xyz,'AbsTol',2e-3);

cam = xyz2cam02(xyz,white);
actual = jch2xyzcam02(cam(:,1:3),white);
verifyEqual(test_case,actual,xyz,'AbsTol',2e-3);
end

function test_invalid_ciecam02_surround(test_case)
verifyError(test_case,@() jch2xyzcam02([50 20 30],d(65),318.31,20,'bad'), ...
    'ColourEngineeringToolbox:jch2xyzcam02:InvalidSurround');
end
