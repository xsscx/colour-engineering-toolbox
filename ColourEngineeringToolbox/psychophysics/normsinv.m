function x = normsinv(p,m,sig)

% NORMSINV: Inverse of the normal cumulative distribution function.
%   
% Example: X = normsinv(p,mu,sigma)
% where mu is the mean and sigma the standard deviation of p
%
% mu and sigma have default values 0 and 1 respectively.
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.1
%   date:  	   17-01-2001
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


if nargin>1;mu=m;else mu=0;end
if nargin>2;sigma=sig;else sigma=1;end

% calculate inverse
x=erfinv(2*p-1).*2^0.5*sigma+mu;

% insert Inf or NaN where p <= 0 or p >= 1
x(p==0)=-inf;
x(p==1)=inf;
x(p<0|p>1)=nan;

