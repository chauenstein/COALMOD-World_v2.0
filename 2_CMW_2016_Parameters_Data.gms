
****************************Parameters & Data Load******************************


********************************************************************************
*****************************Generate GDX - Data Import*************************
********************************************************************************

* Load calibrated CMW data for NPS (WEO2012)
$call "gdxxrw.exe Input_Data/%input_data%.xlsx UpdLinks =3 o=input_data.gdx  @Input_data.txt"


********************************************************************************
***************************General Parameters***********************************
********************************************************************************

Parameter
         emsint          Emission Intensity (CO2 emissions per generated energy) in CO2 Mt per PJ
;
emsint=0.0983;

Parameter
         timestamp ;
timestamp = jnow + 1;



********************************************************************************
**************************Producer Parameters***********************************
********************************************************************************

Parameters
         r(f)                    discount rate of producers
         Producer_data(f,*)      constant producer data
         PCap(f)                 production capacity of Producer in Mt in starting year
*21.07.2021, ch: add depe(f)
         depe(f)                 base in denominator of depreciation function for existing production capacity
*05.01.2021, ch: add depn(f)
         depn(f)                 base in denominator of depreciation function for added (new) production capacity
*2021-06-28, ch: add ml_exist(f) and ml_new(f)
         mlexist(f)              remaining average mine lifetime for existing mines (relates to PCap)
         mlnew(f)                average mine lifetime for new mines (relates to new investments)
         kfs(f)                  quality factor in t per GJ in starting year
         delta(f)                quality depreciation parameter
         res(f)                  reserves in Mt
         CPinv(f)                investment costs in production capacity in USD per t
         Pmaxinv(f)              maximal investments per (5) year in new production capacity in Mt
*20.06.2016, rm: make mc_int_start dependent on year a to implement subsidy removal startin 2020
         mc_int_start(f,a)       marginal costs intercept in USD per t
         mc_slp_start(f)         marginal costs slope in USD per t squared
         mc_int_var(f)           intercept variation factor (mine mortality rate)
         mc_slp_var(f)           slope variation factor (not existing in this version)
         CournotPowerP(a,f,c)    Cournot market power parameter
;


$GDXIN   input_data.gdx
$LOAD    Producer_data
$GDXIN

r(f)= 0.1;
Pcap(f) = Producer_data(f,'Pcap');
*21.07.2021, ch: add depe(f)
depe(f)  = Producer_data(f,'depe');
*05.01.2021, ch: add depn(f)
depn(f)  = Producer_data(f,'depn');
*2021-06-28, ch: add ml_exist(f) and ml_new(f)
mlexist(f) = Producer_data(f,'mlexist');
mlnew(f) = Producer_data(f,'mlnew');
kfs(f)  = Producer_data(f,'kfs');
delta(f) = Producer_data(f,'delta');
res(f)  = Producer_data(f,'res');
CPinv(f)  = Producer_data(f,'CPinv');
Pmaxinv(f) = Producer_data(f,'Pmaxinv');
mc_int_start(f,a) = Producer_data(f,'mc_int_start');
mc_slp_start(f) = Producer_data(f,'mc_slp_start');
mc_int_var(f) = Producer_data(f,'mc_int_var');
mc_slp_var(f) = Producer_data(f,'mc_slp_var');
*CournotPower=0 means no market power. CournotPower=1 means market power.
CournotPowerP(a,f,c)=0;


********************************************************************************
*************************Exporters Parameters***********************************
********************************************************************************

Parameters
         r_e(e)                  discout rate of exporter
         Exporter_data(e,*)      exporter data
         Ecap(e)                 export capacity of port of exporter e in Mt
         fee_port(e)             export fee of port of exporter e in USD per t
         CEinv(e)                investment costs in export capacity in USD per t
         Emaxinv(a,e)            maximal investments per (5) year in new export capacity in Mt
         Emaxcap(e)              maximal export capacity of exporter at final year in Mt
         theta(e,sea)            binary parameter for china export restriction
         CournotPowerE(a,e,c)

******new parameters ************************************************************
         t_i(a,e,sea)            Import tax for import from port e to port sea
*2022-03-20, ch: for Chinese max-import quota
         iota(e,sea)             binary parameter for china import quota

;

$GDXIN   input_data.gdx
$LOAD    Exporter_data
$GDXIN

