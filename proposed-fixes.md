# Proposed MATLAB Toolbox Fixes

Status: Pending independent manual validation

Branch: `work/matlab-calculation-validation`

Remote status: Local only; not pushed

## Purpose

This document records proposed corrections discovered during calculation and
boundary-condition testing of the Colour Engineering Toolbox. The changes
should not be submitted upstream until the numerical results and reproduction
steps have been independently reviewed.

## Evidence Policy

The corrections below are not justified by AI output alone. Evidence is ranked
in this order:

1. Normative CIE, IEC, ICC, or ISO publications.
2. Peer-reviewed papers and official supplementary test data.
3. Official MathWorks documentation and direct execution in MATLAB R2026a.
4. Established open reference implementations that cite the standards.
5. First-principles mathematical proofs and regression tests.

Search-engine summaries and AI-generated explanations are not treated as
authoritative. For example, one search summary claimed that `switch 65` would
not match `case 'A'`. Direct MATLAB R2026a execution disproved that claim:

```matlab
isequal(65,'A')

matched = 'none';
switch 65
    case 'A'
        matched = 'char-A';
    case 65
        matched = 'numeric-65';
end
matched
```

Observed result:

```text
ans = 1
matched = char-A
```

## Proposed Corrections

### CIE94 reference weighting

File: `ColourEngineeringToolbox/difference/cie94.m`

Use reference chroma, rather than mean reference/sample chroma, for the CIE94
chroma and hue scale factors.

References:

- CIE 116:1995, *Industrial Colour-Difference Evaluation*:
  https://www.cie.co.at/publications/industrial-colour-difference-evaluation
- Bruce Lindbloom's published equation summary explicitly defines
  `S_C = 1 + K_1*C_1` and `S_H = 1 + K_2*C_1`, where `C_1` is the reference
  chroma:
  http://www.brucelindbloom.com/Eqn_DeltaE_CIE94.html

Confidence: HIGH. The proposed equation matches the published CIE94 formula.

Reproduction:

```matlab
% Before: 1.379995536663367
% Proposed: 1.395038867858738
cie94([50 2.6772 -79.7751],[50 0 -82.7485])
```

### Difference-equation parameter validation

Files:

- `ColourEngineeringToolbox/difference/ciede2000.m`
- `ColourEngineeringToolbox/difference/cie94.m`
- `ColourEngineeringToolbox/difference/cmc.m`

Validate the number, type, range, and finiteness of weighting parameters before
using them. Replace undefined-variable failures with named MATLAB errors.

References:

- CIE 142:2001, *Improvement to Industrial Colour-Difference Evaluation*,
  defines the CIEDE2000 parametric factors.
- Sharma, Wu, and Dalal (2005), "The CIEDE2000 Color-Difference Formula:
  Implementation Notes, Supplementary Test Data, and Mathematical
  Observations", *Color Research and Application* 30(1), 21-30:
  https://doi.org/10.1002/col.20070
- Author-maintained CIEDE2000 resources and test data:
  https://hajim.rochester.edu/ece/sites/gsharma/ciede2000/
- The full equation and default factors are independently summarized at:
  http://www.brucelindbloom.com/Eqn_DeltaE_CIE2000.html

Confidence: HIGH for the formula and published vectors. The named MATLAB
errors are defensive programming, not a requirement imposed by CIE.

```matlab
% Before: undefined variable kL.
% Proposed: ColourEngineeringToolbox:ciede2000:InvalidWeights.
ciede2000([50 0 0],[50 0 0],1)
```

### Standard illuminant selection

File: `ColourEngineeringToolbox/colour/d.m`

Separate numeric and character illuminant selection. Numeric `65` currently
collides with the character code for `'A'`.

References:

- The collision is directly reproducible in MATLAB R2026a using the script in
  the Evidence Policy section.
- CIE 15:2004, *Colorimetry*, is the normative source for CIE standard
  illuminants.
- IEC 61966-2-1:1999 defines the sRGB reference conditions using D65:
  https://webstore.iec.ch/en/publication/6169
- MathWorks `whitepoint` documentation provides implementation reference
  values for D50, D55, D65, D75, A, and C:
  https://www.mathworks.com/help/images/ref/whitepoint.html

The proposed correction changes dispatch and labels; it does not claim that
the toolbox's rounded legacy XYZ table has full CIE table precision.

