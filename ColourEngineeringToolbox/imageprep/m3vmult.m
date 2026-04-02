function output=m3vmult(M,data)

% M3VMULT Performs matrix multiplication on a 3x3 matrix and 
% each row of a nx3 vector.
%
% Assumes input data is in columns
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.1
%   date:  	   17-01-2001
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


if ischar(data)
   ABC=dlmread(data,'\t');
elseif isnumeric(data)
   ABC=data;
else
   error('No valid input data to m3vmult')
end

output=(M*ABC')';



