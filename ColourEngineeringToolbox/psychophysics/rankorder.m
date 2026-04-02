function [zscores,conf]=rankorder(raw_scores,labels)

% RANKORDER: Calculates z-scores and confidence intervals from
% rank order experiment data.
%
% Assumes that a 'proportion-of-preference' matrix of all possible
% comparisons is implied by the rank order data, and that z-scores
% can be calculated from this matrix as for a pair comparison experiment.
%
% See Cui, C. (2000) 'Comparison of two psychophysical methods for
% image color quality measurement: paired comparison and rank order'
% IS&T/SID 8th Color Imaging Conference, 222-227
%
% Prepares 'frequency-of-preference' matrix from raw rank order data
% Calls paircomp.m to calculate z-scores and confidence interval
% from the frequency-of-preference matrix
%
% Calls ploterror.m to display results as error bars with confidence intervals
%
% Example: [zscores,conf]=rankorder(raw_scores,labels,order)
%
%   raw_scores is an nxk matrix where n is the number of stimuli
%   and k is the number of observers
%
%   labels is a vector containing the names of the stimuli being compared
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.1
%   date:      24-08-2002
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


C=raw_scores;
[n,k]=size(C);   % number of stimuli and observers 
l=n*(n-1)/2;     % number of comparisons
m=pc_seq(n);     % generate pair comparison sequence
s=zeros(1,l);    % pre-allocate observer comparison vector
for h=1:k        % each observer
   for i=1:l     % each comparison
      if C(m(i,1),h)<C(m(i,2),h) 
         s(i)=1; % enter a 1 if the rank of A is less than the rank of B
         % (i.e. A is preferred over B)
      elseif C(m(i,1),h)==C(m(i,2),h)
         r=rand(1)>0.5;
         s(i)=r; % randomly assign equal choices
      else s(i)=0;
      end
   end
   S(:,h)=s';    % vector of pair comparisons for a single observer
end

scores=sum(S,2); % add the binary preferences to obtain the 
                 % vector of frequency-of-preference data
[zscores,conf]=paircomp(scores,m,k,labels);