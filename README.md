# Colour Engineering Toolbox

## Introduction
Colour Engineering Toolbox is a collection of MATLAB functions originally developed to accompany the book _[Colour Engineering: Achieving Device Independent Colour (Wiley, 2002)](https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136)_. The initial codebase was written by Dr. Phil Green. For further background, see [A Colour Engineering Toolbox](ColourEngineeringToolbox/ColourEngineeringToolbox.pdf)

## Toolbox contents

The toolbox provides well-tested algorithms for colour space conversion, colour-difference equations, gamut analysis, device characterization, and psychophysical data analysis.

### `colour/`
Core colour science and colour appearance functions:

- `abs2rel` — Converts CIELAB values relative to a perfect diffuser to corresponding values relative to media white.
- `angle_diff` — Calculates angular difference between two hue angles.
- `bradford` — Calculates tristimulus values under reference adapting field using the BFD chromatic adaptation transform.
- `d` — Returns XYZ tristimulus values of various CIE standard illuminants.
- `drgb2xyz` — Converts Drgb (colorimetric density) to XYZ tristimulus.
- `hue_angle` — Computes four-quadrant polar angle in degrees from Cartesian coordinates.
- `jch2xyzcam02` — Inverse model of CIECAM02; calculates XYZ from appearance coordinates J, C and h.
- `lab2lch` — Converts Cartesian CIELAB to polar LCh.
- `lab2xyz` — Inverts the calculation of CIELAB L*a*b* to find tristimulus XYZ from L*a*b*.
- `lch2lab` — Converts polar LCh data to Cartesian CIELAB.
- `rel2abs` — Converts CIELAB values relative to a perfect diffuser to corresponding values relative to media white.
- `srgb2xyz` — Calculates XYZ tristimulus values from IEC:61966 sRGB.
- `xyy2xyz` — Calculates XYZ tristimulus from xy chromaticity and Y luminance.
- `xyz2cam02` — Forward model of CIECAM02; calculates appearance coordinates J, C, h, Q, M, ac, bc and s.
- `xyz2drgb` — Converts XYZ tristimulus to colorimetric density.
- `xyz2lab` — Calculates L,a,b from XYZ according to CIE 15:2004.
- `xyz2srgb` — Calculates IEC:61966 sRGB values from XYZ.
- `xyz2uvp` — Calculates CIE 1976 u',v' coordinates from tristimulus XYZ.

### `difference/`
Colour-difference and visualization functions:

- `cie94` — Computes CIE94 colour difference between a reference and a sample.
- `ciede2000` — Calculates colour difference between a reference and sample using CIEDE2000 colour difference.
- `cmc` — Computes colour difference according to the CMC equation.
- `euclidist` — Euclidean distance between two points in 1–3 dimensions.
- `plotdiff` — Generates surface plot for a colour difference equation.

### `charac/`
Device characterization and lookup-table functions:

- `charac3` — Third order polynomial regression to find coefficient matrix ABC for transforming between any two colour spaces.
- `create3dlut` — Creates a uniform 3-dimensional table for 3D look-up in which the first dimension varies most slowly and the last dimension varies fastest.
- `extract3d` — Returns the index entries of the bounding cube around input values for use in 3D look-up and interpolation.
- `lookup3d` — Performs 3D table look-up on input data.
- `ndlut` — Creates a uniform n-dimensional table for nD look-up in which the first dimension varies most slowly and the last dimension varies fastest.
- `polyconvert3` — Polynomial conversion between two colour spaces using characterization coefficient matrix.
- `polymat3` — Prepares third order matrix for input to polynomial characterization or colour transformation.

### `imageprep/`
Image preparation, reshaping, and image file utilities:

- `chart2data` — Filters an image made up of colour patches by discarding regions around an array of centres within an image, and resamples to a single pixel per patch.
- `chunk` — Passes a subset of data into the requested function and displays a progress bar.
- `cmykdata2rawimage` — Writes CMYK image data to Raw format image file.
- `displaylabimage` — Displays CIELAB data to screen.
- `imagewindow` — Filters a patch image by discarding regions around an array of centres within an image, and resamples to a single pixel per patch.
- `imscatter` — Plots a 3D scatter diagram of CIELAB data.
- `labdata2rawimage` — Writes CIELAB data to Raw format image files in either 8 or 16 bit precision.
- `labimread` — Reads an 8-bit RGB TIFF file and interprets data as CIELAB L*, a*, b*.
- `labimwrite` — Writes an image in 8-bit CIELAB to an 8-bit RGB TIFF file.
- `m2v` — Converts rxcxn matrix of colour data to n columns.
- `m3vmult` — Performs matrix multiplication on a 3x3 matrix and each row of a nx3 vector.
- `rawimage2labdata` — Reads an 8 or 16 bit image file in `.raw` format, CIELAB colour space, with appropriate scaling of L,a,b channels.
- `v2m` — Converts data arranged in 1D columns to 2D arrays; the array dimensions are taken from `array_size` and the number of columns becomes the number of planes in the 3rd dimension.

### `psychophysics/`
Psychophysical scaling and plotting functions:

- `catjudge` — Calculates interval scale from category judgement data applying Torgerson's Law of Category Judgement (Case D).
- `normsinv` — Inverse of the normal cumulative distribution function.
- `paircomp` — Calculates z-scores and confidence intervals from pair comparison experiment data.
- `pc_seq` — Returns a set of indices to use as a sequence in a pair comparison experiment.
- `plotcaterror` — Uses MATLAB `errorbar` function to plot formatted error bar graph with category boundaries.
- `ploterror` — Uses MATLAB `errorbar` function to plot formatted error bar graph.
- `rankorder` — Calculates z-scores and confidence intervals from rank order experiment data.


## Installation
1. Download the latest release from this Github project.
2. Unzip the toolbox folder.
3. Add the ColourEngineeringToolbox root and its subfolders to the MATLAB path.


## Contributing

Contributors are ICC members and other individual contributors who have volunteered to
maintain ICC software, documentation, or other technical artifacts. Our CONTRIBUTING
document explains our contribution processes and procedures, so please review it first:
[CONTRIBUTING](https://github.com/InternationalColorConsortium/.github/blob/main/docs/CODE_OF_CONDUCT.md). Contributors are asked to sign a [Contributor License Agreement](https://github.com/InternationalColorConsortium/.github/blob/main/docs/CLA.md)

## License

Colour Engineering Toolbox is licensed under the BSD 3-Clause “New” or “Revised” License

Membership in the ICC is encouraged when this software is used for commercial purposes.
For more information on The International Color Consortium,
please visit [www.color.org](http://www.color.org).