r_e(e)= 0.1;
Ecap(e)     = Exporter_data(e,'Ecap');
fee_port(e) = Exporter_data(e,'fee_port');
CEinv(e)    = Exporter_data(e,'CEinv');
Emaxinv(a,e)= Exporter_data(e,'Emaxinv');
Emaxcap(e)  = Exporter_data(e,'Emaxcap');
*CournotPower=0 means no market power. CournotPower=1 means market power.
CournotPowerE(a,e,c)=0;


*Chinese Export Restriction
theta(e,sea) = 0;
theta('E_CHN',NoChina) = 1;


*high dummy value --> constraint not binding
Parameter China_lic(a) export licences in Mt meaning export restriction
          /
           2015   9999
           2020   9999
           2025   9999
           2030   9999
           2035   9999
           2040   9999
           2045   9999
           2050   9999
           2055   9999
           2060   9999
          /;



*2022-03-20, ch: for Chinese max-import quota
iota(e,sea) = 0;
iota(NoChina_exp,China_sea) = 1;

*2022-03-21, ch: import quota in Mt
Parameter China_IQ(a) import quota in Mt meaning max imports via sea into China
         /
         2015    300
         2020    300
         2025    300
         2030    300
         2035    300
         2040    300
         2045    300
         2050    300
         2055    300
         2060    300
         /;

********************************************************************************
**********************TransportLand Parameters**********************************
********************************************************************************

Parameters
         Trans_c_data(f,c,*)
         DomProd(f,c)            existing land transport link between producer and consumer
         Tmaxinv_c_fix(f,c)
         Tmaxinv_c(a,f,c)        maximal investments in additional transport capacity to consumer in year a in Mt
         trans_c(f,c)            transport costs from mine to consumption node in USD per t
         tcap_c(f,c)             tranport capacity from mine to consumption node in Mt
         CTinv_c(f,c)            investment costs in tranport capacity from mine to consumption node in USD per t

         Trans_e_data(f,e,*)
         ExProd(f,e)             existing land transport link between producer and exporter
         Tmaxinv_e_fix(f,e)
         Tmaxinv_e(a,f,e)        maximal investments in additional transport capacity to exporter in year a in Mt
         trans_e(f,e,a)          transport costs from mine to exporter in USD per t
         tcap_e(f,e)             transport capacity from mine to exporter in Mt
         CTinv_e(f,e)            investment costs in tranport capacity from mine to exporter in USD per t
         kes(e)                  quality factor of exporter in t per GJ (note per exporter only one producer)
;


$GDXIN   input_data.gdx
$LOAD    Trans_c_data
$LOAD    Trans_e_data
$GDXIN

DomProd(f,c)       = Trans_c_data(f,c,'DomProd');
Tmaxinv_c_fix(f,c) = Trans_c_data(f,c,'Tmaxinv_c_fix');
trans_c(f,c)       = Trans_c_data(f,c,'trans_c');
tcap_c(f,c)        = Trans_c_data(f,c,'tcap_c');
CTinv_c(f,c)       = Trans_c_data(f,c,'CTinv_c');
Tmaxinv_c(a,f,c)   = Trans_c_data(f,c,'Tmaxinv_c_fix');

ExProd(f,e)        = Trans_e_data(f,e,'ExProd');
Tmaxinv_e_fix(f,e) = Trans_e_data(f,e,'Tmaxinv_e_fix');
trans_e(f,e,a)     = Trans_e_data(f,e,'trans_e');
tcap_e(f,e)        = Trans_e_data(f,e,'tcap_e');
CTinv_e(f,e)       = Trans_e_data(f,e,'CTinv_e');
Tmaxinv_e(a,f,e)   = Trans_e_data(f,e,'Tmaxinv_e_fix');
kes(e)             = sum(f,kfs(f)$ExProd(f,e));


********************************************************************************
**********************SeaTransport Parameters***********************************
********************************************************************************

Parameters
*2021-03-19, ch: no differentiation between seastart and dynamic - set all to seastart
         seastart(e,sea)     starting year freight rates btw two nodes in USD per t
         seadynamic(e,sea)   freight rates btw two nodes in USD per t
         searate(a,e,sea);

$GDXIN   input_data.gdx
$LOAD    seastart
*$LOAD    seadynamic
$GDXIN



searate(as,e,sea) =  seastart(e,sea);
searate(ad,e,sea) =  seastart(e,sea);
*searate(ad,e,sea) =  seadynamic(e,sea);

