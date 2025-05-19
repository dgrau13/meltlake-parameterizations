%Calculating Antarctica Hurst and Sigma
load("AntAnalysis_NewFreq.mat")
an_lat = an.lat_list(1,:);
an_lon = an.lon_list(1,:);
an_H = an.H_list(1,:);
an_sigma = an.sigma_list(1,:);
clear an
%%
H_mean = mean(an_H,"all");
H_std = std(an_H,[],"all");

sigma_mean = mean(an_sigma,"all");
sigma_std = std(an_sigma,[],"all");

wl_star = 0.6*(an_sigma).*(1-0.41*(an_H).^0.6);
wl_star_mean = mean(wl_star,"all");
wl_star_std = std(wl_star,[],"all");

F_star = 0.13*(3-0.13*(an_H.^1.3));
F_star_mean = mean(F_star,"all");
F_star_std = std(F_star,[],"all");

%%
%Pannel Lettering
nIDs = 4;
alphabet = ('a':'z').';
chars = num2cell(alphabet(1:nIDs));
chars = chars.';
charlbl = strcat('(',chars,')'); % {'(a)','(b)','(c)','(d)'}
%%
grayColor = [.7 .7 .7];
%%
%Hurst Antarctic Map
fig = figure;
fig.Position = [20,43,1301,974];
set(gcf, 'color', 'white');
antbounds('coast','color','k')
antbounds('shelves','color','k')
hold on
graticuleps([-90:5:-60],[-150:30:180],'Color','k','LineWidth',1)
h_Hurst=scatterps(an_lat,an_lon,3,an_H,'filled');
H_cb = colorbar;
colormap(cmocean('ice'))
ylabel(H_cb,'Hurst Exponent',"FontSize",35)
caxis([H_mean-H_std   H_mean+H_std])
plot([-1.75*10^6,-1.25*10^6],[-1.35*10^6,-1.35*10^6],"k-","LineWidth", 5)
text(-1.54*10^6,-1.2*10^6,'500 km','horiz','center','vert','top','FontSize',20);
legend off
text(0.025,0.95,charlbl{1},'Units','normalized','FontSize',30,FontWeight='bold')
set(gca,fontsize=30)
axis off
hold off

%%
%Sigma Antarctic Map
fig = figure;
fig.Position = [20,43,1301,974];
set(gcf, 'color', 'white');
antbounds('coast','color','k')
antbounds('shelves','color','k')
hold on
graticuleps([-90:5:-60],[-150:30:180],'Color','k','LineWidth',1)
h_sigma=scatterps(an_lat,an_lon,3,an_sigma,'filled');
sigma_cb = colorbar;
colormap(cmocean('ice'))
ylabel(sigma_cb,'\sigma (m)',"FontSize",30)
caxis([0  sigma_mean+sigma_std])
plot([-1.75*10^6,-1.25*10^6],[-1.35*10^6,-1.35*10^6],"k-","LineWidth", 5)
text(-1.54*10^6,-1.2*10^6,'500 km','horiz','center','vert','top','FontSize',20);
legend off
text(0.025,0.95,charlbl{2},'Units','normalized','FontSize',30,FontWeight='bold')
set(gca,fontsize=30)
axis off
hold off
%%
%Hurst PDF 
fig = figure;
fig.Position = [20,43,1301,694];
histogram(an.H_list(1,:),100,"Normalization","probability","BinLimits",[H_mean-2*H_std   H_mean+2*H_std]);
xlabel('Hurst Exponent (H)','FontSize',20)
ylabel('Probability Density Function','FontSize',20)
text(0.025,0.95,charlbl{3},'Units','normalized','FontSize',30,FontWeight='bold')
set(gca,fontsize=30)

%%
%Sigma CDF
fig = figure;
fig.Position = [20,43,1301,694];
histogram(an.sigma_list(1,:),"NumBins",100,"Normalization","cdf","BinLimits",[0 50]);
xlabel('Standard Deviation in Topography (\sigma)','FontSize',20)
ylabel('Cumulative Density Function','FontSize',20)
text(0.025,0.95,charlbl{4},'Units','normalized','FontSize',30,FontWeight='bold')
set(gca,fontsize=30)

%%
%WL Star Antarctic Map
fig = figure;
fig.Position = [20,47,1110,960];
set(gcf,'color','white');
antbounds('coast','color','k','linewidth',3)
antbounds('shelves','color','k','linewidth',3)
hold on 
graticuleps([-90:5:-60],[-150:30:180],'Color','k','LineWidth',1)
scatterps(an_lat,an_lon,5,wl_star,'filled');
wl_star_cb = colorbar;
a = colormap(cmocean('haline'));
colormap(flipud(a));
ylabel(wl_star_cb,'$\bar{w}_l^*$(m)','Interpreter','Latex',"FontSize",20)
caxis([min(wl_star,[],"all") 4.0]);
xlabel('Eastings (m)')
ylabel('Northings (m)')
antbounds('Ross East','color','k','linewidth',3);
antbounds('Ross West','color','k','linewidth',3);
antbounds('Ronne','color','k','linewidth',3)
antbounds('Amery','color','k','linewidth',3)
antbounds('Larsen C','color','k','linewidth',3)
set(gca,fontsize=25)
% mapzoomps('Larsen Ice Shelf')
legend off
axis off 
plot([-1.75*10^6,-1.25*10^6],[-1.35*10^6,-1.35*10^6],"k-","LineWidth", 5)
text(-1.54*10^6,-1.2*10^6,'500 km','horiz','center','vert','top','FontSize',20);
% colorbar off
hold off

%Marker Size Chart:
%Antarctica: 5
%Ross: 15
%Ronne: 25
%Amery: 55 
%Larsenc C: 105
%%
%F Antarctic Map
fig = figure;
fig.Position = [20,47,1110,960];
set(gcf,'color','white');
antbounds('coast','color','k','linewidth',3)
antbounds('shelves','color','k','linewidth',3)
hold on 
graticuleps([-90:5:-60],[-150:30:180],'Color','k','LineWidth',1)
scatterps(an_lat,an_lon,5,F_star,'filled');
F_star_cb = colorbar;
a = colormap(cbrewer2("YlOrRd",9));
ylabel(F_star_cb,'$\bar{F}^*$','Interpreter','Latex',"FontSize",30)
caxis([min(F_star) max(F_star)]);
xlabel('Eastings (m)')
ylabel('Northings (m)')
antbounds('Ross East','color','k','linewidth',3);
antbounds('Ross West','color','k','linewidth',3);
antbounds('Ronne','color','k','linewidth',3)
antbounds('Amery','color','k','linewidth',3)
antbounds('Larsen C','color','k','linewidth',3)
set(gca,fontsize=20)
% mapzoomps(['Larsen Ice Shelf'])
legend off
axis off
plot([-1.75*10^6,-1.25*10^6],[-1.35*10^6,-1.35*10^6],"k-","LineWidth", 5)
text(-1.54*10^6,-1.2*10^6,'500 km','horiz','center','vert','top','FontSize',18);
% colorbar off
hold off

%Marker Size Chart:
%Antarctica: 5
%Ross: 15
%Ronne: 25
%Amery: 55 
%Larsenc C: 105
%%
%Antarctica Surface Roughness Distributions
clear all
load("FloatingvsGrounded_NewFreq.mat")

antis.lat = [grd.lat; icsh.lat];
antis.lon = [grd.lon;icsh.lon];
antis.H = [grd.H;icsh.H];
antis.h = [grd.h;icsh.h];
antis.sigma = [grd.sigma;icsh.sigma];

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
