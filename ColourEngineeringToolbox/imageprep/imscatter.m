function imscatter(lab,markercolour)
% IMSCATTER: plots a 3D scatter diagram of CIELAB data
%
% Example: imscatter(lab) where lab is a nx3 matrix of CIELAB data
% 
% The scatter diagram is presented initially in projection, rotate to
% obtain the desired view angle.
%
% By default the markers are colored with a representation of the CIELAB
% colour. To obtain a plot in a uniform colour, you can specify the desired colour
% Example: imscatter(lab,'k') colours the markers black. See the Matlab
% help on 'Colorspec' for the colour specification.
% 
% This function is intended primarily for plotting the gamut of test charts. 
% Plotting individual scatter points can be very slow, so avoid using this 
% function on large images.
%
% If the resulting plot is saved as a vector graphic (e.g. '.eps' file
% format), it will render slowly when subsequently opened or printed.
% Convert to a raster format to speed the rendering.
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.0
%   date:  	   17-05-2006
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


% compute rgb
rgb=xyz2srgb(lab2xyz(lab))./255;

% initialise figure and plot each scatter point with corresponding colour
figure; hold on
if nargin==1
for i=1:length(lab)
    scatter3(lab(i,2),lab(i,3),lab(i,1),5,'filled','MarkerFaceColor',rgb(i,:));
end
else
    scatter3(lab(:,2),lab(:,3),lab(:,1),5,'filled',markercolour);
end
set(gca,'XLim',[-100,100]);
set(gca,'YLim',[-100,100]);
set(gca,'ZLim',[0,100]);

line([100,-100],[0,0],'LineWidth',2,'Color','k')
line([0,0],[100,-100],'LineWidth',2,'Color','k')
line([0,0],[0,0],[0,100],'LineWidth',2,'Color','k')

