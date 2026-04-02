function XYZ=xyy2xyz(xyy,xyzw)
% XYY2XYZ: Calculates XYZ tristimulus from xy chromaticity and Y luminance
%
% XYY2XYZ can be called in three different ways:
% 1. To calculate XYZ from xyY
% 2. To calculate XYZ for a media white where Y=100
% 3. To calculate XYZ from xy chromaticity values and the corresponding
%    media white xy or XYZ
%
% In case 1, xyy is an nx3 array where the third column is Y luminance.
% Example: XYZ=xyy2xyz(xyY);
%
% In case 2, xyy is an nx2 array where Y is assumed to be 100
% Example: XYZ=xyy2xyz(xy);
% 
% In case 3, xyy is a 3x2 array where the rows correspond to the xy values
% of the R, G and B primaries; and xyzw is the media white. The media white
% can be given as xy or XYZ values
% Example: XYZ=xyy2xyz(xy,xyzw);
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.2
%   date:  	   22-03-2006
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


if nargin==1
    c=size(xyy,2);
    if c>2
        Y=xyy(:,3);
    else
        Y=100;
    end
elseif nargin==2
    % check that xyzw has three rows
    rw=size(xyy,1);
    if rw~=3
        error('If a white point is supplied, xyy must be a 3x3 matrix')
    end
    % get XYZ and xy of white
    if xyzw(2)>1
        % assume XYZ tristimulus
        Yw=xyzw(2);
        xw=xyzw(1)/sum(xyzw);
        yw=xyzw(2)/sum(xyzw);
    else
        % assume xy chromaticity
        XYZw=xyy2xyz(xyzw);
        Yw=XYZw(2);
        xw=xyzw(1);
        yw=xyzw(2);
    end
    % deal
    xr=xyy(1,1);yr=xyy(1,2);
    xg=xyy(2,1);yg=xyy(2,2);
    xb=xyy(3,1);yb=xyy(3,2);
    % solve for Yr
    s=yw*(yr*(xg-xb)-yg*(xr-xb)+yb*(xr-xg));
    Yr=yr*(yw*(xg-xb)-yg*(xw-xb)+yb*(xw-xg))/s;
    Yg=-yg*(yw*(xr-xb)-yr*(xw-xb)+yb*(xw-xr))/s;
    Yb=yb*(yw*(xr-xg)-yr*(xw-xg)+yg*(xw-xr))/s;
    Y=[Yr;Yg;Yb];
    % scale to values for media white
    if Yw>2
        Y=Y*100;
    end    
end
X=(xyy(:,1).*Y)./xyy(:,2);
Z=Y.*(1-xyy(:,1)-xyy(:,2))./xyy(:,2);
XYZ=[X,Y,Z];
