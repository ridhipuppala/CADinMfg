function y = ddt(t,step_NR,u,v)
y =(CalNormalDist(u,t+step_NR,v) - CalNormalDist(u,t,v))/step_NR;
end