function [S,b,u]=catjudge(scores)

% CATJUDGE: calculates interval scale from category judgement data
% applying Torgerson's Law of Category Judgement (Case D)
% and using method described in: 
% Engledrum, P. 'Psychometric Scaling', Imcotek Press, 2000, pp131-134.
%
% Output data are interval scale scores, category boundaries and 
% 95% confidence interval.
%
% Example: [S,b,u]=catjudge(K)
% where K is an n by m matrix, whose rows correspond to the samples,
% whose columns correspond to the categories, and whose data is the
% frequency with which a given judgement category was selected by 
% observers for each sample.
%
% plotcaterror.m is called to plot resulting interval scores 
% with confidence intervals and category boundaries. To add category 
% labels to the plot, call the function independently using the syntax:
% plotcaterror(zscores,errors,boundaries,labels)
%
% The confidence interval is determined using the Student's t
% distribution to estimate the population standard deviation
% from the sample standard deviation. If the argument 'std' is used, 
% the sample standard deviation is used instead.
% Example: [S,b,c]=catjudge(K,'std');
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.1
%   date:      20-07-2002
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


[n,c]=size(scores); % number of samples and categories
m=c-1; % number of category boundaries
o=sum(scores,2); % number of observers
C=triu(ones(c));

phi=scores*C; %cumulative frequency matrix
P=phi./repmat(o,1,c); % proportion matrix
P(:,c)=[]; %eliminate final column of 1s
z=normsinv(P); % z-scores (normal deviates)

% set up X matrix
q=eye(m);
for i=1:m
   X1(1+(i-1)*n:(i-1)*n+n,:)=repmat(q(i,:),n,1);
end
X2=repmat(-eye(n),m,1);
X=[X1,X2];
X(m*n+1,m+1:m+n)=1;

% create vector of z scores and remove rows z=inf (+/-)
V=[z(:);0];
h=isinf(V);V(h)=[];X(h,:)=[];

% test size of vector V
if length(V)<(m+n+1)
   error('Incomplete proportion matrix: there are too many zeros to generate a valid estimate of scale values')
end

Y=(X'*X)\X'*V; % least-squares solution
b=Y(1:m);      % category boundaries
S=Y((m+1):end); % scale values

if nargin==2 && tdist==0
   n=[2,5,10,20,30];t=[4.3,2.45,2.2,2.08,1.96];
   sig=interp1(n,t,mean(o)); % calculate using population standard deviation
else sig=1.96;
end

u=sig*(1/2^(1/2))/o(1)^(1/2); % 95% confidence interval

% plot results
plotcaterror(S,u,b)
