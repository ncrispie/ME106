clear all;
close all;

load ca-currents.mat

D = load('coastline.dat', '-ascii');

time = 0:6:6*96;

%%% Reformat data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xmax = max(max(max(X)));
xmin = min(min(min(X)));
xdel = (max(max(max(X))) - min(min(min(X))))/(length(X(1,1,:))-1);
ymax = max(max(max(Y)));
ymin = min(min(min(Y)));
ydel = (max(max(max(Y))) - min(min(min(Y))))/(length(Y(1,:,1))-1);

xvec = xmin:xdel:xmax;
yvec = ymin:ydel:ymax;
[Xn, Yn, Tn] = meshgrid(xvec,yvec,time); % New grid data

% The data was funky, so we use interpolation here instead of simple
% permutation
Un = zeros(size(Xn));
Vn = zeros(size(Yn));
for i = 1:length(time)
    Un(:,:,i) = griddata(squeeze(X(i,:,:)),squeeze(Y(i,:,:)),squeeze(U(i,:,:)),Xn(:,:,i),Yn(:,:,i));
    Vn(:,:,i) = griddata(squeeze(X(i,:,:)),squeeze(Y(i,:,:)),squeeze(V(i,:,:)),Xn(:,:,i),Yn(:,:,i));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:length(time)
    quiver(Xn(:,:,i),Yn(:,:,i),Un(:,:,1),Vn(:,:,i))
    axis([min(min(min(X))) max(max(max(X))) min(min(min(Y))) max(max(max(Y)))]);
    hold on;
    patch(D(:,1),D(:,2),[0.5 1 0.5]);
    F(i) = getframe;
    hold off;
end