function XYZ = drgb2xyz(Drgb,refwhite)

% DRGB2XYZ Converts Drgb (colorimetric density) to XYZ tristimulus
%
% XYZ=drgb2xyz(Drgb,refwhite)
%
% The reference white is typically the tristimulus values of the media white; 
% it can also be the tristimulus values of the perfect diffuser.
% Default value is D50 illuminant
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.2
%   date:  	   17-01-2002
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


if nargin>1
   XYZref=refwhite;
else
   XYZref=d(50);
end

Dr=Drgb(:,1);
Dg=Drgb(:,2);
Db=Drgb(:,3);

Xref=XYZref(:,1);
Yref=XYZref(:,2);
Zref=XYZref(:,3);

%Take antilog and undo media-relative normalization
X=Xref./10.^Dr;
Y=Yref./10.^Dg;
Z=Zref./10.^Db;

XYZ=[X,Y,Z];
