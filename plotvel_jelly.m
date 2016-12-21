
% Comment or uncomment the following if you do/dont want to plot images
% of the jellyfish swimming with the velocity field. Plotting them is neat,
% but it slows the plotting process quite a bit.
%plotimages = 0;
plotimages = 1;

load jellyfish.mat % loads X, Y, U, V, time

%%% Reformat data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xmax = max(max(max(X)));
xmin = min(min(min(X)));
xdel = (max(max(max(X))) - min(min(min(X))))/(length(X(1,1,:))-1);
ymax = max(max(max(Y)));
ymin = min(min(min(Y)));
ydel = (max(max(max(Y))) - min(min(min(Y))))/(length(Y(1,:,1))-1);

xvec = xmin:xdel:xmax;
yvec = ymin:ydel:ymax;
[Xn, Yn, Tn] = meshgrid(xvec,-yvec+(max(yvec)),time); % New grid data
Un = permute(U,[2 3 1]); % New field data 
Vn = permute(V,[2 3 1]); % New field data

%%%% Data analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%initialize data inputs
tf = max(time);
t0 = 0;
x0 = 3; y0 = 3; 
x1 = 12; y1 = 2; 
x2 = 11; y2 = 2;
x3 = 6; y3 = 7;
[tSol0,Xsol0] = getPoints(Xn,Yn,Tn,Un,Vn,x0,y0,t0,tf);
[tSol1,Xsol1] = getPoints(Xn,Yn,Tn,Un,Vn,x1,y1,t0,tf);
[tSol2,Xsol2] = getPoints(Xn,Yn,Tn,Un,Vn,x2,y2,t0,tf);
[tSol3,Xsol3] = getPoints(Xn,Yn,Tn,Un,Vn,x3,y3,t0,tf);

%%%% Generate Frames %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

F = struct('cdata', cell(1,length(time)), 'colormap', cell(1,length(time)));

for i = 1:length(time)
    if plotimages
        if i < 10
            inFile  = strcat('T8_002754_00281200', num2str(i),'.jpg');
        elseif i < 100
            inFile  = strcat('T8_002754_0028120', num2str(i),'.jpg');
        else
            inFile  = strcat('T8_002754_002812', num2str(i),'.jpg');
        end
        A = imread(inFile);
        B = imrotate(A,180);
        image([xmin xmax],[ymin ymax], B);
        axis xy
        hold on
        
        %plot velocity vectors
        quiver(Xn(:,:,i), Yn(:,:,i),Un(:,:,i),Vn(:,:,i), 'y');
        
        %plot plankton particles
        plot(Xsol0(i,1),Xsol0(i,2),'*g')
        plot(Xsol1(i,1),Xsol1(i,2),'*g')
        plot(Xsol2(i,1),Xsol2(i,2),'*g')
        plot(Xsol3(i,1),Xsol3(i,2),'*g')
        
        F(i) = getframe;
        hold off;
    else
        quiver(Xn(:,:,i),Yn(:,:,i),Un(:,:,i),Vn(:,:,i), 'b');
        F(i) = getframe;
    end
end


%create video file
v = VideoWriter('jelly_movieTest');
open(v)
writeVideo(v,F)
close(v)

