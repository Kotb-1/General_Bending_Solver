# General_Bending_Solver
The code receives loads and supports of both planes as input; then, it solves the system and generates plots for shear force, bending moment, and beam deflection.


Main_Script.m is what you'll be editing.

You Only need to change 

Is, defined supports, defined loads.

To define loads USE:

rec(INPUTs)     for rectangular loads

n_tri(INPUTs)   for normal triangle

rev_tri(INPUTs) for reversed triangle

trap(INPUTs)    for trapezoid loads

con_f(INPUTs)   for concentrated forces

con_m(INPUTs)   for concentrated moments

To define supports CALL:

fixed(INPUTs)  for fixed supports

simple(INPUTs) for simple supports

roller(INPUTs) for roller supports

"#" indicates a variable that's explained in the help of its relevant function

Instructions
1- Define the number of planes of loadings in the variable n_planes.

2- You can either define Is# or don't pass it as input for Structure_Project function.

3- If number of planes is 2, you should define Is for correct deflection plots.

4- You must define the beam length to be symbolic Ex."3*L".

5- Use initial_plot function to get all required axes as an output.

6- Define the supports and loads in both planes.

7- Pay attention to the supports index; it has to increase by 1 after each support declaration.

8- org must be an input to the distributed loads, and it must be true.

9- Define a cell array "Constraints" that holds all the defined supports.

10- Define another cell array "loads" that holds all defined loads.

11- Use the attached method in Main_Script to get the variable "fixed_index".

12- Call Structure_Project function to solve for Mx, My, Sx, Sy, v, u, and unknown reactions.

13- Call final_plots to get the needed plots.
