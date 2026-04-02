function ploterror(Z,e,labels)
%
% PLOTERROR: Uses MatLab errorbar function to
% plot formatted error bar graph
%
% Example: Z=[1.5,0.25,-0.75,-0.5];e=0.3;
%          labels={'Test1','Test2','Test3','Test4'};
%          ploterror(Z,e,labels)
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.1
%   date:      24-05-2002
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


l=length(Z);
E=repmat(e,1,l);
errorbar(Z,E,'+k');

set(gca,'XTickLabel','');
set(gca,'XTick',[]);
set(gca,'XLim',[0.25,l+0.75]);

% modify Y axis scaling here or edit the plot manually
set(gca,'YLim',[-2.5,2.5]);
line([0.25,(l+0.75)],[0,0],'color','k');

yaxis=-2.75;
if nargin==3
   for i=1:l
      j=i;
      text(j-0.25,yaxis,labels(i));
   end
end
