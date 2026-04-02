function v=pc_seq(n,r)

% PC_SEQ: returns a set of indices to use as a sequence
% in a pair comparison experiment.
%
% Example: 
% v=pc_seq(n) generates all the pairs for the integers 1:n
%
% v=pc_seq(n,'r') generates a randomised matrix in place of 
% an ordered one.
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.1
%   date:      24-08-2002
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


j=(1:1:n);
k=repmat(j,n,1)-diag(j);
t=tril(k);T=t(t>0);
u=triu(k)';U=u(u>0);
v=[T,U];
if nargin>1
    if strcmp(r,'r')
        f=fliplr(v);   
        k=n*(n-1)/2;
        x=randperm(k); % set of random indices
        y=randperm(k);
        g=(2:2:2*floor(k/2));
        h=y(g);
        v(h,:)=f(h,:); % flip half the rows
        v=v(x,:);      % use x as index vector to shuffle the rows
    end   
end
