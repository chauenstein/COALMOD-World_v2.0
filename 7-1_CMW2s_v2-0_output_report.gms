
********************************************************************************
********** Auxiliary Results                                          **********
********************************************************************************

zz(e,sea,a)              = z.l(a,e,sea);

mc_int(a,f)              = mc_int_start(f,a)
                                  +  sum(aa$(ORD(aa) < ORD(a)),(( sum(c$DomProd(f,c),kfs(f)*x.l(aa,f,c))+ sum(e$ExProd(f,e),kfs(f)*y.l(aa,f,e)) )
                                  * mc_slp_start(f) * mc_int_var(f) ))  ;

loop{(country,c,f,a)$(Prodcountry(f,country) AND Conscountry(c,country)),
        xxdom(country,f,c,a) =  x.l(a,f,c);
        qxdom(country,f,c,a) =  x.l(a,f,c)*kfs(f);
};

loop{(country,c,f,a)$(Prodcountry(f,country) AND ( NOT Conscountry(c,country))),
        xxexp(country,f,c,a)   =  x.l(a,f,c);
        qxexp(country,f,c,a)   =  x.l(a,f,c)*kfs(f);
};

loop{(country,e,sea,a)$(Expcountry(e,country) AND ( Conscountry(sea,country))),

        zzdom(country,e,sea,a) =  z.l(a,e,sea);
        qzdom(country,e,sea,a) =  z.l(a,e,sea)*kes(e);
};

loop{(country,e,sea,a)$(Expcountry(e,country) AND ( NOT Conscountry(sea,country))),
        zzexp(country,e,sea,a) =  z.l(a,e,sea);
        qzexp(country,e,sea,a) =  z.l(a,e,sea)*kes(e);
};

yydom(country,f,e,a)$ExProd(f,e)=sum(sea,zzdom(country,e,sea,a));
yyexp(country,f,e,a)$ExProd(f,e)=sum(sea,zzexp(country,e,sea,a));

xxfracdom(country,f,a)$sum(c,x.l(a,f,c))= sum(c,xxdom(country,f,c,a))/sum(c,x.l(a,f,c));
xxfracexp(country,f,a)$sum(c,x.l(a,f,c))= sum(c,xxexp(country,f,c,a))/sum(c,x.l(a,f,c));

yyfracdom(country,f,a)$sum(e,yydom(country,f,e,a))= sum(e,yydom(country,f,e,a))/(sum(e,yydom(country,f,e,a))+sum(e,yyexp(country,f,e,a)));
yyfracexp(country,f,a)$sum(e,yyexp(country,f,e,a))= sum(e,yyexp(country,f,e,a))/(sum(e,yydom(country,f,e,a))+sum(e,yyexp(country,f,e,a)));

fracdom(country,f,a)$(sum(c,x.l(a,f,c))+sum(e,y.l(a,f,e)))=  (sum(c,xxdom(country,f,c,a))+sum(e,yydom(country,f,e,a)))/(sum(c,x.l(a,f,c))+sum(e,y.l(a,f,e)));
fracexp(country,f,a)$(sum(c,x.l(a,f,c))+sum(e,y.l(a,f,e)))=  (sum(c,xxexp(country,f,c,a))+sum(e,yyexp(country,f,e,a)))/(sum(c,x.l(a,f,c))+sum(e,y.l(a,f,e)));


********************************************************************************
********** Energy balance report                                      **********
********************************************************************************

** Production Report **

