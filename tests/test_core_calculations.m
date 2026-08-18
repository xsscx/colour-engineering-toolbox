function tests = test_core_calculations
tests = functiontests(localfunctions);
end

function setupOnce(test_case)
repository_root = fileparts(fileparts(mfilename('fullpath')));
toolbox_root = fullfile(repository_root,'ColourEngineeringToolbox');
addpath(genpath(toolbox_root));
test_case.TestData.toolbox_root = toolbox_root;
end

function test_ciede2000_published_reference_pairs(test_case)
reference = [
    50  2.6772 -79.7751
    50  3.1571 -77.2803
    50  2.8361 -74.0200
    50 -1.3802 -84.2814
];
sample = repmat([50 0 -82.7485],4,1);
expected = [2.0425;2.8615;3.4412;1.0000];

actual = ciede2000(reference,sample);

verifyEqual(test_case,actual,expected,'AbsTol',5e-5);
end

function test_cie94_uses_reference_chroma_weighting(test_case)
reference = [50 2.6772 -79.7751];
sample = [50 0 -82.7485];

actual = cie94(reference,sample);

verifyEqual(test_case,actual,1.3950388678587375,'AbsTol',1e-12);
end

function test_lab_lch_round_trip(test_case)
lab = [
    0    0   0
    50   3   4
    100 -20  30
];

actual = lch2lab(lab2lch(lab));

verifyEqual(test_case,actual,lab,'AbsTol',1e-12);
end

function test_xyz_lab_round_trip(test_case)
white = [96.4212 100 82.5188];
xyz = [
    0 0 0
    white
    20 30 10
    1 2 3
];

actual = lab2xyz(xyz2lab(xyz,white),white);

verifyEqual(test_case,actual,xyz,'AbsTol',1e-12);
end

function test_srgb_xyz_reference_values(test_case)
rgb = [
    255 255 255
    255   0   0
      0 255   0
      0   0 255
];
expected = [
    95.05 100.00 108.90
    41.24  21.26   1.93
    35.76  71.52  11.92
    18.05   7.22  95.05
];

actual = srgb2xyz(rgb);

verifyEqual(test_case,actual,expected,'AbsTol',1e-12);
end

function test_srgb_xyz_round_trip(test_case)
rgb = [
      0   0   0
    255 255 255
    255   0   0
      0 255   0
      0   0 255
     12  34  56
    128 128 128
];

actual = xyz2srgb(srgb2xyz(rgb));

verifyEqual(test_case,actual,rgb,'AbsTol',0.3);
end

function test_invalid_difference_weights(test_case)
verifyError(test_case,@() ciede2000([50 0 0],[50 0 0],1), ...
    'ColourEngineeringToolbox:ciede2000:InvalidWeights');
verifyError(test_case,@() cie94([50 0 0],[50 0 0],[1 1]), ...
    'ColourEngineeringToolbox:cie94:InvalidWeights');
verifyError(test_case,@() cmc([50 0 0],[50 0 0],1), ...
    'ColourEngineeringToolbox:cmc:InvalidWeights');
end

function test_valid_difference_weights_preserve_defaults(test_case)
reference = [50 20 30];
sample = [52 22 33];

verifyEqual(test_case,ciede2000(reference,sample,[1 1 1]), ...
    ciede2000(reference,sample),'AbsTol',1e-12);
verifyEqual(test_case,ciede2000(reference,sample,[1 1]), ...
    ciede2000(reference,sample),'AbsTol',1e-12);
verifyEqual(test_case,cie94(reference,sample,[1 1 1]), ...
    cie94(reference,sample),'AbsTol',1e-12);
verifyEqual(test_case,cmc(reference,sample,[1 1]), ...
    cmc(reference,sample),'AbsTol',1e-12);
end
