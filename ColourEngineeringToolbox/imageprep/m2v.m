function V = m2v(data)
% M2V: Converts rxcxn matrix of colour data to n columns. 
% The order of the data in the resulting columns is r1,r2,...rn
%
% Example: M2V(CMY) where CMY is a 3D matrix 
% arranged row x column x colour.
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.1
%   date:  	   17-01-2001
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


% Input matrix and get size
LMN=data;
[r,c,n]=size(LMN);

% Prepare empty matrix
V=zeros(r*c,n);

% Transpose and reshape to vectors
for i=1:n
   L=LMN(:,:,i);
   Lt=L';
   V(:,i)=Lt(:);
end
