% roughing tool path
clear
clc
syms u v
dia=5;
[x,y,z]=beziersurface;  %creates bezier surface x,y,z are parametric equations of the surface
uu=0;
vv=0;
xx=[];
yy=[];
zz=[];
xt=[];
yt=[];
zt=[];
while (vv<=1)
    uu=0;
    a=cutterlocation(dia,uu,vv);
    xt=[xt,a(1)];
    yt=[yt,a(2)];
    zt=[zt,a(3)];
        while(uu<1) %when u moves from 0 to 1
            uu=step_u(uu,vv,1);  %step size for given u and v
            if(uu>=1)
                uu=1;
            end
            a=cutterlocation(dia,uu,vv);
            xt=[xt,a(1)];
            yt=[yt,a(2)];
            zt=[zt,a(3)];
        end
    dv=side_step(uu,vv);
    vv=vv+dv;
    uu=1;
    a=cutterlocation(dia,uu,vv);
    xt=[xt,a(1)];
    yt=[yt,a(2)];
    zt=[zt,a(3)];
        while(uu>0) %when u moves from 1 to 0
            uu=step_u(uu,vv,-1);
            if(uu<0)
                uu=0;
            end
            a=cutterlocation(dia,uu,vv);
            xt=[xt,a(1)];
            yt=[yt,a(2)];
            zt=[zt,a(3)];
        end
    dv=side_step(uu,vv);
    vv=vv+dv;
end
co=double([xt',yt',zt']);
display_coordinates(co)