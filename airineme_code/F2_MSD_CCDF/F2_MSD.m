% F2_MSD.m

load('experimental.mat')
%%
dataNumEachBin = nonzeros(histcounts(sortedPair(:,1))); %nonzero counts in each histogram bin

cumBinVec = [];
for iCum = 1:length(dataNumEachBin)
    cumBin = sum(dataNumEachBin(1:iCum));
    cumBinVec = [cumBinVec; cumBin];
end

timeVec2 = [];
msdVec2 = [];
semVec2 = [];

time2 = mean(sortedPair(1:cumBinVec(1),1));
timeVec2 = [timeVec2; time2]; %time
msd2 = mean(sortedPair(1:cumBinVec(1),2));
msdVec2 = [msdVec2; msd2]; %MSD
semVal2 = std(sortedPair(1:cumBinVec(1),2))/length(sortedPair(1:cumBinVec(1),2));
semVec2 = [semVec2; semVal2]; %standard error

for iCumBin = 1:length(cumBinVec)-1
    
    time2 = mean(sortedPair(cumBinVec(iCumBin)+1:cumBinVec(iCumBin+1),1));
    timeVec2 = [timeVec2; time2];
    
    msd2 = mean(sortedPair(cumBinVec(iCumBin)+1:cumBinVec(iCumBin+1),2));
    msdVec2 = [msdVec2; msd2];
    
    semVal2 = std(sortedPair(cumBinVec(iCumBin)+1:cumBinVec(iCumBin+1),2))/length(sortedPair(cumBinVec(iCumBin)+1:cumBinVec(iCumBin+1),2));
    semVec2 = [semVec2; semVal2];
end

%% MSD Fitting and 90% CI
[p_msd,S_msd] = polyfit(log10(timeVec2),log10(msdVec2),1);

CI_msd = polyparci(p_msd,S_msd,0.90)
fprintf(1, '\n\tParameter Estimates and Confidence Intervals:\n\t\t\t\t\t\tSlope\t\tIntercept')
fprintf(1, '\n\t\tUpper 90%%CI\t%.4f\t\t%.4f',CI_msd(1,:))
fprintf(1, '\n\t\tParameter    \t%.4f\t\t%.4f',p_msd)
fprintf(1, '\n\t\tLower 90%%CI\t%.4f\t\t%.4f\n',CI_msd(2,:))

%%
% ----------------------------- Plot MSD ----------------------------------
figure(1);clf;
hold all
box on
% grid on
% plot(timeVec2,msdVec2,'m*') %sqrt(2)*msdVec %plot number 1
plot(timeVec2,msdVec2,'o','MarkerSize',5,'color',[1 0.5 0])
v = 4.5;

DthetaArray = 0.1844; %Dtheta measured from experimental data
lp = v/(2*DthetaArray); %persistence length lp = v/(2*Dtheta)
timeVec22 = linspace(timeVec2(1),100,100);

%theory line for persistent random walk
plot(timeVec22,4.*lp.*v.*timeVec22.*(1-(2.*lp./(v.*timeVec22)).*(1-exp(-v.*timeVec22./(2.*lp)))),'color',[0 0.5 0],'LineStyle','-','LineWidth',2);
set(gca,'xscale','log','yscale','log')

%theory line for diffusion
D = v^2/(2*DthetaArray);
plot(timeVec22,4.*D.*timeVec22,'b--','LineWidth',2) %plot number 3
set(gca,'xscale','log','yscale','log')

% errorbar(timeVec2,msdVec2,semVec2,'m')
% e = errorbar(timeVec2,msdVec2,semVec2,'LineWidth',0.5,'color',[0.9290 0.6940 0.1250])
e = errorbar(timeVec2,msdVec2,semVec2,'LineWidth',0.5,'color',[1 0.5 0])
e.LineStyle = 'none';
% plot(linspace(1,100),linspace(100,10000),'k--')

slopeTicks = linspace(1,10,100);
plot(slopeTicks,slopeTicks.^2,'k--')

ll = legend('Experimental','Theory: PRW','Theory: Diffusion','error')
xlim([timeVec2(1) 10^2])
xticks([10^0 10^1 10^2])
yticks([10^0 10^1 10^2 10^3 10^4 10^5])
% pbaspect([1 1 1])
xlabel('time')
ylabel('\langle r^2 \rangle')
title('Experimental data MSD')
% ---------------------------- Figure specifics ---------------------------
fs = 8;
w = 8;
h = 8;
fsll = 10;

%get the figure handle
fig = gcf;
%set the figure to the correct size
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 w h];
fig.PaperSize = [w h];
%set the line and font sizes
set(findall(gcf,'-property','FontSize'),'FontSize',fs)
set(findall(gcf,'-property','LineWidth'),'LineWidth',1)
set(ll,'FontSize',fsll)
%print to pdf
print('prettypdf','-dpdf')