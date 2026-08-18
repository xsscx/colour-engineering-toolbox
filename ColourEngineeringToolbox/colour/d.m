function [XYZ,name]=d(K)
% D: returns XYZ tristimulus values of various CIE standard illuminants.
%
%        xyz=d(50) returns XYZ values for the D50 illuminant
%        xyz=d(55) returns XYZ values for the D55 illuminant
%        xyz=d(65) returns XYZ values for the D65 illuminant
%        xyz=d(75) returns XYZ values for the D75 illuminant
%        xyz=d('A') returns XYZ values for Illuminant A
%        xyz=d('C') returns XYZ values for Illuminant C
%
% 'D' with no arguments displays the tristimulus values of 
% all four D illuminants together with A and C illuminants.
%
% XYZ=D displays the values as above and returns the array
% of tristimulus values for all the illuminants
%
% [XYZ,name]=d(50) returns XYZ values for the D50 illuminant together
% with the string D50
%
% [XYZ,name]=d returns the XYZ values for all the illuminants together 
% with their names as a cell array of strings
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.1
%   date:  	   14-05-03
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


   A=[109.85,100,35.8];
   C=[98.07,100,118.23];
   D50=[96.42,100,82.49];
   D55=[96.68,100,92.14];
   D65=[95.04,100,108.89];
   D75=[94.96,100,122.62];
   allXYZ=[A;C;D50;D55;D65;D75];
   
   xyz=num2str(allXYZ,'%8.2f');
   labels=[' A    ';' C    ';' D50  ';' D55  ';' D65  ';' D75  '];
   all=[labels,xyz];

if nargin>0
   if (ischar(K) || (isstring(K) && isscalar(K)))
      switch upper(char(K))
      case 'A';XYZ=A;name='A';
      case 'C';XYZ=C;name='C';
      otherwise
         error('ColourEngineeringToolbox:d:InvalidIlluminant', ...
             'Illuminant must be A, C, 50, 55, 65, or 75.');
      end
   elseif isnumeric(K) && isscalar(K)
      switch K
      case 50;XYZ=D50;name='D50';
      case 55;XYZ=D55;name='D55';
      case 65;XYZ=D65;name='D65';
      case 75;XYZ=D75;name='D75';
      otherwise
         error('ColourEngineeringToolbox:d:InvalidIlluminant', ...
             'Illuminant must be A, C, 50, 55, 65, or 75.');
      end
   else
      error('ColourEngineeringToolbox:d:InvalidIlluminant', ...
          'Illuminant must be A, C, 50, 55, 65, or 75.');
   end
else
    if nargout>0;
        XYZ=allXYZ;
    else
        disp(all);
    end   
end   

if nargout>1
    if nargin==0
        name=labels;
    end
end

        
    
    