function x=cmykdata2rawimage(data,filename)
% CMYKDATA2RAWIMAGE: Writes CMYK image data to Raw format image file.
%
% This function is useful when CMYK image data is to be saved to file, since Matlab does 
% not support CMYK data in the imwrite function.
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.1
%   date:  	   7-11-2006
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


c=size(data,2);

if c~=4
   error('the number of channels is incorrect for CMYK colour space')
end
   

fid=fopen(filename,'wb');
x=fwrite(fid,data,'uint8');
status=fclose(fid);
if status<0
    error('Could not close file')
end
 