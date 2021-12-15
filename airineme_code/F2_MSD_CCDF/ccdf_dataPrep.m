%% F2_CCDF 

cd('/Users/sohyeonpark/Desktop/airineme_target_search/F2_MSD_CCDF/ccdf')

%Airineme file number
firstIndex = 1;
lastIndex = 56;

stepSize_all = [];
stepSize_all2 = [];
%import files
for iAirineme = firstIndex:lastIndex
    inputFileName = ['v1_a' num2str(iAirineme, '%d') '.txt'];

    [rawdata,delimiterOut] = importdata(inputFileName);
    x = rawdata(:,1); %x coordinate
    y = rawdata(:,2); %y coordinate
    vectors = [x(2:end)-x(1:end-1) y(2:end)-y(1:end-1)]; % 10min int segment
    vectors2 = [x(3:end)-x(1:end-2) y(3:end)-y(1:end-2)]; % 20min int segment
    
    segLength = sqrt(vectors(:,1).^2 + vectors(:,2).^2); %segment length
    stepSize_all = [stepSize_all; segLength];
    conversion = 0.75; %known distance per pixel
    stepSize_all_microns = stepSize_all./conversion;
    
    segLength2 = sqrt(vectors2(:,1).^2 + vectors2(:,2).^2); %segment length
    stepSize_all2 = [stepSize_all2; segLength2];
    stepSize_all_microns2 = stepSize_all2./0.75;
end

save('experimental_ccdf.mat')