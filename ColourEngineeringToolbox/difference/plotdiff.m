function plotdiff(equation,diffsize)
%PLOTDIFF: generates surface plot for a colour difference equation
%
% Example: plotdiff('cie94')
%
% By default, the surface plot is an intersection through the CIELAB solid
% at L* = 50 and a uniform difference of 3.5 CIELAB Delta E
%
% The form plotdiff(equation,L,diffsize) permits different values for L and
% Delta E to be used
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.3
%   date: 	   16-06-07
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136



if nargin>1
    diffs=diffsize;
else
    diffs=3.5;
end

L=50;

Lm=repmat(L,52,52);
a=[-128:5:128];b=a';
am=repmat(a,52,1);bm=repmat(b,1,52);

ac=am(:);
bc=bm(:);
Lc=Lm(:);
LAB1=[Lc,ac,bc];
LAB2=[Lc,ac+diffs,bc+diffs];

DE=feval(equation,LAB1,LAB2);
DE2=reshape(DE,52,52);

rgb=xyz2srgb(lab2xyz(LAB1));
surf(am,bm,DE2)