
%% Distância para o destino (d)
d = sqrt((obj.Pdes(1)-obj.Pos(1))^2 + (obj.Pdes(2)-obj.Pos(2))^2); %distï¿½ncia atï¿½ o destino

%% Calculo do erro de orientação para o destino (theta_e)
theta_d = atan2((obj.Pdes(2)-obj.Pos(2)),(obj.Pdes(1)-obj.Pos(1))); % ï¿½ngulo de destino de -pi a pi
theta_e = theta_d - obj.Pos(3);
% converte theta_e para -pi a pi
if theta_e > pi, theta_e = theta_e - 2*pi; end
if theta_e < -pi, theta_e = theta_e + 2*pi; end

%% Distância para o obstáculo mais próximo (d_obs_min)
[d_obs_min, idc_min] = min(obj.v_sensor);

%% Calculo do angulo (theta_obs)
theta_obs = obj.angs(idc_min); % ïangulo para o obstaculo de 0 a 2*pi

% Tentando implementar

% atrativo
c_atr = 0.9; %% constante atrativa
f_atr_x = -c_atr*((obj.Pos(1)-obj.Pdes(1))); %%força atrativo
f_atr_y =  -c_atr*((obj.Pos(2)-obj.Pdes(2)));

f_atr = [f_atr_x; f_atr_y]; % p transladar
Pva = [f_atr./norm(f_atr)]*30;
Pva = obj.Pos(1:2,:)+Pva;

%repulsivo
flag = 0.05;
p  = flag*d_obs_min;%%p(q) que eh a menor distancia p o obstaculo
idc = idc_min;
qx_obst = obj.s2(1, idc);
qy_obst = obj.s2(2, idc);
p0 = 60; % restricao para perceber o obstaculo
c_rep = 10;
if (p0 >= p )
   F_rep_x = c_rep*((1/p)-(1/p0))*(1/(p)^2)*((obj.Pos(1) - qx_obst)/p);
   F_rep_y = c_rep*((1/p)-(1/p0))*(1/(p)^2)*((obj.Pos(2) - qy_obst)/p);
else
    F_rep_x = 0;
    F_rep_y = 0;
end
F_rep = [F_rep_x; F_rep_y]; %p transladar
Pvr = [F_rep./norm(F_rep)]*30; 
Pvr = obj.Pos(1:2,:)+Pvr;

%%
%Resultante
 
fx_resultante = f_atr_x + F_rep_x;
fy_resultante = f_atr_y + F_rep_y;

f_resultante = [fx_resultante; fy_resultante];
f_resultante = f_resultante./norm(f_resultante);


ang_resultante = atan2(f_resultante(2), f_resultante(1)); %% ang da força resultante
ang_err = ang_resultante - obj.Pos(3); %% erro do resultante para a obj.Posição atual

% converte theta_e para -pi a pi
if ang_err > pi, ang_err =  ang_err - 2*pi; end
if ang_err < -pi, ang_err = ang_err + 2*pi; end

mod_resultante = sqrt(( f_resultante(1))^2+(f_resultante(2))^2); % modulo da força resultante

Vmax = mod_resultante+(0.9*obj.Vmax); %mï¿½ximo ï¿½ aproximadamente 78.4 cm/s1
Wmax = (0.9)*obj.Wmax*tanh(ang_err); %mï¿½ximo ï¿½ aproximadamente 8.16 rad/s

if(d <=7)
    Vmax = 0;
    Wmax = 0;
end

V = Vmax/2;
W = Wmax/2;

obj.Ksi_r = [V ; 0 ; W];

%% saï¿½da da funï¿½ï¿½o de controle deve ser U = [U_e ; U_d] entrada
obj.U = obj.Modcin\[V ; W]; %U = [FI_e ; FI_d];
% 
% %%% Saturação do sinal de controle
% if abs(obj.U(1)) > 1
%     obj.U(1) = sign(obj.U(1));
% end
% if abs(obj.U(2)) > 1
%     obj.U(2) = sign(obj.U(2));
% end
% obj.Ud = obj.U;
