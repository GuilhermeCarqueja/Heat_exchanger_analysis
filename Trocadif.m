%UFSC - Labtucal
%Programa de simulação de trocadores de calor compactos
%Batista & Carqueja

format long
close all
clear all
clc


%Dados geométricos
a = 0.003; %Aresta do canal em m
n = 19; %Número de canais por camada
N = n*9; %Número de canais por ramal
L = 0.33; %Comprimento dos canais frios em m
esp_placa = 0.001; %Espessura das placas inteiriças
t_aleta = 0.0015; %Espessura das aletas
Ra = (0.15 + 0.11 + 2.41 + 3.43)/4000000; %Rugosidade média em m

%Ramal quente (água)
%Vazões
%80;1,35
%Vazao_q = [1.37442405	1.370004807	1.377610027	1.36876009	1.364570937	1.378055483	1.364664323	1.367952257	1.368973257	1.36669954	1.37436809	1.380057087	1.36721539	1.363482083	1.35937385	1.377438947	1.358314857	1.320774047];

%80;0,90
%Vazao_q = [0.91362793	0.91872361	0.919553253	0.90522121	0.904657667	0.916231293	0.912922757	0.9168031	0.91655766	0.893837977	0.88442718	0.912095783	0.902851833	0.892834563	0.88564652	0.913302213	0.913101637	0.88910417];

%70;1,35
%Vazao_q = [1.354330063	1.360425623	1.37260324	1.358569543	1.372051153	1.35880123	1.370295097	1.3568737	1.364346187	1.356796127	1.35731948	1.358413177	1.36025511	1.362282877	1.362008043	1.362283357	1.361885237	1.361918797];

%70;0,90
%Vazao_q = [0.892779397	0.894106143	0.895285227	0.893980047	0.894471147	0.89002647	0.89935903	0.891370667	0.89902742	0.892645083	0.895278753	0.889977973	0.897627973	0.88991752	0.89452171	0.888943077	0.89538004	0.88746516];


Vazao_q = [0.5 0.5 0.5 0.5 0.5 1 1 1 1 1 1.5 1.5 1.5 1.5 1.5]
%Temperaturas de entrada
%80;1,35
%Tq_in = [79.32467466	79.40737957	79.63803615	79.60199667	79.41736393	79.37644906	79.41108217	79.42650636	79.27757149	79.24804217	79.27171865	79.36188142	79.37792463	79.34509711	79.31382946	79.3860708	79.55711115	79.42780981];

%80;0,90
%Tq_in = [79.56221329	79.48837033	80.01663234	79.61064515	79.50000072	79.34787217	79.71422459	79.59219083	79.44890657	79.37591746	79.26653709	79.74505087	79.39985679	79.52634451	79.68006587	79.57701722	79.75563643	79.80026634];

%70;1,35
%Tq_in = [69.56376493	69.55270691	69.60406854	69.42176227	69.73380676	69.56153392	69.47320231	69.43265164	69.56264556	69.35272606	69.57284492	69.3650367	69.37192914	69.46308965	69.56645505	69.52236564	69.61887675	69.60804485];

