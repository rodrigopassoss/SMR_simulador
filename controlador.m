


d = sqrt((obj.Pdes(1)-obj.Pos(1))^2 + (obj.Pdes(2)-obj.Pos(2))^2); %dist�ncia at� o destino

%% C�lculo do erro de orienta��o para o destino (theta_e)
theta_d = atan2((obj.Pdes(2)-obj.Pos(2)),(obj.Pdes(1)-obj.Pos(1))); % �ngulo de destino de -pi a pi
theta_e = theta_d - obj.Pos(3);
% converte theta_e para -pi a pi
if theta_e > pi, theta_e = theta_e - 2*pi; end
if theta_e < -pi, theta_e = theta_e + 2*pi; end

%% Dist�ncia do rob� at� o obst�culo mais pr�ximo (d_obs_min)
[d_obs_min, idc_min] = min(obj.v_sensor);

%% C�lculo do �ngulo do sensor para o obst�culo mais pr�ximo (theta_obs)
theta_obs = obj.angs(idc_min); % �ngulo para o obst�culo de 0 a 2*pi

%% C�culo das velocidades linear (V) e angular (W) do rob� (controle de obj.Posi��o final simples)
Vmax = obj.Vmax/2; %m�ximo � aproximadamente 229 cm/s
Wmax = obj.Wmax/2; %m�ximo � aproximadamente 24 rad/s

%% CAMPO POTENCIAL - JORGE PAIVA
raio_campo = 80;%% Raio de efeito do campo potencial (Essa variavel afeta a formula de forma que quanto maior o raio, menor sera a parcela subtraida de Forca_rep) )
k_distancia = 0.015;  %% Constante que amplifica ou atenua a influencia da distancia na repulsao
k_repulsao = 0.05; %% Constante que amplifica ou atenua a repulsao

Forca_rep = (k_repulsao*((1/(d_obs_min*k_distancia)) - (1/raio_campo))*(1/((d_obs_min*k_distancia)^2)).*(([obj.Pos(1)-obj.s2(1, idc_min); obj.Pos(2)-obj.s2(2, idc_min)])./(d_obs_min*k_distancia)));
% Forca_rep Leva o robo para longe de obstaculos

k_atracao = 0.8; %% Constante que amplifica ou atenua a atracao
Forca_atra = -k_atracao*[obj.Pos(1)-obj.Pdes(1) ; obj.Pos(2)-obj.Pdes(2)]; %% Forca que leva o rob� ao destino

%% Calculo da forca resultante 
Ftotal = Forca_rep + Forca_atra;
Ftotal = Ftotal/norm(Ftotal);

%% Constantes que alteram V e W no final do codigo, para aumentar ou diminuir elas
Kangular = 0.5; %% Constante da velocidade angular
Klinear = 0.5;  %% Constante da velocidade linear
Kdist = 0.7; %% Constante que dita o quanto a distancia pode ser aumentada ou diminuida na tangente hiperbolica de V  


 theta_asd = atan2((Ftotal(2)),(Ftotal(1))); % �ngulo de destino de -pi a pi
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

%% sa�da da fun��o de controle deve ser U = [U_e ; U_d] entrada
U = obj.Modcin\[V ; W]; %U = [FI_e ; FI_d];