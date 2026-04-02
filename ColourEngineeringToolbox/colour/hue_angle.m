function h=hue_angle(a,b)
% HUE_ANGLE: Computes four-quadrant polar angle in degrees from Cartesian coordinates 
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.1
%   date:  	   17-01-2001
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


h=(180/pi)*atan2(b,a);
j=(b<0);
h(j)=h(j)+360;