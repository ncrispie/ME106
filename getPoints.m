
function [tsol,Xsol] = getPoints(Xn,Yn,Tn,Un,Vn,x0,y0,t0,tf) 
%Parent Function that return tSol (nx1 vector) and Xsol (nx2) vector that
%represents the solution of (x,y) coordinates per each time in tSol
    function Vel = odefun1(t,x)
        %differential equation for ode45
        ui = interp3(Xn,Yn,Tn,Un,x(1),x(2),t); %interpolated u vel
        vi = interp3(Xn,Yn,Tn,Vn,x(1),x(2),t); %interpolated v vel
        Vel = [ui; vi]; %total vel
    end
    tspan = linspace(t0,tf,351);
    X0 = [x0; y0]; %initial conditions
    [tsol,Xsol] = ode45(@odefun1,tspan,X0);
end



