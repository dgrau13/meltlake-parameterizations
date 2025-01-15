%Preallocating Variables
an_angle_list = [];
an_h_list = [];
an_H_list=[];
an_lat_list=[];
an_lon_list = [];
an_r_sq_list = [];
an_sigma_list = [];
t_list = [];
total_subtracks_list = [];
passed_subtracks_list = [];
an_lat_tossed = [];
an_lon_tossed = [];

%Loading Data of Analyzed Data from June 2021 - June 2022 and Saving into
%Temporary Variables
load ('202106_Final.mat')
an_angle_list = angle_list;
an_h_list = h_list;
an_H_list = H_list;
an_lat_list = lat_list;
an_lon_list = lon_list;
an_r_sq_list = r_sq_list;
an_sigma_list = sigma_list;
t_list = t;
total_subtracks_list = total_subtracks;
passed_subtracks_list = accept_subtracks;
an_lat_tossed = [an_lat_tossed lat_tossed];
an_lon_tossed = [an_lon_tossed lon_tossed];


load('202107_Final.mat')
an_angle_list = [an_angle_list angle_list];
an_h_list = [an_h_list h_list];
an_H_list = [an_H_list H_list];
an_lat_list = [an_lat_list lat_list];
an_lon_list = [an_lon_list lon_list];
an_r_sq_list = [an_r_sq_list r_sq_list];
an_sigma_list = [an_sigma_list sigma_list];
t_list = [t_list,t];
total_subtracks_list = [total_subtracks_list total_subtracks];
passed_subtracks_list = [passed_subtracks_list accept_subtracks];
an_lat_tossed = [an_lat_tossed lat_tossed];
an_lon_tossed = [an_lon_tossed lon_tossed];

load('202108_Final.mat')
an_angle_list = [an_angle_list angle_list];
an_h_list = [an_h_list h_list];
an_H_list = [an_H_list H_list];
an_lat_list = [an_lat_list lat_list];
an_lon_list = [an_lon_list lon_list];
an_r_sq_list = [an_r_sq_list r_sq_list];
an_sigma_list = [an_sigma_list sigma_list];
t_list = [t_list,t];
total_subtracks_list = [total_subtracks_list total_subtracks];
passed_subtracks_list = [passed_subtracks_list accept_subtracks];
an_lat_tossed = [an_lat_tossed lat_tossed];
an_lon_tossed = [an_lon_tossed lon_tossed];

load('202109_Final.mat')
an_angle_list = [an_angle_list angle_list];
an_h_list = [an_h_list h_list];
an_H_list = [an_H_list H_list];
an_lat_list = [an_lat_list lat_list];
an_lon_list = [an_lon_list lon_list];
an_r_sq_list = [an_r_sq_list r_sq_list];
an_sigma_list = [an_sigma_list sigma_list];
t_list = [t_list,t];
total_subtracks_list = [total_subtracks_list total_subtracks];
passed_subtracks_list = [passed_subtracks_list accept_subtracks];
an_lat_tossed = [an_lat_tossed lat_tossed];
an_lon_tossed = [an_lon_tossed lon_tossed];

load('202110_Final.mat')
an_angle_list = [an_angle_list angle_list];
an_h_list = [an_h_list h_list];
an_H_list = [an_H_list H_list];
an_lat_list = [an_lat_list lat_list];
an_lon_list = [an_lon_list lon_list];
an_r_sq_list = [an_r_sq_list r_sq_list];
an_sigma_list = [an_sigma_list sigma_list];
t_list = [t_list,t];
total_subtracks_list = [total_subtracks_list total_subtracks];
passed_subtracks_list = [passed_subtracks_list accept_subtracks];
an_lat_tossed = [an_lat_tossed lat_tossed];
an_lon_tossed = [an_lon_tossed lon_tossed];

load('202111_Final.mat')
an_angle_list = [an_angle_list angle_list];
an_h_list = [an_h_list h_list];
an_H_list = [an_H_list H_list];
an_lat_list = [an_lat_list lat_list];
an_lon_list = [an_lon_list lon_list];
an_r_sq_list = [an_r_sq_list r_sq_list];
an_sigma_list = [an_sigma_list sigma_list];
t_list = [t_list,t];
total_subtracks_list = [total_subtracks_list total_subtracks];
passed_subtracks_list = [passed_subtracks_list accept_subtracks];
an_lat_tossed = [an_lat_tossed lat_tossed];
an_lon_tossed = [an_lon_tossed lon_tossed];

