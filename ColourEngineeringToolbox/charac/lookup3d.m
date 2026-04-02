function out=lookup3d(input_data,output_table,input_table)

% LOOKUP3D: performs 3D table look-up on input data.
% Output value is calculated by trilinear interpolation on the values 
% in the output table, after extraction of the input table rows 
% corresponding to the bounding cube around each input point.
%
% input_data is the rx3 matrix of input values in the range 0-1
%
% output_table is the nx3 table of output values corresponding to 
% the entries in a uniformly-spaced input table.
%
% If no input table is supplied, a uniformly spaced table that is 
% in the range 0-1 and has the same dimension as the output table
% is assumed. In this case the input data must be in the range 0-1
%
% Example: XYZ=lookup3d(input_data,output_table)
% if no input table is supplied and the input data is in the range 0-1;
% or XYZ=lookup3d(input_data,output_table,input_table)
%
%   Colour Engineering Toolbox
%   author:    Phil Green (with input from Martin Spillane)
%   version:   1.1
%   date:  	   23-12-03
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


T=output_table;
r=size(T,1);n=round(r^(1/3));

if nargin>2
   % if an input table is supplied normalise the table and the 
   % input data to the range 0-1
	table=input_table;
	m=max(table); %	m=max(max(table)); ?
	Ti=table./m;
	data=[input_data(:,1)./m(1),input_data(:,2)./m(2),input_data(:,3)./m(3)];
else
   % if no input table is supplied, find dimension of output table 
   % and generate matching uniformly spaced input table
   Ti=create3dlut(n);
   if any(input_data<max(max(Ti)))
      error('Input data must be ranged 0-1 if no input table is supplied');
   else data=input_data;
   end
end

% get bounding cube around each point in data
lutrows=extract3d(data,n);P=lutrows;

% difference from input data to lower bounding corner in input table
d=data-Ti(P(:,1),:);
dx=d(:,1);dy=d(:,2);dz=d(:,3);

% difference between lower and upper bounding corners in input table
D=Ti(P(:,8),:)-Ti(P(:,1),:);
Dx=D(:,1);Dy=D(:,2);Dz=D(:,3);

% get interpolation weights and do trilinear interpolation for each channel
for j=1:3
	% calculate interpolation weights
	c1=T(P(:,1),j);
	c2=(T(P(:,5),j)-T(P(:,1),j))./Dx;
	c3=(T(P(:,3),j)-T(P(:,1),j))./Dy;
	c4=(T(P(:,2),j)-T(P(:,1),j))./Dz;
	c5=(T(P(:,7),j)-T(P(:,3),j)-T(P(:,5),j)+T(P(:,1),j))./(Dx.*Dy);
	c6=(T(P(:,6),j)-T(P(:,2),j)-T(P(:,5),j)+T(P(:,1),j))./(Dx.*Dz);
	c7=(T(P(:,4),j)-T(P(:,2),j)-T(P(:,3),j)+T(P(:,1),j))./(Dy.*Dz);
	c8=(T(P(:,8),j)-T(P(:,4),j)-T(P(:,6),j)-T(P(:,7),j)+T(P(:,5),j)...
	+T(P(:,2),j)+T(P(:,3),j)-T(P(:,1),j))./(Dx.*Dy.*Dz);

	% calculate the output value for the current channel
	out(:,j)=c1+c2.*dx+c3.*dy+c4.*dz+c5.*dx.*dy+c6.*dx.*dz...
	+c7.*dy.*dz+c8.*dx.*dy.*dz;
end

