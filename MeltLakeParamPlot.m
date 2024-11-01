clear all
load("CWalkerFull10K500NormCompiled_100Snaps.mat")
h = 0:0.1:1;
s = transpose(1:1:20);

hurst = repmat(h, [20 1]);
sigma = repmat(s, [1 11]);

avg_wd = mean(wd_comp,4) ;
avg_wl = mean(ld_comp,4);
avg_F = mean(fc_comp,4);
avg_ws = mean(supp_comp,4);

avg_wd = cat(3,zeros(20,11),avg_wd);
avg_wl = cat(3,zeros(20,11),avg_wl);
avg_F = cat(3,zeros(20,11),avg_F);

hurst101 =repmat(hurst,[1 1 101]);
sigma101 = repmat(sigma, [1 1 101]);

avg_wd_s = avg_wd./sigma101;
avg_wl_s = avg_wl./sigma101;

Lx = 10000;
for j=1:100
    w_S(:,:,j) =avg_ws(:,:,j)*(j/100)/(Lx^2);
end

w_S = cat(3,zeros(20,11),w_S);
w_S_star = w_S (:,:,end);

wd_star = sigma.*(0.2-0.12*hurst.^0.6);
wdstar_num = avg_wd(:,:,end);

S = w_S./w_S_star;
S_param = w_S./wd_star;

wlstar = avg_wl(:,:,end);
Fstar = avg_F(:,:,end);
%%

wd_par = wd_param(hurst101,sigma101,w_S);
F_par = F_param(hurst101,sigma101,w_S);
wl_par = wl_param(hurst101,sigma101,w_S);

wd_diff = (avg_wd - wd_par)./(avg_wd);
wl_diff = (avg_wl-wl_par)./(avg_wl);
F_diff = (avg_F - F_par)./(avg_F);

wd_full = cat(3,zeros(20,11,1,500),wd_comp);
wl_full = cat(3,zeros(20,11,1,500),ld_comp);
F_full = cat(3,zeros(20,11,1,500),fc_comp);

wd_rmse = rmse(wd_par,wd_full,4);
wl_rmse = rmse(wl_par,wl_full,4);
F_rmse = rmse(F_par,F_full,4);

%%
sigma_in = squeeze(sigma101(:,5,:));
w_S_in = squeeze(w_S(:,5,:));
H_in = squeeze(hurst101(:,5,:,:));
S_in = squeeze(S(:,5,:));

wd_num_in = squeeze(avg_wd(:,5,:));
wd_par_in = squeeze(wd_par(:,5,:));
wd_diff_in = squeeze(wd_diff(:,5,:));
wd_rmse_in = squeeze(wd_rmse(:,5,:));

wl_num_in = squeeze(avg_wl(:,5,:));
wl_par_in = squeeze(wl_par(:,5,:));
wl_diff_in = squeeze(wl_diff(:,5,:));
wl_rmse_in = squeeze(wl_rmse(:,5,:));

F_num_in = squeeze(avg_F(:,5,:));
F_par_in = squeeze(F_par(:,5,:));
F_diff_in = squeeze(F_diff(:,5,:));
F_rmse_in = squeeze(F_rmse(:,5,:));
%%

nIDs = 4;
alphabet = ('a':'z').';
chars = num2cell(alphabet(1:nIDs));
chars = chars.';
charlbl = strcat('(',chars,')'); % {'(a)','(b)','(c)','(d)'}

fig1 = figure;
fig1.Position = [1,457,1792,560]; %1x3 config
t_wd = tiledlayout(1,3);
nexttile;
pcolor(sigma_in,w_S_in,wd_num_in)
shading interp
cbnum = colorbar;
caxis([0 max(wd_par_in,[],'all')]);
cbnum.Label.String = 'Depth (m)';
cbnum.Label.Interpreter = 'latex';
set(gca,fontsize=20)
cbnum.FontSize = 25;
title('Numerical $\bar{w}_d$','Interpreter','latex',"FontSize",30)
text(0.025,0.95,charlbl{1},'Units','normalized','FontSize',30,FontWeight='bold')
nexttile;
pcolor(sigma_in,w_S_in,wd_par_in)
shading interp
cbpar = colorbar;
caxis([0 max(wd_par_in,[],'all')]);
cbpar.Label.String = 'Depth (m)';
cbpar.Label.Interpreter = 'latex';
cbpar.FontSize = 25;
set(gca,fontsize=20)

title('Parameterized $\bar{w}_d$','Interpreter','latex',"FontSize",30)
text(0.025,0.95,charlbl{2},'Units','normalized','FontSize',30,FontWeight='bold')
nexttile;
pcolor(sigma_in,w_S_in,wd_diff_in)
shading interp
colorbar;
caxis([-0.25 0.25]);
colormap(gca, cbrewer('div','RdBu',9))
set(gca,fontsize=20)
xlabel(t_wd,'$\sigma (m)$',"Interpreter","latex",'FontSize',35)
ylabel(t_wd,'Total Supply (m)',"Interpreter","latex","FontSize",25)
title('Relative Difference $\bar{w}_d$','Interpreter','latex',"FontSize",30)
text(0.025,0.95,charlbl{3},'Units','normalized','FontSize',30,FontWeight='bold')



