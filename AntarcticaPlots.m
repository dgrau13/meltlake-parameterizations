%load("/Users/dgrau13/Library/CloudStorage/Box-Box/Research/dgraumelt/Output Files/031924/FloatingvsGrounded.mat")
antis.lat = [grd.lat; icsh.lat];
antis.lon = [grd.lon;icsh.lon];
antis.H = [grd.H;icsh.H];
antis.h = [grd.h;icsh.h];
antis.sigma = [grd.sigma;icsh.sigma];
%%
antis.wl_star = 0.6*(antis.sigma).*(1-0.41*(antis.H).^0.6);
icsh.wl_star = 0.6*(icsh.sigma).*(1-0.41*(icsh.H).^0.6);
grd.wl_star = 0.6*(grd.sigma).*(1-0.41*(grd.H).^0.6);
%%

antis.F_star = 0.13*(3-0.13*(antis.H.^1.3));
icsh.F_star = 0.13*(3-0.13*(icsh.H.^1.3));
grd.F_star = 0.13*(3-0.13*(grd.H.^1.3));

%%

[y_H,x_H] = histcounts(antis.H,100,"Normalization","probability");
x_H = x_H(2:end) - (x_H(2)-x_H(1))/2;

[y_sigma,x_sigma] = histcounts(antis.sigma,100,"Normalization","probability","BinLimits",[0 50]);
x_sigma = x_sigma(2:end) - (x_sigma(2)-x_sigma(1))/2;

%%
%Histogram for Hurst

Hfig =figure;
Hfig.Position = [5,43,1488,974];
hold on
histogram(icsh.H,"NumBins",100,"Normalization","probability","FaceAlpha",0.5,"FaceColor","#4DBEEE");
histogram(grd.H,"NumBins",100,"Normalization","probability","FaceAlpha",0.5,"FaceColor","#EDB120");
plot(x_H,y_H,'k-',"LineWidth",3);
legend({"Floating Ice","Grounded Ice","AIS"})
xlim([0.3 0.7])
xlabel('Hurst (H)')
ylabel("Probability Density Function")
% title('Grounded vs. Floating Hurst Exponents')
set(gca,fontsize=30)
hold off


%%
%Histogram for Sigma

sigmafig =figure;
sigmafig.Position = [5,43,1488,974];
hold on
histogram(icsh.sigma,"NumBins",100,"Normalization","probability","FaceAlpha",0.5,"FaceColor","#4DBEEE","BinLimits",[0 50]);
histogram(grd.sigma,"NumBins",100,"Normalization","probability","FaceAlpha",0.5,"FaceColor","#EDB120","BinLimits",[0 50]);
plot(x_sigma,y_sigma,'k-',"LineWidth",3)
legend({"Floating Ice","Grounded Ice","AIS"})
xlim([0 20])
xlabel('Standard Deviation of Topography (\sigma) in meters')
ylabel("Probability Density Function")
% title('Grounded vs. Floating Standard Deviation in Topography (\sigma)')
set(gca,fontsize=30)
hold off
%%
load('AntAnalysis.mat')
%%
%Hurst Antarctica Map
H_mean = mean(an.H_list,"all");
H_std = std(an.H_list,[],"all");

fig = figure;
fig.Position = [20,43,1301,974];
set(gcf, 'color', 'white');
antbounds('coast','color','k')
antbounds('shelves','color','k')
hold on
h_Hurst=scatterps(an.lat_list(1,:),an.lon_list(1,:),3,an.H_list(1,:),'filled');
H_cb = colorbar;
colormap(cmocean('ice'))
ylabel(H_cb,'Hurst Exponent',"FontSize",35)
caxis([H_mean-H_std   H_mean+H_std])
xlabel('Eastings (m)')
ylabel('Northings (m)')
plot([-1.75*10^6,-1.25*10^6],[-1.35*10^6,-1.35*10^6],"k-","LineWidth", 5)
text(-1.54*10^6,-1.2*10^6,'500 km','horiz','center','vert','top','FontSize',20);
% legend('Coast','Shelves','Hurst')
% legend('boxoff')
legend off
set(gca,fontsize=30)
axis off
% title("Hurst Exponents of Antarctica");
hold off

