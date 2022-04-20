***** Output Generation *****
execute_unload "Report.gdx"  timestamp, report, flow;
execute 'gdxxrw.exe i=Report.gdx UpdLinks =3 o=Output/Output_CMW_v2-0.xlsx @export_xls.txt';