%70;0,90
%Tq_in = [69.48997135	69.68963423	69.76785419	69.67693194	69.7205097	69.68946517	69.74218354	69.71221035	69.82482192	69.51588867	69.73289664	69.43415439	69.69500253	69.45581359	69.98830363	69.68721256	69.59180444	69.67632901];
Tq_in = [79.99309889	79.49883135	80.51990889	79.12581079	79.89571402 79.70565205	60.2296817	72.02604598	59.90491805	76.88672607 80.09536008	59.43209181	67.75227281	59.3173773	58.99012841]
%Ramal frio (ar)
%Vazões
%80;1,35
%Vazao_f = [0.0286397	0.0314099	0.0346261	0.0373941	0.0402221	0.0432810	0.0459348	0.0481826	0.0508140	0.0540525	0.0579420	0.0616015	0.0639963	0.0664879	0.0690951	0.0717548	0.0742581	0.0766555];
%80;0,90
%Vazao_f = [0.0286515	0.0313692	0.0346988	0.0373847	0.0403212	0.0432621	0.0460383	0.0481438	0.0509235	0.0539543	0.0579662	0.0616989	0.0640491	0.0665543	0.0690191	0.0718295	0.0742663	0.0767719];
%70;1,35
%Vazao_f = [0.0290244	0.0314502	0.0345133	0.0377426	0.0409120	0.0433170	0.0463494	0.0484152	0.0517777	0.0541152	0.0575235	0.0609831	0.0632626	0.0667328	0.0689679	0.0714526	0.0738936	0.0798105];
%70;0,90
%Vazao_f = [0.0272383	0.0307512	0.0333919	0.0365620	0.0396246	0.0435410	0.0459563	0.0488758	0.0518339	0.0550790	0.0574478	0.0623072	0.0648222	0.0672008	0.0699406	0.0718903	0.0749132	0.0795052];
Vazao_f = [0.5 0.9 1 1.35 1.5 0.5 0.9 1 1.35 1.5 0.5 0.9 1 1.35 1.5]
%Temperaturas de entrada
%80;1,35
%Tf_in = [26.607162	27.409048	27.282798	30.107718	31.392824	31.281482	33.343722	35.147733	36.522552	34.455526	36.627525	36.787706	37.698256	38.968051	39.746919	40.563284	41.093958	42.357610];
%80;0,90
%Tf_in = [26.488211	27.453048	26.970362	30.194285	31.249057	31.230922	32.224055	35.290009	36.250736	35.123001	36.553745	36.527285	37.876215	38.985751	39.800443	40.577963	40.907583	42.190404];
%70;1,35
%Tf_in = [24.965175	25.519614	26.412030	27.397774	28.304094	29.811104	33.284366	36.048764	35.795174	35.094144	35.861259	36.674955	38.193180	39.327565	40.365097	41.573036	42.605455	46.029316];
%70;0,90
%Tf_in = [27.651167	29.944128	30.437514	31.156108	32.233099	29.879805	33.083212	32.546591	35.721025	31.926274	35.992669	34.534739	35.642283	37.848552	37.780502	40.425714	40.303259	44.532264];




Tf_in = [27.0518665	26.75255122	24.1378627	23.99389862	23.53367359 25.77292797	22.99252892	25.01099561	22.84306736	24.60227359 26.19831404	23.08020374	24.1392386	23.27341539	23.05157797]
%Primeira Simulação
%Modelo Isotérmico
for i=1:length(Vazao_f)
  UA(i) = h_agua(Vazao_f(i),Tf_in(i),N,a,Ra,L,Tq_in(i))*4*a*L*N;
  Cmin = cp_ar(Tf_in(i))*Vazao_f(i);
  NUT = UA(i)/Cmin;
  epsilon = 1 - exp(-NUT);
  qmax = Cmin*(Tq_in(i) - Tf_in(i));
  q(i) = epsilon*qmax;
  Tf_out(i) = q(i)/Cmin + Tf_in(i);
  DTa = Tq_in(i) - Tf_out(i);
  DTb = Tq_in(i) - Tf_in(i);
  DT_lm = (DTa - DTb)/log(DTa/DTb);
  Tm(i) = Tq_in(i) - DT_lm;
  %Tm(i) = 0.5*(Tf_in(i) + Tf_out(i));
  UA_old(i) = 0;
end
%UA
%q
%Tf_out

while max(abs(UA - UA_old)) > 1e-9
  for i=1:length(Vazao_f)
    UA_old(i) = UA(i);
    DTa = Tq_in(i) - Tf_out(i);
    DTb = Tq_in(i) - Tf_in(i);
    DT_lm = (DTa - DTb)/log(DTa/DTb);
    Tm(i) = Tq_in(i) - DT_lm;
    %Tm(i) = 0.5*(Tf_in(i) + Tf_out(i));
    UA(i) = h_agua(Vazao_f(i),Tm(i),N,a,Ra,L,Tq_in(i))*4*a*L*N;
    Cmin = cp_ar(Tm(i))*Vazao_f(i);
    NUT = UA(i)/Cmin;
    epsilon = 1 - exp(-NUT);
    qmax = Cmin*(Tq_in(i) - Tf_in(i));
    q(i) = epsilon*qmax;
    Tf_out(i) = q(i)/Cmin + Tf_in(i);
  end
