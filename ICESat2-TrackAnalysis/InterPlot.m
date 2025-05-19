load("Inter_NewFreq.mat")
i = abs(inter.angle(:,2)-inter.angle(:,1))>1;
mdl_H=fitlm(inter.H(i,2),inter.H(i,1));
mdl_sigma = fitlm(inter.sigma(i,2), inter.sigma(i,1));
one2one_H = 0:0.1:1;
one2one_sigma = 0:1:10;

%Hurst Intersections
fig = figure;
fig.Position = [77,195,1701,822];
tiledlayout(1,2);
nexttile;
plot(inter.H(i,2),inter.H(i,1),'b*')
hold on 
plot(inter.H(i,2),mdl_H.Fitted,'r-')
plot(one2one_H, one2one_H,'k-')
hold off
xlabel("H($0^\circ>\theta\geq -90^\circ$)","Interpreter","latex")
ylabel("H($-90^\circ>\theta\geq -180^\circ$)","Interpreter","latex")
H_leg = legend({"Data","H($-90^\circ>\theta\geq -180^\circ$) = 0.0512H($0^\circ>\theta\geq -90^\circ$)+0.3803", ...
    "H($-90^\circ>\theta\geq -180^\circ$)=H($0^\circ>\theta\geq -90^\circ$)"});
set(H_leg, 'Interpreter','latex')
set(gca,fontsize=20)

%Sigma Intersection
nexttile;
plot(inter.sigma(i,2),inter.sigma(i,1),'b*')
hold on 
plot(inter.sigma(i,2),mdl_sigma.Fitted,'r-')
plot(one2one_sigma,one2one_sigma,'k-')
xlabel("$\sigma(0^\circ>\theta\geq -90^\circ)$","Interpreter","latex")
ylabel("$\sigma(-90^\circ>\theta\geq -180^\circ)$","Interpreter","latex")
xlim([0 10])
ylim([0 10])
sigma_leg = legend({"Data","$\sigma(-90^\circ>\theta\geq -180^\circ) = 0.715\sigma(0^\circ>\theta\geq -90^\circ)+8.31$", ...
    "$\sigma(-90^\circ>\theta\geq -180^\circ)=\sigma(0^\circ>\theta\geq -90^\circ)$"});
set(sigma_leg, 'Interpreter','latex')
set(gca,fontsize=20)
