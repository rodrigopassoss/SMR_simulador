


d = sqrt((obj.Pdes(1)-obj.Pos(1))^2 + (obj.Pdes(2)-obj.Pos(2))^2); %distância até o destino

%% Cálculo do erro de orientação para o destino (theta_e)
theta_d = atan2((obj.Pdes(2)-obj.Pos(2)),(obj.Pdes(1)-obj.Pos(1))); % ângulo de destino de -pi a pi
theta_e = theta_d - obj.Pos(3);
% converte theta_e para -pi a pi
if theta_e > pi, theta_e = theta_e - 2*pi; end
if theta_e < -pi, theta_e = theta_e + 2*pi; end

%% Distância do robô até o obstáculo mais próximo (d_obs_min)
[d_obs_min, idc_min] = min(obj.v_sensor);

%% Cálculo do ângulo do sensor para o obstáculo mais próximo (theta_obs)
theta_obs = obj.angs(idc_min); % ângulo para o obstáculo de 0 a 2*pi

%% Cáculo das velocidades linear (V) e angular (W) do robô (controle de obj.Posição final simples)
Vmax = obj.Vmax/2; %máximo é aproximadamente 229 cm/s
Wmax = obj.Wmax/2; %máximo é aproximadamente 24 rad/s

%% CAMPO POTENCIAL - JORGE PAIVA
raio_campo = 80;%% Raio de efeito do campo potencial (Essa variavel afeta a formula de forma que quanto maior o raio, menor sera a parcela subtraida de Forca_rep) )
k_distancia = 0.015;  %% Constante que amplifica ou atenua a influencia da distancia na repulsao
k_repulsao = 0.05; %% Constante que amplifica ou atenua a repulsao

Forca_rep = (k_repulsao*((1/(d_obs_min*k_distancia)) - (1/raio_campo))*(1/((d_obs_min*k_distancia)^2)).*(([obj.Pos(1)-obj.s2(1, idc_min); obj.Pos(2)-obj.s2(2, idc_min)])./(d_obs_min*k_distancia)));
% Forca_rep Leva o robo para longe de obstaculos

k_atracao = 0.8; %% Constante que amplifica ou atenua a atracao
Forca_atra = -k_atracao*[obj.Pos(1)-obj.Pdes(1) ; obj.Pos(2)-obj.Pdes(2)]; %% Forca que leva o robô ao destino

%% Calculo da forca resultante 
Ftotal = Forca_rep + Forca_atra;
Ftotal = Ftotal/norm(Ftotal);

%% Constantes que alteram V e W no final do codigo, para aumentar ou diminuir elas
Kangular = 0.5; %% Constante da velocidade angular
Klinear = 0.5;  %% Constante da velocidade linear
Kdist = 0.7; %% Constante que dita o quanto a distancia pode ser aumentada ou diminuida na tangente hiperbolica de V  


 theta_asd = atan2((Ftotal(2)),(Ftotal(1))); % ângulo de destino de -pi a pi
 angulo_erro_verdadeiro = theta_asd - obj.Pos(3);
 
if angulo_erro_verdadeiro < -pi
    angulo_erro_verdadeiro = angulo_erro_verdadeiro + 2*pi;
end
if angulo_erro_verdadeiro > pi
    angulo_erro_verdadeiro = angulo_erro_verdadeiro - 2*pi;
end
% Aqui eu digo para o robo ir mais devagar quando chegar proximo do destino.
% -> Serve para evitar aquela rodopiada no final dos experimentos

if(d_obs_min < 1)
    Klinear = d_obs_min/50;
end
if(d < 20)
    Klinear = d/100;    
end

W = Kangular*obj.Wmax*(tanh(angulo_erro_verdadeiro));



if(d < 35)
    Klinear = d/100;  
   W = theta_e;
   
end


V = Klinear*obj.Vmax*tanh(d*Kdist);
obj.Ksi_r = [V ; 0 ; W];

if (d<obj.raio) || (V<1e-2 && W<1e-2)
   obj.chegou = true; 
end

%% saída da função de controle deve ser U = [U_e ; U_d] entrada
U = obj.Modcin\[V ; W]; %U = [FI_e ; FI_d];