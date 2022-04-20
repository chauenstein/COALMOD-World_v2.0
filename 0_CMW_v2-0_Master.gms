$title COALMOD-World version 2.0 (April 2022)
$eolcom #
$onempty

********************************************************************************
*************** How to use *****************************************************
********************************************************************************
*All scenario specifications should be made in the scenario file, only!
*Also including the specifications for Tax Scenarios



********************************************************************************
*************** Setting to be set before model run *****************************
********************************************************************************


*include the name of the set file specifying the geographical coverage and the time horizon
$setglobal set_specs 1_CMW_v2-0_Sets


*include the name of the data input file excluding .xlsx
$setglobal input_data    Input_data_v2-0_BY2015_high_demand

*Specify the purpose of the run. Choose between calibration, normal_use

$setglobal purpose      normal_use

*calibration

********************************************************************************
*************** No modifications below this point!!!****************************
*************** Please go to Scenario file 4_CMW_v2-0_Scenario.gms *************
********************************************************************************


********************************************************************************
*************** Basic Model ****************************************************
********************************************************************************

*** Include Sets ***   choose the basic coverage in terms of regional and time coverage
$Include %set_specs%


*** Include basic Parameters - Load from Excel input file ***
$batinclude 2_CMW_v2-0_Parameters_Data.gms  %input_data%


*** Include basic Variables ***
$Include 3_CMW_v2-0_Variables.gms

*** Include Scenario ***
$Include Calibration/4_CMW_v2-0_Scenario_calibration.gms

*** Include basic Equations ***
$Include 5_CMW_v2-0_Equations.gms


*** execute basic Model ***
$batinclude Calibration/6_CMW_v2-0_MCP_calibration.gms  %purpose%



$iftheni.purpose %purpose% == normal_use
********************************************************************************
************** Scenario runs ***************************************************
********************************************************************************
$Include 4_CMW_v2-0_Scenario.gms
*** Include basic Equations ***




********************************************************************************
*************** Generate Output ************************************************
********************************************************************************
$include 7-2_CMW_v2-0_Generate_Excel_Output.gms
$include 7-3_CMW_v2-0_Generate_ECT_Output.gms

$endif.purpose