```matlab
% Before: name is A and XYZ is [109.85 100 35.8].
% Proposed: name is D65 and XYZ is [95.04 100 108.89].
[xyz,name] = d(65)
```

Also return correct D65 and D75 names, accept lowercase A and C, and reject
unsupported illuminants with a named error.

ICC qualification:

- ICC.1 uses D50 as the Profile Connection Space white point, not D65.
- ICC states the PCS D50 value as `[96.42, 100, 82.49]`:
  https://www.color.org/whyd50/
- ICC profile connection background:
  https://www.color.org/iccmax/connection1/
- Current ICC profile specification:
  https://archive.color.org/specification/ICC.1-2022-05.pdf
- The ICC Profile Registry is a catalogue of registered profiles and does not
  itself define illuminant XYZ values:
  https://registry.color.org/profile-registry/

CIE D50 and ICC PCS D50 use slightly different published rounded values. The
toolbox should document whether `d(50)` represents general CIE colorimetry or
the ICC PCS engineering value before changing the existing table.

Confidence: HIGH for the dispatch bug and D65 identity. A future precision
change to the illuminant table requires a separate design decision.

### 3D lookup-table range validation

File: `ColourEngineeringToolbox/charac/lookup3d.m`

Reject values below 0 or above 1 rather than rejecting normal values below 1.
Preallocate the output matrix and provide a named range error.

References:

- The function's own documented contract states that input values are in the
  range 0 through 1.
- Trilinear interpolation on an identity LUT is a convex combination of the
  surrounding corner values. Substitution proves that an identity LUT returns
  the input at corners and internal points.
- General trilinear interpolation reference:
  https://en.wikipedia.org/wiki/Trilinear_interpolation

Confidence: HIGH by direct logical proof and the identity regression test.
This is not a standards-conformance claim.

```matlab
table = create3dlut(3);

% Before: valid input is rejected.
% Proposed: returns [0.25 0.50 0.75].
lookup3d([0.25 0.50 0.75],table)
```

### Euclidean input dimensions

File: `ColourEngineeringToolbox/difference/euclidist.m`

Compare complete array sizes with `isequal` and report named errors for shape
mismatches and unsupported coordinate counts.

References:

- Euclidean distance requires corresponding vectors with the same number of
  coordinates.
- MATLAB's `if` treats a nonscalar condition as true only when all elements
  are nonzero. The old size comparison can therefore miss a partial mismatch:

```matlab
size(ones(2,3)) ~= size(ones(2,2))  % returns [false true]
```

- Official MathWorks `isequal` documentation:
  https://www.mathworks.com/help/matlab/ref/isequal.html

Confidence: HIGH by mathematical definition and direct MATLAB reproduction.
The one-to-three-coordinate limit remains a toolbox policy.

```matlab
% Before: unrelated array-index error.
% Proposed: ColourEngineeringToolbox:euclidist:DimensionMismatch.
euclidist(ones(2,3),ones(2,2))
```

### CIECAM02 Cartesian coordinates

File: `ColourEngineeringToolbox/colour/xyz2cam02.m`

Convert hue from degrees to radians before passing it to `cos` and `sin`.

References:

- MATLAB `cos` uses radians:
  https://www.mathworks.com/help/matlab/ref/cos.html
- MATLAB `cosd` uses degrees:
  https://www.mathworks.com/help/matlab/ref/cosd.html
- The established Colour reference implementation documents CIECAM02 `h` as
  a hue angle in degrees and cites Fairchild, Luo, and Moroney:
  https://colour.readthedocs.io/en/develop/_modules/colour/appearance/ciecam02.html
- CIE 159:2004, *A Colour Appearance Model for Colour Management Systems:
  CIECAM02*, is the normative model publication.

Confidence: HIGH for degree conversion.

```matlab
white = [95.04 100 108.89];
cam = xyz2cam02([19.01 20 21.78],white,318.31,20,'average');

% Proposed ac and bc must match these values.
expected_ac = cam(2)*cosd(cam(3))
expected_bc = cam(2)*sind(cam(3))
actual_ac = cam(6)
actual_bc = cam(7)
```

Before:

```text
actual_ac=0.056963690697
actual_bc=0.056178833166
```

Proposed:

```text
actual_ac=-0.054591236569
actual_bc=-0.058486923697
```

Notation qualification:

