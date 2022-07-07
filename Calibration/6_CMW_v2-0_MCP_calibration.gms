***calibration settings

******2022-06-28, ch: implement simplified calibration process
***To calibrate a new scenario, set the purpose to "calibration" in the gams file 0_CMW_v2-0_Master.
***Specify the number of calibration iterations to be run in line 13 (default = 30)
***Run script in master file
***Open Excel file "Calibration.xlsx" in subfolder \Calibration and refresh data in sheet "Calibrate_Consumption"
***In case of significant deviations of resulting nodal consumption (columns Z:AJ) from reference nodal consumption (y_ref) (columns N:X), close file, increase number of calibration iterations and rerun calibration mode
***In case of deviations below desired threshold (e.g. 0.5 %), copy new prices (sheet "Calibrate_Prices", columns Z:AJ) to sheet "p_ref" in Input_data Excel file (replacing previous values for p_ref).


$iftheni %purpose% == calibration
Set stepX /1*30/;
$else
Set stepX /1*1/;
$endif

Model COALMOD_World_MCP /
         PKKT_x_Dom.x, PKKT_y_Exp.y, PKKT_Pinv.Pinv, PKKT_Tinv_c.Tinv_c, PKKT_Tinv_e.Tinv_e, PKKT_Prod.alpha_p, PKKT_Pmax.alpha_Pinv,
         PKKT_Res.alpha_res, PKKT_Tcap_c.alpha_tc, PKKT_Tcap_e.alpha_te,
         DS.p_c, DL.p_c,
         EKKT_z.z, EKKT_Einv.Einv, EKKT_Exp.mu_e, EKKT_Emax.mu_Einv,
         MCC.p_e, EKKT_China.pi_CHN, EKKT_ChinaIQ.rho_CHN,
         /;

loop(stepX,
if(ord(stepX) < card(stepX),

solve COALMOD_World_MCP using mcp;

p_c_fix(a,c)         =     p_c.l(a,c)          ;

b(a,c)        =  (1/epsi(c,a))*(p_c_fix(a,c)/y_ref(c,a));
DemInter(a,c) =  p_c_fix(a,c)*(1-1/epsi(c,a));

else

solve COALMOD_World_MCP using mcp;

x_fix(a,f,c)         =     x.l(a,f,c)          ;
y_fix(a,f,e)         =     y.l(a,f,e)          ;
z_fix(a,e,sea)       =     z.l(a,e,sea)        ;
Pinv_fix(a,f)        =     Pinv.l(a,f)         ;
Tinv_c_fix(a,f,c)    =     Tinv_c.l(a,f,c)     ;
Tinv_e_fix(a,f,e)    =     Tinv_e.l(a,f,e)     ;
alpha_p_fix(a,f)     =     alpha_p.l(a,f)      ;
alpha_Pinv_fix(a,f)  =     alpha_Pinv.l(a,f)   ;
alpha_tc_fix(a,f,c)  =     alpha_tc.l(a,f,c)   ;
alpha_te_fix(a,f,e)  =     alpha_te.l(a,f,e)   ;
Einv_fix(a,e)        =     Einv.l(a,e)         ;
mu_e_fix(a,e)        =     mu_e.l(a,e)         ;
mu_Einv_fix(a,e)     =     mu_Einv.l(a,e)      ;
pi_CHN_fix(a)        =     pi_CHN.l(a)         ;
p_c_fix(a,c)         =     p_c.l(a,c)          ;
p_e_fix(a,e)         =     p_e.l(a,e)          ;
rho_CHN_fix(a)       =     rho_CHN.l(a)        ;

consumption(c,a) = sum(f,x.l(a,f,c));
consumption(sea,a) = consumption(sea,a) + sum(e,z.l(a,e,sea));

);
);

$iftheni %purpose% == calibration

execute_unload "Calibration/No_tax_calibration.gdx"   timestamp, p_c_fix, consumption, p_ref, y_ref;
execute 'gdxxrw.exe i=Calibration/No_tax_calibration.gdx UpdLinks =3 o=Calibration/Calibration.xlsx @Calibration/calibration.txt';

$endif
