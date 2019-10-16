%% input1 = [delu]

function p =lineeq(u1,delu,v)
u2=u1+delu;
p1=bezier(u1,v);
p2=bezier(u2,v);
x1 = p1(1);
y1 = p1(2);
z1 = p1(3);
x2 = p2(1);
y2 = p2(2);
z2 = p2(3);
syms t
    xl=x1+(x2-x1)*t;
    yl=y1+(y2-y1)*t;
    zl=z1+(z2-z1)*t;
    
    p = [xl,yl,zl;x2-x1,y2-y1,z2-z1];
end
%% output = line equation interms of parameter[t]