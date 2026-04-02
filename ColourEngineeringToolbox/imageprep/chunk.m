function data2=chunk(functionname,data,varargin)

% CHUNK: passes a subset of data into the requested function 
% and displays a progress bar.
%
% Up to four additional input arguments can be passed in.
%
% Example: data_out=chunk(function, data, arg1, arg2, arg3);
%
% Use CHUNK to avoid memory overload and to speed processing.
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.3
%   date: 	   23-12-03
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


% default chunk size; adjust as necessary
chunk_size=1000;  

%_____________________________________________________________

% get the size of the data array
[r,c,p]=size(data);

% get the number of input arguments
v=length(varargin);

% preallocate output matrix
data2=ones(r,c,p);

% divide by chunk_size to get the number of chunks to be processed 
chunks=ceil(r/chunk_size);
disp(chunks,' chuncks')
msg=strcat('Processing...',functionname);
h=waitbar(0,msg);

% no input arguments...
if nargin==2
if chunks==1
   %if the data set is <= chunk_size
   data2=feval(functionname,data); 		
else
   for i=1:chunks            %otherwise process a chunk at a time
      waitbar(i/chunks,h)
      j=i-1;
      if i==chunks;thischunk_size=r-(chunks-1)*chunk_size;
      else thischunk_size=chunk_size;end
      data2((j*chunk_size+1):(j*chunk_size+thischunk_size),:)=feval...
      (functionname,data((j*chunk_size+1):(j*chunk_size+thischunk_size),:));
   end
end
end

% case of the number of input arguments
switch v

case 1
if chunks==1
   %if the data set is <= chunk_size
   data2=feval(functionname,data,varargin{1}); 		
else
   for i=1:chunks            %otherwise process a chunk at a time
      waitbar(i/chunks,h)
      j=i-1;
      if i==chunks;thischunk_size=r-(chunks-1)*chunk_size;
      else thischunk_size=chunk_size;end
      data2((j*chunk_size+1):(j*chunk_size+thischunk_size),:)=feval...
      (functionname,data((j*chunk_size+1):(j*chunk_size+thischunk_size),:),...
      varargin{1});
   end
end

case 2
if chunks==1
   % if the data set is <= chunk_size
   data2=feval(functionname,data,varargin{1},varargin{2}); 
else
   for i=1:chunks            %otherwise process a chunk at a time
      waitbar(i/chunks,h)
      j=i-1;
      if i==chunks;thischunk_size=r-(chunks-1)*chunk_size;
      else thischunk_size=chunk_size;end
      data2((j*chunk_size+1):(j*chunk_size+thischunk_size),:)=feval...
      (functionname,data((j*chunk_size+1):(j*chunk_size+thischunk_size),:),...
      varargin{1},varargin{2});
   end
end

case 3
if chunks==1
   %if the data set is <= chunk_size
   data2=feval(functionname,data,varargin{1},varargin{2},varargin{3}); 
else
   for i=1:chunks            %otherwise process a chunk at a time
      waitbar(i/chunks,h)
      j=i-1;
      if i==chunks;thischunk_size=r-(chunks-1)*chunk_size;
      else thischunk_size=chunk_size;end
      data2((j*chunk_size+1):(j*chunk_size+thischunk_size),:)=feval...
      (functionname,data((j*chunk_size+1):(j*chunk_size+thischunk_size),:),...
      varargin{1},varargin{2},varargin{3});
   end
end

case 4
if chunks==1
   %if the data set is <= chunk_size
   data2=feval(functionname,data,varargin{1},varargin{2},varargin{3},varargin{4}); 
else
   for i=1:chunks            %otherwise process a chunk at a time
      waitbar(i/chunks,h)
      j=i-1;
      if i==chunks;thischunk_size=r-(chunks-1)*chunk_size;
      else thischunk_size=chunk_size;end
      data2((j*chunk_size+1):(j*chunk_size+thischunk_size),:)=feval...
      (functionname,data((j*chunk_size+1):(j*chunk_size+thischunk_size),:),...
      varargin{1},varargin{2},varargin{3},varargin{4});
   end
end

end
close(h)
