%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute MSD using 70 airineme experimental data sets.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% set the directory
cd('xxx')

% Read Airineme coordinate text files
firstIndex = 101;
lastIndex = 7001;
numInt = 100;

% Parameter values
velocity = 4.5;

% Initialization
t_rSquared_pair_vec = []; % record [1.time , 2.squared displacement]


%Import coordinate text data and compute contourlength, cosAngle, etc.
for iAirineme = firstIndex:numInt:lastIndex
    inputFileName = ['airineme' num2str(iAirineme, '%d') '.txt'];
    
    [rawdata,delimiterOut] = importdata(inputFileName);
    
    %x,y coordinate
    x = rawdata(:,1);
    y = rawdata(:,2);
    
    vectors = [x(2:end)-x(1:end-1) y(2:end)-y(1:end-1)];
    segLength = sqrt(vectors(:,1).^2 + vectors(:,2).^2); %segment length
    
    for iSeg = 1:length(x)-1
        for jSeg = iSeg+1:length(x)
            contourLength = sum(segLength(iSeg:jSeg-1));
            delta_t = contourLength / velocity; %compute time with constant velocity assumption
            rSquared = (x(jSeg)-x(iSeg))^2+(y(jSeg)-y(iSeg))^2;  %squared displacement
            t_rSquared_pair = [delta_t rSquared]; %[1.time , 2.squared displacement]
            t_rSquared_pair_vec = [t_rSquared_pair_vec; t_rSquared_pair]; % record [1.time , 2.squared displacement]
        end %end of jSeg
    end %end of iSeg
end %end of iArineme

sortedPair = sortrows(t_rSquared_pair_vec); %sort pairs in ascending order

%%
figure(1);
xvalue = logspace(-1,2,20);
yvalue = xvalue;
hold all
plot(xvalue,yvalue,'--') %guideline slope 1
plot(sortedPair(:,1),sortedPair(:,2),'o')
set(gca,'yscale','log')
set(gca,'xscale','log')
ylim([10^-1 10^5])
xlabel('\Delta t')
ylabel('\Delta r^2')
title('Squared displacement using Sohyeon''s data')

%% Binning
binWidth = 40;
numBins = floor(length(sortedPair(:,2))/binWidth);
tau_msd = [];

figure(1)
hold all
for iBins = 1:numBins
    dataInBin = sortedPair((iBins-1)*binWidth+1:iBins*binWidth,:);
    delta_t_mean = mean(dataInBin(:,1));
    msd = mean(dataInBin(:,2));
    pair = [delta_t_mean msd];
    tau_msd = [tau_msd; pair];
    plot(log(delta_t_mean),log(msd),'o')
end

dataInLastBin = sortedPair(numBins*binWidth+1:end,:);
delta_t_mean = mean(dataInLastBin(:,1));
msd = mean(dataInLastBin(:,2));
pair = [delta_t_mean msd];
tau_msd = [tau_msd; pair];
plot(log(delta_t_mean),log(msd),'o');

x = linspace(-1,4,20)
y = x;
plot(x,y,'--')
hold off

save('MSD_XXX.mat')