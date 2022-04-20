# COALMOD-World Version 2.0
This repository contains all files necessary to run COALMOD-World Version 2.0 (CMW_v2.0). CMW_v2.0 is based on [Holz et al. (2016)](https://www.diw.de/documents/publikationen/73/diw_01.c.546364.de/diw_datadoc_2016-085.pdf). The changes compared to [COALMOD-World Version 1.0](https://www.diw.de/de/diw_01.c.599753.de/modelle.html#c_599799) are introduced in [Hauenstein (pre-print)]().


## How to run COALMOD-World Version 2.0

### Install GAMS

1. Choose the GAMS version depending on your system: https://www.gams.com/download/
2. Follow the steps of installation wizard.

*Note: A GAMS licens is required.*

### Set up a framework environment

1. Create a directory with the __project name__ in any convenient location.
2. Download the model from [GitHub](https://github.com/chauenstein/COALMOD-World_v2-0) by either:
	- cloning the COALMOD-World_v2-0 GitHub repository, or
	- downloading the zip file and extracting all to the previously created project directory.
	
### Open a model in GAMS

1. Open the main folder and create a new text file:
	- name it e.g. as the scenario and
	- change the __file extension__ from __txt__ to __gpr__ (GAMS project file).
2. Open the .gpr file: This will start the GAMS IDE.
3. After the GAMS startup open the 0_CMW_v2-0_Master.gms file.

### Run the model

Run the model by simply pressing __F9__.

### Access results

The result files are placed in the model folder under:
	- __/output/__.

### Scenario data

This repository contains exemplary the input data file for the "High_demand" scenario.

Further scenario data is published here: https://zenodo.org/communities/coalmod-world
