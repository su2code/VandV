import matplotlib.pyplot as plt
import pandas as pd
import scienceplots

plt.style.use(['science', 'no-latex'])

# solvers to plot
solvers = {
    "CFL3D": {"file": "cfl3d_forces.csv", "color": "blue", "marker": "s", "label": "CFL3D, SST"},
    "FUN3D": {"file": "fun3d_forces.csv", "color": "red", "marker": "^", "label": "FUN3D, SST"},
    "SU2-ROE": {"file": "SU2-ROE_forces.csv", "color": "green", "marker": "x", "label": "SU2-ROE"},
}

# columns to plot
forces = ["Cl", "Cd", "Cdp", "Cdv"]
latex_labels = {
    "Cl": r"$C_L$",
    "Cd": r"$C_D$",
    "Cdp": r"$C_{D,p}$",
    "Cdv": r"$C_{D,v}$"
}
chart_titles = {
    "Cl": "Lift force grid convergence ",
    "Cd": "Drag force grid convergence",
    "Cdp": "Pressure Drag force grid convergence",
    "Cdv": "Viscous Drag force grid convergence"
}
# Read data from CSV files
data = {}
for solver, info in solvers.items():
    df = pd.read_csv(info["file"], delimiter=',')
    df.columns = df.columns.str.strip()
    data[solver] = df

for force in forces:
    plt.figure(figsize=(6, 4))  # Set figure size
    for solver, info in solvers.items():
        df = data[solver]
        x = df["sqrt(1/N)"]
        y = df[force]
        mesh_values = df["Mesh"]
        
        plt.plot(x, y, marker=info["marker"], color=info["color"], linestyle='-', markerfacecolor='none', label=info["label"])

    plt.xlabel(r"$h = \sqrt{1/N}$")  
    plt.ylabel(latex_labels[force])
    plt.title(chart_titles[force])
    plt.grid(True)
    plt.legend(loc='best')

    # Save the plot
    plt.tight_layout()
    plt.savefig(f"force_comparison_{force}.png", dpi=800)
    plt.close() 


