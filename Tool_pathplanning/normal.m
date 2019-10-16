function [p]=normal(X,Y,Z,uu,vv)
syms u v;
a1=gradient(X,u);
b1=gradient(Y,u);
c1=gradient(Z,u);
a2=gradient(X,v);
b2=gradient(Y,v);
c2=gradient(Z,v);
tangent1=[a1 b1 c1];
tangent2=[a2 b2 c2];
p=cross(tangent2,tangent1);
p=subs(p,[u,v],[uu,vv]);