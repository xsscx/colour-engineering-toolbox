function polymat = polymat3(data)
%POLYMAT3 Prepares third order matrix for input to polynomial 
%characterization or colour transformation 
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.1
%   date:  	   17-01-2001
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


col=data; %First-order terms
col2=col.^2; %Second-order terms
col3=col.^3; %Third-order terms

%First-order cross-products
colCross=[col(:,1).*col(:,2),col(:,1).*col(:,3),col(:,2).*col(:,3)];

%Second-order cross-products
col2Cross=[col2(:,1).*col(:,2),col2(:,1).*col(:,3),col2(:,2).*col(:,3),...
      col2(:,2).*col(:,1),col2(:,3).*col(:,1),col2(:,3).*col(:,2)];

colcol=(col(:,1).*col(:,2).*col(:,3)); %Triple cross-product

%Form matrix and transpose to matrix of size mxn where m is the total number of 
%terms in the polynomial
polymat=[col,col2,col3,colCross,col2Cross,colcol]';
