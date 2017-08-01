%% real neurons
% This is a dataset from a monkey moving in a real experiment done to test
% decoding. Thanks to Lee  Miller and Jim Rebesco
load datasetReal

%% Fit the mean and std for p(N|Left) and p(N|Right) for each neuron
for i=1:size(X,2)
    muLeft(i) = mean(X(find(y==0),i));
    stdLeft(i) = std(X(find(y==0),i));
    muRight(i) = mean(X(find(y==1),i));
    stdRight(i) = std(X(find(y==1),i));
end

%% Classify

clear pNg* pLeft* pRight*
% X=X_test;
% y=y_test;

% For each trial calculate p(N|Left) and p(N|Right)
for i=1:size(X,1)       % each trial
    for j=1:size(X,2)   % each neuron
        pNgLeft(i,j)=1/(sqrt(2*pi)*stdLeft(j))*exp(-(X(i,j)-muLeft(j)).^2/(2*stdLeft(j)^2))*1000;  % the multiplication with a fixed constant has no effect ... done for numerical stability
        pNgRight(i,j)=1/(sqrt(2*pi)*stdRight(j))*exp(-(X(i,j)-muRight(j)).^2/(2*stdRight(j)^2))*1000;
        pLeftgN(i,j)=pNgLeft(i,j)./(pNgLeft(i,j)+pNgRight(i,j));
        pRightgN(i,j)=pNgRight(i,j)./(pNgLeft(i,j)+pNgRight(i,j));
    end
end

% Combine neurons...
for i=1:size(X,1)
    pLeft(i)=prod(pNgLeft(i,:));
    pRight(i)=prod(pNgRight(i,:));
end
pLeft = pLeft./(pLeft+pRight);
pRight = pRight./(pLeft+pRight);

% how good
percentCorrect=sum((pLeft<0.5)==y')/length(y)