load('202112_Final.mat')
an_angle_list = [an_angle_list angle_list];
an_h_list = [an_h_list h_list];
an_H_list = [an_H_list H_list];
an_lat_list = [an_lat_list lat_list];
an_lon_list = [an_lon_list lon_list];
an_r_sq_list = [an_r_sq_list r_sq_list];
an_sigma_list = [an_sigma_list sigma_list];
t_list = [t_list,t];
total_subtracks_list = [total_subtracks_list total_subtracks];
passed_subtracks_list = [passed_subtracks_list accept_subtracks];
an_lat_tossed = [an_lat_tossed lat_tossed];
an_lon_tossed = [an_lon_tossed lon_tossed];

load('202201_Final.mat')
an_angle_list = [an_angle_list angle_list];
an_h_list = [an_h_list h_list];
an_H_list = [an_H_list H_list];
an_lat_list = [an_lat_list lat_list];
an_lon_list = [an_lon_list lon_list];
an_r_sq_list = [an_r_sq_list r_sq_list];
an_sigma_list = [an_sigma_list sigma_list];
t_list = [t_list,t];
total_subtracks_list = [total_subtracks_list total_subtracks];
passed_subtracks_list = [passed_subtracks_list accept_subtracks];
an_lat_tossed = [an_lat_tossed lat_tossed];
an_lon_tossed = [an_lon_tossed lon_tossed];

load('202202_Final.mat')
an_angle_list = [an_angle_list angle_list];
an_h_list = [an_h_list h_list];
an_H_list = [an_H_list H_list];
an_lat_list = [an_lat_list lat_list];
an_lon_list = [an_lon_list lon_list];
an_r_sq_list = [an_r_sq_list r_sq_list];
an_sigma_list = [an_sigma_list sigma_list];
t_list = [t_list,t];
total_subtracks_list = [total_subtracks_list total_subtracks];
passed_subtracks_list = [passed_subtracks_list accept_subtracks];
an_lat_tossed = [an_lat_tossed lat_tossed];
an_lon_tossed = [an_lon_tossed lon_tossed];

load('202203_Final.mat')
an_angle_list = [an_angle_list angle_list];
an_h_list = [an_h_list h_list];
an_H_list = [an_H_list H_list];
an_lat_list = [an_lat_list lat_list];
an_lon_list = [an_lon_list lon_list];
an_r_sq_list = [an_r_sq_list r_sq_list];
an_sigma_list = [an_sigma_list sigma_list];
t_list = [t_list,t];
total_subtracks_list = [total_subtracks_list total_subtracks];
passed_subtracks_list = [passed_subtracks_list accept_subtracks];
an_lat_tossed = [an_lat_tossed lat_tossed];
an_lon_tossed = [an_lon_tossed lon_tossed];


load('202204_Final.mat')
an_angle_list = [an_angle_list angle_list];
an_h_list = [an_h_list h_list];
an_H_list = [an_H_list H_list];
an_lat_list = [an_lat_list lat_list];
an_lon_list = [an_lon_list lon_list];
an_r_sq_list = [an_r_sq_list r_sq_list];
an_sigma_list = [an_sigma_list sigma_list];
t_list = [t_list,t];
total_subtracks_list = [total_subtracks_list total_subtracks];
passed_subtracks_list = [passed_subtracks_list accept_subtracks];
an_lat_tossed = [an_lat_tossed lat_tossed];
an_lon_tossed = [an_lon_tossed lon_tossed];

load('202205_Final.mat')
an_angle_list = [an_angle_list angle_list];
an_h_list = [an_h_list h_list];
an_H_list = [an_H_list H_list];
an_lat_list = [an_lat_list lat_list];
an_lon_list = [an_lon_list lon_list];
an_r_sq_list = [an_r_sq_list r_sq_list];
an_sigma_list = [an_sigma_list sigma_list];
t_list = [t_list,t];
total_subtracks_list = [total_subtracks_list total_subtracks];
passed_subtracks_list = [passed_subtracks_list accept_subtracks];
an_lat_tossed = [an_lat_tossed lat_tossed];
an_lon_tossed = [an_lon_tossed lon_tossed];