loop{(country,f)$prodcountry(f,country),
report(%modrun%,'Production','out','Energy',country,f,a) = sum(c,x.l(a,f,c))+ sum(e,y.l(a,f,e));
report(%modrun%,'Production','out','Mass',country,f,a) = (sum(c,x.l(a,f,c))+ sum(e,y.l(a,f,e)))*kfs(f);
report(%modrun%,'Production','out','Mass',country,f,'cum')= sum(a$(1<ORD(a)),((sum(c,x.l(a,f,c))+ sum(e,y.l(a,f,e)))*kfs(f)
                                                                   +(sum(c,x.l(a-1,f,c))+ sum(e,y.l(a-1,f,e)))*kfs(f))*plength/2);
report(%modrun%,'Production','PCap','Mass',country,f,a) = 1/(1+depe(f)**(-(ord(a)-(mlexist(f)/5+1))))*PCap(f)
                                                         + sum(aa$(ORD(aa) < ORD(a)), Pinv.l(aa,f)*1/(1+depn(f)**(-(ord(a)-(mlnew(f)/5+1)-ord(aa)))) );
report(%modrun%,'Production','MC at PCap','USD/t',country,f,a) = mc_int(a,f) + mc_slp_start(f) * report(%modrun%,'Production','PCap','Mass',country,f,a);

report(%modrun%,'Production','MC_int','USD/t',country,f,a) = mc_int(a,f);

report(%modrun%,'Production','MC at PLev','USD/t',country,f,a) = mc_int(a,f) + mc_slp_start(f) * (sum(c,kfs(f)*x.l(a,f,c)) + sum(e,kfs(f)*y.l(a,f,e))) ;
*** include Pinv
report(%modrun%,'Production','Pinv','mnUSD',country,f,a)  = Pinv.l(a,f)*CPinv(f);
report(%modrun%,'Production','Pinv','Mass',country,f,a)  = Pinv.l(a,f);

** Production Surplus **

report(%modrun%,'Production','PSur','mnUSD',country,f,a) = sum(c,p_c.l(a,c)*x.l(a,f,c)) + sum(e,p_e.l(a,e)*y.l(a,f,e)) - ( +( kfs(f)* mc_int(a,f)
                                                       + 0.5*kfs(f)**2 *mc_slp_start(f)*( sum(c$DomProd(f,c),x.l(a,f,c))+ sum(e$ExProd(f,e),y.l(a,f,e))))
                                                       *(sum(c$DomProd(f,c),x.l(a,f,c))+ sum(e$ExProd(f,e),y.l(a,f,e)))
                                                       + sum(c,kfs(f)*trans_c(f,c)*x.l(a,f,c)) + sum(e,kfs(f)*trans_e(f,e,a)*y.l(a,f,e))
                                                       + CPinv(f)/plength*Pinv.l(a,f) + sum(c,CTinv_c(f,c)/plength*Tinv_c.l(a,f,c)) + sum(e,CTinv_e(f,e)/plength*Tinv_e.l(a,f,e)));

** shadow price (dual) of producers capacity for new investments  **
report(%modrun%,'Production','alpha_Pinv','XX',country,f,a) = alpha_Pinv.l(a,f);

** shadow price (dual) of reserve constraint  **
report(%modrun%,'Production','alpha_res','XX',country,f,'cum') = alpha_res.l(f);

*** investments in transport infrastructre
report(%modrun%,'Production','Tinv_c','mnUSD',country,f,a)  =  sum(c, Tinv_c.l(a,f,c)*CTinv_c(f,c)*DomProd(f,c));

report(%modrun%,'Production','Tinv_e','mnUSD',country,f,a)  =  sum(e, Tinv_e.l(a,f,e)*CTinv_e(f,e)*ExProd(f,e));

};


report(%modrun%,'Production','Prod','Energy','World','World',a) = sum((country,c), report(%modrun%,'Production','Prod','Energy',country,c,a) );
report(%modrun%,'Production','Exports','Energy',country,f,a) = sum((e,c)$ExProd(f,e),zzexp(country,e,c,a))+ sum(c,xxexp(country,f,c,a)) ;

report(%modrun%,'Production','PSur','mnUSD',country,f,'cum') = sum(a$(1 < ORD(a)),((1/(1 + r(f)))**(year(a)-2015)*report(%modrun%,'Production','PSur','mnUSD',country,f,a)
                                                           + (1/(1 + r(f)))**(year(a-1)-2015)*report(%modrun%,'Production','PSur','mnUSD',country,f,a-1))*plength/2 );



** Consumption Report **

loop{(country,c)$Conscountry(c,country),

report(%modrun%,'Consumption','out','Energy',country,c,a) = sum(f,x.l(a,f,c)) + sum(e,zz(e,c,a));
report(%modrun%,'Consumption','out','Mass',country,c,a)   = sum(f,x.l(a,f,c)*kfs(f)) + sum(e,zz(e,c,a)*kes(e));
report(%modrun%,'Price','PriceC','USD/GJ',country,c,a)    = p_c.l(a,c);
report(%modrun%,'Price','DemInter','USD/GJ',country,c,a)  = p_ref(c,a)*(1-1/epsi(c,a));
};

