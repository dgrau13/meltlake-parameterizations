#Import Packages
import numpy as np
import matplotlib.pyplot as plt
import scipy.io as sio
from scipy import special as sp
import pandas as pd
import seaborn as sns
from datetime import datetime
from matplotlib.dates import YearLocator, DateFormatter

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
amery_obs_ld = amery_depth[1].to_numpy()/1000
amery_obs_fc = amery_fcovr[1].to_numpy()
amery_obs_wd = amery_obs_ld*amery_obs_fc
amery_obs_dates = pd.to_datetime(amery_fcovr[0]).to_numpy()
amery_runoff = amery_supp[2].to_numpy()/1000
amery_dates = pd.to_datetime(amery_supp[1]).to_numpy()
amery_dates = amery_dates[418:478]
amery_runoff = amery_runoff[418:478]

larsen_hurst = larsen_stats.H.to_numpy()
larsen_sigma = larsen_stats.sigma.to_numpy()
larsen_obs_ld = larsen_depth[1].to_numpy()/1000
larsen_obs_fc = larsen_fcovr[1].to_numpy()
larsen_obs_wd = larsen_obs_ld*larsen_obs_fc
larsen_obs_dates = pd.to_datetime(larsen_fcovr[0]).to_numpy()
larsen_runoff = larsen_supp[2].to_numpy()/1000
larsen_dates = pd.to_datetime(larsen_supp[1]).to_numpy()
larsen_dates = larsen_dates[418:478]
larsen_runoff = larsen_runoff[418:478]

#%%

# #Defining Functions 
# #Average Water Depth Parameterization
# def wd_param(sig,H,w_S):
#     wd_star = sig*(0.2-0.12*H**0.6)
#     S = w_S/wd_star
#     wat_dep = sig*(sp.erf(0.27*S))*(0.9-0.08*H**0.6 -0.72*sp.erf(0.76*S))
#     return(wat_dep)

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

perc_thresh = 0#in meters
for i in range(0,len(amery_runoff)):
    if amery_runoff[i]<=perc_thresh:
        amery_runoff[i]= 0
    else:
        amery_runoff[i] = amery_runoff[i] - perc_thresh

for i in range(0,len(larsen_runoff)):
    if larsen_runoff[i]<=perc_thresh:
        larsen_runoff[i]= 0
    else:
        larsen_runoff[i] = larsen_runoff[i] - perc_thresh

#%%
        
# #Computing Avg WD
# amery_wd = np.zeros((len(amery_runoff),len(amery_hurst)))
# larsen_wd = np.zeros((len(larsen_runoff),len(larsen_hurst)))
# for i in range(0,len(amery_runoff)):
#     amery_wd[i,:] = wd_param(amery_sigma,amery_hurst,amery_runoff[i])
#     larsen_wd[i,:] = wd_param(larsen_sigma,larsen_hurst,larsen_runoff[i])

#Computing Avg FC
amery_fc = np.zeros((len(amery_runoff),len(amery_hurst)))
larsen_fc = np.zeros((len(larsen_runoff),len(larsen_hurst)))
for i in range(0,len(amery_runoff)):
    amery_fc[i,:] = F_param(amery_sigma,0.6,amery_runoff[i])
    larsen_fc[i,:] = F_param(larsen_sigma,0.6,larsen_runoff[i])
    
    
#Computing Avg LD
amery_ld = np.zeros((len(amery_runoff),len(amery_hurst)))
larsen_ld = np.zeros((len(larsen_runoff),len(larsen_hurst)))
for i in range(0,len(amery_runoff)):
    amery_ld[i,:] = wl_param(amery_sigma,0.6,amery_runoff[i])
    larsen_ld[i,:] = wl_param(larsen_sigma,0.6,larsen_runoff[i])

#%%
    
#Creating Dictionaries for Melt Lake Parameters
# lar_dict_wd={str(larsen_dates[0]):larsen_wd[0,:]}
# amer_dict_wd={str(amery_dates[0]):amery_wd[0,:]}

