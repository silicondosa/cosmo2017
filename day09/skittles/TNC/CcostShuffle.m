load EA.mat;

AVD=Data{3,4}(:,2:4);
xtarget=-.6;ytarget=.6;
shuffleTime=100;
for s=1:shuffleTime
shuffleAVD=[];mindist=[];
shuffleAVD(:,1)=AVD(randperm(size(AVD,1)),1);
shuffleAVD(:,2)=AVD(:,2);
for i=1:size(AVD,1)
[mindist(i)] = execution2result_polar(shuffleAVD(i,1),shuffleAVD(i,2),xtarget,ytarget);
end
shuffleError(s) = mean(mindist);
end
[Actual, Ideal, Cost] = covariationCost(0,AVD,xtarget,ytarget);
actualError = mean(AVD(:,3));
idealError = actualError-Cost;

figure; xticks([1 2 3]); xticklabels({'Error','Ideal Error','Shuffle Error'});
xlim([.5,3.5]);ylabel('Error (m)');hold on;
scatter(1,actualError,50,'k','filled');hold on;
scatter(2,idealError,50,'b','filled');hold on;
scatter(ones(1,shuffleTime)*3,shuffleError,50,'b');