%%
%Hurst PDF 
fig = figure;
fig.Position = [20,43,1301,974];
histogram(an.H_list(1,:),100,"Normalization","probability","BinLimits",[H_mean-2*H_std   H_mean+2*H_std]);
xlabel('Hurst Exponent (H)','FontSize',20)
ylabel('Probability Density Function','FontSize',20)
% title('PDF of the Hurst Exponent (H)','FontSize',20)
set(gca,fontsize=30)

%%
%Sigma Antarctica Map
sigma_mean = mean(an.sigma_list,"all");
sigma_std = std(an.sigma_list,[],"all");

fig = figure;
fig.Position = [20,43,1301,974];
set(gcf, 'color', 'white');
antbounds('coast','color','k')
antbounds('shelves','color','k')
hold on
scatterps(an.lat_list(1,:),an.lon_list(1,:),3,an.sigma_list(1,:),'filled')
sigma_cb = colorbar;
colormap(cmocean('ice'))
ylabel(sigma_cb,'\sigma (m)',"FontSize",30)
caxis([0 sigma_mean+sigma_std])
xlabel('Eastings (m)')
ylabel('Northings (m)')
plot([-1.75*10^6,-1.25*10^6],[-1.35*10^6,-1.35*10^6],"k-","LineWidth", 5)
text(-1.54*10^6,-1.2*10^6,'500 km','horiz','center','vert','top','FontSize',20);
% legend('Coast','Shelves','Hurst')
% legend('boxoff')
axis off
legend off
set(gca,fontsize=30)
% title("Standard Deviations in Topography of Antarctica");
hold off

%%
%Sigma CDF
fig = figure;
fig.Position = [20,43,1301,974];
histogram(an.sigma_list(1,:),"NumBins",100,"Normalization","cdf","BinLimits",[0 50]);
xlabel('Standard Deviation in Topography (\sigma)','FontSize',20)
ylabel('Cumulative Density Function','FontSize',20)
% title('CDF of the Topographical Standard Deviation (\sigma)','FontSize',20)
set(gca,fontsize=30)

%%
% WD_Star Antarctic Map
wd_star = (an.sigma_list(1,:)).*(0.2-0.12*(an.H_list(1,:)).^0.6);
wd_star_mean = mean(wd_star,"all");
wd_star_std = std(wd_star,[],"all");

fig = figure;
fig.Position = [20,47,1110,960];
set(gcf,'color','white');
antbounds('coast','color','k','linewidth',3)
antbounds('shelves','color','k','linewidth',3)
hold on 
scatterps(an.lat_list(1,:),an.lon_list(1,:),105,wd_star,'filled');
wd_star_cb = colorbar;
a = colormap(cmocean('haline'));
colormap(flipud(a));
ylabel(wd_star_cb,'$\bar{w}_d^* (m)$','Interpreter','Latex',"FontSize",20)
caxis([0.0050 3]);
xlabel('Eastings (m)')
ylabel('Northings (m)')
antbounds('Ross East','color','r','linewidth',3);
antbounds('Ross West','color','r','linewidth',3);
antbounds('Ronne','color','r','linewidth',3)
antbounds('Amery','color','r','linewidth',3)
antbounds('Larsen C','color','r','linewidth',3)
% legend({'Coast','Shelves','$\bar{w}_d^*$','Ross East','Ross West','Ronne','Amery','Larsen C'},'Interpreter','latex');
% legend('boxoff')
set(gca,fontsize=20)
mapzoomps('Larsen Ice Shelf')
title("Predicted Maximum Water Depth of Larsen C Ice Shelf($\bar{w}_d^*$)","Interpreter","latex","FontSize",30)
legend off
%axis off 
colorbar off
hold off
%%
%WL Star Antarctic Map
wl_star = 0.6*(an.sigma_list(1,:)).*(1-0.41*(an.H_list(1,:)).^0.6);
wl_star_mean = mean(wl_star,"all");
wl_star_std = std(wl_star,[],"all");

