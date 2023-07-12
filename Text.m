close all
clear all
clc

%Temperature distributions
x = linspace(0,1,101);
T_ci = 0.2;
C_c = 1;
T_hi = 0.9;
C_h = 0.5;
epsilon = 0.8;

if C_c <= C_h
  T_co = T_ci + epsilon*(T_hi - T_ci);
  T_ho = T_hi - (C_c/C_h)*(T_co - T_ci);
else
  T_ho = T_hi - epsilon*(T_hi - T_ci);
  T_co = T_ci + (C_h/C_c)*(T_hi - T_ho);
endif
DT_A = T_ho - T_ci;
DT_B = T_hi - T_co;

T_c(1,:) = T_ci + (T_co - T_ci)*DT_A*((DT_B/DT_A).^x(:) - 1)/(DT_B - DT_A);
T_h(1,:) = T_ho + (T_hi - T_ho)*DT_A*((DT_B/DT_A).^x(:) - 1)/(DT_B - DT_A);



figure
plot(x,T_c,'k')
hold on
plot(x,T_h,'k')
axis([0 1 0 1])
set(gca,'XTick',[0 1])
xl = {'0' 'L'};
set(gca,'XTickLabel',xl)
set(gca,'YTick',[])
xlabel('x')
hy = ylabel('Temperature');
set(hy,'Position',[-0.07 0.5])
text(-0.058,T_ci,'T_{ci}','FontSize',15)
text(-0.058,T_ho,'T_{ho}','FontSize',15)
text(1.01,T_co,'T_{co}','FontSize',15)
text(1.01,T_hi,'T_{hi}','FontSize',15)
text(0.5,T_c((length(x)+1)/2)-0.05,'T_c(x)','FontSize',15,'HorizontalAlignment','Center')
text(0.5,T_h((length(x)+1)/2)+0.05,'T_h(x)','FontSize',15,'HorizontalAlignment','Center')
line([x(80) x(80)],[0 1],'linestyle','--','color','k')
line([x(85) x(85)],[0 1],'linestyle','--','color','k')
line([x(70) x(79)],[T_c(80) T_c(80)],'color','k')
line([x(70) x(84)],[T_c(85) T_c(85)],'color','k')
quiver(x(72),T_c(80)-0.1,0,0.1,'color','k')
quiver(x(72),T_c(85)+0.1,0,-0.1,'color','k')
text(x(69),(T_c(80)+T_c(85))/2,'\DeltaT_c','FontSize',15,'HorizontalAlignment','Right')
line([x(70) x(79)],[T_h(80) T_h(80)],'color','k')
line([x(70) x(84)],[T_h(85) T_h(85)],'color','k')
quiver(x(72),T_h(80)-0.1,0,0.1,'color','k')
quiver(x(72),T_h(85)+0.1,0,-0.1,'color','k')
text(x(69),(T_h(80)+T_h(85))/2,'\DeltaT_c','FontSize',15,'HorizontalAlignment','Right')
quiver(x(70),0.1,x(80)-x(70),0,'color','k')
quiver(x(95),0.1,x(85)-x(95),0,'color','k')
text(x(71),0.115,'\Deltax','FontSize',15,'HorizontalAlignment','Left','VerticalAlignment','Bottom')
set(gca,'FontSize',15)
figfile = ['Figures\Counterflow_Heat_Exchanger_Temperature_Distributions.png'];
print(figfile)

%Finite Volume
figure
plot(0.5,0.5,'o','MarkerSize',5,'Color','k','MarkerFaceColor','k')
line([0.3 0.55],[0.3 0.3],'linestyle','-','color','k')
line([0.3 0.3],[0.3 0.55],'linestyle','-','color','k')
line([0.3 0.55],[0.55 0.55],'linestyle','-','color','k')
line([0.55 0.55],[0.55 0.3],'linestyle','-','color','k')
line([0.45 0.7],[0.45 0.45],'linestyle','-','color','k')
line([0.45 0.45],[0.45 0.7],'linestyle','-','color','k')
line([0.45 0.7],[0.7 0.7],'linestyle','-','color','k')
line([0.7 0.7],[0.7 0.45],'linestyle','-','color','k')
line([0.3 0.45],[0.3 0.45],'linestyle','-','color','k')
line([0.3 0.45],[0.55 0.7],'linestyle','-','color','k')
line([0.55 0.7],[0.55 0.7],'linestyle','-','color','k')
line([0.55 0.7],[0.3 0.45],'linestyle','-','color','k')
line([0.35 0.65],[0.35 0.65],'linestyle','-','color','k')
line([0.25 0.75],[0.5 0.5],'linestyle','-','color','k')
line([0.5 0.5],[0.25 0.75],'linestyle','-','color','k')
hold on
plot(0.35,0.35,'o','MarkerSize',5,'Color','k','MarkerFaceColor','k')
plot(0.65,0.65,'o','MarkerSize',5,'Color','k','MarkerFaceColor','k')
plot(0.25,0.5,'o','MarkerSize',5,'Color','k','MarkerFaceColor','k')
plot(0.75,0.5,'o','MarkerSize',5,'Color','k','MarkerFaceColor','k')
plot(0.5,0.25,'o','MarkerSize',5,'Color','k','MarkerFaceColor','k')
plot(0.5,0.75,'o','MarkerSize',5,'Color','k','MarkerFaceColor','k')
text(0.51,0.49,'P','FontSize',15,'HorizontalAlignment','Left','VerticalAlignment','Top')
text(0.78,0.5,'E','FontSize',15,'HorizontalAlignment','Left')
text(0.22,0.5,'W','FontSize',15,'HorizontalAlignment','Right')
text(0.5,0.22,'S','FontSize',15,'HorizontalAlignment','Center','VerticalAlignment','Top')
text(0.5,0.78,'N','FontSize',15,'HorizontalAlignment','Center','VerticalAlignment','Bottom')
text(0.35,0.37,'F','FontSize',15,'HorizontalAlignment','Center','VerticalAlignment','Bottom')
text(0.65,0.63,'B','FontSize',15,'HorizontalAlignment','Center','VerticalAlignment','Top')
quiver(0.75,0.25,0.1,0,'color','k')
quiver(0.75,0.25,0,0.1,'color','k')
quiver(0.75,0.25,-3/50,-3/50,'color','k')
text(0.87,0.25,'x','FontSize',15,'HorizontalAlignment','left')
text(0.75,0.37,'y','FontSize',15,'HorizontalAlignment','Center','VerticalAlignment','Bottom')
text(0.75-3/50-0.015,0.25-3/50-0.015,'z','FontSize',15,'HorizontalAlignment','Right','VerticalAlignment','Top')
axis([0.2 0.85 0.15 0.85])
pbaspect([1 1 1])
axis off
print('Figures\Finite_Volume.png')