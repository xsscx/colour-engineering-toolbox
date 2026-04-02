function anglediff = angle_diff(col1,col2)
%ANGLE_DIFF Calculates angular difference between two hue angles
%
% col1 or col2 can be a vector of values with which the other value is compared
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.1
%   date:  	   17-01-2001
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


anglediff=abs(col1-col2);
t=find(anglediff>180);
anglediff(t)=360-anglediff(t);
