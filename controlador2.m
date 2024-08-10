%% Controle Reativo - Campos Potênciais
ka = 10;
grad_Ua = -ka*(obj.Pos(1:2)-obj.Pdes);
Ua = norm(grad_Ua);

kr = 10; kr = kr/2;
ro_L = 20e-2; [ro,I]=min(obj.v_sensor); ro = ro*1e-2;
grad_Ur = kr*((1/ro - 1/ro_L)*(1/(ro^3)))*(obj.Pos(1:2)-obj.s2(:,I))*(ro<=ro_L);

Ur = norm(grad_Ur);

grad_U = grad_Ua + grad_Ur;



%% Norma do vetor gradiente (d)
d = norm(grad_U); %dist�ncia at� o destino
dist = sqrt((obj.Pos(1:2)-obj.Pdes)'*(obj.Pos(1:2)-obj.Pdes));

%% angulação do vetor gradiente (theta_e)
theta_d = atan2(grad_U(2),grad_U(1)); % �ngulo de destino de -pi a pi
theta_e = theta_d - obj.Pos(3);

% converte theta_e para -pi a pi
if theta_e > pi/2, theta_e = pi/2; end
if theta_e < -pi/2, theta_e = -pi/2; end

%% C�culo das velocidades linear (V) e angular (W) do rob� (controle de posi��o final simples)
vmax = 35;kv = 15;
V = vmax*tanh(kv*d)*cos(theta_e);
wmax = 6;kw = 0.3;
W = wmax*tanh(kw*theta_e);

if (dist<obj.raio)||((V<1e-2)&&(W<1e-2))
   obj.chegou = true; 
end

%% sa�da da fun��o de controle deve ser U = [U_d ; U_e] entrada
obj.Ksi_r = [V ; 0 ; W];

%% saï¿½da da funï¿½ï¿½o de controle deve ser U = [U_e ; U_d] entrada
obj.U = obj.Modcin\[V ; W]; %U = [FI_e ; FI_d];
