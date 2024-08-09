function funcao_plotar_graficos(arquivo,nRobos)

load(arquivo);

if habilitaDinamica
    legenda=[];   
    for k = 1:nRobos
        g = figure(30+k);
        set(g,'name',['Evolução no tempo das velocidades linear e angular do robô ',num2str(k)]);
        subplot(211)
        plot(tempo,robo_(k).plotInfo.Pvel(1,:))
        hold on; grid on
        plot(tempo,robo_(k).plotInfo.Pvel_medido(1,:),'r')
        xlabel('tempo em segundos')
        ylabel('V [cm/s]')
        legend('desejado','medido')
        subplot(212)
        % plot(tempo,Pvel(1,:)*180/pi)
        plot(tempo,robo_(k).plotInfo.Pvel(2,:))
        hold on; grid on
        % plot(tempo,Pvel_medido(1,:)*180/pi,'r')
        plot(tempo,robo_(k).plotInfo.Pvel_medido(2,:),'r')
        xlabel('tempo em segundos')
        ylabel('W [graus/s]')
        legend('desejado','medido')

        g3 = figure(50+k);
        set(g3,'name',['Evolução no tempo das ações de controle Ud e Ue do robô ',num2str(k)]);
        subplot(211)
        plot(tempo,robo_(k).plotInfo.Pu(1,:))
        hold on; grid on
        plot(tempo,robo_(k).plotInfo.Pu_real(1,:))
        xlabel('tempo em segundos')
        ylabel('U_d [-1 , 1]')
        legend('desejado','medido')
        subplot(212)
        plot(tempo,robo_(k).plotInfo.Pu(2,:))
        hold on; grid on
        plot(tempo,robo_(k).plotInfo.Pu_real(2,:))
        xlabel('tempo em segundos')
        ylabel('U_e [-1 , 1]')
        legend('desejado','medido')

        g4 = figure(60+k);
        set(g4,'name',['Evolução no tempo das velocidades das rodas Fid e FIe',num2str(k)]);
        subplot(211)
        plot(tempo,robo_(k).plotInfo.Pfi(1,:))
        hold on; grid on
        plot(tempo,robo_(k).plotInfo.Pfi_real(1,:))
        xlabel('tempo em segundos')
        ylabel('FI_d')
        legend('desejado','medido')
        subplot(212)
        plot(tempo,robo_(k).plotInfo.Pfi(2,:))
        hold on; grid on
        plot(tempo,robo_(k).plotInfo.Pfi_real(2,:))
        xlabel('tempo em segundos')
        ylabel('FI_e')
        legend('desejado','medido')
        
        g2 = figure(40);
        set(g2,'name',['Evolução no tempo das velocidades linear e angular dos robôs ']);
        subplot(211)
        hold on; grid on
        plot(tempo,robo_(k).plotInfo.Pvel_medido(1,:),robo_(k).colors(k),'linewidth',2)
        xlabel('tempo em segundos')
        ylabel('V [cm/s]')
        legenda = [legenda;['robô',num2str(k)]];
        legend(legenda);
        subplot(212)
        hold on; grid on
        plot(tempo,robo_(k).plotInfo.Pvel_medido(2,:),robo_(k).colors(k),'linewidth',2)
        xlabel('tempo em segundos')
        ylabel('W [rad/s]')
        legend(legenda);
       
    end

else
    
    legenda = [];
    for k = 1:nRobos        
        g = figure(30);
        set(g,'name',['Evolução no tempo das velocidades linear e angular dos robôs ']);
        subplot(211)
        hold on; grid on
        plot(tempo,robo_(k).plotInfo.Pvel_medido(1,:),robo_(k).colors(k),'linewidth',2)
        xlabel('tempo em segundos')
        ylabel('V [cm/s]')
        legenda = [legenda;['robô',num2str(k)]];
        legend(legenda);
        subplot(212)
        hold on; grid on
        plot(tempo,robo_(k).plotInfo.Pvel_medido(2,:),robo_(k).colors(k),'linewidth',2)
        xlabel('tempo em segundos')
        ylabel('W [rad/s]')
        legend(legenda);
    end
    
end