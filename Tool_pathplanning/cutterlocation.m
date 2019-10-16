function a=cutterlocation(d,u,v)%Read diameter, u and v
p=bezier(u,v);
[x,y,z]=beziersurface;
norm=normal(x,y,z,u,v);% n is the unit normal vector
un=double(sqrt(norm(1)^2+norm(2)^2+norm(3)^2));
norm=double(norm/un);
k=(d/2) / sqrt (norm(1)^2+norm(2)^2+norm(3)^2);
x2=norm(1)*k+p(1);
y2=norm(2)*k+p(2);
z2=norm(3)*k+p(3);
a=[x2,y2,z2];
% return(a)   %Returns the center location of the cutter