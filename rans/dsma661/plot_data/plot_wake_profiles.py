import os, shutil, vtk, numpy as np, csv, pandas as pd, matplotlib.pyplot as plt, scienceplots

plt.style.use(['science', 'no-latex'])

solvers = ["SU2-ROE"]
meshes = ["149_29", "297_57", "593_113", "1185_225", "2369_449"]
x_values = [1.01, 1.05, 1.20, 1.40, 1.80, 2.19, 3.00]
resolution = 1000

def setup_folders():
    """Create mesh folders and copy corresponding VTU files."""
    for mesh in meshes:
        folder = f"wake_profile_{mesh}"
        os.makedirs(folder, exist_ok=True)
        
        for solver in solvers:
            vtu_filename = f"{solver}_{mesh}.vtu"
            if os.path.exists(vtu_filename):
                print(f"{solver}-{mesh}.vtu exists")
                shutil.copy(vtu_filename, folder)
            else:
                print(f"{solver}-{mesh}.vtu does not exist")


def extract_line_data(vtu_filepath, x_values, output_template, resolution=1000):
    """Extract wake profile data from VTU file."""
    reader = vtk.vtkXMLUnstructuredGridReader()
    reader.SetFileName(vtu_filepath)
    reader.Update()
    data = reader.GetOutput()

    for x in x_values:
        line_source = vtk.vtkLineSource()
        line_source.SetPoint1(x, -0.15, 0)
        line_source.SetPoint2(x, 0.15, 0)
        line_source.SetResolution(resolution)
        line_source.Update()

        probe = vtk.vtkProbeFilter()
        probe.SetInputConnection(line_source.GetOutputPort())
        probe.SetSourceData(data)
        probe.Update()

        interpolated_data = probe.GetOutput()
        num_points = interpolated_data.GetNumberOfPoints()
        
        array_names = []
        processed_arrays = []
        
        for i in range(interpolated_data.GetPointData().GetNumberOfArrays()):
            array = interpolated_data.GetPointData().GetArray(i)
            name = interpolated_data.GetPointData().GetArrayName(i)
            num_components = array.GetNumberOfComponents()
            
            if num_components == 1:
                array_names.append(name)
                processed_arrays.append((name, array))
            else:
                for j in range(num_components):
                    array_names.append(f"{name}_{j}")
                processed_arrays.append((name, array))
        
        csv_filename = output_template.format(value=x)
        with open(csv_filename, mode='w', newline='') as file:
            writer = csv.writer(file)
            writer.writerow(["x", "y", "z"] + array_names)
            
            for i in range(num_points):
                point = interpolated_data.GetPoint(i)
                row = list(point)
                for name, array in processed_arrays:
                    num_components = array.GetNumberOfComponents()
                    if num_components == 1:
                        row.append(array.GetTuple1(i))
                    else:
                        row.extend(array.GetTuple(i))
                writer.writerow(row)

