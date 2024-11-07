clear all;
close all;
clc;
format long eng;

load('PR.txt');
load('SVPOS.txt');


K = length(PR);
stop_cr = 100;
iterations = 0;

Upos = zeros(4,1);

while (stop_cr > 1) && ...
    (iterations < 20)
    
    r = zeros(K,1);
    for i = 1:K
        r(i) = norm(SVPOS(i,:) - Upos(1:3)');
    end
    
    
    rho = zeros(K, 1);
    for i = 1:K
        rho(i) = r(i) + Upos(4);
    end
    
    
    drho = PR - rho;
    
    for i = 1:K
        G(i,1:3) = (Upos(1:3)' - SVPOS(i,:))/r(i);
        G(i,4) = 1;
    end
    
    
    dxdb = G \ drho;
    
    Upos = Upos + dxdb;
    
    stop_cr = norm(dxdb(1:3));
    
    iterations = iterations + 1;
    
end



iterations 
Upos


function pos_llh=xyz2llh(pos_ecef)



x=pos_ecef(1);
y=pos_ecef(2);
z=pos_ecef(3);

x2=x^2;
y2=y^2;
z2=z^2;

a   = 6378137.0;
b   = 6356752.3142;
e = sqrt(1-b^2/a^2);
ep = a*e/b;

a2  = a^2;
b2  = b^2;
e2  = e^2;
ep2 = ep^2;


r=sqrt(x2+y2);
r2=x2+y2;

E2=a2-b2;

F = 54*b2*z2;

G=r2+(1-e2)*z2-e2*E2;

c=(e2*e2)*F*r2/(G*G*G);

s=(1+c+sqrt(c*c+2*c))^(1/3);

P=F/(3*(s+1/s+1)^2*G^2);

Q=sqrt(1+2*(e2^2)*P);

r0=-P*e2*r/(1+Q)+sqrt(1/2*a2*(1+1/Q)-P*(1-e2)*z2/(Q*(1+Q))-1/2*P*r2);

tmp = (r - e2*r0)^2 + z2;


U=sqrt(tmp);

V=sqrt(tmp - e2*z2);

z0=b2*z/(a*V);

h=U*(1-b2/(a*V));

phi=rad2deg(atan((z+ep2*z0)/r));

lam=rad2deg(atan2(y,x));

pos_llh=[phi;lam;h];

end


