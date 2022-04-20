*******************************Sets*********************************************


********************************************************************************
**********************Sets - Years**********************************************
********************************************************************************

Sets
         a years
         /2015,2020,2025,2030,2035,2040,2045,2050,2055,2060
         /

         as(a) starting year
         /2015/

         ad(a) dynamic years
         /2020, 2025,2030,2035,2040,2045,2050,2055,2060
         /;

Set fix(a);
fix(a)=no;


Parameter year(a) /

2015     2015
2020     2020
2025     2025
2030     2030
2035     2035
2040     2040
2045     2045
2050     2050
2055     2055
2060     2060 /         ;



Parameter plength              period length;
          plength = 5;


********************************************************************************
**********************Sets - Nodes & Countries**********************************
********************************************************************************

Sets
         f producers
         /
          P_AUS_QLD,P_AUS_NSW, P_AUS_GAL
          P_IDN
          P_CHN_SIS
          P_MOZ
          P_CHN_Northeast, P_CHN_HSA
          P_CHN_YG
          P_USA_PRB,P_USA_Rocky
          P_USA_ILL
          P_USA_APP
          P_COL
          P_POL
          P_KAZ
          P_RUS
          P_ZAF
          P_IND_North
          P_IND_Orissa
          P_IND_West,P_IND_South
          P_MNG
         /

         e exporters
         /
          E_AUS_QLD,E_AUS_NSW, E_AUS_AP
          E_IDN
          E_CHN
          E_MOZ
          E_USA_PRB_W, E_USA_PRB_SC, E_USA_PRB_SE
          E_USA_Rocky_W, E_USA_Rocky_SC, E_USA_Rocky_SE
          E_USA_ILL_SC, E_USA_ILL_SE
          E_USA_APP_SC, E_USA_APP_SE
          E_COL
          E_POL
          E_Black_Sea_RUS
          E_RUS_West,E_RUS_East
          E_ZAF
         /

         NoChina_exp(e) all exporters except CHN
         /
          E_AUS_QLD,E_AUS_NSW, E_AUS_AP
          E_IDN
          E_MOZ
          E_USA_PRB_W, E_USA_PRB_SC, E_USA_PRB_SE
          E_USA_Rocky_W, E_USA_Rocky_SC, E_USA_Rocky_SE
          E_USA_ILL_SC, E_USA_ILL_SE
          E_USA_APP_SC, E_USA_APP_SE
          E_COL,
          E_POL
          E_Black_Sea_RUS,
          E_RUS_West,E_RUS_East
          E_ZAF
         /

         c consumers
         /
          C_VNM
          C_BD
          C_PK

          C_MEX
          C_BRA
          C_CHL

          C_AUS
          C_IDN
          C_CHN_Northeast, C_CHN_Main
          C_CHN_SIS
          C_USA_W, C_USA_NC, C_USA_SC, C_USA_NE
          C_CAN
          C_POL
          C_KAZ
          C_RUS_Siberia,C_RUS_Central
          C_ZAF
          C_IND_East,C_IND_North
          C_USA_SE
          C_CHN_Eastern
          C_CHN_South
          C_MAR
          C_PRT,C_ESP,C_GBR,C_NFB,C_DEU,C_DNK,C_FIN,C_ITA
          C_TUR,C_ISR
          C_IND_West,C_IND_South
          C_THA,C_MYS
          C_KOR,C_JPN
          C_TWN,C_PHL
         /

         sea(c) consumers with port
         /
          C_VNM
          C_BD
          C_PK

          C_MEX
          C_BRA
          C_CHL

          C_USA_SE
          C_CHN_Eastern,C_CHN_South
          C_MAR
          C_PRT,C_ESP,C_GBR,C_NFB,C_DEU,C_DNK,C_FIN,C_ITA
          C_TUR,C_ISR
          C_IND_West,C_IND_South
          C_THA,C_MYS
          C_KOR,C_JPN
          C_TWN,C_PHL
         /

         land(c) consumers only reachable by land
         /
          C_AUS
          C_IDN
          C_CHN_SIS
          C_CHN_Northeast,C_CHN_Main
          C_USA_W, C_USA_NC, C_USA_SC, C_USA_NE
          C_CAN
          C_POL
          C_KAZ
          C_RUS_Siberia,C_RUS_Central
          C_ZAF
          C_IND_East,C_IND_North
         /

         NoChina(sea) all seaports except China
         /
          C_VNM
          C_BD
          C_PK

          C_MEX
          C_BRA
          C_CHL

          C_USA_SE
          C_MAR
          C_PRT,C_ESP,C_GBR,C_NFB,C_DEU,C_DNK,C_FIN,C_ITA
          C_TUR,C_ISR
          C_IND_West,C_IND_South
          C_THA,C_MYS
          C_KOR,C_JPN
          C_TWN,C_PHL
         /

         China_sea(sea) all Chinese seaports
         /
         C_CHN_Eastern,C_CHN_South
         /
