function lut_rows=extract3d(data,n)

% EXTRACT3D: returns the index entries of the bounding cube
% around input values for use in 3D look-up and interpolation.
%
% data is the rx3 matrix of input values in the range 0-1 and 
% n is the dimension of the uniformly-spaced look-up table
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.1
%   date:  	   30-06-03
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


% create vector of unique uniformly-spaced entries in LUT of dimension n
v=(0:1:n-1).*1/(n-1);

% find the index in v for the lower value relative to input data
% for each channel

r=size(data,1);
A=zeros(r,length(v));B=A;C=A; % preallocate

% first channel
for i=1:length(v)-1;A(:,i)=data(:,1)>=v(i);end

% second channel
for i=1:length(v)-1;B(:,i)=data(:,2)>=v(i);end

% third channel
for i=1:length(v)-1;C(:,i)=data(:,3)>=v(i);end

% sum the logical arrays A, B and C row-wise to get the index entries
D=[sum(A,2),sum(B,2),sum(C,2)];

% call bounding_cube subfunction to return LUT row numbers
% from the indices D
lut_rows=bounding_cube(D,n);

function out=bounding_cube(lut_indices,lut_dim)

% BOUNDING_CUBE returns a matrix in which the columns of the rth row 
% specify the row numbers of the bounding cube of 8 LUT entries 
% surrounding the coordinate data(r,:)
%
% The vector D contains the indices of the LUT values below P 
% in each channel, and n is the dimension of the LUT
%
% The output matrix has rx8 values, where r is the number of rows in D 

D=lut_indices;
n=lut_dim;
r=size(D,1);

% find the row number p1 of lowest corner of bounding cube
N=[n^2,n,1];
p1=N*(D'-1)+1; % subtraction and addition of 1 required for 1-based indexing

% prepare vector of offsets from p1
v=[0,1,n,n+1,n^2,n^2+1,n^2+n,n^2+n+1];

% add v to p1 to locate the row indices of all 8 bounding corners 
out=repmat(p1',1,8)+repmat(v,r,1);
