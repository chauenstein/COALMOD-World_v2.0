
****************************Variables*******************************************


*** General Model Variables - Lower Level ***
Positive variables
         x(a,f,c)                energy sold by producer to inland demand in PJ
         y(a,f,e)                energy sold by producer to exporter in PJ
         z(a,e,sea)              energy sold by exporter e to importer sea(c) in PJ
         Pinv(a,f)               investments in additional production capacity
         Tinv_c(a,f,c)           investments in additional transport capacity to local demand
         Tinv_e(a,f,e)           investments in additional transport capacity to exporter
         alpha_p(a,f)            dual of producers production capacity
         alpha_Pinv(a,f)         dual of producers capacity for new investments
         alpha_res(f)            dual of reserve constraint
         alpha_tc(a,f,c)         dual of transport capacity constraint of producer f to consumer c
         alpha_te(a,f,e)         dual of export constraint of producer f to exporter e
         Einv(a,e)               investments in additional export capacity
         mu_e(a,e)               dual of exporters export capacity
         mu_Einv(a,e)            dual of exporters capacity for new investments
         pi_CHN(a)               dual of Chinas export restriction
         rho_CHN(a)              dual of Chinas import quota
         mu_k_avg(a,e,sea)       dual of quality restriction for imported coal
;

Variables
         p_c(a,c)                price at consumption node c
         p_e(a,e)                price paid by exporter to producers
;


** fix last period investment (Tinv_e, Tinv_e) to 0 in order to avoid empty equations
Tinv_c.fx(a,f,c)$(DomProd(f,c) AND ord(a) = card(a) ) = 0;
Tinv_e.fx(a,f,e)$(Exprod(f,e) AND ord(a) = card(a) ) = 0;

** fix other last period investments to reduce endog. variables
Pinv.fx(a,f)$(ord(a) = card(a)) = 0;
Einv.fx(a,e)$(ord(a) = card(a)) = 0;

