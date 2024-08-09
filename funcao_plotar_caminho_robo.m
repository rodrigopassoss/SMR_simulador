function funcao_plotar_caminho_robo_(arquivo,nRobos)

load(arquivo);

g = figure(3);
set(g,'name','Resultado final - trajetória executada pelos robôs');
axis equal
hold on
for k = 1:nRobos
%     if nRobos <= 3
%         plot(robo_(k).plotInfo.P(1,:),robo_(k).plotInfo.P(2,:),robo_(k).colors(3+k));
%     else
        plot(robo_(k).plotInfo.P(1,:),robo_(k).plotInfo.P(2,:),robo_(k).colors(k));        
%     end
    x = robo_(k).plotInfo.P(1,end);
    y = robo_(k).plotInfo.P(2,end);
    theta = robo_(k).plotInfo.P(3,end);


    % calculo dos pontos de interesse da plotagem
    aux = linspace(0,2*pi*100,100);
    vlimitex = cos(aux)';
    vlimitey = sin(aux)';
    xc = (vlimitex.*robo_(k).raio);
    yc = (vlimitey.*robo_(k).raio);


    pxyc = [cos(theta) -sin(theta) ; sin(theta) cos(theta)]*[xc' ; yc'];
    xc3 = pxyc(1,:)+x;
    yc3 = pxyc(2,:)+y;
    plot(xc3,yc3,'b')
    plot([x x+robo_(k).raio*cos(theta)],[y y+robo_(k).raio*sin(theta)],'r');
    plot(robo_(k).Pdes(1),robo_(k).Pdes(2),'.','MarkerEdgeColor',robo_(k).colors(k),'MarkerSize',20)
end


[linhas , colunas] = size(A);
xlim([-30 colunas+30])
ylim([-30 linhas+30]) 
plot(Ax,Ay,'.','MarkerEdgeColor','k','MarkerSize',2)
set(gca,'xtick',[],'ytick',[])
% nome_do_arquivo = ['D:\Documents\escolta_robotica\simulador\dados_salvos\plot_geral.svg'];
% saveas(gcf, nome_do_arquivo, 'svg');
drawnow