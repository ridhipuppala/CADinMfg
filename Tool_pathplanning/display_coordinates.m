function display_coordinates(co)    %Input is NX3 matrix
figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color','w');
[x,y,z]=beziersurface;
grid on;box on;
view(50,50);hold on;
ezsurf(x,y,z,[0,1])
title('\fontsize{20} Tool Path');
sz = size(co);
frame_no = sz(1);
curve = animatedline('LineWidth',2);
for j = 1:frame_no
    view(50 + (j/frame_no)*150,50);
    addpoints(curve,co(j,1),co(j,2),co(j,3));
    head = scatter3(co(j,1),co(j,2),co(j,3),'filled','MarkerFaceColor','b');
    drawnow 
    F(j) = getframe(gcf);
    pause(0.0001);
    delete(head);
end
view(3)
video = VideoWriter('ToolPath_GroupB.avi','Uncompressed AVI');
open(video)
writeVideo(video,F);
close(video)