function plotcaterror(zscores,errors,boundaries,labels)
%
% PLOTCATERROR: Uses MatLab errorbar function to
% plot formatted error bar graph with category boundaries
%
% Example: Z=[1.5,0.25,-0.75,-0.5];e=0.3;
%          labels={'Test1','Test2','Test3','Test4'};
%          plotcaterror(Z,e,labels)
%
% Depending on values of Z, axis scaling may need to be modified
% inside the function or by editing the resulting plot
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.1
%   date:      24-05-2002
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


b=boundaries;Z=zscores;e=errors;
l=length(Z);
E=repmat(e,1,l);
errorbar(Z,E,'+k');

set(gca,'XTickLabel','');
set(gca,'XTick',[]);
set(gca,'XLim',[0.25,l+0.75]);

%% modify Y axis scaling here or edit the plot manually
set(gca,'YLim',[-2.5,2.5]);

for i=1:length(b)
   line([0.25,(l+0.75)],[b(i),b(i)],'color','b');
end

if nargin>3
   yaxis=-2.25;   
   for i=1:l
      j=i;
      text(j-0.25,yaxis,labels(i));
   end
end