load('202206_Final.mat')
an_angle_list = [an_angle_list angle_list];
an_h_list = [an_h_list h_list];
an_H_list = [an_H_list H_list];
an_lat_list = [an_lat_list lat_list];
an_lon_list = [an_lon_list lon_list];
an_r_sq_list = [an_r_sq_list r_sq_list];
an_sigma_list = [an_sigma_list sigma_list];
t_list = [t_list,t];
total_subtracks_list = [total_subtracks_list total_subtracks];
passed_subtracks_list = [passed_subtracks_list accept_subtracks];
an_lat_tossed = [an_lat_tossed lat_tossed];
an_lon_tossed = [an_lon_tossed lon_tossed];

%Storing Fully Analyzed ICESat-2 Data into Matlab Structure
an.angle_list = an_angle_list;
an.h_list = an_h_list;
an.H_list = an_H_list;
an.lat_list = an_lat_list;
an.lon_list = an_lon_list;
an.r_sq_list = an_r_sq_list;
an.sigma_list = an_sigma_list;
an.t = t_list;
an.total_subtracks = total_subtracks_list;
an.passed_subtracks = passed_subtracks_list;
an.lat_tossed = an_lat_tossed;
an.lon_tossed = an_lon_tossed;

%Eliminating Unnecessary Variables
clear an_angle_list an_lat_list an_lon_list an_h_list an_H_list an_r_sq_list an_sigma_list t_list t angle_list h_list H_list lat_list lon_list r_sq_list sigma_list total_subtracks total_subtracks_list passed_subtracks_list accept_subtracks lat_tossed lon_tossed an_lat_tossed an_lon_tossed

%Finding the Intersection Points Between Subtracks
%Preallocating Variables for Intersections Analysis 
[I,J] = size(an_lat_list);
disp(J);
lon_inter = [];
lat_inter = [];
iout = [];
jout = [];
coordii = [];
coordjj = [];
H_inter = [];
h_inter=[];
angle_inter = [];
sigma_inter=[];
r_sq_inter=[];

lat_list = [an.lat_list];
lon_list = [an.lon_list];

%Using Intersections
for i = 1:101
    disp(i);
    for j = i+1:J
        [loi,lai,ii,jj] = intersections(lon_list(:,i),lat_list(:,i),lon_list(:,j),lat_list(:,j)); %Collecting indices of intersections between each subtrack
        if isempty(loi)==1 && isempty(lai)==1 %Checking if there aren't any intersection points between two subtracks
            continue;
        else
            %Storing Intersections Data between two subtracks
            lon_inter = [lon_inter, loi'];
            lat_inter =[lat_inter, lai'];
            iout = [iout, round(ii,0)'];
            jout = [jout,round(jj,0)'];
            temp_ii = [an.lon_list(round(ii,0),i),an.lat_list(round(ii,0),i)];
            coordii = [coordii;temp_ii];
            temp_jj = [an.lon_list(round(jj,0),j),an.lat_list(round(jj,0),j)];
            coordjj= [coordjj;temp_jj];
            H_temp =[an.H_list(round(ii,0),i),an.H_list(round(jj,0),j)];
            H_inter= [H_inter;H_temp];
            angle_temp = [an.angle_list(round(ii,0),i),an.angle_list(round(jj,0),j)];
            angle_inter = [angle_inter;angle_temp];
            h_temp = [an.h_list(round(ii,0),i),an.h_list(round(jj,0),j)];
            h_inter = [h_inter;h_temp];
	        sigma_temp = [an.sigma_list(round(ii,0),i),an.sigma_list(round(jj,0),j)];
            sigma_inter = [sigma_inter;sigma_temp];
            r_sq_temp = [an.r_sq_list(round(ii,0),i),an.r_sq_list(round(jj,0),j)];
            r_sq_inter = [r_sq_inter;r_sq_temp];
        end
    end
end

%Storing Intersection Subtrack Data into Matlab Strutcture
inter.lat = lat_inter;
inter.lon = lon_inter;
inter.i = iout;
inter.j = jout;
inter.coordi = coordii;
inter.coordj = coordjj;
inter.h = h_inter;
inter.H = H_inter;
inter.r_sq = r_sq_inter;
inter.angle = angle_inter;
inter.sigma = sigma_inter;
save('Inter_NewFreq.mat','inter','-v7.3')
