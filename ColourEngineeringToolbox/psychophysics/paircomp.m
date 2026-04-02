function [zscores,conf]=paircomp(sum_scores,order,num_observers,labels)

% PAIRCOMP: Calculates z-scores and confidence intervals from
% pair comparison experiment data.
%
% Where a stimulus is preferred by all observers or no observers, 
% a substitute value is computed by logistic regression.
%
% See Engledrum, P. 'Psychometric Scaling', Imcotek Press, 2000;
% Morovic, J. (1998) To develop a universal gamut mapping algorithm, 
% PhD Thesis, University of Derby, UK
%
% Calls ploterror to display results as error bars with confidence intervals
%
% Example: [zscores,conf]=paircomp(sum_scores,order,num_observers,labels)
%
%   sum_scores is an nx1 vector containing the total number 
%   of times a stimulus was preferred
%
%   order is a nx2 vector of the positions of the stimuli
%   (can be output from the function pc_seq.m)
%
%   num_observers is the number of observers
%
%   labels is an optional argument which enables the error bar plot to be
%   labelled with the names of the stimuli being compared
%   date:      20-07-2002
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.2
%   date:  	   22-05-2006
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


n=size(sum_scores,1); % number of comparisons
s=ceil((2*n)^0.5); % number of stimuli
opps=num_observers-sum_scores; 

% Prepare frequency matrix from score data
fm=zeros(s);

%    use the locations in 'order' as indexes for the frequency matrix
for i=1:n;fm(order(i,2),order(i,1))=sum_scores(i);end 
%    add the cells from the opposing scores
for i=1:n;fm(order(i,1),order(i,2))=opps(i);end

pm=fm/num_observers; % proportion matrix

% calculate inverse of normal distribution
zm=erfinv(2*pm-1).*2^0.5;

% insert Inf or NaN where p <= 0 or p >= 1
zm(pm==0)=-inf;
zm(pm==1)=inf;
zm(pm<0|pm>1)=nan;

% calculate logistic matrix
lgm=log((fm+0.5)./(num_observers-fm+0.5));

% get indices of proportion matrix = 0|1
j=find(pm==0|pm==1);
k=find(pm~=0&pm~=1);

% find scaling factor by least squares regression
% and substitute logistic values into z-scores in cases 
% where a stimulus was preferred by all observers or no observers
sf=lgm(k)\zm(k);
zm(j)=lgm(j)*sf;

% find mean z-score for each stimulus (removing diagonal)
zscores=(sum(zm)-diag(zm)')./(s-1); 

% calculate confidence intervals
conf=1.96*(1/2^0.5)/num_observers^0.5; 

if nargin>3
   zlabels=labels;
else
   for i=1:s
      zlabels{i}=num2str(i);
   end
end

% plot the results
ploterror(zscores,conf,zlabels)