end
UA1 = UA
q1 = q
Tf_out_1 = Tf_out

%Segunda simulação
%Modelo semi-isotérmico
A_placa = (n*(a + t_aleta))*L;
k_s = k_s(sum(Tq_in)/length(Tq_in));%46.6; %Condutividade térmica do sólido em W/(Km)
Rp = esp_placa/(k_s*A_placa*17);
Aaf = a*L; %Área de transferência de calor de uma aleta
for i=1:length(Vazao_f)
  m = sqrt(h_agua(Vazao_f(i),Tf_in(i),N,a,Ra,L,Tq_in(i))*2*L/(k_s*t_aleta*L));
  eta_a = tanh(m*0.5*a)/(m*0.5*a);
  eta_o = 1-(Aaf/2*a*L)*(1-eta_a);
  UA(i) = (1/(eta_o*h_agua(Vazao_f(i),Tf_in(i),N,a,Ra,L,Tq_in(i))*4*a*L*N) + Rp)^(-1);
  Cmin = cp_ar(Tf_in(i))*Vazao_f(i);
  NUT = UA(i)/Cmin;
  epsilon = 1 - exp(-NUT);
  qmax = Cmin*(Tq_in(i) - Tf_in(i));
  q(i) = epsilon*qmax;
  Tf_out(i) = q(i)/Cmin + Tf_in(i);
  Tm(i) = 0.5*(Tf_in(i) + Tf_out(i));
  UA_old(i) = 0;
end
%UA
%q
%Tf_out

while max(abs(UA - UA_old)) > 1e-9
  for i=1:length(Vazao_f)
    UA_old(i) = UA(i);
    DTa = Tq_in(i) - Tf_out(i);
    DTb = Tq_in(i) - Tf_in(i);
    DT_lm = (DTa - DTb)/log(DTa/DTb);
    Tm(i) = Tq_in(i) - DT_lm;
    %Tm(i) = 0.5*(Tf_in(i) + Tf_out(i));
    m = sqrt(h_agua(Vazao_f(i),Tm(i),N,a,Ra,L,Tq_in(i))*2*L/(k_s*t_aleta*L));
    eta_a = tanh(m*0.5*a)/(m*0.5*a);
    eta_o = 1-(Aaf/4*a*L)*(1-eta_a);
    UA(i) = (1/(eta_o*h_agua(Vazao_f(i),Tm(i),N,a,Ra,L,Tq_in(i))*4*a*L*N) + Rp)^(-1);
    Cmin = cp_ar(Tm(i))*Vazao_f(i);
    NUT = UA(i)/Cmin;
    epsilon = 1 - exp(-NUT);
    qmax = Cmin*(Tq_in(i) - Tf_in(i));
    q(i) = epsilon*qmax;
    Tf_out(i) = q(i)/Cmin + Tf_in(i);
  end
end
UA2 = UA
q2 = q
Tf_out_2 = Tf_out

%Resolver q = epsilon*q_max
%q_max = C_min(Tq_in - Tf_in)
%epsilon = f(NUT,C_min/C_max)
%NUT = UA/C_min
%19*9 canais




