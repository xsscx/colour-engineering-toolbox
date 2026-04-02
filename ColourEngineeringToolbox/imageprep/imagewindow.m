function T=imagewindow(imagefilename,num_patches,patch_fraction)
% PATCHIMAGE2DATA: Filters a patch image by discarding regions around an 
% array of centres within an image, and resamples to a single pixel per patch.
% Filtered image is written to file, and displayed for evaluation.
%
% T=imagewindow(imagefilename,num_patches,patch_fraction)
% where num_patches is a 1x2 vector containing the number of rows 
% and columns of the final patch image, and patch_fraction is 
% the fraction of each patch to be retained.
%
% Example: T=('IT873Image.tif',[38,26],0.7);
%
% If patch_fraction is empty, a default of 0.6 is used.

A=imread(imagefilename);
outfilestem=imagefilename(1:length(imagefilename)-4);

[r,c,p]=size(A);
if nargin>2
	pfract=patch_fraction/2;
else
	pfract=0.3;
end

% Create vectors of patch centres and offsets from centres
pixelsx=num_patches(1);
pixelsy=num_patches(2);
patchsizey=r/pixelsx;
patchsizex=c/pixelsy;
pixelcentresx=((patchsizex/2):patchsizex:(c-patchsizex/2));
pixelcentresy=((patchsizey/2):patchsizey:(r-patchsizey/2));
pixeloffsetsx=floor([pixelcentresx-patchsizex(1)*pfract;pixelcentresx+patchsizex*pfract]);
pixeloffsetsy=floor([pixelcentresy-patchsizey*pfract;pixelcentresy+patchsizey*pfract]);

% Create a vector containing all the row indices to be retained
poy=pixeloffsetsy';
vy=(0:poy(1,2)-poy(1,1)-1);
Vy=repmat(vy,pixelsx,1);
cvy=size(Vy,2);
Py=repmat(poy(:,1),1,cvy);
PY=Py+Vy;
ay=PY';by=ay(:);

% Create a vector containing all the column indices to be retained
pox=pixeloffsetsx';
vx=(0:pox(1,2)-pox(1,1)-1);
Vx=repmat(vx,pixelsy,1);
cvx=size(Vx,2);
Px=repmat(pox(:,1),1,cvx);
PX=Px+Vx;
ax=PX';bx=ax(:);

% Filter using indices
T1=A(by,:,:);T=T1(:,bx,:);

% Display the resulting image
image(T);

% Resample
% First add pixels all round
[rt,ct,pt]=size(T);
px=floor(patchsizex/2);
py=floor(patchsizey/2);
T2=ones(rt+2*px,ct+2*py,3);T2(:,:,:)=128;
T2((px+1):(rt+px),(py+1):(ct+py),1)=T(:,:,1);
T2((px+1):(rt+px),(py+1):(ct+py),2)=T(:,:,2);
T2((px+1):(rt+px),(py+1):(ct+py),3)=T(:,:,3);

% Resize and display
W=imresize(T2,[pixelsx+2,pixelsy+2],'bicubic');
[rw,cw,pw]=size(W);
W(rw,:,:)=[];W(1,:,:)=[];
W(:,cw,:)=[];W(:,1,:)=[];
W(W<0)=0;W(W>255)=255;

w=W/255;figure;image(w);

% Write data to text file
outfilename=strcat(outfilestem,'_windowed.txt');
dlmwrite(outfilename,m2v(W),'\t');
