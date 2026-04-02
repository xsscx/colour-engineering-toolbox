function Lab2=abs2rel(Lab,mwhite,illuminant)
%ABS2REL: Converts CIELAB values relative to a perfect diffuser to corresponding 
% values relative to media white.
%
% Example: Lab2 =abs2rel(Lab2,[96.42,100,82.49]);
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.1
%   date:  	   17-01-2001
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


if nargin>2
   rwhite=illuminant;
else
   rwhite=d(50);
end

XYZ=lab2xyz(Lab,rwhite);
Lab2=xyz2lab(XYZ,mwhite);