fig2 = figure;
fig2.Position = [1,457,1792,560]; %1x3 config
t_ld = tiledlayout(1,3);
nexttile;
pcolor(sigma_in,w_S_in,wl_num_in)
shading interp
cbnum = colorbar;
caxis([0 max(wl_par_in,[],'all')]);
cbnum.Label.String = 'Depth (m)';
cbnum.Label.Interpreter = 'latex';
cbnum.FontSize = 25;
title('Numerical $\bar{w}_l$','Interpreter','latex',"FontSize",25)
text(0.025,0.95,charlbl{1},'Units','normalized','FontSize',30,FontWeight='bold')
set(gca,fontsize=20)
nexttile;
pcolor(sigma_in,w_S_in,wl_par_in)
shading interp
cbpar = colorbar;
caxis([0 max(wl_par_in,[],'all')]);
cbpar.Label.String = 'Depth (m)';
cbpar.Label.Interpreter = 'latex';
cbpar.FontSize=25;
title('Parameterized $\bar{w}_l$','Interpreter','latex',"FontSize",25)
text(0.025,0.95,charlbl{2},'Units','normalized','FontSize',30,FontWeight='bold')
set(gca,fontsize=20)
nexttile;
pcolor(sigma_in,w_S_in,wl_diff_in)
shading interp
colorbar;
caxis([-0.25 0.25]);
colormap(gca, cbrewer('div','RdBu',9))
xlabel(t_ld,'$\sigma (m)$',"Interpreter","latex",'FontSize',35)
ylabel(t_ld,'Total Supply (m)',"Interpreter","latex","FontSize",25)
title('Relative Difference $\bar{w}_l$','Interpreter','latex',"FontSize",25)
text(0.025,0.95,charlbl{3},'Units','normalized','FontSize',30,FontWeight='bold')
set(gca,fontsize=20)

fig3 = figure;
fig3.Position = [1,457,1792,560];%1x3 config
t_fc = tiledlayout(1,3);
nexttile;
pcolor(sigma_in,w_S_in,F_num_in)
shading interp
cbnum = colorbar;
caxis([0 max(F_par_in,[],'all')]);
title('Numerical $\bar{F}$','Interpreter','latex',"FontSize",25)
text(0.025,0.95,charlbl{1},'Units','normalized','FontSize',30,FontWeight='bold')
set(gca,fontsize=20)
nexttile;
pcolor(sigma_in,w_S_in,F_par_in)
shading interp
cbpar = colorbar;
caxis([0 max(F_par_in,[],'all')]);
title('Parameterized $\bar{F}$','Interpreter','latex',"FontSize",25)
text(0.025,0.95,charlbl{2},'Units','normalized','FontSize',30,FontWeight='bold')
set(gca,fontsize=20)
nexttile;
pcolor(sigma_in,w_S_in,F_diff_in)
shading interp
colorbar;
caxis([-0.25 0.25]);
colormap(gca, cbrewer('div','RdBu',9))
xlabel(t_fc,'$\sigma (m)$',"Interpreter","latex",'FontSize',30)
ylabel(t_fc,'Total Supply (m)',"Interpreter","latex","FontSize",30)
title('Relative Difference $\bar{F}$','Interpreter','latex',"FontSize",25)
text(0.025,0.95,charlbl{3},'Units','normalized','FontSize',30,FontWeight='bold')
set(gca,fontsize=20)

%%
fig4 = figure;
fig4.Position = [1,457,1792,560];
t_RMSE = tiledlayout(1,2);

nexttile;
pcolor(sigma_in,S_in,wl_rmse_in./wl_par_in)
shading interp
colorbar;
colormap(gca, cbrewer('seq','BuGn',9))
xlabel('$\sigma (m)$',"Interpreter","latex",'FontSize',20)
ylabel('Total Supply (m)',"Interpreter","latex","FontSize",15)
title('RMSE $\bar{w}_l/\bar{w}_l(H,\sigma,S)$','Interpreter','latex',"FontSize",15)
set(gca,fontsize=20)

nexttile;
pcolor(sigma_in,S_in,F_rmse_in./F_par_in)
shading interp
colorbar;
colormap(gca, cbrewer('seq','BuGn',9))
xlabel('$\sigma (m)$',"Interpreter","latex",'FontSize',20)
ylabel('Total Supply (m)',"Interpreter","latex","FontSize",15)
title('RMSE $\bar{F}/\bar{F}(H,\sigma,S)$','Interpreter','latex',"FontSize",15)
set(gca,fontsize=20)
