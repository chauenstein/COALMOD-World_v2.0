********************************************************************************
*************** Scenario Assumptions *******************************************
********************************************************************************

*Scenario variation set (set number of scenarios to be run)
Set stepM /1*1/;

********************************************************************************
**********************  Scenario data ***************************************
********************************************************************************


*useful parameter to store initial value and allow parameter variation
parameter
store1(*,*)
store2(*,*,*)
store3(*,*,*);




*start year of treatment shock
tsyear=2020;

*fix all values before shock to prohibit anticipation
fix(a)$(a.val<tsyear)=yes;


*** LOOP ***
$include 6_CMW_v2-0_MCP.gms
loop(stepM,
$Setglobal modrun stepM


$ontext$
if (stepM.val=2,

execute "gdxxrw.exe Input_Data/Input_data_v2-0_BY2015_moderate_decline.xlsx UpdLinks =3 o=input_data.gdx  @Input_data.txt"

execute_load   "input_data.gdx"   p_ref, y_ref, epsi     ;

b(a,c)        =  (1/epsi(c,a))*(p_ref(c,a)/y_ref(c,a));
DemInter(a,c) =  p_ref(c,a)*(1-1/epsi(c,a));
);

if (stepM.val=3,

execute "gdxxrw.exe Input_Data/Input_data_v2-0_BY2015_1-5degC.xlsx UpdLinks =3 o=input_data.gdx  @Input_data.txt"

execute_load   "input_data.gdx"   p_ref, y_ref, epsi     ;

b(a,c)        =  (1/epsi(c,a))*(p_ref(c,a)/y_ref(c,a));
DemInter(a,c) =  p_ref(c,a)*(1-1/epsi(c,a));
);
$offtext$



solve COALMOD_World_MCP_scenario using mcp;





* Output with report collection *
$batinclude 7-1_CMW2s_v2-0_output_report.gms

);



