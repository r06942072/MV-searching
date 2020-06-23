function [u,v] = get_u_v(MV_pic)
u = zeros(size(MV_pic,1), size(MV_pic,2));
v = zeros(size(MV_pic,1), size(MV_pic,2));
for i=1:1:size(MV_pic,1)
    for j=1:1:size(MV_pic,2)
        i2 = size(MV_pic,1)-i+1;
        if(isempty(MV_pic{i, j}))
            u(i,j) = 0;
            v(i,j) = 0;
        else
            u(i,j) = MV_pic{i2, j}(1, 1);  % x direction of MV
            v(i,j) = MV_pic{i2, j}(1, 2);  % y direction of MV
        end
    end
end
end