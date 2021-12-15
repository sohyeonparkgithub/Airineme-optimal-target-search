%% F4_main.m: Autocorrelation from experimental data, MLE best fit
% This script calls F4_likelihood.m function(Likelihood function)

% Sohyeon Park(sohyeop@uci.edu)

%------------ Experimental data---------------
load('experimentalData.mat')
%% Maximum likelihood estimation for optimum Dtheta

% ----------- Dtheta testing value -------------------------------
DthetaTestingValue = logspace(-3,0,1000); % all testing value
% DthetaTestingValue = 0.12:0.001:0.32; % smaller range for focused view

% ------------ Use MLE to find optimum Dtheta ------------------------
pcEqn = @(DthetaVal) F4_likelihood(sortedPair(:,1),sortedPair(:,2)-1e-14,DthetaVal); %call pcDtheta function
likelihoodFcn = @(DthetaVal) sum(log(pcEqn(DthetaVal)));
% likelihoodFcn = @(DthetaVal) prod(pcEqn(DthetaVal));
likelihoodDistribution = likelihoodFcn(DthetaTestingValue);
maxVal = max(likelihoodDistribution);
maxDtheta = find(maxVal == likelihoodDistribution);
optimum = DthetaTestingValue(maxDtheta)

% ---------- Corresponding persistence length lp
v = 4.5; % fixed velocity
lp = v/(2*optimum);
%%
% --------------- Plot ---------------------------------------
figure(1),clf;
hold on
box on
% grid on
plot(DthetaTestingValue,exp(likelihoodDistribution./1000),'r','LineWidth',2) %division by 1000 takes care of numerical error
xline(optimum)

set(gca,'xscale','log')

% ------ figure specifics ------------------------------------
figureSpecifics

hold off
% xlim([10^-3 10^0])
% set(gca,'xscale','log','yscale','log')
% set(gca,'yscale','log')
%xlabel('Angular diffusion, D_\theta')
%ylabel('Likelihood Distribution')

%% Moving mean of <cos(theta)> with autocorrelation function
maxXval = 250;
xPoints = 0:1:maxXval;

% ------------   Moving mean of <cos(theta)> -----------------------
windowSize = 10;
cosAngle_movingMean = movmean(sortedPair(:,2)-1e-14,windowSize);

% ------------- Plot ------------------------------------------------
figure(2), clf;
hold on
box on
% grid on

plot(sortedPair(:,1),cosAngle_movingMean,'b.');
plot(xPoints,exp(-xPoints./(2.*lp)),'LineWidth',2)
xlabel('contour length s (µm)')
ylabel('<cos\theta>','Rotation',0)
ylim([-1 1])
ll = legend('moving mean','MLE fit')
title('movine mean <cos\theta> and MLE <cos\theta> fit')

% ------ figure specifics ------------------------------------
figureSpecifics
hold off
%% Find likelihood region & confidence interval
% -------------------------------------------------------------------------
% About 14.65% of likelihood interval corresponds to 95 percent confidence
% interval.
% -------------------------------------------------------------------------
DthetaTestingValue = 0.12:0.001:0.32; % smaller range for focused view

% ------------ Use MLE to find optimum Dtheta ------------------------
pcEqn = @(DthetaVal) F4_likelihood(sortedPair(:,1),sortedPair(:,2)-1e-14,DthetaVal); %call pcDtheta function
likelihoodFcn = @(DthetaVal) sum(log(pcEqn(DthetaVal)));
% likelihoodFcn = @(DthetaVal) prod(pcEqn(DthetaVal));
likelihoodDistribution = likelihoodFcn(DthetaTestingValue);
maxVal = max(likelihoodDistribution);
maxDtheta = find(maxVal == likelihoodDistribution);
optimum = DthetaTestingValue(maxDtheta)

% ---------- Corresponding persistence length lp
v = 4.5; % fixed velocity
lp = v/(2*optimum);

% ------------ Find likelihood region -----------------------------------
leftIndex = 1;
rightIndex = 1;
LR_Left = 1;
LR_Right = 1;

% while (LR_Left > .1465)
while(LR_Left > 0.0694)
    LR_Left = likelihoodDistribution(maxDtheta-leftIndex)/likelihoodDistribution(maxDtheta);
    leftIndex = leftIndex + 1;
end

% while (LR_Right > .1465)
while(LR_Right > 0.0694)
    LR_Right = likelihoodDistribution(maxDtheta+rightIndex)/likelihoodDistribution(maxDtheta);
    rightIndex = rightIndex + 1;
end

leftDtheta = DthetaTestingValue(maxDtheta-(leftIndex-1));
rightDtheta = DthetaTestingValue(maxDtheta+(rightIndex-1));

% --------lower bound and upper bound for 90percent confidence interval
lowerBound = v/(2*leftDtheta);
upperBound = v/(2*rightDtheta);

maxXval = 250;
xPoints = 0:1:maxXval;

% ------------   Moving mean of <cos(theta)> -----------------------
windowSize = 10;
cosAngle_movingMean = movmean(sortedPair(:,2)-1e-14,windowSize);

% ------------- Plot ------------------------------------------------
figure(3), clf;
hold on
box on
% grid on

plot(sortedPair(:,1),cosAngle_movingMean,'.');
% values=hist3([sortedPair(:,1),cosAngle_movingMean]);
% imagesc(values)
h = fill([xPoints fliplr(xPoints)],[exp(-xPoints./(2.*lowerBound)) fliplr(exp(-xPoints./(2.*upperBound)))],'b')
set(h,'facealpha',.2)
plot(xPoints,exp(-xPoints./(2.*lp)),'r','LineWidth',2)
% xlabel('contour length s (µm)')
% ylabel('<cos\theta>','Rotation',0)
ylim([-1 1])
% legend('moving mean','90% CI','MLE fit')
ll = legend('','','')
set(gca,'Xticklabel',[])
set(gca,'Yticklabel',[])
% title('movine mean <cos\theta> and MLE <cos\theta> fit')
% ------ figure specifics ------------------------------------
figureSpecifics
%------------------------------------------------------------
hold off

%%
figure(4), clf;
hold on 
box on

histogram(sortedPair(:,1))
set(gca,'Xticklabel',[])
set(gca,'Yticklabel',[])
figureSpecifics
%%
figure(5), clf;
hold on 
box on

histogram(cosAngle_movingMean)
set(gca,'Xticklabel',[])
set(gca,'Yticklabel',[])
xlim([-1 1])
figureSpecifics