lar_dict_ld={str(larsen_dates[0]):larsen_ld[0,:]}
amer_dict_ld={str(amery_dates[0]):amery_ld[0,:]}

lar_dict_fc={str(larsen_dates[0]):larsen_fc[0,:]}
amer_dict_fc={str(amery_dates[0]):amery_fc[0,:]}

for i in range(1,len(larsen_dates)):
    # lar_dict_wd.update({str(larsen_dates[i]):larsen_wd[i,:]})
    lar_dict_ld.update({str(larsen_dates[i]):larsen_ld[i,:]})
    lar_dict_fc.update({str(larsen_dates[i]):larsen_fc[i,:]})
    
    #amer_dict_wd.update({str(amery_dates[i]):amery_wd[i,:]})
    amer_dict_ld.update({str(amery_dates[i]):amery_ld[i,:]})
    amer_dict_fc.update({str(amery_dates[i]):amery_fc[i,:]})

#%%
    
#Creating DataFrames
#larsen_df_wd = pd.DataFrame(lar_dict_wd)
larsen_df_ld = pd.DataFrame(lar_dict_ld)
larsen_df_fc = pd.DataFrame(lar_dict_fc)

#amery_df_wd = pd.DataFrame(amer_dict_wd)
amery_df_ld = pd.DataFrame(amer_dict_ld)
amery_df_fc = pd.DataFrame(amer_dict_fc)

#%%

#Creating Box Plot Statistics
#lar_wd_box = plt.boxplot(larsen_df_wd)
lar_ld_box = plt.boxplot(larsen_df_ld)
lar_fc_box = plt.boxplot(larsen_df_fc)

#amer_wd_box = plt.boxplot(amery_df_wd)
amer_ld_box = plt.boxplot(amery_df_ld)
amer_fc_box = plt.boxplot(amery_df_fc)

#%%

#Water Depth Box Plot Statics
#lar_wd_5 = np.array([item.get_ydata()[0] for item in lar_wd_box['caps']][::2])
# lar_wd_95 = np.array([item.get_ydata()[0]for item in lar_wd_box['caps']][1::2])
# lar_wd_25 = np.array([min(item.get_ydata()) for item in lar_wd_box['boxes']])
# lar_wd_75 = np.array([max(item.get_ydata()) for item in lar_wd_box['boxes']])

# amer_wd_5 = np.array([item.get_ydata()[0] for item in amer_wd_box['caps']][::2])
# amer_wd_95 = np.array([item.get_ydata()[0]for item in amer_wd_box['caps']][1::2])
# amer_wd_25 = np.array([min(item.get_ydata()) for item in amer_wd_box['boxes']])
# amer_wd_75 = np.array([max(item.get_ydata()) for item in amer_wd_box['boxes']])

#Lake Depth Box Plot Statics
lar_ld_5 = np.array([item.get_ydata()[0] for item in lar_ld_box['caps']][::2])
lar_ld_95 = np.array([item.get_ydata()[0]for item in lar_ld_box['caps']][1::2])
lar_ld_25 = np.array([min(item.get_ydata()) for item in lar_ld_box['boxes']])
lar_ld_75 = np.array([max(item.get_ydata()) for item in lar_ld_box['boxes']])

amer_ld_5 = np.array([item.get_ydata()[0] for item in amer_ld_box['caps']][::2])
amer_ld_95 = np.array([item.get_ydata()[0]for item in amer_ld_box['caps']][1::2])
amer_ld_25 = np.array([min(item.get_ydata()) for item in amer_ld_box['boxes']])
amer_ld_75 = np.array([max(item.get_ydata()) for item in amer_ld_box['boxes']])

#Fractional Coverage Box Plot Statics
lar_fc_5 = np.array([item.get_ydata()[0] for item in lar_fc_box['caps']][::2])
lar_fc_95 = np.array([item.get_ydata()[0]for item in lar_fc_box['caps']][1::2])
lar_fc_25 = np.array([min(item.get_ydata()) for item in lar_fc_box['boxes']])
lar_fc_75 = np.array([max(item.get_ydata()) for item in lar_fc_box['boxes']])