The toolbox names output columns 6 and 7 `ac` and `bc`. CIECAM02 literature
normally calls the opponent dimensions `a` and `b`; `ac` and `bc` are local
toolbox aliases. The mathematical polar-to-Cartesian correction is supported,
but the variable names are not standard CIE notation.

### Inverse CIECAM02 surround handling

File: `ColourEngineeringToolbox/colour/jch2xyzcam02.m`

Use the standard average, dim, and dark induction factors consistently in the
forward and inverse models. Preserve documented toolbox aliases, validate
unsupported values, and replace explicit matrix inversion with matrix
division.

Evidence:

- CIE 159:2004 is the normative source.
- Moroney et al. (2002), "The CIECAM02 Color Appearance Model", *Color and
  Imaging Conference*, 1, 23-27.
- The Colour reference implementation defines:
  - Average: `F=1`, `c=0.69`, `N_c=1`
  - Dim: `F=0.9`, `c=0.59`, `N_c=0.9`
  - Dark: `F=0.8`, `c=0.525`, `N_c=0.8`
  https://colour.readthedocs.io/en/develop/_modules/colour/appearance/ciecam02.html
- Fairchild (2004), *Color Appearance Models*, 2nd edition, pages 289-301,
  documents CIECAM02 forward and inverse calculations.
- MathWorks advises solving linear systems with matrix division instead of
  forming explicit inverses:
  https://www.mathworks.com/help/matlab/ref/inv.html
  https://www.mathworks.com/help/matlab/ref/mldivide.html

Confidence: HIGH for average, dim, dark, inverse consistency, and matrix
division.

Alias qualification:

- `average` is the canonical named condition.
- `avg` is a toolbox convenience alias.
- `T1` is present in the legacy toolbox but is not a CIE 159:2004 standard
  surround name. Its preservation is compatibility behavior, not a
  standards-backed correction.

```matlab
white = [95.04 100 108.89];
xyz = [19.01 20 21.78];
cam = xyz2cam02(xyz,white,318.31,20,'average');

% Before: undefined variable c.
% Proposed: approximately [19.00999950 20.00000028 21.78000105].
jch2xyzcam02(cam(1:3),white,318.31,20,'average')
```

## Automated QA

Proposed test files:

- `tests/test_core_calculations.m`
- `tests/test_utility_calculations.m`

Run from the repository root:

```matlab
% Execute all proposed reference, round-trip, validation, and boundary tests.
results = runtests('tests');

% Stop with an error if any proposed behavior is not satisfied.
assertSuccess(results);
```

Current local result:

```text
15 Passed, 0 Failed, 0 Incomplete
```

## Evidence Summary

| Correction | Evidence grade | Qualification |
|---|---|---|
| CIE94 reference chroma | HIGH | Directly matches CIE94 equations |
| CIEDE2000 reference vectors | HIGH | Peer-reviewed Sharma data |
| Named parameter errors | ENGINEERING | Defensive programming, not mandated |
| D65 dispatch and label | HIGH | Direct MATLAB reproduction plus CIE/IEC |
| Illuminant table precision | UNRESOLVED | Must distinguish CIE from ICC PCS |
| LUT bounds | HIGH | Function contract and algebraic proof |
| Euclidean shape check | HIGH | Mathematical definition and MATLAB behavior |
| CIECAM02 degree conversion | HIGH | CIECAM02 uses degrees; MATLAB `cos` uses radians |
| CIECAM02 average/dim/dark factors | HIGH | CIE 159 and reference implementation |
| `ac`/`bc` names | TOOLBOX-SPECIFIC | CIE notation normally uses `a`/`b` |
| `T1` alias | TOOLBOX-SPECIFIC | No CIE 159 backing found |
| Matrix division | HIGH | Official MathWorks numerical guidance |

## Manual Validation Checklist

- Confirm the CIE94 equation against the applicable CIE publication.
- Confirm all CIEDE2000 published reference pairs.
- Confirm D50, D55, D65, D75, A, and C tristimulus values and labels.
- Confirm LUT interpolation at 0, internal nodes, fractional values, and 1.
- Confirm CIECAM02 forward and inverse results against an independent
  implementation for average, dim, and dark surrounds.
- Confirm the new errors do not reject previously supported valid inputs.
- Run `checkcode` on every modified MATLAB file.
- Run the complete test suite in a fresh MATLAB process.

## Submission Gate

Do not push or submit these proposed changes until the manual validation
checklist is complete and any discrepancies are resolved.