def compile_su2_data(folder, solver, x_values, final_output):
    """Compile extracted wake profile data into a single CSV file."""
    su2_data = {}
    
    for idx, x in enumerate(x_values, start=1):
        csv_filename = os.path.join(folder, f"{solver}_x_{x}_data.csv")
        
        with open(csv_filename, mode='r') as file:
            reader = csv.DictReader(file)
            y_values = []
            velocity_values = []
            
            for row in reader:
                y_values.append(float(row["y"]))
                velocity_values.append(float(row["Velocity_0"]))
            
            su2_data[f"Y_{idx}"] = y_values
            su2_data[f"X_{idx}"] = velocity_values
    
    max_length = max(len(v) for v in su2_data.values())
    
    with open(final_output, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(su2_data.keys())
        
        for i in range(max_length):
            row = [su2_data[key][i] if i < len(su2_data[key]) else '' for key in su2_data.keys()]
            writer.writerow(row)

def process_all_meshes():
    """Process all meshes: extract data and compile CSVs."""
    for mesh in meshes:
        folder = f"wake_profile_{mesh}"
        for solver in solvers:
            vtu_filepath = os.path.join(folder, f"{solver}_{mesh}.vtu")
            if os.path.exists(vtu_filepath):
                output_template = os.path.join(folder, f"{solver}_x_{{value}}_data.csv")
                final_output = os.path.join(folder, f"{solver}_{mesh}_data.csv")
                extract_line_data(vtu_filepath, x_values, output_template, resolution)
                compile_su2_data(folder, solver, x_values, final_output)

def plot_wake_profiles():
    """Generate and save wake profile plots for all meshes in the correct order."""
    experimental_data = "experimental_data.csv"
    cfl3d_data = "cfl3d_data.csv"
    fun3d_data = "fun3d_data.csv"
    experimental_norm = 24
    su2_norm = 30.5552677

    #plotting order
    plot_order = ["EXPERIMENTAL", "CFL3D (finest grid)", "FUN3D (finest grid)", "SU2-ROE"]
    colors = {
        "EXPERIMENTAL": "black",
        "CFL3D (finest grid)": "blue",
        "FUN3D (finest grid)": "red",
        "SU2-ROE": "green",
    }
    markers = {
        "EXPERIMENTAL": "+",
    }

    for mesh in meshes:
        folder = f"wake_profile_{mesh}"

        #Load data
        solvers_data = {solver: pd.read_csv(os.path.join(folder, f"{solver}_{mesh}_data.csv")) for solver in solvers}
        solvers_data["EXPERIMENTAL"] = pd.read_csv(experimental_data)
        solvers_data["CFL3D (finest grid)"] = pd.read_csv(cfl3d_data)
        solvers_data["FUN3D (finest grid)"] = pd.read_csv(fun3d_data)

        for i, x in enumerate(x_values, start=1):
            plt.figure(figsize=(8, 6))

            for solver in plot_order:
                if solver in solvers_data:
                    df = solvers_data[solver]
                    y_column, x_column = f"Y_{i}", f"X_{i}"

                    if y_column in df and x_column in df:
                        y_data = df[y_column].dropna()
                        x_data = df[x_column].dropna()

                        #normalise data
                        if solver == "EXPERIMENTAL":
                            y_data /= experimental_norm
                        elif solver in ["SU2-ROE"]:
                            x_data /= su2_norm

                        #scatter for experimental and lines for cfd
                        if solver == "EXPERIMENTAL":
                            plt.scatter(x_data, y_data, label=solver, marker=markers.get(solver, "o"), color=colors[solver])
                        else:
                            plt.plot(x_data, y_data, label=solver, color=colors[solver])

            plt.xlabel(r"$u/U_{\infty}$")
            plt.ylabel(r"$y/c$")
            plt.ylim(-0.125, 0.125)
            plt.title(rf"Wake Profile at $x/c = {x}$ for {mesh.replace("_", r"$\times$")} mesh")            
            plt.legend()
            plt.savefig(os.path.join(folder, f"wake_profile_{mesh}_x_{i}.png"), dpi=800)
            plt.close()

def extract_min_velocity():
    """Extract minimum u/U_infty for each x location and store in a CSV file."""
    
    su2_roe_output = "su2_roe_minvel.csv" #output naem
    
    #fixed columns
    mesh_info = [
        (1060864, 0.00097089, "2369x449"),
        (265216, 0.00194178, "1185x225"),
        (66304, 0.00388356, "593x113"),
        (16576, 0.00776712, "297x57"),
        (4144, 0.0155342, "149x29"),
    ]

    results = {
        "SU2-ROE": []
    }

    for (N, sqrt_inv_N, mesh) in mesh_info:
        folder_mesh_format = mesh.replace("x", "_")  #convert folder format: "149x29" → "149_29"
        folder = f"wake_profile_{folder_mesh_format}"

        row_roe = [N, sqrt_inv_N, mesh]  

        for i, x in enumerate(x_values, start=1):
            roe_file = os.path.join(folder, f"SU2-ROE_{folder_mesh_format}_data.csv")

            min_roe = None

            if os.path.exists(roe_file):
                df_roe = pd.read_csv(roe_file)
                x_column = f"X_{i}"
                if x_column in df_roe:
                    min_roe = df_roe[x_column].min() / 30.5552677  # normalise vel using freestream

            row_roe.append(min_roe if min_roe is not None else "")

        results["SU2-ROE"].append(row_roe)

    #aave as CSV files
    header = ["N", "sqrt(1/N)", "Mesh"] + [f"x{i}" for i in range(1, len(x_values) + 1)]

    for solver, output_file in zip(["SU2-ROE"], [su2_roe_output]):
        with open(output_file, mode='w', newline='') as file:
            writer = csv.writer(file)
            writer.writerow(header)
            writer.writerows(results[solver])

    print(f"Minimum velocity data saved: {su2_roe_output}")

def plot_min_velocity_convergence():
    """Plot the minimum velocity convergence for each x/c location."""
    
    solvers = {
        "CFL3D": {"file": "cfl3d_minvel.csv", "color": "blue", "marker": "s", "label": "CFL3D"},
        "FUN3D": {"file": "fun3d_minvel.csv", "color": "red", "marker": "^", "label": "FUN3D"},
        "SU2-ROE": {"file": "su2_roe_minvel.csv", "color": "green", "marker": "x", "label": "SU2-ROE"},
    }
    
    data = {}
    for solver, info in solvers.items():
        df = pd.read_csv(info["file"], delimiter=',')
        df.columns = df.columns.str.strip()
        data[solver] = df
    
    #create plots for each x/c location
    for i, x in enumerate(x_values, start=1):
        plt.figure(figsize=(6, 4))  
        
        for solver, info in solvers.items():
            df = data[solver]
            x_column = f"x{i}"
            
            if x_column in df:
                x_axis = df["sqrt(1/N)"]
                y_axis = df[x_column]
                mesh_values = df["Mesh"]
                
                plt.plot(x_axis, y_axis, marker=info["marker"], color=info["color"], linestyle='-', 
                         markerfacecolor='none', label=info["label"])

                
        plt.xlabel(r"$h = \sqrt{1/N}$")  # X-axis: h=sqrt(1/N)
        plt.ylabel(r"$\min(u/U_{\infty})$")  # Y-axis: min velocity
        plt.title(rf"$x/c = {x}$") 
        plt.grid(True)
        plt.legend(loc='best')  
        
        # Save the plot
        plt.tight_layout()
        plt.savefig(f"min_velocity_convergence_x_{i}.png", dpi=800)
        plt.close()  
    
    print("Min velocity convergence plots saved.")

def main():
    setup_folders()
    process_all_meshes()
    plot_wake_profiles()
    extract_min_velocity()
    plot_min_velocity_convergence()

if __name__ == "__main__":
    main()
