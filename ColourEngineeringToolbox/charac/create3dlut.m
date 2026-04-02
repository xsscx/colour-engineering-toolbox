function LUT=create3dlut(nodes)

% CREATE3DLUT: creates a uniform 3-dimensional table for 3D look-up 
% in which the first dimension varies most slowly and the last 
% dimension varies fastest.
%
% LUT entries are uniformly spaced from 0 to 1 in each dimension.
% The argument 'nodes' is the number of nodes in each dimension
% E.g. create3DLUT(7) creates a LUT with 7 nodes in each dimension,
% corresponding to a 7x7x7 table.
%
% The number of LUT entries in each dimension will be nodes^3.
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.1
%   date:  	   06-01-2001
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


%check that n is an integer greater then 1
if round(nodes)/nodes~=1||nodes<=1
   error('The number of nodes must be an integer greater than 1');
else
   n=nodes;
end

%preallocate LUT
D1=zeros(n^3,1);
n2=n^2;
Da=zeros(1,n2);
Db=zeros(1,n);

%first dimension (slowest)
for i=1:n;j=i-1;D1((j*n2+1):(j+1)*n2)=j/(n-1);end;

%second dimension
for i=1:n;j=i-1;Da((j*n+1):(j+1)*n)=j/(n-1);end;
D2=repmat(Da,1,n)';

%third dimension (fastest)
for i=1:n;j=i-1;Db(i)=j/(n-1);end;
D3=repmat(Db,1,n2)';

LUT=[D1,D2,D3];