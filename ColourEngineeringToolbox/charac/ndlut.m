function LUT=ndlut(nodes,channels)

% NDLUT: creates a uniform n-dimensional table for nD look-up 
% in which the first dimension varies most slowly and the last 
% dimension varies fastest.
%
% LUT entries are uniformly spaced from 0 to 1 in each dimension.
%
% The argument 'nodes' is the number of nodes in each dimension
%
% The argument 'channels' is the number of colours
% If the number of channels is not specified, it is assumed to be 3.
%
% E.g. ndlut(7) creates a LUT with 7 nodes in each dimension,
% corresponding to a 7x7x7 table.
%
% The number of LUT entries in each dimension will be nodes^channels.
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.1
%   date:  	   16-11-2004
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


% check that n is an integer greater then 1
if round(nodes)/nodes~=1||nodes<=1
   error('The number of nodes must be an integer greater than 1');
else
   n=nodes;
end

% check the number of channels
if nargin>1
   if round(channels)/channels~=1||channels<=0
      error('The number of channels must be a positive integer');
   else
      c=channels;
   end
else
   c=3;
end

%initialise LUT
for i=1:c
   LUT(:,i)=zeros(n^c,1);
end

% loop to generate LUT values
for m=1:c
   for i=1:n;
      j=i-1;
      D((j*n^(c-m)+1):(j+1)*n^(c-m))=j/(n-1);
   end;
   LUT(:,m)=repmat(D,1,n^(m-1))';
   clear D;
end 

