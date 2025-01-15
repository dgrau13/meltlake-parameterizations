%Updated Analog Melt Water Distribution Simulation
itter = 50; 
m = 100;
n = 100;
snap_num = 100;
Lx = 10000;

%Constrained Hurst and Sigma Values 
s = 1:1:20;
h = 0:0.1:1;

%Pre-Allocating Matrices sizes 
wd_walker=zeros(length(s),length(h),snap_num,itter);
wd_star = zeros(length(s),length(h),itter);
fc_walker = zeros(length(s),length(h),snap_num,itter);
ld_walker = zeros(length(s),length(h),snap_num,itter);
supp = zeros(length(s),length(h),snap_num,itter);
fr =zeros(length(s),length(h),snap_num,itter);
wf = zeros(length(s),length(h),snap_num,itter);

for a=1:itter
    ns = 100;
    %Setting up Empty Matrices for Parallel For Loop
    wd_walker_temp = zeros(length(s),length(h),ns);
    wd_star_temp = zeros(length(s),length(h));
    ld_walker_temp = zeros(length(s),length(h),ns);
    fc_walker_temp = zeros(length(s),length(h),ns);
    supp_temp = zeros(length(s),length(h),ns);
    wf_temp = zeros(length(s),length(h),ns);
    fr_temp = zeros(length(s),length(h),ns);
    %Normal Analysis 
    for b=1:length(s)
        for c=1:length(h)
            surface=artificial_surf(s(b),h(c),Lx,m,n);
            surfacefill = imfill(surface);
            waterdepth_fill = surfacefill-surface;

            wd_star_temp(b,c)=mean(mean(waterdepth_fill));
            topo =surface;
        %DEM should be imported as variable "topo"
        %dx is the grid resolution
            dx=1;
            water_supply = 3;               %average depth of water to supply to surface

            x = dx*(1:1:size(topo,2))';
            y = dx*(1:1:size(topo,1))';
            [X,Y] = meshgrid(x,y);

            L_x = max(x);
            L_y = max(y);

            n_x = length(x);
            n_y = length(y);
            nb_matrix_idx = makeNBmatrix(n_y,n_x);  %create the neighbor matrix which is used by the CA code

            drain_nodes = zeros(n_y,n_x);   %here is where you define the drainage node
            drain_nodes(n_y,:) = 1;         %xend nodes in drainage cluster
            drain_nodes(:,1) = 1;           %y=1 nodes in drainage cluster
            drain_nodes(:,end) = 1;         %yend nodes in drainage cluster

            totalwater = 10*wd_star_temp(b,c)*Lx^2;  %total volume of water to put on DEM
            nsnaps = 100;                    %number of output snapshots (divides totalwater evenly)
            nwalkers_perpixel = 1;          %how many precipitons to make per node (more will ensure smooth filling, but take longer to run code)
            seed = 'Order';                %what order to seed the precipitons on the surface (options: random or order)
            thickness_out= DrainCWalker_ndc(totalwater,topo,drain_nodes,nsnaps,nwalkers_perpixel,seed,nb_matrix_idx);
            thickness_out(thickness_out<0.01)=0;
	    for d=1:100
	            waterdepth_walker = thickness_out(:,:,d);
                thickness_snap = thickness_out(:,:,d);
                wd_walker_temp(b,c,d) = mean(mean(thickness_out(:,:,d)));
                supp_temp(b,c,d) = totalwater;
                wf_temp(b,c,d) = wd_walker_temp(b,c,d)/wd_star_temp(b,c);
                fc_walker_temp(b,c,d)= sum(sum(waterdepth_walker>0))/(m*n);
                ld_walker_temp(b,c,d) = mean(waterdepth_walker(waterdepth_walker>0));
                fr_temp(b,c,d) = wd_walker_temp(b,c,d)*m*n./supp_temp(b,c,d);
            end
        end
    end
%Storing the inputs 
wd_star(:,:,a) = wd_star_temp;
wd_walker(:,:,:,a) = wd_walker_temp;
ld_walker(:,:,:,a) = ld_walker_temp;
fc_walker(:,:,:,a) = fc_walker_temp;
wf (:,:,:,a) = wf_temp;
fr(:,:,:,a) = fr_temp;
supp(:,:,:,a) = supp_temp;
end

save('Full10K500NormMeltPondNumerSim2_100Snaps','wd_star','wd_walker','supp','ld_walker','fc_walker','fr','wf')
