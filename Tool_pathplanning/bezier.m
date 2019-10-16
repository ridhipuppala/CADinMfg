function p=bezier(uu,vv)
syms u v
[x,y,z]=beziersurface;
p(1)=subs(x,[u,v],[uu,vv]);
p(2)=subs(y,[u,v],[uu,vv]);
p(3)=subs(z,[u,v],[uu,vv]);
end