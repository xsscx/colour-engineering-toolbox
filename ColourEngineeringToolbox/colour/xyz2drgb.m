function Drgb = xyz2drgb(XYZ,refwhite)

% XYZ2DRGB: Converts XYZ tristimulus to colorimetric density.
%
% Drgb=XYZ2Drgb(Drgb,refwhite)
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

%avoid division by zero;
XYZ(XYZ==0)=eps;

X=XYZ(:,1);
Y=XYZ(:,2);
Z=XYZ(:,3);

Xref=XYZref(:,1);
Yref=XYZref(:,2);
Zref=XYZref(:,3);

%Normalize to media-relative XYZ
Xrel=X.\Xref;
Yrel=Y.\Yref;
Zrel=Z.\Zref;

%Take logs to find D(r,g,b)
Dr=log10(Xrel);
Dg=log10(Yrel);
Db=log10(Zrel);

Drgb=[Dr,Dg,Db];