***average consumers' price
report(%modrun%,'Price','Avg_Price','USD/GJ','all','all',a)   = sum((country,c),report(%modrun%,'Price','PriceC','USD/GJ',country,c,a)*(sum(e,zz(e,c,a))+ sum(f,x.l(a,f,c))))
                                                                 /(sum((c,e),zz(e,c,a))+ sum((c,f),x.l(a,f,c)));


loop{(country,sea)$Conscountry(sea,country),
report(%modrun%,'Consumption','CSur','mnUSD',country,sea,a)  = 0.5*(sum(e,(DemInter(a,sea)-p_c.l(a,sea))*z.l(a,e,sea) ));
};
loop{(country,land)$Conscountry(land,country),
report(%modrun%,'Consumption','CSur','mnUSD',country,land,a) = 0.5*(sum(f,(DemInter(a,land)-p_c.l(a,land))*x.l(a,f,land) ));
};

report(%modrun%,'Consumption','CSur','mnUSD',country,sea,'cum')   = sum(a$(1 < ORD(a)),((1/(1 + r_c))**(year(a)-2015)*report(%modrun%,'Consumption','CSur','mnUSD',country,sea,a)
                                                           + (1/(1 + r_c))**(year(a-1)-2015)*report(%modrun%,'Consumption','CSur','mnUSD',country,sea,a-1) )*plength/2 );
report(%modrun%,'Consumption','CSur','mnUSD',country,land,'cum')  = sum(a$(1 < ORD(a)),((1/(1 + r_c))**(year(a)-2015)*report(%modrun%,'Consumption','CSur','mnUSD',country,land,a)
                                                           + (1/(1 + r_c))**(year(a-1)-2015)*report(%modrun%,'Consumption','CSur','mnUSD',country,land,a-1))*plength/2 );

report(%modrun%,'Consumption','out','Mass',country,c,'cum')   = sum(a$(1<ORD(a)),(sum(f,x.l(a,f,c)*kfs(f)) + sum(e,zz(e,c,a)*kes(e))
                                                                       +sum(f,x.l(a-1,f,c)*kfs(f)) + sum(e,zz(e,c,a-1)*kes(e)))*plength/2);




** Export Report **

loop{(country,e)$Expcountry(e,country),

report(%modrun%,'Price','PriceE','USD/GJ',country,e,a)   = p_e.l(a,e);
report(%modrun%,'Price','PriceE','USD/t',country,e,a)    = p_e.l(a,e)/kes(e);
report(%modrun%,'Exports','ECap','Mass',country,e,a)     = Ecap(e) + sum(aa$(ORD(aa) < ORD(a)), Einv.l(aa,e));
report(%modrun%,'Exports','EInv','mnUSD',country,e,'cum')  = sum(a$(ORD(a)<5), Einv.l(a,e)*CEinv(e));
***annual EInv
report(%modrun%,'Exports','EInv','mnUSD',country,e,a)  =  Einv.l(a,e)*CEinv(e);

report(%modrun%,'Exports','ESur','mnUSD',country,e,a)      = sum(sea,p_c.l(a,sea)*z.l(a,e,sea)) - ( sum(sea,p_e.l(a,e)*z.l(a,e,sea) + kes(e)* searate(a,e,sea)*z.l(a,e,sea)
                                                         + kes(e)*fee_port(e)*z.l(a,e,sea)) + CEinv(e)/plength*Einv.l(a,e));

** shadow price (dual) of exporters capacity for new investments  **
***changed from 'Production' to 'Exports'
*report(%modrun%,'Production','mu_Einv','XX',country,e,a) = mu_Einv.l(a,e);
report(%modrun%,'Exports','mu_Einv','XX',country,e,a) = mu_Einv.l(a,e);

};



report(%modrun%,'Exports','ESur','mnUSD',country,e,'cum') = sum(a$(1 < ORD(a)),((1/(1 + r_e(e)))**(year(a)-2015)*report(%modrun%,'Exports','ESur','mnUSD',country,e,a)
                                                        + (1/(1 + r_e(e)))**(year(a-1)-2015)*report(%modrun%,'Exports','ESur','mnUSD',country,e,a-1))*plength/2 );



