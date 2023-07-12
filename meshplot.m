[X,Y] = meshgrid(-8:.5:8)
R = sqrt(X.^2 + Y.^2) + eps;
%Z = sin(R)./R;
Z = ones(size(X,1),size(Y,2))
mesh(X,Y,Z)
hold on
mesh(X,Y,2*Z)
axis([-10 10 -10 10 0 2])