#Import Packages
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.dates import YearLocator, DateFormatter
import scipy.io as sio
from scipy import special as sp
from scipy.optimize import fsolve
import pandas as pd
import seaborn as sns
from datetime import datetime

#Pulling All Larsen Data
larsen_stats = pd.read_csv("LarsenTable_NewFreq.csv")
larsen_depth = pd.read_csv("depth_data/larsen_depth.csv",header=None)
larsen_fcovr = pd.read_csv("larsen_c_frac.csv",header=None)
larsen_supp = pd.read_csv("larsen_running_total_runoff.csv",header=None)
larsen_supp =larsen_supp.drop(index=0)

#Pulling All Amery Data
amery_stats = pd.read_csv("AmeryTable_NewFreq.csv")
amery_depth = pd.read_csv("depth_data/amery_depth.csv",header=None)
amery_fcovr = pd.read_csv("amery_frac.csv",header=None)
amery_supp = pd.read_csv("amery_running_total_runoff.csv",header=None)
amery_supp=amery_supp.drop(index=0)

#%%

#Convert DFs to Numpy Arrays 
amery_hurst = amery_stats.H.to_numpy()
amery_sigma = amery_stats.sigma.to_numpy()
amery_obs_wl = amery_depth[1].to_numpy()/1000
amery_obs_F = amery_fcovr[1].to_numpy()
amery_obs_dates = pd.to_datetime(amery_fcovr[0]).to_numpy()
amery_runoff = amery_supp[2].to_numpy()/1000
amery_dates = pd.to_datetime(amery_supp[1]).to_numpy()

larsen_hurst = larsen_stats.H.to_numpy()
larsen_sigma = larsen_stats.sigma.to_numpy()
larsen_obs_wl = larsen_depth[1].to_numpy()/1000
larsen_obs_F = larsen_fcovr[1].to_numpy()
larsen_obs_dates = pd.to_datetime(larsen_fcovr[0]).to_numpy()
larsen_runoff = larsen_supp[2].to_numpy()/1000
larsen_dates = pd.to_datetime(larsen_supp[1]).to_numpy()
#%%
#Average Lake Depth Parameterization
def wl_param(sig,H,w_S):
    wd_star = sig*(0.2-0.12*H**0.6)
    S = w_S/wd_star
    lak_dep = 0.6*sig*sp.erf(67*S)*(1-0.41*H**0.6)
    return(lak_dep)


#Average Fractional Coverage Parameterization
def F_param(sig,H,w_S):
    wd_star = sig*(0.2-0.12*H**0.6)
    S = w_S/wd_star
    frac_cov = 0.13*sp.erf(55*S)*(1+2*sp.erf(0.08*S)-(0.13*H**1.3))
    return(frac_cov)

#%%

amery_hurst_mean = np.mean(amery_hurst)
amery_sigma_mean = np.mean(amery_sigma)
amery_wdstar = (amery_sigma_mean)*(0.2-0.12*amery_hurst_mean**0.6)

larsen_hurst_mean = np.mean(larsen_hurst)
larsen_sigma_mean = np.mean(larsen_sigma)
larsen_wdstar = (larsen_sigma_mean)*(0.2-0.12*larsen_hurst_mean**0.6)

#%%
#AMERY
#0-80
amery_Fmean_1314 = np.mean(amery_obs_F[0:80])
#80-173
amery_Fmean_1415 = np.mean(amery_obs_F[80:173])
#173-258
amery_Fmean_1516 = np.mean(amery_obs_F[173:258])
#258-348
amery_Fmean_1617 = np.mean(amery_obs_F[258:348])
#348-430
amery_Fmean_1718 = np.mean(amery_obs_F[348:430])
#430-526
amery_Fmean_1819 = np.mean(amery_obs_F[430:526])
#526-end
amery_Fmean_1920 = np.mean(amery_obs_F[526:626])

amery_obs_Fmean = np.array([amery_Fmean_1314,amery_Fmean_1415,amery_Fmean_1516,amery_Fmean_1617,amery_Fmean_1718])