;

Alias (a,aa) ;
Alias (c,cc) ;
Alias (e,ee) ;


*** Countries and Mappings ***

Set country           Countries
          /
            AUS
            BD
            BRA
            CAN
            CHL
            CHN
            COL
            DEU
            DNK
            ESP
            FIN
            GBR
            IDN
            IND
            ISR
            ITA
            JPN
            KAZ
            KOR
            MAR
            MEX
            MNG
            MOZ
            MYS
            NFB
            PHL
            PK
            POL
            PRT
            RUS
            THA
            TUR
            TWN
            USA
            VNM
            ZAF
          /;

alias(country,country2);



Parameter Prodcountry(f,country)  Producer Country Mapping
          /
           P_IDN.IDN            1
           P_CHN_SIS.CHN        1
           P_MOZ.MOZ            1
           P_CHN_Northeast.CHN  1
           P_CHN_HSA.CHN        1
           P_CHN_YG.CHN         1
           P_USA_PRB.USA        1
           P_USA_Rocky.USA      1
           P_USA_ILL.USA        1
           P_USA_APP.USA        1
           P_COL.COL            1
           P_POL.POL            1
           P_KAZ.KAZ            1
           P_RUS.RUS            1
           P_ZAF.ZAF            1
           P_IND_North.IND      1
           P_IND_Orissa.IND     1
           P_IND_West.IND       1
           P_IND_South.IND      1
           P_AUS_QLD.AUS        1
           P_AUS_NSW.AUS        1
           P_AUS_GAL.AUS        1
           P_MNG.MNG            1
          /;

Parameter Expcountry(e,country)   Exporter Country Mapping
          /
           E_IDN.IDN            1
           E_CHN.CHN            1
           E_MOZ.MOZ            1
           E_USA_PRB_W.USA      1
           E_USA_PRB_SC.USA     1
           E_USA_PRB_SE.USA     1
           E_USA_Rocky_W.USA    1
           E_USA_Rocky_SC.USA   1
           E_USA_Rocky_SE.USA   1
           E_USA_ILL_SC.USA     1
           E_USA_ILL_SE.USA     1
           E_USA_APP_SC.USA     1
           E_USA_APP_SE.USA     1
           E_COL.COL            1
           E_POL.POL            1
           E_Black_Sea_RUS.RUS  1
           E_RUS_West.RUS       1
           E_RUS_East.RUS       1
           E_ZAF.ZAF            1
           E_AUS_QLD.AUS        1
           E_AUS_NSW.AUS        1
           E_AUS_AP.AUS         1
          /;


Parameter Conscountry(c,country)  Consumer Country Mapping
          /
           C_VNM.VNM            1
           C_BD.BD              1
           C_PK.PK              1

           C_MEX.MEX            1
           C_BRA.BRA            1
           C_CHL.CHL            1

           C_IDN.IDN            1
           C_CHN_Northeast.CHN  1
           C_CHN_Main.CHN       1
           C_CHN_SIS.CHN        1
           C_USA_W.USA          1
           C_USA_NC.USA         1
           C_USA_SC.USA         1
           C_USA_NE.USA         1
           C_CAN.CAN            1
           C_POL.POL            1
           C_KAZ.KAZ            1
           C_RUS_Siberia.RUS    1
           C_RUS_Central.RUS    1
           C_ZAF.ZAF            1
           C_IND_East.IND       1
           C_IND_North.IND      1
           C_AUS.AUS            1
           C_USA_SE.USA         1
           C_CHN_Eastern.CHN    1
           C_CHN_South.CHN      1
           C_MAR.MAR            1
           C_PRT.PRT            1
           C_ESP.ESP            1
           C_GBR.GBR            1
           C_NFB.NFB            1
           C_DEU.DEU            1
           C_DNK.DNK            1
           C_FIN.FIN            1
           C_ITA.ITA            1
           C_TUR.TUR            1
           C_ISR.ISR            1
           C_IND_West.IND       1
           C_IND_South.IND      1
           C_THA.THA            1
           C_MYS.MYS            1
           C_KOR.KOR            1
           C_JPN.JPN            1
           C_TWN.TWN            1
           C_PHL.PHL            1
          /;



*** Chinese maximum annual import quota and export restrictions ***

*Chinese import quota in Mt
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

*high dummy value --> constraint not binding (China turned from net coal exporter to importer)
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