amer_fc_5 = np.array([item.get_ydata()[0] for item in amer_fc_box['caps']][::2])
amer_fc_95 = np.array([item.get_ydata()[0]for item in amer_fc_box['caps']][1::2])
amer_fc_25 = np.array([min(item.get_ydata()) for item in amer_fc_box['boxes']])
amer_fc_75 = np.array([max(item.get_ydata()) for item in amer_fc_box['boxes']])

#%%

#lar_i = larsen_obs_wd>=0
#amer_i = amery_obs_wd>=0
#lar_r = larsen_runoff>=0
#amer_r = amery_runoff>=0

#%%
fig, axs = plt.subplots(2,2,layout='constrained')

fig.set_figheight(21)
fig.set_figwidth(19)
#Amery Lake Depth 
axs[0,0].plot(amery_obs_dates,amery_obs_ld,'ko',label="Observations")
axs[0,0].fill_between(amery_dates,amer_ld_5,amer_ld_95,color='lightcyan',alpha=1,label="5th & 95th Percentile")
axs[0,0].fill_between(amery_dates,amer_ld_25,amer_ld_75,color='lightskyblue',alpha=1,label="25th & 75th Percentile")
axs2_00 = axs[0,0].twinx()
axs2_00.set_ylabel('Simulated Runoff (m)',color='r',fontsize=25)
axs2_00.plot(amery_dates,amery_runoff,'r',label = 'RACMO Amery Runoff')
axs2_00.tick_params(axis='y', labelcolor='r')
axs2_00.tick_params(axis='both',labelsize=22.5)
axs[0,0].set_xlim([amery_obs_dates[0],amery_dates[-1]])
#axs[0,0].set_ylim([0,1.5])
axs[0,0].set_ylabel(r'$\bar{w}_l$ (meters)',fontsize=25)
axs[0,0].tick_params(axis='both',labelsize=22.5)
axs[0,0].set_title('A.',loc='left',fontweight='bold',fontsize=30)
axs[0,0].set_title(r"Amery Ice Shelf Mean Lake Depth ($\bar{w}_l$)",fontsize=20)
axs[0,0].xaxis.set_major_formatter(DateFormatter("%m-%Y"))
lines00,labels00 =axs[0,0].get_legend_handles_labels()
lines00_2, labels00_2 = axs2_00.get_legend_handles_labels()
plt.legend(lines00 + lines00_2, labels00 + labels00_2,loc=0)
for label in axs[0,0].get_xticklabels(minor=True):
    label.set_horizontalalignment('right')

#Amery Area Fraction 
axs[0,1].fill_between(amery_dates,amer_fc_5,amer_fc_95,color='lightcyan',alpha=1,label="5th & 95th Percentile")
axs[0,1].fill_between(amery_dates,amer_fc_25,amer_fc_75,color='lightskyblue',alpha=1,label="25th & 75th Percentile")
axs[0,1].plot(amery_obs_dates,amery_obs_fc,'ko',label="Observations")
axs2_01 = axs[0,1].twinx()
axs2_01.set_ylabel('Simulated Runoff (m)',color='r',fontsize=25)
axs2_01.plot(amery_dates,amery_runoff,'r',label = 'RACMO Amery Runoff')
axs2_01.tick_params(axis='y', labelcolor='r')
axs2_01.tick_params(axis='both',labelsize=22.5)
axs[0,1].set_xlim([amery_obs_dates[0],amery_dates[-1]])
#axs[0,1].set_ylim([0,0.28])
axs[0,1].set_ylabel(r'$\bar{F}$',fontsize=25)
axs[0,1].tick_params(axis='both',labelsize=22.5)
axs[0,1].set_title('B.',loc='left',fontweight='bold',fontsize=30)
axs[0,1].set_title(r"Amery Ice Shelf Mean Area Fraction ($\bar{F}$)",fontsize=20)
axs[0,1].xaxis.set_major_formatter(DateFormatter("%m-%Y"))
lines01,labels01 =axs[0,1].get_legend_handles_labels()
lines01_2, labels01_2 = axs2_01.get_legend_handles_labels()
plt.legend(lines01 + lines01_2, labels01 + labels01_2,loc=0)