#LARSEN
#0-10
larsen_Fmean_1314 = np.mean(larsen_obs_F[0:10])
#10-25
larsen_Fmean_1415 = np.mean(larsen_obs_F[10:25])
#25-44
larsen_Fmean_1516 = np.mean(larsen_obs_F[25:44])
#44-72
larsen_Fmean_1617 = np.mean(larsen_obs_F[44:72])
#72-90
larsen_Fmean_1718 = np.mean(larsen_obs_F[72:90])
#90-106
larsen_Fmean_1819 = np.mean(larsen_obs_F[90:106])
#106-end
larsen_Fmean_1920 = np.mean(larsen_obs_F[106:129])

larsen_obs_Fmean = np.array([larsen_Fmean_1314,larsen_Fmean_1415,larsen_Fmean_1516,larsen_Fmean_1617,larsen_Fmean_1718])





#%%

amery_obs_len = len(amery_obs_Fmean)
S_amery = np.zeros(amery_obs_len)

for i in range(0,amery_obs_len):
    def F_Amery(x):
        return(0.13*sp.erf(55*x)*(2*sp.erf(0.08*x)+1-(0.0775*amery_hurst_mean**1.3))-amery_obs_Fmean[i])
    S_amery[i] = fsolve(F_Amery, 0)

larsen_obs_len = len(larsen_obs_Fmean)
S_larsen = np.zeros(larsen_obs_len)
for i in range(0,larsen_obs_len):
    def F_Larsen(x):
        return(0.13*sp.erf(55*x)*(2*sp.erf(0.08*x)+1-(0.0775*larsen_hurst_mean**1.3))-larsen_obs_Fmean[i])
    S_larsen[i] = fsolve(F_Larsen, 0)
    

#%%

amery_wS_opt = S_amery*amery_wdstar
larsen_wS_opt= S_larsen*larsen_wdstar

#%%
#AMERY & LARSEN DATES INDICES 418-478
#2013-14: 418-430
amery_meanro_1314 = np.mean(amery_runoff[418:430])
larsen_meanro_1314 = np.mean(larsen_runoff[418:430])
#2014-15: 430-442
amery_meanro_1415 = np.mean(amery_runoff[430:442])
larsen_meanro_1415 = np.mean(larsen_runoff[430:442])
#2015-16: 442-454
amery_meanro_1516 = np.mean(amery_runoff[442:454])
larsen_meanro_1516 = np.mean(larsen_runoff[442:454])
#2016-17: 454-466
amery_meanro_1617 = np.mean(amery_runoff[454:466])
larsen_meanro_1617 = np.mean(larsen_runoff[454:466])
#2017-18: 466-478
amery_meanro_1718 = np.mean(amery_runoff[466:478])
larsen_meanro_1718 = np.mean(larsen_runoff[466:478])

amery_meanro = np.array([amery_meanro_1314,amery_meanro_1415,amery_meanro_1516,amery_meanro_1617,amery_meanro_1718])
larsen_meanro = np.array([larsen_meanro_1314,larsen_meanro_1415,larsen_meanro_1516,larsen_meanro_1617,larsen_meanro_1718])


amery_wS = amery_runoff[418:478]
larsen_wS = larsen_runoff[418:478]

amery_dates = amery_dates[418:478]
larsen_dates = larsen_dates[418:478]

#%%
for i in range(0,len(amery_wS_opt)):
    i1=i*12
    i2=(i+1)*12
    amery_wS[i1:i2] = amery_wS[i1:i2]*(amery_wS_opt[i]/amery_meanro[i])
    larsen_wS[i1:i2] = larsen_wS[i1:i2]*(larsen_wS_opt[i]/larsen_meanro[i])

amery_wS = np.nan_to_num(amery_wS)
larsen_wS = np.nan_to_num(larsen_wS)
#%%
#Computing Avg FC
amery_F = np.zeros((len(amery_wS),len(amery_hurst)))
larsen_F = np.zeros((len(larsen_wS),len(larsen_hurst)))
for i in range(0,len(amery_wS)):
    amery_F[i,:] = F_param(amery_sigma,amery_hurst,amery_wS[i])
    larsen_F[i,:] = F_param(larsen_sigma,larsen_hurst,larsen_wS[i])
    
    
