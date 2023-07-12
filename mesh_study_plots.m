close all
[ax,h1,h2] = plotyy(N_e,dimensionless_q,N_e,t_s);
set(h1,'marker','o','linestyle','--','color','k')
set(h2,'marker','s','color','k')
set(ax(1),'YLim',[0.98 1],'ycolor','k','FontSize',15)
xmax = 50000*ceil(max(N_e)/50000);
set(ax(1),'XLim',[0 xmax],'ycolor','k','FontSize',15)
set(ax(2),'XLim',[0 xmax],'ycolor','k','FontSize',15)
set(ax(2),'ycolor','k','FontSize',15)
yl = get(ax(1),'YTickLabel');
new_yl = strrep(yl(:),'.',',');
set(gca,'YTickLabel',new_yl)
ylabel(ax(1),'Dimensionless Heat Transfer Rate')
ylabel(ax(2),'Solution Time [s]')
xlabel('Number of Elements')
legend('Dimensionless Heat Transfer Rate','Solution Time','Location','Southeast')
print('Figures\Mesh_Study.png')