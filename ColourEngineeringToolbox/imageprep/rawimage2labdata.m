function lab_data=rawimage2labdata(filename,bitdepth)
% RAWIMAGE2LABDATA Reads an 8 or 16 bit image file in .raw format, CIELAB 
% colour space, with appropriate scaling of L,a,b channels
%
% Example:
% LAB=rawimage2labdata('labdata.raw') opens the file as  8-bit  
% 
% LAB=rawimage2labdata('labdata.raw',16) opens the file as 16-bit
% 
% Raw files for opening using this function can be saved in Photoshop by
% File, Save, .raw format, selecting the following options:
% Header: 0
% Channels: Non-interleaved
% Byte order: IBM (if 16-bit)
%
% Lab data can be re-saved to a .raw file in Matlab using the function labdata2rawimage
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.2
%   date:  	   23-07-2007
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


fid=fopen(filename,'r');

% do LAB offset and scaling
if nargin>1 && bitdepth==16
      A=fread(fid,'uint16');
      data=reshape(A,length(A)/3,3);
      L=data(:,1)*(100/65535);
      ab=data(:,2:3)./257-128;    
else
      A=fread(fid,'uint8');
      data=reshape(A,length(A)/3,3);
      L=data(:,1)*(100/255);
      ab=data(:,2:3)-128;
end

if mod(length(A),3)~=0
    error('Number of pixels does not correspond to the 3 colour channels for CIELAB data')
end

fclose(fid);
lab_data=[L,ab];