for label in axs[0,1].get_xticklabels(minor=True):
    label.set_horizontalalignment('right')

#Larsen Lake Depth 
axs[1,0].fill_between(larsen_dates,lar_ld_5,lar_ld_95,color='lightcyan',alpha=1,label="5th & 95th Percentile")
axs[1,0].fill_between(larsen_dates,lar_ld_25,lar_ld_75,color='lightskyblue',alpha=1,label="25th & 75th Percentile")
axs[1,0].plot(larsen_obs_dates,larsen_obs_ld,'ko',label="Observations")
axs2_10 = axs[1,0].twinx()
axs2_10.set_ylabel('Simulated Runoff (m)',color='r',fontsize=25)
axs2_10.plot(larsen_dates,larsen_runoff,'r',label = 'RACMO Larsen Runoff')
axs2_10.tick_params(axis='y', labelcolor='r')
axs2_10.tick_params(axis='both',labelsize=22.5)
axs[1,0].set_xlim([larsen_obs_dates[0],larsen_dates[-1]])
axs[1,0].set_xlabel("Dates",fontsize=20)
#axs[1,0].set_ylim([0,1.5])
axs[1,0].set_ylabel(r'$\bar{w}_l$ (meters)',fontsize=25) 
axs[1,0].tick_params(axis='both',labelsize=22.5)
axs[1,0].set_title('C.',loc='left',fontweight='bold',fontsize=30)
axs[1,0].set_title(r"Larsen Ice Shelf Mean Lake Depth ($\bar{w}_l$)",fontsize=20)
axs[1,0].xaxis.set_major_formatter(DateFormatter("%m-%Y"))
lines10,labels10 =axs[1,0].get_legend_handles_labels()
lines10_2, labels10_2 = axs2_10.get_legend_handles_labels()
plt.legend(lines10 + lines10_2, labels10 + labels10_2,loc=0)
for label in axs[1,0].get_xticklabels(minor=True):
    label.set_horizontalalignment('right')

#Larsen Area Fraction
axs[1,1].fill_between(larsen_dates,lar_fc_5,lar_fc_95,color='lightcyan',alpha=1,label="5th & 95th Percentile")
axs[1,1].fill_between(larsen_dates,lar_fc_25,lar_fc_75,color='lightskyblue',alpha=1,label="25th & 75th Percentile")
axs[1,1].plot(larsen_obs_dates,larsen_obs_fc,'ko',label="Observations")

axs2_11 = axs[1,1].twinx()
axs2_11.set_ylabel('Simulated Runoff (m)',color='r',fontsize=25)
axs2_11.plot(larsen_dates,larsen_runoff,'r',label = 'RACMO Larsen Runoff')
axs2_11.tick_params(axis='y', labelcolor='r')
axs2_11.tick_params(axis='both',labelsize=22.5)
axs[1,1].set_xlim([larsen_obs_dates[0],larsen_dates[-1]])
axs[1,1].set_xlabel("Dates",fontsize=20)
#axs[1,1].set_ylim([0,0.2])
axs[1,1].set_ylabel(r'$\bar{F}$',fontsize=25)
axs[1,1].tick_params(axis='both',labelsize=22.5)
axs[1,1].set_title('D.',loc='left',fontweight='bold',fontsize=30)
axs[1,1].set_title(r"Larsen Ice Shelf Mean Area Fraction ($\bar{F}$)",fontsize=20)
axs[1,1].xaxis.set_major_formatter(DateFormatter("%m-%Y"))
lines11,labels11 =axs[1,1].get_legend_handles_labels()
lines11_2, labels11_2 = axs2_11.get_legend_handles_labels()
plt.legend(lines11 + lines11_2, labels11 + labels11_2,loc=0)

for label in axs[1,1].get_xticklabels(minor=True):
    label.set_horizontalalignment('cright')

fig.autofmt_xdate()
plt.savefig('AntVald.eps',format='eps')
plt.savefig('AntVald.png',format='png')


