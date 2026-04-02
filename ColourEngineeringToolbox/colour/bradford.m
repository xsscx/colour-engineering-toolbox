function XYZr=bradford(XYZs,XYZws,XYZor,degree)

%BRADFORD: Calculates tristimulus values under reference adapting field
%using the BFD chromatic adaptation transform.
%
%Algorithm according to Hunt, R. W. G. 'Reversing the Bradford chromatic 
%adaptation transform', Colour Research and Application 22 pp355-356
%
%Example: XYZr=Bradford(XYZws,XYZor,XYZs)
%
%The subscripts ws,or denote the tristimulus values of the 
%source white under source conditions and reference white under
%reference conditions respectively; and the subscript s denotes the 
%tristimulus values of the colour being transformed.
%
%The degree of adaptation is an optional fourth argument;
%complete adaptation (D=1.0) is assumed if no argument is supplied
%
%   Colour Engineering Toolbox
%   author:	Phil Green
%   version:	1.1
%   date:	17-01-2001
%   book:	https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136
%   web:    http://www.digitalcolour.org

%define Bradford matrix (Lam & Rigg) and its inverse
M=[0.8951,0.2664,-0.1614;-0.7502,1.7135,0.0367;0.0389,-0.0685,1.0296];
Minv=[0.98699,-0.14705,0.15996;0.43231,0.51836,0.04929;-0.00853,0.04004,0.96849];

%set the degree of adaptation
if nargin>3
   D=degree;
else
   D=1;
end
%_____________________________________________________________


%Calculate RGB cone responses for the three sets of XYZ
RGBws=M*(XYZws'./XYZws(2));
RGBor=M*(XYZor'./XYZor(2));

Xs=XYZs(:,1);Ys=XYZs(:,2);Zs=XYZs(:,3);
Ys(Ys==0)=eps;
RGBs=(M*[Xs./Ys,Ys./Ys,Zs./Ys]')';

%calculate cone responses for the colour under 
%reference adapting conditions
Wr=D*RGBor(1)/RGBws(1)+1-D;  %pre-divide the source and reference white
Wg=D*RGBor(2)/RGBws(2)+1-D;
p=(RGBws(3)/RGBor(3))^0.0834;
Wb=D*RGBor(3)/(RGBws(3)^p)+1-D;

Rs=RGBs(:,1);Gs=RGBs(:,2);Bs=RGBs(:,3);
Rr=Wr*Rs;
Gr=Wg*Gs;
Br=Wb*abs(Bs).^p;

j=find(Bs<0);
if ~isempty(j)
   Br(j)=-Wb.*abs(Bs(j)).^p;
end

%calculate XYZ under reference adapting conditions using
%the inverse Bradford matrix
XYZr=(Minv*[Rr.*Ys,Gr.*Ys,Br.*Ys]')';
