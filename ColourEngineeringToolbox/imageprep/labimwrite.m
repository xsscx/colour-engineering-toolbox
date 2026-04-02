function labimwrite(data,imagename)
% LABIMWRITE: Writes an image in 8-bit CIELAB to an 8-bit RGB TIFF file.
% The image data is offset and scaled so that it can be opened as RGB.
% To correctly interpret the channels they must be assigned to CIELAB after opening.
% This can be don in Adobe Photoshop by % doing Image..Mode..Multichannel 
% and then Image..Mode..LAB
%
% Calls MatLab function imwrite.m to write uint8 tiff image.
% For help on the use of imwrite, including supported data types,
% type 'help imwrite'
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.1
%   date:  	   17-01-2003
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


%define image filename and open image
l=length(imagename);
if strcmp(imagename((l-3):l),'.tif');
   imagename((l-3):l)=[];
end
filename=strcat(imagename,'.tif');

L=data(:,:,1);
ab=data(:,:,2:3);

% offset and scaling
L2=uint8(round(L*(255/100)));
ab2=uint8(round(ab+128));

image(:,:,1)=L2;
image(:,:,2:3)=ab2;
imwrite(image,filename)