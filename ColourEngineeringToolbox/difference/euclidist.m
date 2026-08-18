function D=euclidist(data1,data2)
% EUCLIDIST: Euclidean distance between two points in 1-3 dimensions
%
%   Colour Engineering Toolbox
%   author:	Phil Green
%   version:	1.1
%   date:	17-01-2001
%   book:	https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136
%   web:     	http://www.digitalcolour.org

if ~isequal(size(data1),size(data2))
    error('ColourEngineeringToolbox:euclidist:DimensionMismatch', ...
        'Input coordinates have different dimensions.');
end

c1=size(data1,2);
if c1==1
   D=abs(data1-data2);
elseif c1==2
   D=((data1(:,1)-data2(:,1)).^2+(data1(:,2)-data2(:,2)).^2).^0.5;
elseif c1==3
   D=((data1(:,1)-data2(:,1)).^2+(data1(:,2)-data2(:,2)).^2+(data1(:,3)-data2(:,3)).^2).^0.5;
else
    error('ColourEngineeringToolbox:euclidist:UnsupportedDimensions', ...
        'Euclidean distance requires one to three coordinates.')
end