loop{(f,country)$Prodcountry(f,country),
report(%modrun%,'Exports','out','Energy',country,f,a) = sum((e,c)$ExProd(f,e),zzexp(country,e,c,a))+ sum(c,xxexp(country,f,c,a));
report(%modrun%,'Exports','out','Mass',country,f,a)   = sum((e,c)$ExProd(f,e),zzexp(country,e,c,a)*kes(e))+ sum(c,xxexp(country,f,c,a)*kfs(f));
report(%modrun%,'Exports','out','Mass',country,f,'cum') = sum(a$(1<ORD(a)),(sum((e,c)$ExProd(f,e),zzexp(country,e,c,a)*kes(e))+ sum(c,xxexp(country,f,c,a)*kfs(f))
                                                                 +sum((e,c)$ExProd(f,e),zzexp(country,e,c,a-1)*kes(e))+ sum(c,xxexp(country,f,c,a-1)*kfs(f)))*plength/2);

};

* Production for domestic market (xxdom):
report(%modrun%,'ProductionDom','out','Energy',country,f,a) = report(%modrun%,'Production','out','Energy',country,f,a) - report(%modrun%,'Exports','out','Energy',country,f,a);
report(%modrun%,'ProductionDom','out','Mass',country,f,a)   = report(%modrun%,'Production','out','Mass',country,f,a)   - report(%modrun%,'Exports','out','Mass',country,f,a);


** Emissions Report **

report(%modrun%,'Emissions','Cons','Mt',country,c,a)            = emsint * report(%modrun%,'Consumption','out','Energy',country,c,a);
report(%modrun%,'Emissions','Cons','Mt',country,c,'cum')        = sum (a$(1 < ORD(a)),(report(%modrun%,'Emissions','Cons','Mt',country,c,a)
                                                                + report(%modrun%,'Emissions','Cons','Mt',country,c,a-1) )*plength/2 );
report(%modrun%,'Emissions','Prod','Mt',country,f,a)            = emsint * report(%modrun%,'Production','out','Energy',country,f,a);
report(%modrun%,'Emissions','Prod','Mt',country,f,'cum')        = sum (a$(1 < ORD(a)),(report(%modrun%,'Emissions','Prod','Mt',country,f,a)
                                                                + report(%modrun%,'Emissions','Prod','Mt',country,f,a-1) )*plength/2 );
report(%modrun%,'Emissions','Cons','Mt','World','World',a)      = sum((country,c), report(%modrun%,'Emissions','Cons','Mt',country,c,a) );
report(%modrun%,'Emissions','Cons','Mt','World','World','cum')  = sum (a$(1 < ORD(a)),(report(%modrun%,'Emissions','Cons','Mt','World','World',a)
                                                                + report(%modrun%,'Emissions','Cons','Mt','World','World',a-1) )*plength/2 );

** All values to calculate FOB **

report(%modrun%,'FOB','MC_init','USD/t',country,f,a)              =  mc_int(a,f)$(Prodcountry(f,country)) ;
report(%modrun%,'FOB','MC at PCap','USD/t',country,f,a)           =  (mc_int(a,f) + mc_slp_start(f) * report(%modrun%,'Production','PCap','Mass',country,f,a))$(Prodcountry(f,country));
report(%modrun%,'FOB','trans_e','USD/t',e,f,a)                    =  trans_e(f,e,a);
report(%modrun%,'FOB','fee_port','USD/t',e,country,a)             =  fee_port(e)$(Expcountry(e,country));
report(%modrun%,'FOB','sum_shadow_prices','USD/t',e,f,a)          =  sum(country,(p_e.l(a,e)/kes(e)- (mc_int(a,f) + mc_slp_start(f) * (sum(c,x.l(a,f,c))+ sum(ee,y.l(a,f,ee)))*kfs(f)-trans_e(f,e,a)))$(Prodcountry(f,country) AND Expcountry(e,country)));



**** WELFARE REPORTING  ****

*** Per-period surpluses ***


report(%modrun%,'Welfare','PSurG','mnUSD','All',country,a) =    sum(f$ProdCountry(f,country), report(%modrun%,'Production','PSur','mnUSD',country,f,a));


