# Karman Vortex Street Simulation

### Numerical approximation of critical Reynolds number
Computaitonal analysis of the critical Reynolds number for a Karman vortex street.

Project done for my Fluid Mechanics course at ESPCI Paris under supervision from Prof. Marc Fermigier

### Requirements

FreeFem++: download at ```https://freefem.org/```

FreeFem++ is a an open-source programming language and a software focused on solving partial differential equations using the finite element method. FreeFem++ is written in C++ and developed and maintained by Université Pierre et Marie Curie and Laboratoire Jacques-Louis Lions.

### Run

clone git repo: ```$ git clone https://github.com/jgbrasier/karman-vortex-street```

go to project dir: ``` cd /path/to/dir```

launch simulation in prompt: ``` FreeFem++ BVK_simple_2019.edp``` and follow instructions in prompt.

### Tips:

When launching: 

``` Raffinement automatique du maillage pendant le calcul? (o/n): ``` recomment you put in ```n``` (no), otherwise compute times will be too long (several hours)

``` Entrer le nombre de Reynolds: ``` input reynolds number (around 0-1000 for current configurations, modifiable in FreeFem++)

``` Entrer le nombre d'itérations: ``` input number of interations (1000+ for Reynolds < 1000)

### Outputs:

Program outputs a series of .vtk (visual tool kit) files every t=10 (adimentional time frame)

### MATLAB analysis:

__main.m___: Main file to extract and display computed data.

__session_variables.mat__: MATLAB variables to load in if you do not wish to run computations

### Visualisation:
You can visualise the Von Karman Vortex with any program that reads .vtk files, I used __Paraview-5.8.0__.
![Vortex](Captures/Re100_courant.png)

### Final Report:
You are free to read my report. It is in french ^^
