function Lab=lch2lab(LCh)
% LCH2LAB: Converts polar LCh data to Cartesian CIELAB
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.1
%   date:  	   17-01-2001
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


r=(pi/180);
L=LCh(:,1);
C=LCh(:,2);
h=LCh(:,3);

a=cos(r*h).*C;
b=sin(r*h).*C;

Lab=[L,a,b];