%Terceira Simulação
%Modelo Completo
Lq = 0.3052; %Comprimento térmico dos canais de água em m
Aaq = a*Lq;
for i=1:length(Vazao_f)
  m_f = sqrt(h_agua(Vazao_f(i),Tf_in(i),N,a,Ra,L)*2*L/(k_s*t_aleta*L));
  eta_a_f = tanh(m_f*0.5*a)/(m_f*0.5*a);
  eta_o_f = 1-(Aaf/4*a*L)*(1-eta_a_f);
  m_q = sqrt(h_agua(Vazao_q(i),Tq_in(i),N,a,Ra,Lq)*2*L/(k_s*t_aleta*L));
  eta_a_q = tanh(m_q*0.5*a)/(m_q*0.5*a);
  eta_o_q = 1-(Aaq/4*a*Lq)*(1-eta_a_q);
  UA(i) = (1/(eta_o_f*h_agua(Vazao_f(i),Tf_in(i),N,a,Ra,L,Tq_in(i))*4*a*L*N) + Rp + 1/(eta_o_q*h_agua(Vazao_q(i),Tq_in(i),N,a,Ra,Lq)*4*a*Lq*N))^(-1);
  Cmin = cp_ar(Tf_in(i))*Vazao_f(i);
  Cmax = cp_agua(Tq_in(i))*Vazao_q(i);
  Cr = Cmin/Cmax;
  NUT = UA(i)/Cmin;
  epsilon = (1 - exp(-NUT*(1-Cr)))/(1 - Cr*exp(-NUT*(1-Cr)));
  qmax = Cmin*(Tq_in(i) - Tf_in(i));
  q(i) = epsilon*qmax;
  Tf_out(i) = q(i)/Cmin + Tf_in(i);
  Tfm(i) = 0.5*(Tf_in(i) + Tf_out(i));
  Tq_out(i) = q(i)/Cmax + Tq_in(i);
  UA_old(i) = 0;
  %Tq_out_old(i) = 0;
end
%UA
%q
%Tf_out

while max(abs(UA - UA_old)) > 1e-9
  for i=1:length(Vazao_f)
    UA_old(i) = UA(i);
    %Tq_out_old(i) = Tq_out(i);
    %Tfm(i) = 0.5*(Tf_in(i) + Tf_out(i));
    Tqm(i) = 0.5*(Tq_in(i) + Tq_out(i));
    DTa = Tq_in(i) - Tf_out(i);
    DTb = Tq_out(i) - Tf_in(i);
    DT_lm = (DTa - DTb)/log(DTa/DTb);
    Tfm(i) = Tqm(i) - DT_lm;
    m_f = sqrt(h_agua(Vazao_f(i),Tfm(i),N,a,Ra,L,Tqm(i))*2*L/(k_s*t_aleta*L));
    eta_a_f = tanh(m_f*0.5*a)/(m_f*0.5*a);
    eta_o_f = 1-(Aaf/4*a*L)*(1-eta_a_f);
    m_q = sqrt(h_agua(Vazao_q(i),Tqm(i),N,a,Ra,Lq)*2*L/(k_s*t_aleta*L));
    eta_a_q = tanh(m_q*0.5*a)/(m_q*0.5*a);
    eta_o_q = 1-(Aaq/4*a*Lq)*(1-eta_a_q);
    hf(i) = h_agua(Vazao_f(i),Tfm(i),N,a,Ra,L,Tqm(i));
    hq(i) = h_agua(Vazao_q(i),Tqm(i),N,a,Ra,Lq);
    Rf(i) = 1/(eta_o_f*h_agua(Vazao_f(i),Tfm(i),N,a,Ra,L,Tqm(i))*4*a*L*N);
    Rq(i) = 1/(eta_o_q*h_agua(Vazao_q(i),Tqm(i),N,a,Ra,Lq)*4*a*Lq*N);
    UA(i) = (1/(eta_o_f*h_agua(Vazao_f(i),Tfm(i),N,a,Ra,L,Tqm(i))*4*a*L*N) + Rp + 1/(eta_o_q*h_agua(Vazao_q(i),Tqm(i),N,a,Ra,Lq)*4*a*Lq*N))^(-1);
    Cmin = cp_ar(Tfm(i))*Vazao_f(i);
    Cmax = cp_agua(Tqm(i))*Vazao_q(i);
    Cr = Cmin/Cmax;
    Cmin = cp_ar(Tfm(i))*Vazao_f(i);
    NUT = UA(i)/Cmin;
    epsilon = 1 - exp(-NUT);
    qmax = Cmin*(Tq_in(i) - Tf_in(i));
    q(i) = epsilon*qmax;
    Tf_out(i) = q(i)/Cmin + Tf_in(i);
    Tq_out(i) = q(i)/Cmax + Tq_in(i);
  end
end
UA3 = UA
q3 = q
Tf_out_3 = Tf_out