#Computing Avg LD
amery_wl = np.zeros((len(amery_wS),len(amery_hurst)))
larsen_wl = np.zeros((len(larsen_wS),len(larsen_hurst)))
for i in range(0,len(amery_wS)):
    amery_wl[i,:] = wl_param(amery_sigma,amery_hurst,amery_wS[i])
    larsen_wl[i,:] = wl_param(larsen_sigma,larsen_hurst,larsen_wS[i])
#%%
amer_dict_wl={str(amery_dates[0]):amery_wl[0,:]}
lar_dict_wl={str(larsen_dates[0]):larsen_wl[0,:]}


amer_dict_F={str(amery_dates[0]):amery_F[0,:]}
lar_dict_F={str(larsen_dates[0]):larsen_F[0,:]}

for i in range(1,len(larsen_dates)):
    amer_dict_wl.update({str(amery_dates[i]):amery_wl[i,:]})
    amer_dict_F.update({str(amery_dates[i]):amery_F[i,:]})
    
    lar_dict_wl.update({str(larsen_dates[i]):larsen_wl[i,:]})
    lar_dict_F.update({str(larsen_dates[i]):larsen_F[i,:]})
    


#%%
    
#Creating DataFrames
amery_df_wl = pd.DataFrame(amer_dict_wl)
amery_df_F = pd.DataFrame(amer_dict_F)

larsen_df_wl = pd.DataFrame(lar_dict_wl)
larsen_df_F = pd.DataFrame(lar_dict_F)

#%%
#Create Box Plot Statistics 
amer_wl_box = plt.boxplot(amery_df_wl)
amer_F_box = plt.boxplot(amery_df_F)

lar_wl_box = plt.boxplot(larsen_df_wl)
lar_F_box = plt.boxplot(larsen_df_F)

#%%
#Lake Depth Box Plot Statics
amer_wl_5 = np.array([item.get_ydata()[0] for item in amer_wl_box['caps']][::2])
amer_wl_95 = np.array([item.get_ydata()[0]for item in amer_wl_box['caps']][1::2])
amer_wl_25 = np.array([min(item.get_ydata()) for item in amer_wl_box['boxes']])
amer_wl_75 = np.array([max(item.get_ydata()) for item in amer_wl_box['boxes']])


lar_wl_5 = np.array([item.get_ydata()[0] for item in lar_wl_box['caps']][::2])
lar_wl_95 = np.array([item.get_ydata()[0]for item in lar_wl_box['caps']][1::2])
lar_wl_25 = np.array([min(item.get_ydata()) for item in lar_wl_box['boxes']])
lar_wl_75 = np.array([max(item.get_ydata()) for item in lar_wl_box['boxes']])

#Fractional Coverage Box Plot Statics
amer_F_5 = np.array([item.get_ydata()[0] for item in amer_F_box['caps']][::2])
amer_F_95 = np.array([item.get_ydata()[0]for item in amer_F_box['caps']][1::2])
amer_F_25 = np.array([min(item.get_ydata()) for item in amer_F_box['boxes']])
amer_F_75 = np.array([max(item.get_ydata()) for item in amer_F_box['boxes']])


lar_F_5 = np.array([item.get_ydata()[0] for item in lar_F_box['caps']][::2])
lar_F_95 = np.array([item.get_ydata()[0]for item in lar_F_box['caps']][1::2])
lar_F_25 = np.array([min(item.get_ydata()) for item in lar_F_box['boxes']])
lar_F_75 = np.array([max(item.get_ydata()) for item in lar_F_box['boxes']])

#%%
fig, axs = plt.subplots(2,2,layout='constrained')

