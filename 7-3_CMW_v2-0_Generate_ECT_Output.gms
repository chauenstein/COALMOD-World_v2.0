***** Output ECT Generation *****
execute_unload "Report_ECT.gdx"  timestamp, report_ECT, flow_ECT;
execute 'gdxxrw.exe i=Report_ECT.gdx UpdLinks =3 o=Output/Output_CMW_ECT_v2-0.xlsx @export_ECT_xls.txt';
