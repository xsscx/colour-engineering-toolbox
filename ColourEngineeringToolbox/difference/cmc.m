function DE=cmc(LAB1,LAB2,K)
% CMC: Computes colour difference according to the CMC equation
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.1
%   date:  	   17-01-2001
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


%Set constants for weighting lightness and chroma relative to hue
if nargin>2
   if length(K)>1
      l=K(1);c=K(2);
   end
else
   l=1;c=1;
end
%_______________________________________________________

L1=LAB1(:,1);L2=LAB2(:,1);
a1=LAB1(:,2);a2=LAB2(:,2);
b1=LAB1(:,3);b2=LAB2(:,3);
C1=(a1.^2+b1.^2).^0.5;C2=(a2.^2+b2.^2).^0.5;
h1=hue_angle(a1,b1);h2=hue_angle(a2,b2);

%calculate difference components
Dh=angle_diff(h1,h2);
DL=abs(L1-L2);
DC=abs(C1-C2);
rad=pi/180;
DH=2*((C1.*C2).^0.5.*sin(rad*(Dh)/2));

%parameters f, T
f=((C1.^4)./(C1.^4+1900)).^.5;
T=0.56+abs(0.2*cos(rad*(h1+168)));
j=find(h1>=345|h1<=164);
T(j)=0.36+abs(0.4*cos(rad*(h1(j)+35)));

%weighting function for lightness
SL=0.040975*L1./(1+0.01765*L1);
k=L2<16;
SL(k)=0.511;

%weighting functions for chroma and hue
SC=0.0638*C1./(1+0.0131*C1)+0.638;
SH=SC.*(f.*T+1-f);

%calculate CMC colour difference
DE=((DL./(SL*l)).^2+(DC./(SC.*c)).^2+(DH./SH).^2).^.5;