fig.set_figheight(15)
fig.set_figwidth(17)
#Amery Lake Depth 
axs[0,0].plot(amery_obs_dates,amery_obs_wl,'ko')
axs[0,0].fill_between(amery_dates,amer_wl_5,amer_wl_95,color='lightcyan',alpha=1)
axs[0,0].fill_between(amery_dates,amer_wl_25,amer_wl_75,color='lightskyblue',alpha=1)
axs[0,0].set_xlim([amery_obs_dates[0],amery_dates[-1]])
axs[0,0].set_ylim([0,1.5])
axs[0,0].set_ylabel(r'$\bar{w}_l$ (meters)',fontsize=25)
axs[0,0].tick_params(axis='both',labelsize=22.5)
axs[0,0].set_title('A.',loc='left',fontweight='bold',fontsize=30)
axs[0,0].set_title(r"Amery Ice Shelf Mean Lake Depth ($\bar{w}_l$)",fontsize=20)
axs[0,0].xaxis.set_major_formatter(DateFormatter("%m%Y"))
for label in axs[0,0].get_xticklabels(minor=True):
    label.set_horizontalalignment('right')

#Amery Area Fraction 
axs[0,1].fill_between(amery_dates,amer_F_5,amer_F_95,color='lightcyan',alpha=1)
axs[0,1].fill_between(amery_dates,amer_F_25,amer_F_75,color='lightskyblue',alpha=1)
axs[0,1].plot(amery_obs_dates,amery_obs_F,'ko')
axs[0,1].set_xlim([amery_obs_dates[0],amery_dates[-1]])
axs[0,1].set_ylim([0,0.28])
axs[0,1].set_ylabel(r'$\bar{F}$',fontsize=25)
axs[0,1].tick_params(axis='both',labelsize=22.5)
axs[0,1].set_title('B.',loc='left',fontweight='bold',fontsize=30)
axs[0,1].set_title(r"Amery Ice Shelf Mean Lake Depth ($\bar{F}$)",fontsize=20)
axs[0,1].xaxis.set_major_formatter(DateFormatter("%m%Y"))
for label in axs[0,1].get_xticklabels(minor=True):
    label.set_horizontalalignment('right')

#Larsen Lake Depth 
axs[1,0].fill_between(larsen_dates,lar_wl_5,lar_wl_95,color='lightcyan',alpha=1)
axs[1,0].fill_between(larsen_dates,lar_wl_25,lar_wl_75,color='lightskyblue',alpha=1)
axs[1,0].plot(larsen_obs_dates,larsen_obs_wl,'ko')
axs[1,0].set_xlim([larsen_obs_dates[0],larsen_dates[-1]])
axs[1,0].set_xlabel("Dates",fontsize=20)
axs[1,0].set_ylim([0,1.5])
axs[1,0].set_ylabel(r'$\bar{w}_l$ (meters)',fontsize=25) 
axs[1,0].tick_params(axis='both',labelsize=22.5)
axs[1,0].set_title('C.',loc='left',fontweight='bold',fontsize=30)
axs[1,0].set_title(r"Larsen Ice Shelf Mean Lake Depth ($\bar{w}_l$)",fontsize=20)
axs[1,0].xaxis.set_major_formatter(DateFormatter("%m-%Y"))
for label in axs[1,0].get_xticklabels(minor=True):
    label.set_horizontalalignment('right')

#Larsen Area Fraction
axs[1,1].fill_between(larsen_dates,lar_F_5,lar_F_95,color='lightcyan',alpha=1)
axs[1,1].fill_between(larsen_dates,lar_F_25,lar_F_75,color='lightskyblue',alpha=1)
axs[1,1].plot(larsen_obs_dates,larsen_obs_F,'ko')
axs[1,1].set_xlim([larsen_obs_dates[0],larsen_dates[-1]])
axs[1,1].set_xlabel("Dates",fontsize=20)
axs[1,1].set_ylim([0,0.2])
axs[1,1].set_ylabel(r'$\bar{F}$',fontsize=25)
axs[1,1].tick_params(axis='both',labelsize=22.5)
axs[1,1].set_title('D.',loc='left',fontweight='bold',fontsize=30)
axs[1,1].set_title(r"Larsen Ice Shelf Mean Area Fraction ($\bar{F}$)",fontsize=20)
axs[1,1].xaxis.set_major_formatter(DateFormatter("%m-%Y"))
for label in axs[1,1].get_xticklabels(minor=True):
    label.set_horizontalalignment('cright')

fig.autofmt_xdate()

plt.savefig('Opt_Supp.eps',format='eps')
plt.savefig('Opt_Supp.png',format='png')




