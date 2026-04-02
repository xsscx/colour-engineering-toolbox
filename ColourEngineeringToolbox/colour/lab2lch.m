function LCh=lab2lch(Lab)
%LAB2LCH: Converts Cartesian CIELAB to polar LCh
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.2
%   date:  	   17-01-2004
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


L=Lab(:,1);a=Lab(:,2);b=Lab(:,3);
C=(a.^2+b.^2).^(1/2);
h=hue_angle(a,b);

LCh=[L,C,h];