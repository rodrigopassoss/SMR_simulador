function ZUADENTO_SIMULADOR(experimento,robo_,mapabmp,tempo_max,habilitaPlot,habilitaDinamica,nRobos, cont)
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inicializa��o das vari�veis globais
global  Pdes  Mapa Mapa2 i tempo tamos;


tamos = experimento.tamos; % tempo de amostragem da simual��o em segundos
for k = 1:nRobos
    robo_(k) = robo_(k).configuracao_inicial(experimento,tempo_max,k); 
end
%% carregando o mapa do ambiente
A = imread(mapabmp);
A = A(:,:,1);
A = A./(max(max(A)));
A = A.*255;
% A = A(end:-1:1,:);
%A = rgb2gray(A);
Mapa2 = A;
% A = A(end:-1:1,:); % utilizada no plot para parecer a imagem no SC padr�o
[Ay , Ax] = find(A~=255);
Mapa = [Ax,Ay]';

% Mapa a ser descoberto
experimento.mapa_descoberto = 127*ones(size(Mapa2));


% inicializa��o das vari�veis do loop while
tempo = 0:tamos:tempo_max;  % controle de tempo
i = 0;  % contador

colidiu = 0;
concluiu =0;
while  (~colidiu && (i*tamos<tempo_max) && ~concluiu)
      % distancia maior que 5 cm ou vlin maior q 5 cm/s ou vrot maior que 0.1 rad/s
    tic     
    % atualiza��o das vari�veis de controle de tempo
    i = i+1;          
    tempo(i+1) = i*tamos;   
    
    % Defini��o da flag que habilita a aloca��o
    experimento.flag = true;
    for k = 1:nRobos
                
        robo_(k) = robo_(k).simulacao_sensores(updateMapa2(A,robo_,nRobos,k));
        experimento.mapa_descoberto = robo_(k).DescobrimentoMapa(experimento.mapa_descoberto);
        %%%%%%%%%%%%%%%%%%% CONTROLADOR IN�CIO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %s_i = sensores no sistema de coordenadas do ambiente
        %    = sem ru�do e n�o deve ser usado pelo controlador

        %s = sensores no sistema de coordenadas do rob�
        %  = com ru�do adicionado. Esse pode ser utilizado pelo controlador.

        %s2 = sensores no sistema de coordenadas do ambiente
        %  = com ru�do adicionado. Esse pode ser utilizado pelo controlador.
        tamos_controle = 0.01; %atualizar a cada 40 ms
        
        if mod(tempo(i),tamos_controle) == 0
                robo_(k) = robo_(k).controle_e_navegacao(); 
        end


        %%%%%%%%%%%%%%%%%%%%% CONTROLADOR FIM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%% SIMULAÇÃO IN�?CIO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if habilitaDinamica==1
            robo_(k) = robo_(k).simulacao(tamos,i);
        else
            robo_(k) = robo_(k).simulacao_apenas_cinematica(tamos,i);
        end

         if robo_(k).colidiu
            robo_(k) = robo_(k).simulacao_falha();
            colidiu = 1;
         end
         
         experimento.flag = experimento.flag&robo_(k).chegou;
    end
                                                         
    alocacao_tarefas

    % PLOT DO GR�FICO "ON LINE"
    tamos_plot = 0.1; %atualizar a cada 100 ms
    if mod(tempo(i),tamos_plot) == 0
        if habilitaPlot, plot_graficos_online; end
    end 
    i*tamos
    
end

tempo = tempo(1:i);
for k = 1:nRobos
    robo_(k) = robo_(k).vecCorrecao(i,habilitaDinamica);
end

%%%% Salvando os dados no arquivo
save -mat experimento.mat experimento robo_ tempo A Ax Ay Pdes habilitaDinamica  
save -mat .mat experimento robo_ tempo A Ax Ay Pdes habilitaDinamica

end