t_i(a,e,sea) = 0;

$ontext
*2022-03-10, ch: import tax from 2020 on in China on all imports (except from E_CHN and P_MNG) representing Chinese import quota (limiting imports to around 200Mt/a)
t_i(ad,e,'C_CHN_Eastern')= 25;
t_i(ad,e,'C_CHN_South')= 25;
t_i('2020',e,'C_CHN_Eastern')= 5;
t_i('2020',e,'C_CHN_South')= 5;
t_i('2025',e,'C_CHN_Eastern')= 15;
t_i('2025',e,'C_CHN_South')= 15;
t_i(ad,'E_CHN','C_CHN_Eastern')= 0;
t_i(ad,'E_CHN','C_CHN_South')= 0;
$offtext

********************************************************************************
**********************Consumer Parameters***************************************
********************************************************************************

Parameters
         p_ref(c,a)      ref steam coal price in demand node c in USD per GJ
         y_ref(c,a)      ref steam coal consumption of demand node c in PJ
         epsi(c,a)       price elasticity of demand node c
         b(a,c)          demand curve slope
         DemInter(a,c)   demand curve intercept
         r_c             cosumer discount rate

******new parameters ************************************************************
         k_avg(c)        average quality standard at import node

;

k_avg(c)= 0;

$GDXIN   input_data.gdx
$LOAD    p_ref
$LOAD    y_ref
$LOAD    epsi
$GDXIN

b(a,c)        =  (1/epsi(c,a))*(p_ref(c,a)/y_ref(c,a));
DemInter(a,c) =  p_ref(c,a)*(1-1/epsi(c,a));

*epsi(c,a)$(epsi(c,a)=0)=999;
*p_ref(c,a)$(p_ref(c,a)=0)=999;
*y_ref(c,a)$(y_ref(c,a)=0)=999;

*Display epsi, p_ref, y_ref;

r_c = 0.1    ;



********************************************************************************
**********************Save variables to fix for later runs**********************
********************************************************************************
parameters
x_fix(a,f,c)
y_fix(a,f,e)
z_fix(a,e,sea)
Pinv_fix(a,f)
Tinv_c_fix(a,f,c)
Tinv_e_fix(a,f,e)
alpha_p_fix(a,f)
alpha_Pinv_fix(a,f)
alpha_tc_fix(a,f,c)
alpha_te_fix(a,f,e)
Einv_fix(a,e)
mu_e_fix(a,e)
mu_Einv_fix(a,e)
pi_CHN_fix(a)
*2022-03-20, ch: for Chinese max-import quota
roh_CHN_fix(a)
p_c_fix(a,c)
p_e_fix(a,e)
mc_int_fix(a,f)
consumption(c,a)
tsyear



********************************************************************************
**********************Output Parameters*****************************************
********************************************************************************

alias(r1,r2,r3,r4,r5,r6,r7,f1,f2,f3,f4,f5,f6,f7,f8,f9,*);




Parameters
         zz                             what is this?
         xxdom(country,f,c,a)
         qxdom(country,f,c,a)
         xxexp(country,f,c,a)
         qxexp(country,f,c,a)
         zzdom(country,e,c,a)
         qzdom(country,e,c,a)
         zzexp(country,e,c,a)
         qzexp(country,e,c,a)
         yydom(country,f,e,a)
         yyexp(country,f,e,a)
         fracdom(country,f,a)
         fracexp(country,f,a)
         xxfracdom(country,f,a)
         xxfracexp(country,f,a)
         yyfracdom(country,f,a)
         yyfracexp(country,f,a)
         ttest(country,f,a)
*30-12-2020, ch: add new parameter for mc_int reporting
         mc_int

* General Reporting
         report(r1,r2,r3,r4,r5,r6,r7)              General Output Report all loop steps
*                                  %modrun%,'tax rate','production','type', 'Unit', country,node,a
         report_ECT(r1,r2,r3,r4,r5,r6,r7)          Output Report ECT

         flow(f1,f2,f3,f4,f5,f6,f7,f8,f9)          General Flow Report all loop steps
*                                  %modrun%,'trade','type','Unit',countryOut,node,countryIn,node,a
         flow_ECT(f1,f2,f3,f4,f5,f6,f7,f8,f9)      Flow Report ECT
;

Display y_ref;

