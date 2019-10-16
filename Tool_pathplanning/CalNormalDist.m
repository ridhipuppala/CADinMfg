% Function to Calculate the Normal Distance between Bezier surface and
% straight line
% inputs : step size and u,v (parameters)
% output : normal distance
%
function d = CalNormalDist(u,du,v)

% u1 = U+du/4;
% u2 = U+du/2;
% u3 = U+(3*du/4);
% uArray = [u1,u2,u3];
% noOfDivision = size(uArray,2);
% dArray = zeros(1,noOfDivision);
% for i=1:noOfDivision
    
% u = uArray(i);

R1 = bezier(u,v);   % calling function to obtain the coordinates of point on surface
X1 = R1(1);
Y1 = R1(2);
Z1 = R1(3);

syms t

R2 = lineeq(u,du,v);  % calling function to obtain the coordinates of point on line
x2 = R2(1,1) - X1;
y2 = R2(1,2) - Y1;
z2 = R2(1,3) - Z1;
v1 = [x2,y2,z2];

a = R2(2,1);
b = R2(2,2);
c = R2(2,3);
v2 = [a,b,c];

C = dot(v1,v2);
eq = C == 0;
solt = solve(eq,t);

X2 = subs(x2, t, solt);
Y2 = subs(y2, t, solt);
Z2 = subs(z2, t, solt);

d = sqrt(X2^2 + Y2^2 + Z2^2);    % distance formula
% dArray(i) = d;
% end

% dmax= max(dArray);

end