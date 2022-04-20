
Model COALMOD_World_MCP_scenario /
         PKKT_x_Dom.x, PKKT_y_Exp.y, PKKT_Pinv.Pinv, PKKT_Tinv_c.Tinv_c, PKKT_Tinv_e.Tinv_e, PKKT_Prod.alpha_p, PKKT_Pmax.alpha_Pinv,
         PKKT_Res.alpha_res, PKKT_Tcap_c.alpha_tc, PKKT_Tcap_e.alpha_te,
         DS.p_c, DL.p_c,
         EKKT_z.z, EKKT_Einv.Einv, EKKT_Exp.mu_e, EKKT_Emax.mu_Einv,
         MCC.p_e, EKKT_China.pi_CHN, EKKT_ChinaIQ.roh_CHN


/;

x.fx(a,f,c)$(fix(a))             =    x_fix(a,f,c)            ;
y.fx(a,f,e)$(fix(a))             =    y_fix(a,f,e)            ;
z.fx(a,e,sea)$(fix(a))           =    z_fix(a,e,sea)          ;
Pinv.fx(a,f)$(fix(a))            =    Pinv_fix(a,f)           ;
Tinv_c.fx(a,f,c)$(fix(a))        =    Tinv_c_fix(a,f,c)       ;
Tinv_e.fx(a,f,e)$(fix(a))        =    Tinv_e_fix(a,f,e)       ;
alpha_p.fx(a,f)$(fix(a))         =    alpha_p_fix(a,f)        ;
alpha_Pinv.fx(a,f)$(fix(a))      =    alpha_Pinv_fix(a,f)     ;
alpha_tc.fx(a,f,c)$(fix(a))      =    alpha_tc_fix(a,f,c)     ;
alpha_te.fx(a,f,e)$(fix(a))      =    alpha_te_fix(a,f,e)     ;
Einv.fx(a,e)$(fix(a))            =    Einv_fix(a,e)           ;
mu_e.fx(a,e)$(fix(a))            =    mu_e_fix(a,e)           ;
mu_Einv.fx(a,e)$(fix(a))         =    mu_Einv_fix(a,e)        ;
pi_CHN.fx(a)$(fix(a))            =    pi_CHN_fix(a)           ;
p_c.fx(a,c)$(fix(a))             =    p_c_fix(a,c)            ;
p_e.fx(a,e)$(fix(a))             =    p_e_fix(a,e)            ;
roh_CHN.fx(a)$(fix(a))           =    roh_CHN_fix(a)          ;


