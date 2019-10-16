function [X,Y,Z]=beziersurface
syms u v
% b(:,:,1)=[0 12 28 40;
%            -5 13 29 43;
%            -7 14 28 37;
%            0 12 29 40];
% b(:,:,2)=[0 0 1 0;
%           18 17 15 18;
%           32 31 28 32;
%           50 55 45 50];
% b(:,:,3)=[0 -5 4 1;
%           5 -3 3 -1;
%           7 10 0 5;
%           -3 5 -7 0];

b(:,:,1)=[0 20 40 60;
          0 20 40 60;
          0 20 40 60;
          0 20 40 60];
b(:,:,2)=[0 0 0 0;
          20 20 20 20;
          40 40 40 40;
          60 60 60 60];
b(:,:,3)=[0 5 5 0;
          5 20 20 5;
          5 20 20 5
          0 5 5 0];


U=[1 u u^2 u^3];
V=[1;v;v^2;v^3];
M=[1 -3 3 -1;
   0 3 -6 3;
   0 0 3 -3;
   0 0 0 1];

X=U*M'*b(:,:,1)*M*V;
Y=U*M'*b(:,:,2)*M*V;
Z=U*M'*b(:,:,3)*M*V;
end