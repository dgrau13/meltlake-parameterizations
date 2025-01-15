%ICESat2 Track Analysis 
%Pulling List of ICESat2 Files from June 2021 Directory 
list= glob('/storage/home/hcoda1/4/dgrau7/scratch/IceSat2_Data/202106/ATL06*.h5');
I = length(list);
disp(I)

%Preallocated Variables
lon_list = [];
lat_list = [];
h_list = [];
H_list = [];
sigma_list = [];
r_sq_list = [];
p_list = [];
angle_list = [];
total_subtracks = 0;
accept_subtracks = 0;
lat_tossed = [];
lon_tossed = [];

%Iterrating through each file 
for i=1:I
    disp(i)
    file(i) = string(cell2mat(list(i)));
    splice = char(file(i));
    date(i) = convertCharsToStrings(splice(65:78));
    finfo = h5info(file(i));
    g_names = {finfo.Groups.Name};
    %Checking if file contains L1 track Beam Data
    if ismember('/gt1l',g_names)==1
        ind = '/gt1l/land_ice_segments/';
    %Checking if file contains L2 track Beam Data (if L1 is not present)
    elseif ismember('/gt2l',g_names)==1
        ind = '/gt2l/land_ice_segments/';
    %Checking if file contains L3 track Beam Data (if L1 and L2 aren't
    %present
    elseif ismember('/gt3l',g_names)==1
        ind = '/gt3l/land_ice_segments/';
    end
    %Grabbing Latitude, Longitude, Ice Height, Satellite Orientation Data
    lati = h5read(file(i),append(ind,'latitude'));
    lon = h5read(file(i),append(ind,'longitude'));
    h_li= h5read(file(i),append(ind,'h_li'));
    h_li_sigma= h5read(file(i),append(ind,'h_li_sigma'));
    orien = h5read(file(i),append(ind,'ground_track/seg_azimuth'));
    %Eliminating Nonsensical Ice Heights from Data Set
    in = h_li<10^38;
    h_li = h_li(in);
    if isempty(h_li)==0
    lati = lati(in);
    lon = lon(in);
    orien = orien(in);
    %Calcuting Distance between each data point from start of track
    d = coord_dist(lon(1),lati(1),lon,lati);
    
    if length(d)>506 %Checking if track contains more than 506 points
        for j = 1:fix(length(d)/506)-1 %Subselecting subtracks from larger track
            j1 = j*506;
            j2 = (j+1)*506;
            lat_sel = lati(j1:j2);
            lon_sel = lon(j1:j2);
            h_sel = h_li(j1:j2);
            d_sel = d(j1:j2);
            d_sel = d_sel-d_sel(1);
	        d_dx = d_sel(2);
            L = d_sel(end);
            N = length(h_sel);
            orien_sel = orien(j1:j2);

            %Power Spectral Analysis 
            f = fftfreq(N,d_dx);
            h_fft = fft(h_sel);
            h_psd = abs(h_fft).^2;
            h_log = log(h_psd);
            f_log = log(f);
	        f_log = real(f_log);
            i2 = f_log>-9 & f_log<-5;
            %Linear Regression of the PSD 
            mdl = fitlm(f_log(2:end),-h_log(2:end));
            r_sq = mdl.Rsquared.Adjusted; %Goodness of Fit of Linear Regression
            beta = mdl.Coefficients.Estimate(2); %Spectral Decay Coefficent
            H = (beta-1)/2; %Hurst Calculation
            sigma = std(h_sel); %Calculating Standard Deviation of Topography 
            %Track Total Number of SubTracks Analyzed
            total_subtracks = 1+total_subtracks;
	    if r_sq <= 0.7
		lat_tossed = [lat_tossed lat_sel];
		lon_tossed = [lon_tossed lon_sel];
	    end 
            if r_sq>0.7 %Selecting Tracks with Linear Regression Fit Greater Than 0.7
            if H<1 & H>0 %Verfying Calculated is within Possible Range of Hurst Exponents
                %Storing Hurst, sigma, r-square, and capture angle of
                %entire subtrack
                H_vec = ones([length(h_sel) 1])*H;
                H_list = [H_list H_vec];
                lon_list = [lon_list lon_sel];
                lat_list = [lat_list lat_sel];
                h_list = [h_list h_sel];
                sigma_vec = ones([length(h_sel) 1])*sigma;
                sigma_list = [sigma_list sigma_vec];
                r_sq_vec = ones([length(h_sel) 1])*r_sq;
                r_sq_list = [r_sq_list r_sq_vec];
                angle_list = [angle_list orien_sel];
                %Calculating Amount of Subtracks Stored
                accept_subtracks = accept_subtracks +1;
            end
            end
            
        end
        continue;
    end
    continue;
    end
end

t = datetime(date,'InputFormat','yyyyMMddHHmmss'); %Date of ICESat-2 Track Acquitistion 

%Storing Data into new .mat file
save('202106_Final.mat','H_list','lat_list','lon_list','sigma_list','angle_list','h_list','r_sq_list','t','total_subtracks','accept_subtracks','lat_tossed','lon_tossed')
