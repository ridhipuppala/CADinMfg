clc
clear all
close all
%% read file
file_name= input('Input STL file name with .stl extension: ','s');
%File name is <cone.stl>
delta_h= input('Slice Thickness value in mm [Recommended Range is (0.1mm,2mm)]: ');
%delta_H is the slice thickness
model= stl_read(file_name); %stl file reading command
count= size(model.vertices,1)/3;
face_mesh= size(model.faces,1);
vertex_mesh= size(model.vertices,1);
%% validation of the stl file

if mod(face_mesh,2)~=0
    disp('stl file inaccurate, no. of meshes is odd');
    exit;
else
    disp('stl file is validated, no errors found');
    X= sprintf('no. of facets: %d',face_mesh);
    disp(X);
end

mesh= NaN(count,9);
loop_size= 2;

for i= 1:count
    mesh(i,:)= [model.vertices(3*i-2,:) model.vertices(3*i-1,:) model.vertices(3*i,:)];
end

%% arrange vertices of mesh in ascending order
mesh_new= NaN(count,9);

for i= 1:count
    temp= [mesh(i,1:3); mesh(i,4:6); mesh(i,7:9)];
    temp_new= sortrows(temp,3);
    mesh(i,:)= [temp_new(1,:) temp_new(2,:) temp_new(3,:)];
end

mesh_new= sortrows(mesh,3); %arrange meshes in ascending order
%% find intersecting meshes

max_h= mesh_new(count,9);
min_h= mesh_new(1,3);
layer= cell((max_h-min_h)/delta_h,1);
range= (max_h-min_h)/delta_h;

for m= 1:range
    h= min_h+delta_h*m;
    n= 1;
    clear slice
    for i= 1:size(mesh_new,1)
        if (h> mesh_new(i,3)) && (h<= mesh_new(i,9))
            if h< mesh_new(i,6)
                weight(1)= (mesh_new(i,3)-h)/(h-mesh_new(i,6));
                weight(2)= (mesh_new(i,3)-h)/(h-mesh_new(i,9));
                pt1= [mesh_new(i,1)+weight(1)*mesh_new(i,4) mesh_new(i,2)+weight(1)*mesh_new(i,5) (weight(1)+1)*h]/(weight(1)+1);
                pt2= [mesh_new(i,1)+weight(2)*mesh_new(i,7) mesh_new(i,2)+weight(2)*mesh_new(i,8) (weight(2)+1)*h]/(weight(2)+1);
            elseif h> mesh_new(i,6)
                weight(1)= (mesh_new(i,9)-h)/(h-mesh_new(i,6));
                weight(2)= (mesh_new(i,9)-h)/(h-mesh_new(i,3));
                pt1= [mesh_new(i,7)+weight(1)*mesh_new(i,4) mesh_new(i,8)+weight(1)*mesh_new(i,5) (weight(1)+1)*h]/(weight(1)+1);
                pt2= [mesh_new(i,7)+weight(2)*mesh_new(i,1) mesh_new(i,8)+weight(2)*mesh_new(i,2) (weight(2)+1)*h]/(weight(2)+1);
            elseif h== mesh_new(i,6)
                weight(1)= (mesh_new(i,9)-h)/(h-mesh_new(i,3));
                pt1= mesh_new(i,4:6);
                pt2= [mesh_new(i,7)+weight(1)*mesh_new(i,1) mesh_new(i,8)+weight(2)*mesh_new(i,2) (weight(2)+1)*h]/(weight(2)+1);
            end
            slice(n,1:6)= [pt1 pt2]; 
            n= n+1;
        end
    end
    layer{m}= slice; % all the sliced layers are stored in the layer variable
end

%% layerwise loop formation
contours= cell(range-1,loop_size);

for i= 1:range-1
    check= [0 0 0];
    plane= layer{i};
    j= 1;
    while j<= size(plane,1)
        if isnan(plane(j,:))
            plane(j,:)=[];
        else
            j=j+1;
        end
    end
    for j= 1:size(plane,1)
        temp2= [plane(j,1:3); plane(j,4:6)];
        temp2_new= sortrows(temp2,1); % arrange between the 1st & 2nd point of line segment 
        plane(j,:)= [temp2_new(1,:) temp2_new(2,:)];
    end
    plane_new= sortrows(plane,1); % the points in a plane in ascending order fo x coordinate
    p= 1;
    while ~isempty(plane_new)  % this calculates all the loops possible in a layer
        loop(1,:)= plane_new(1,1:3);
        loop(2,:)= plane_new(1,4:6);
        plane_new(1,:)= [];
        q= 3;
        k= 3;
        while ~isequal(round(loop(1,:),4),round(loop(q - 1,:),4)) % this finds all the line segment in a loop
            check(1)= check(1)+1;
            alpha= size(plane_new,1);
            while k<= alpha(1) % forward search
                if isequal(round(loop(q-1,:),4),round(plane_new(k,1:3),4))
                    check(2)= check(2)+1;
                    loop(q,:)= plane_new(k,4:6);
                    plane_new(k,:)= [];
                    q= q+1;
                    alpha(1)= alpha(1)-1;
                else
                    k= k+1;
                end
            end
            k= k-1; % backward search
            while k>= 1
                if isequal(round(loop(q-1,:),4),round(plane_new(k,4:6),4))
                    check(3)= check(3)+1;
                    loop(q,:)= plane_new(k,1:3);
                    plane_new(k,:)= [];
                    q= q+1;
                    alpha(1)= alpha(1)-1;
                end
                k= k-1;
            end
            k= k+1;
        end
        contours{i,p}= loop; % save all the loops layerwise in a contours variable 
        clear loop;
        p= p+1;
    end 
end
%% plotting/animation
figure('Name','Sliced Output','NumberTitle','off','Units','normalized','Position',[0 0 1 1],'Color','white');
DP= sprintf('no. of Layer: %d',range);
disp(DP);
disp('Displaying the sliced output layer by layer...');
view([45 45]);
axis([-70 70 -70 70 0 70]);
hold on; grid on; axis fill;
title('Slicing of hollow cone');
colormap parula;
color= colormap;
col_size= size(color,1);
while col_size< range
color= [color; flipud(color)];
col_size= size(color,1);
end

for i= 1:range-1
    take1= contours{i,1};
    take2= contours{i,2};
    x_take= [take1(:,1)', take2(:,1)'];
    y_take= [take1(:,2)', take2(:,2)'];
    z_take= [take1(:,3)', take2(:,3)'];
    fill3(x_take,y_take,z_take,color(i));
    drawnow;
    pause(0.1);
end