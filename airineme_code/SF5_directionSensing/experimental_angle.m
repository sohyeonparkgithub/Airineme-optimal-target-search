%Airineme directional sensing: hitting angle data

cd('angleData') %path
table = readtable('angleData.xlsx') %file name
angleData = table(:,1);
angleData = angleData{:,:}
figure(1)
hist(angleData)
%%
figure(2)
polarhistogram(angleData*pi/180,'FaceColor','green')
title('Experimental Angle Data')
%%
figure(3)
hold all
box on
grid on
ecdf(angleData*pi/180)
set(gca,'FontName','Palatino')
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','LineWidth'),'LineWidth',2)
%%
% pd = fitdist(angleData,'Normal');
% s = std(pd);
% FI = 1/s^2;
% %%
% [h,p,ksstat,cv]=kstest(angleData);
