function uvp=xyz2uvp(XYZ)
% XYZ2UVP: calculates CIE 1976 u',v' coordinates from tristimulus XYZ
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.1
%   date:  	   17-01-2001
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


X=XYZ(:,1);Y=XYZ(:,2);Z=XYZ(:,3);
up=4*X./(X+15*Y+3*Z);
vp=9*Y./(X+15*Y+3*Z);
uvp=[up,vp];