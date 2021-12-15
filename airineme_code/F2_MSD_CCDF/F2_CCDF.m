% F2_CCDF.m
% load ccdf_experimental.mat and generate ccdf plots

load('experimental_ccdf.mat')
%%
%-------------------------------- CCDF: 10 min interval

sortedVector = sort(stepSize_all_microns);
totalStep = length(sortedVector);
probVec = [];

for indStep = 1:totalStep
    prob = (totalStep-indStep)/totalStep;
    probVec = [probVec; prob];
end

figure(2)
clf;
hold all
box on; grid on;
plot(sortedVector,probVec,'o','color',[1 0 1])
set(gca,'xscale','log','yscale','log')


xlabel('x [µm]')
ylabel('P(step size > x)')
title('10 min interval')
%%
%------------------------------------ CCDF: 20 min interval
sortedVector2 = sort(stepSize_all_microns2); %total steps
totalStep2 = length(sortedVector2);
probVec2 = [];

for indStep = 1:totalStep2
    prob = (totalStep2-indStep)/totalStep2;
    probVec2 = [probVec2; prob];
end

figure(3)
clf;
hold all
box on; grid on;
plot(sortedVector2,probVec2,'o','color',[0.5 0 0.5])
set(gca,'xscale','log','yscale','log')


xlabel('x [µm]')
ylabel('P(step size > x)')
title('20 min interval')
%% CCDF plot combined (Final)

%---------------------------------------------------------------------------------------------------------------
% find slope of CCDF for last 30percent of data (10min interval: slope ~ 3.8115, 20min interval: slope ~ 4.3962)
%----------------------------------------------------------------------------------------------------------------
index_picked = 98; %~30percent of data from the last index
index_picked2 = 43; %~30percent of data from the last index

slope = polyfit(log(sortedVector(end-index_picked:end-1)),log(probVec(end-index_picked:end-1)),1); %10 min interval case
[p,S] = polyfit(log(sortedVector(end-index_picked:end-1)),log(probVec(end-index_picked:end-1)),1)
[yval,delta] = polyval(slope,log(sortedVector(end-index_picked:end-1)),S); %delta is estimate of standard error

%-------------------------------------------------------------------------------------
% confidence interval
%-------------------------------------------------------------------------------------

[p,S] = polyfit(log(sortedVector(end-index_picked:end-1)),log(probVec(end-index_picked:end-1)),1);
CI1 = polyparci(p,S,0.90)
fprintf(1, '\n\tParameter Estimates and Confidence Intervals:\n\t\t\t\t\t\tSlope\t\tIntercept')
fprintf(1, '\n\t\tUpper 90%%CI\t%.4f\t\t%.4f',CI1(1,:))
fprintf(1, '\n\t\tParameter    \t%.4f\t\t%.4f',p)
fprintf(1, '\n\t\tLower 90%%CI\t%.4f\t\t%.4f\n',CI1(2,:))

slope2 = polyfit(log(sortedVector2(end-index_picked2:end-1)),log(probVec2(end-index_picked2:end-1)),1); %20 min interval case
[p2,S2] = polyfit(log(sortedVector(end-index_picked:end-1)),log(probVec(end-index_picked:end-1)),1)
[yval2,delta2] = polyval(slope2,log(sortedVector2(end-index_picked2:end-1)),S2); %delta is estimate of standard error

[p2,S2] = polyfit(log(sortedVector2(end-index_picked2:end-1)),log(probVec2(end-index_picked2:end-1)),1);
CI2 = polyparci(p2,S2,0.90)
fprintf(1, '\n\tParameter Estimates and Confidence Intervals:\n\t\t\t\t\t\tSlope\t\tIntercept')
fprintf(1, '\n\t\tUpper 90%%CI\t%.4f\t\t%.4f',CI2(1,:))
fprintf(1, '\n\t\tParameter    \t%.4f\t\t%.4f',p2)
fprintf(1, '\n\t\tLower 90%%CI\t%.4f\t\t%.4f\n',CI2(2,:))

%-------------------------------------------------------------------------------------
% CCDF plot combined
%-------------------------------------------------------------------------------------
figure(4)
clf;
hold all
box on; 
% grid on;

plot(sortedVector,probVec,'o','color',[0.8500 0.3250 0.0980]) %10min interval
plot(sortedVector2,probVec2,'o','color',[0.9290 0.6940 0.1250]) %20min interval
% ----------  different color scheme -----------
% plot(sortedVector,probVec,'o','color',[1 0 1])
% plot(sortedVector2,probVec2,'o','color',[0.5 0 0.5])
% ----------------------------------------------

set(gca,'xscale','log','yscale','log')
xlabel('x [µm]')
ylabel('P(step size > x)')

loglog(sortedVector(end-index_picked:end-1),exp(yval),'k-')

%95percent confidence interval
loglog(sortedVector(end-index_picked:end-1),exp(yval+1.96*delta),'m--')
loglog(sortedVector(end-index_picked:end-1),exp(yval-1.96*delta),'m--')

loglog(sortedVector2(end-index_picked2:end-1),exp(yval2),'k-')

%90percent confidence interval
CI90 = 1.645*delta;

%95percent confidence interval
loglog(sortedVector2(end-index_picked2:end-1),exp(yval2+1.96*delta2),'g--')
loglog(sortedVector2(end-index_picked2:end-1),exp(yval2-1.96*delta2),'g--')

%90percent confidence interval
CI90_2 = 1.645*delta2;

ll = legend('10 min','20 min','','')
xlim([0 10^2])
ylim([10^-3 10^0])
% plot(sortedVector(30:end-100),sortedVector(30:end-100).^-3,'r--')

 