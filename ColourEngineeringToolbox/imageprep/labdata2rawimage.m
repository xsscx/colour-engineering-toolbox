function labdata2rawimage(data,filename,bitdepth)
% LABDATA2RAWIMAGE: Writes CIELAB data to Raw format image files in either 
% 8 or 16 bit precision.
% 
% CIELAB data should be in columns, one column each for L*, a* and b*.
% The function offsets and scales the data for 8 or 16 bit unsigned 
% integer encoding as required. Using 16-bit precision minimises rounding
% errors.
%
% Example:
% labdata2rawimage(LAB,'labdata.raw') writes the data in LAB to an 8-bit
% file
% 
% labdata2rawimage(LAB,'labdata.raw',16) writes the data in LAB to a 16-bit
% file
% 
% Raw files generated using this function can be opened in Photoshop by
% selecting the following options:
% Channels: 3
% Interleaved: No
% Header: 0
% Depth: 8 or 16 bits
% Byte order: IBM (if 16-bit)
%
% Ensure that you know the pixel dimensions of the image, as Photoshop is
% unable to determine these from the file.
%
% To interpret the channels in Photoshop they must be assigned to CIELAB 
% after opening. This can be done in Photoshop by doing 
% Image..Mode..Multichannel and then Image..Mode..LAB
%
% Lab data saved to a .raw file using labdata2rawimage can be re-opened in
% Matlab using the function rawimage2labdata.
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.2
%   date:  	   23-07-2007
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


c=size(data,2);
if c~=3
   error('LAB data must be in 3 columns')
end
   
LAB_L=data(:,1);
LAB_a=data(:,2);
LAB_b=data(:,3);

% do LAB offset and scaling
if nargin> 2 && bitdepth==16
    L=uint16(round(LAB_L*65535/100));
    a=uint16(round((LAB_a+128)*257));
    b=uint16(round((LAB_b+128)*257));
    precision='uint16';
else
   L=uint8(round(LAB_L*(255/100)));
   a=uint8(round(LAB_a+128));
   b=uint8(round(LAB_b+128));
   precision='uint8';
end

% now write the file at the selected precision
fid=fopen(filename,'wb');
fwrite(fid,[L,a,b],precision);
status=fclose(fid);
if status<0
    error('Could not close file')
end
 