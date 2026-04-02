function LMN = polyconvert3(data,coefs)
% POLYCONVERT3 Polynomial conversion between two colour spaces  
% using characterization cofficient matrix
%
% Calls polymat3 to prepare terms in polynomial
%
% Example: polyconvert3('Lab.dat','coeffs.dat')
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.1
%   date:  	   17-01-2001
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


%Transpose coefficient matrix
coefmat=coefs';

%chunk the polymat calculation to avoid memory overload
l=length(data);
chunks=ceil(l/100000);
if chunks>1
   for i=1:chunks
      j=i-1;
      if i==chunks;chunk_size=l-(chunks-1)*100000;
      else chunk_size=100000;end
     %Form polynomial matrix
     polymat=polymat3(data((j*100000+1):(j*100000+chunk_size),:));
      LMN((j*100000+1):(j*100000+chunk_size),:)=(coefmat*polymat)';   
   end
else
   polymat=polymat3(data);
   LMN=(coefmat*polymat)';
end