report(%modrun%,'Welfare','PSurD','mnUSD','All',country,a) =    sum(f$(ProdCountry(f,country)),
                                                                sum(c,p_c.l(a,c)*xxdom(country,f,c,a)) + sum(e,p_e.l(a,e)*yydom(country,f,e,a)) - (
                                                                +( kfs(f)* mc_int(a,f) + 0.5*kfs(f)**2 *mc_slp_start(f)*( sum(c,x.l(a,f,c))+ sum(e,y.l(a,f,e))))
                                                                *(sum(c, xxdom(country,f,c,a))+ sum(e,yydom(country,f,e,a)))
                                                                + sum(c,kfs(f)*trans_c(f,c)*xxdom(country,f,c,a))
                                                                + sum(e,kfs(f)*trans_e(f,e,a)*yydom(country,f,e,a))
                                                                + CPinv(f)/plength*Pinv.l(a,f)*fracdom(country,f,a)
                                                                + sum(c,CTinv_c(f,c)/plength*Tinv_c.l(a,f,c))*xxfracdom(country,f,a)
                                                                + sum(e,CTinv_e(f,e)/plength*Tinv_e.l(a,f,e))*yyfracdom(country,f,a)
                                                                ));

report(%modrun%,'Welfare','PSurE','mnUSD','All',country,a) =    sum(f$(ProdCountry(f,country)),
                                                                sum(c,p_c.l(a,c)*xxexp(country,f,c,a)) + sum(e,p_e.l(a,e)*yyexp(country,f,e,a)) - (
                                                                +( kfs(f)* mc_int(a,f) + 0.5*kfs(f)**2 *mc_slp_start(f)*( sum(c,x.l(a,f,c))+ sum(e,y.l(a,f,e))))
                                                                *(sum(c, xxexp(country,f,c,a))+ sum(e,yyexp(country,f,e,a)))
                                                                + sum(c,kfs(f)*trans_c(f,c)*xxexp(country,f,c,a))
                                                                + sum(e,kfs(f)*trans_e(f,e,a)*yyexp(country,f,e,a))
                                                                + CPinv(f)/plength*Pinv.l(a,f)*fracexp(country,f,a)
                                                                + sum(c,CTinv_c(f,c)/plength*Tinv_c.l(a,f,c))*xxfracexp(country,f,a)
                                                                + sum(e,CTinv_e(f,e)/plength*Tinv_e.l(a,f,e))*yyfracexp(country,f,a)
                                                                ));

report(%modrun%,'Welfare','ESurG','mnUSD','All',country,a) =    sum(e$(ExpCountry(e,country)),(
                                                                sum(sea,p_c.l(a,sea)*z.l(a,e,sea)) - ( sum(sea,p_e.l(a,e)*z.l(a,e,sea) + kes(e)* searate(a,e,sea)*z.l(a,e,sea)
                                                                + kes(e)*fee_port(e)*z.l(a,e,sea)) + CEinv(e)/plength*Einv.l(a,e)
                                                                )));

report(%modrun%,'Welfare','CSurG','mnUSD','All',country,a) =    0.5*(sum(sea$(ConsCountry(sea,country)),(sum(e,(DemInter(a,sea)-p_c.l(a,sea))*z.l(a,e,sea) )))
                                                                + sum(land$(ConsCountry(land,country)),(sum(f,(DemInter(a,land)-p_c.l(a,land))*x.l(a,f,land) )))
                                                                );

report(%modrun%,'Welfare','SurG','mnUSD','All',country,a)  =  report(%modrun%,'Welfare','PSurG','mnUSD','All',country,a) + report(%modrun%,'Welfare','ESurG','mnUSD','All',country,a)
                                                              + report(%modrun%,'Welfare','CSurG','mnUSD','All',country,a);


**** WELFARE REPORTING - TAX SETTER ****




report(%modrun%,'Emissions','delta','Mt','World','World','cum')          = report(%modrun%,'Emissions','Cons','Mt','World','World','cum')- report(%modrun%-1,'Emissions','Cons','Mt','World','World','cum') ;
report(%modrun%,'Welfare','delta','mnUSD','All',country,'cum')    = report(%modrun%,'Welfare','SurG','mnUSD','All',country,'cum')- report(%modrun%-1,'Welfare','SurG','mnUSD','All',country,'cum');


