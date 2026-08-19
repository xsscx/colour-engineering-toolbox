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
% Sharma, Wu, and Dalal (2005) supplementary CIEDE2000 test data.
data = [
    50.0000   2.6772 -79.7751 50.0000   0.0000 -82.7485  2.0425
    50.0000   3.1571 -77.2803 50.0000   0.0000 -82.7485  2.8615
    50.0000   2.8361 -74.0200 50.0000   0.0000 -82.7485  3.4412
    50.0000  -1.3802 -84.2814 50.0000   0.0000 -82.7485  1.0000
    50.0000  -1.1848 -84.8006 50.0000   0.0000 -82.7485  1.0000
    50.0000  -0.9009 -85.5211 50.0000   0.0000 -82.7485  1.0000
    50.0000   0.0000   0.0000 50.0000  -1.0000   2.0000  2.3669
    50.0000  -1.0000   2.0000 50.0000   0.0000   0.0000  2.3669
    50.0000   2.4900  -0.0010 50.0000  -2.4900   0.0009  7.1792
    50.0000   2.4900  -0.0010 50.0000  -2.4900   0.0010  7.1792
    50.0000   2.4900  -0.0010 50.0000  -2.4900   0.0011  7.2195
    50.0000   2.4900  -0.0010 50.0000  -2.4900   0.0012  7.2195
    50.0000  -0.0010   2.4900 50.0000   0.0009  -2.4900  4.8045
    50.0000  -0.0010   2.4900 50.0000   0.0010  -2.4900  4.8045
    50.0000  -0.0010   2.4900 50.0000   0.0011  -2.4900  4.7461
    50.0000   2.5000   0.0000 50.0000   0.0000  -2.5000  4.3065
    50.0000   2.5000   0.0000 73.0000  25.0000 -18.0000 27.1492
    50.0000   2.5000   0.0000 61.0000  -5.0000  29.0000 22.8977
    50.0000   2.5000   0.0000 56.0000 -27.0000  -3.0000 31.9030
    50.0000   2.5000   0.0000 58.0000  24.0000  15.0000 19.4535
    50.0000   2.5000   0.0000 50.0000   3.1736   0.5854  1.0000
    50.0000   2.5000   0.0000 50.0000   3.2972   0.0000  1.0000
    50.0000   2.5000   0.0000 50.0000   1.8634   0.5757  1.0000
    50.0000   2.5000   0.0000 50.0000   3.2592   0.3350  1.0000
    60.2574 -34.0099  36.2677 60.4626 -34.1751  39.4387  1.2644
    63.0109 -31.0961  -5.8663 62.8187 -29.7946  -4.0864  1.2630
    61.2901   3.7196  -5.3901 61.4292   2.2480  -4.9620  1.8731
    35.0831 -44.1164   3.7933 35.0232 -40.0716   1.5901  1.8645
    22.7233  20.0904 -46.6940 23.0331  14.9730 -42.5619  2.0373
    36.4612  47.8580  18.3852 36.2715  50.5065  21.2231  1.4146
    90.8027  -2.0831   1.4410 91.1528  -1.6435   0.0447  1.4441
    90.9257  -0.5406  -0.9208 88.6381  -0.8985  -0.7239  1.5381
     6.7747  -0.2908  -2.4247  5.8714  -0.0985  -2.2286  0.6377
     2.0776   0.0795  -1.1350  0.9033  -0.0636  -0.5514  0.9082
];

actual = ciede2000(data(:,1:3),data(:,4:6));

verifyEqual(test_case,actual,data(:,7),'AbsTol',5e-5);
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
reference = [50 0 0];
sample = [50 0 0];

for weights = {1,[1 1 1 1],[1 0],[1 NaN]}
    verifyError(test_case,@() ciede2000(reference,sample,weights{1}), ...
        'ColourEngineeringToolbox:ciede2000:InvalidWeights');
end

for weights = {[1 1],[1 1 1 1],[1 0 1],[1 Inf 1]}
    verifyError(test_case,@() cie94(reference,sample,weights{1}), ...
        'ColourEngineeringToolbox:cie94:InvalidWeights');
end

for weights = {1,[1 1 1],[1 0],[1 NaN]}
    verifyError(test_case,@() cmc(reference,sample,weights{1}), ...
        'ColourEngineeringToolbox:cmc:InvalidWeights');
end
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
