clear;
load CD.mat
load D.mat;
xtarget=-.6;ytarget=.6;
for day=1:3
    for block=1:4

AVD = Data{day,block}(:,2:4);

[~, ~, TCost(day,block)] = toleranceCost(0,AVD,D);
[~, ~, NCost(day,block)] = noiseCost(0,AVD,xtarget,ytarget);
[~, ~, CCost(day,block)] = covariationCost(0,AVD,xtarget,ytarget);
    end
end

figure;plot(1:1:12,reshape(TCost',[],1),1:1:12,reshape(NCost',[],1),1:1:12,reshape(CCost',[],1));