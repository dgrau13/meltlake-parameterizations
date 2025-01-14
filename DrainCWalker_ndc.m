function thickness_out = DrainCWalker_ndc(totalwater,topo,drain_nodes,nsnaps,nwalkers_perpixel,seed,nb_matrix_idx)

N8list = [0 1;0 -1;1 0;-1 0;-1 -1;-1 1;1 -1;1 1];   %neighbor orientation

[n_x,n_y] = size(topo);
thickness = zeros(n_x+2,n_y+2);                     %make thickness with padding
nwalkers = floor(nwalkers_perpixel.*n_x.*n_y);      %number of precipitons

%% Precipiton Ordering
[NX,NY] = meshgrid(2:n_x+1,2:n_y+1);
nxuw = NX(:);
nxuw(drain_nodes(:)==1) = [];
nyuw = NY(:);
nyuw(drain_nodes(:)==1) = [];

nx_ordered = repmat(nxuw,[max([nwalkers_perpixel 1]) 1]);
ny_ordered = repmat(nyuw,[max([nwalkers_perpixel 1]) 1]);

nwalkers = length(nx_ordered);      %number of precipitons

switch seed
    case 'Order'
        %Seed pixels in order
        walker_init_locs(:,1) = nx_ordered(1:nwalkers);
        walker_init_locs(:,2) = ny_ordered(1:nwalkers);
    case 'Random'
        %Randomize pixel order (but still cover all pixels)
        rnd_order = randperm(nwalkers,nwalkers);
        walker_init_locs(:,1) = nx_ordered(rnd_order);
        walker_init_locs(:,2) = ny_ordered(rnd_order);
end

%% Pre-allocate space
thickness_out = zeros(n_x,n_y,nsnaps);
topo_padded = padarray(topo,[1 1],Inf);     %pad edges with Inf (impenetrable to walkers)
topothick_padded = topo_padded+thickness;  

stp=0;
for iwalker = 1:nwalkers                    %iterate through precipitons
    stp = stp+1;
    i = walker_init_locs(iwalker,1);
    j = walker_init_locs(iwalker,2);
    dwater_dwalker = totalwater/nwalkers;   %start with a set amount of water per walker
    
%     walker_path = [i,j];
%     walker_path_dry = [i,j];
    
    still_moving = 1;   
    while(still_moving)
        
        local_topothick = topothick_padded(i,j);   %local node topography + thickness
        
        nb_idx = nb_matrix_idx(i,j,:);             %indices of neighbors 
        topo_nb = topothick_padded(nb_idx);        %elevation of neighbors 
        topothick_nb = reshape(topo_nb,1,8,1);
            
        tt_nb_diff = local_topothick-topothick_nb;    %difference between local elevation and neighbors 
        [mx_tt_nb_diff,idx_steep] = max(tt_nb_diff);  %find direction of steepest descent
        
        if(mx_tt_nb_diff<=0)                       %if all neighbors are higher                 
            if(-1*mx_tt_nb_diff>dwater_dwalker)    %if highest barrier is greater then avail water thickness, then stop moving
                still_moving=0;
                local_drain = 0;
            else
                thickness(i,j) = thickness(i,j)-1*mx_tt_nb_diff+1e-3;       %if have more water than barrier, add water to thickness and spill over and keep going   
                topothick_padded(i,j) = topo_padded(i,j) + thickness(i,j);  
                dwater_dwalker = dwater_dwalker+mx_tt_nb_diff-1e-3;         %take away water left behind during spill over barrier

                i = i + N8list(idx_steep,1);                                %set new index of walker
                j = j + N8list(idx_steep,2);
                
                local_drain = drain_nodes(i-1,j-1);                         %local drainage node value
                
            end
%             walker_path = [];           %if all neighbors are higher, this path is not in drainage cluster
%             walker_path_dry = [];       %if all neighbors are higher, this path is not in drainage cluster
        else
            i = i + N8list(idx_steep,1);        %set new index of walker
            j = j + N8list(idx_steep,2);
            
            local_drain = drain_nodes(i-1,j-1);
%             walker_path = [walker_path;i,j];                           %if walker is moving, add to possible drainge cluster path
%             if(thickness(i,j)==0)
%                 walker_path_dry = [walker_path_dry;i,j];    %if walker is moving and on a dry spot, add to possible dry drainage cluster
%             else
%                 walker_path_dry = [];    %if spot is wet, this path is not in dry drainage cluter
%             end
            
        end
        
        if(local_drain)                  %if the walker is on a drainage node, stop and remove
            still_moving = 0;
%             if(~isempty(walker_path))
%                 drain_cluster(sub2ind(size(drain_cluster),walker_path(:,1)-1,walker_path(:,2)-1)) = 1; %add points in walker path to drainage cluster if ending at drainage node
%             end
%             if(~isempty(walker_path_dry))
%                 drain_cluster_dry(sub2ind(size(drain_cluster_dry),walker_path_dry(:,1)-1,walker_path_dry(:,2)-1)) = 1; %add points in dry walker path to dry drainage cluster if ending at drainage node
%             end

        end
        
    end
    if(~local_drain)         %if the walker does not end on a drainage node, add walker water to thickness field
        thickness(i,j) = thickness(i,j)+dwater_dwalker;
        topothick_padded(i,j) = topo_padded(i,j) + thickness(i,j);
        
    end
    
    if(mod(iwalker,floor(nwalkers/nsnaps))==0)
        thickness_out(:,:,iwalker/floor(nwalkers/nsnaps)) = thickness(2:end-1,2:end-1);        
        [iwalker/floor(nwalkers/nsnaps),iwalker]
        
%         if(~isempty(filename))
%             save([filename , '.mat'])
%         end
%         toc
%         tic
    end
    

end

end