function DE=ciede2000(LABREF,LAB,K)

% CIEDE2000 calculates colour difference between a reference and sample 
% using CIEDE2000 colour difference (as defined in Luo, Cui and Rigg (2000))
%
% Input data can be single values or multiple values arranged in columns
% LABREF can be a single value while LAB is a column
%
% Parametric weighting factors, if used, should be supplied either as a vector of
% 2 values (kH is then set to 1) or as a vector of three values.
% Example:
%   DE=ciede2000(labref,labsample,[1.5,1.2,0.8]);
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.1
%   date:  	   17-01-2001
%   updated:   29-8-2007
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


% set the values of parametric weighting factors KL,KC,KH

if nargin>2
   if ~isnumeric(K) || ~isvector(K) || ~ismember(numel(K),[2 3]) || ...
         any(~isfinite(K)) || any(K<=0)
       error('ColourEngineeringToolbox:ciede2000:InvalidWeights', ...
           'K must be a vector of two or three positive finite values.');
   elseif length(K)==3
       kL=K(1);kC=K(2);kH=K(3);
   else
       kL=K(1);kC=K(2);kH=1;
   end
else
   kL=1;kC=1;kH=1;
end

L1=LABREF(:,1);a1=LABREF(:,2);b1=LABREF(:,3);
L2=LAB(:,1);a2=LAB(:,2);b2=LAB(:,3);

C1=sqrt(a1.^2+b1.^2);
C2=sqrt(a2.^2+b2.^2);
Cbar=(C1+C2)/2;
G=0.5*(1-sqrt(Cbar.^7./(Cbar.^7+25^7)));

a1p=(1+G).*a1;
a2p=(1+G).*a2;
C1p=sqrt(a1p.^2+b1.^2);
C2p=sqrt(a2p.^2+b2.^2);
h1p=mod(atan2d(b1,a1p),360);
h2p=mod(atan2d(b2,a2p),360);

DL=L2-L1;
DC=C2p-C1p;
Dh=h2p-h1p;
zero_chroma=(C1p.*C2p)==0;
Dh(zero_chroma)=0;
hue_wrap_threshold=180+eps(180);
Dh(Dh>hue_wrap_threshold)=Dh(Dh>hue_wrap_threshold)-360;
Dh(Dh<-hue_wrap_threshold)=Dh(Dh<-hue_wrap_threshold)+360;
DH=2*sqrt(C1p.*C2p).*sind(Dh/2);

Lbar=(L1+L2)/2;
Cbar=(C1p+C2p)/2;
hbar=(h1p+h2p)/2;
hue_difference=abs(h1p-h2p);
hbar(zero_chroma)=h1p(zero_chroma)+h2p(zero_chroma);
wrap=(~zero_chroma) & (hue_difference>hue_wrap_threshold);
sum_below_360=wrap & ((h1p+h2p)<360);
hbar(sum_below_360)=(h1p(sum_below_360)+h2p(sum_below_360)+360)/2;
hbar(wrap & ~sum_below_360)=(h1p(wrap & ~sum_below_360)+h2p(wrap & ~sum_below_360)-360)/2;

T=1-0.17*cosd(hbar-30)+0.24*cosd(2*hbar)+ ...
    0.32*cosd(3*hbar+6)-0.2*cosd(4*hbar-63);
SL=1+(0.015*(Lbar-50).^2)./sqrt(20+(Lbar-50).^2);
SC=1+0.045*Cbar;
SH=1+0.015*Cbar.*T;
Dt=30*exp(-((hbar-275)/25).^2);
RC=2*sqrt(Cbar.^7./(Cbar.^7+25^7));
RT=-sind(2*Dt).*RC;

lightness=DL./(kL*SL);
chroma=DC./(kC*SC);
hue=DH./(kH*SH);
DE=sqrt(lightness.^2+chroma.^2+hue.^2+RT.*chroma.*hue);
