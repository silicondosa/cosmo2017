clear;
    size = 11;

    variance = 8.3^2;
    B=.9;
    Bamp = .0015;


    
    threshold1 = [8.9*ones(1,720) 8.9*ones(1,720) 8.9*ones(1,1200)];
for s=1:6
                [~, ~, angle1] = simulateModelNoThreshold(threshold1, variance, B, Bamp);
                blockAngle1 = reshape(angle1, 240, 11);
                std1 (s,:) = iqr(blockAngle1,1)';
                for d=1:11
                    [c, lags] = xcorr(detrend(blockAngle1(:,d)), 1, 'coeff');
                    acf1(s,d) = c(1);
                end
           


    threshold2 = [8.9*ones(1,720) 4.4*ones(1,720) 8.9*ones(1,1200)];
    
                [~, ~, angle2] = simulateModelNoThreshold(threshold2, variance, B, Bamp);
                blockAngle2 = reshape(angle2, 240, 11);
                std2 (s,:) = iqr(blockAngle2,1)';
                for d=1:11
                    [c2, lags2] = xcorr(detrend(blockAngle2(:,d)), 1, 'coeff');
                    acf2(s,d) = c(1);
                end
end
    figure;plot(1:1:11,mean(std1),1:1:11,mean(std2));legend('Constant Group','Changing Group');





