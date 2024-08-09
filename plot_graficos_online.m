[vlimitex,vlimitey] = scircle2(0,0,1,0); % circulo limite de vis?o MATLAB
aux = linspace(0,2*pi*100,100);
vlimitex = cos(aux)';
vlimitey = sin(aux)';
figure(1)
hold off  
subplot(211)
plot(0,0,'.')
hold on
plot(Ax,Ay,'sk','MarkerEdgeColor','k','MarkerSize',2);
image(A)
colormap(gray(2))
hold on
axis equal;
for k = 1:nRobos    
        robo_(k) = robo_(k).plotConfig(k);
%         plota o destino no ambiente de navegação
        plot(robo_(k).Pdes(1),robo_(k).Pdes(2),'.','MarkerEdgeColor',robo_(k).colors(k),'MarkerSize',20)
        set(gca,'xtick',[],'ytick',[])        
        xlim([0 size(A,2)])
        ylim([0 size(A,1)])    
end
xlabel('x[cm]');
ylabel('y[cm]');
% nome_do_arquivo = ['C:\Users\rodri\Documents\escolta_robotica\simulador\dados_salvos\plot_',num2str(i),'.svg'];
% saveas(gcf, nome_do_arquivo, 'svg');
drawnow

% figure(2)
subplot(212)
imshow(uint8(experimento.mapa_descoberto(end:-1:1,:)))
hold on
% [M,N]=size(experimento.mapa_descoberto);
% plot(experimento.fronteirax,M-experimento.fronteiray,'.r','MarkerSize',5);
drawnow