fig = figure;
fig.Position = [20,47,1110,960];
set(gcf,'color','white');
antbounds('coast','color','k','linewidth',3)
antbounds('shelves','color','k','linewidth',3)
hold on 
scatterps(an.lat_list(1,:),an.lon_list(1,:),105,wl_star,'filled');
wl_star_cb = colorbar;
a = colormap(cmocean('haline'));
colormap(flipud(a));
ylabel(wl_star_cb,'$\bar{w}_l^*$(m)','Interpreter','Latex',"FontSize",20)
caxis([min(wl_star,[],"all") 4.0]);
xlabel('Eastings (m)')
ylabel('Northings (m)')
antbounds('Ross East','color','r','linewidth',3);
antbounds('Ross West','color','r','linewidth',3);
antbounds('Ronne','color','r','linewidth',3)
antbounds('Amery','color','r','linewidth',3)
antbounds('Larsen C','color','r','linewidth',3)
% legend({'Coast','Shelves','$\bar{w}_l^*$','Ross East','Ross West','Ronne','Amery','Larsen C'},'Interpreter','latex');
% legend('boxoff')
set(gca,fontsize=25)
mapzoomps('Larsen Ice Shelf')
% title("Predicted Maximum Lake Depth of Ross Ice Shelf($\bar{w}_l^*$)","Interpreter","latex","FontSize",30)
legend off
axis off 
plot([-1.75*10^6,-1.25*10^6],[-1.35*10^6,-1.35*10^6],"k-","LineWidth", 5)
text(-1.54*10^6,-1.2*10^6,'5000 km','horiz','center','vert','top','FontSize',20);
colorbar off
hold off

%%
%F Antarctic Map
F_star = 0.13*(3-0.13*(an.H_list(1,:).^1.3));
F_star_mean = mean(F_star,"all");
F_star_std = std(F_star,[],"all");

fig = figure;
fig.Position = [20,47,1110,960];
set(gcf,'color','white');
antbounds('coast','color','k','linewidth',3)
antbounds('shelves','color','k','linewidth',3)
hold on 
scatterps(an.lat_list(1,:),an.lon_list(1,:),105,F_star,'filled');
F_star_cb = colorbar;
a = colormap(cbrewer2("YlOrRd",9));
% colormap(flipud(a));
ylabel(F_star_cb,'$\bar{F}^*$','Interpreter','Latex',"FontSize",30)
caxis([min(F_star) max(F_star)]);
xlabel('Eastings (m)')
ylabel('Northings (m)')
antbounds('Ross East','color','k','linewidth',3);
antbounds('Ross West','color','k','linewidth',3);
antbounds('Ronne','color','k','linewidth',3)
antbounds('Amery','color','k','linewidth',3)
antbounds('Larsen C','color','k','linewidth',3)
% legend({'Coast','Shelves','$\bar{F}^*$','Ross East','Ross West','Ronne','Amery','Larsen C'},'Interpreter','latex');
% legend('boxoff')
set(gca,fontsize=20)
mapzoomps(['Larsen Ice Shelf'])
% title("Predicted Maximum Fraction Area of Larsen C Ice Shelf ($\bar{F}^*$)","Interpreter","latex","FontSize",30)
legend off
axis off
plot([-1.75*10^6,-1.25*10^6],[-1.35*10^6,-1.35*10^6],"k-","LineWidth", 5)
text(-1.54*10^6,-1.2*10^6,'5000 km','horiz','center','vert','top','FontSize',18);
colorbar off
hold off

%%
%Tossed Subtracks
fig = figure;
fig.Position = [20,47,1110,960];
set(gcf,'color','white');
antbounds('coast','color','k')
antbounds('shelves','color','k')
hold on 
scatterps(an.lat_tossed(1,:),an.lon_tossed(1,:),1,'b');
xlabel('Eastings (m)')
ylabel('Northings (m)')
legend({'Coast','Shelves','Tossed Points'},'Interpreter','latex');
set(gca,fontsize=20)
title("Tossed ICESat-2 Track Points","Interpreter","latex")