********************************************************************************
********** Trade flow report                                         ***********
********************************************************************************

loop{(country,f,country2,c)$(Prodcountry(f,country) AND Conscountry(c,country2)),
flow(%modrun%,'Trade','Land','Energy',country,f,country2,c,a)= x.l(a,f,c);
flow(%modrun%,'Trade','Land','Mass',country,f,country2,c,a)= x.l(a,f,c)*kfs(f);
flow(%modrun%,'Trade','alpha_tc','XX',country,f,country2,c,a)= alpha_tc.l(a,f,c);


};


loop{(country,f,country2,e)$(Prodcountry(f,country) AND Expcountry(e,country2)),
flow(%modrun%,'Trade','Land','Energy',country,f,country2,e,a)= y.l(a,f,e);
flow(%modrun%,'Trade','Land','Mass',country,f,country2,e,a)= y.l(a,f,e)*kfs(f);
flow(%modrun%,'Trade','alpha_te','XX',country,f,country2,e,a)= alpha_te.l(a,f,e);
};

loop{(country,e,country2,sea)$(Expcountry(e,country) AND Conscountry(sea,country2)),
flow(%modrun%,'Trade','Sea','Energy',country,e,country2,sea,a)= z.l(a,e,sea);
flow(%modrun%,'Trade','Sea','Mass',country,e,country2,sea,a)= z.l(a,e,sea)*kes(e);
};

loop{(country,f,country2,c)$(Prodcountry(f,country) And Conscountry(c,country2)),
flow(%modrun%,'Trade','TotalDom','Energy',country,f,country2,c,a)= sum((e)$ExProd(f,e),zzdom(country,e,c,a))+ xxdom(country,f,c,a);
flow(%modrun%,'Trade','TotalDom','Mass',country,f,country2,c,a)= sum((e)$ExProd(f,e),qzdom(country,e,c,a))+ qxdom(country,f,c,a);
};

loop{(country,f,country2,c)$(Prodcountry(f,country) And Conscountry(c,country2)),
flow(%modrun%,'Trade','TotalExp','Energy',country,f,country2,c,a)= sum((e)$ExProd(f,e),zzexp(country,e,c,a))+ xxexp(country,f,c,a);
flow(%modrun%,'Trade','TotalExp','Mass',country,f,country2,c,a)= sum((e)$ExProd(f,e),qzexp(country,e,c,a))+ qxexp(country,f,c,a);
};


flow(%modrun%,'Trade','Total','Energy',country,f,country2,c,a) = flow(%modrun%,'Trade','TotalDom','Energy',country,f,country2,c,a)
                                                                  +flow(%modrun%,'Trade','TotalExp','Energy',country,f,country2,c,a);
flow(%modrun%,'Trade','Total','Mass',country,f,country2,c,a) = flow(%modrun%,'Trade','TotalDom','Mass',country,f,country2,c,a)
                                                                  +flow(%modrun%,'Trade','TotalExp','Mass',country,f,country2,c,a);

********************************************************************************
********** International seaborne report                             ***********
********************************************************************************


report(%modrun%,'Trade','seaborne','Mtpa','World','World',a) = sum((e,sea),z.l(a,e,sea)*kes(e));
report(%modrun%,'Trade','seaborne','Mtpa','World','China',a) = sum(sea$(Conscountry(sea,'CHN')),z.l(a,'E_CHN',sea)*kes('E_CHN'));
report(%modrun%,'Trade','seaborne','Mtpa','World','World',a) = report(%modrun%,'Trade','seaborne','Mtpa','World','World',a) - report(%modrun%,'Trade','seaborne','Mtpa','World','CHN',a);
report(%modrun%,'Trade','seaborne','Mtpa','World',country,a) = sum((e,sea)$((NOT Expcountry(e,country)) AND Conscountry(sea,country)),z.l(a,e,sea)*kes(e));
report(%modrun%,'Trade','seaborne','Mtpa','RoW','RoW',a)         = sum((e,sea),z.l(a,e,sea)*kes(e))
                                                                   -report(%modrun%,'Trade','seaborne','Mtpa','World','IND',a)
                                                                   -report(%modrun%,'Trade','seaborne','Mtpa','World','CHN',a);



