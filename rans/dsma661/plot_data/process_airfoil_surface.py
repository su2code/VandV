import vtk, matplotlib.pyplot as plt, numpy as np, pandas as pd, scienceplots
from scipy.spatial import cKDTree

plt.style.use(['science', 'no-latex'])  # Apply scientific style

def extract_airfoil_surface_data(vtu_file, x_min, y_min, x_max, y_max, output_csv):
    """Extracts airfoil surface points and all flow field data from a VTU file and saves to CSV (unsorted)."""

    reader = vtk.vtkXMLUnstructuredGridReader()
    reader.SetFileName(vtu_file)
    reader.Update()
    unstructured_grid = reader.GetOutput()

    if unstructured_grid.GetNumberOfPoints() == 0:
        raise ValueError("VTU file contains no points! Check the file.")

    #extract surface using GeometryFilter
    surface_filter = vtk.vtkGeometryFilter()
    surface_filter.SetInputData(unstructured_grid)
    surface_filter.Update()
    poly_data = surface_filter.GetOutput()

    # extract airfoil boundary
    feature_edges = vtk.vtkFeatureEdges()
    feature_edges.SetInputData(poly_data)
    feature_edges.BoundaryEdgesOn()
    feature_edges.FeatureEdgesOn()
    feature_edges.ManifoldEdgesOff()
    feature_edges.NonManifoldEdgesOff()
    feature_edges.SetFeatureAngle(30.0)  
    feature_edges.Update()

    boundary_poly_data = feature_edges.GetOutput()

    num_surface_points = boundary_poly_data.GetNumberOfPoints()
    print(f"Extracted surface mesh: {num_surface_points} points.")

    if num_surface_points == 0:
        raise ValueError("Surface extraction failed! The mesh might be purely volumetric.")

    original_points = unstructured_grid.GetPoints()
    original_coords = np.array([original_points.GetPoint(i) for i in range(unstructured_grid.GetNumberOfPoints())])
    kdtree = cKDTree(original_coords)

    # extract airfoil points
    def is_within_range(point):
        x, y, z = point
        return x_min <= x <= x_max and y_min <= y <= y_max and np.isclose(z, 0, atol=1e-3)

    node_ids = []
    coordinates = []
    data_values = {}

    point_data = unstructured_grid.GetPointData()
    for i in range(point_data.GetNumberOfArrays()):
        array_name = point_data.GetArrayName(i)
        array = point_data.GetArray(i)
        num_components = array.GetNumberOfComponents()
        
        if num_components == 1:
            data_values[array_name] = []
        else:
            for c in range(num_components):
                data_values[f"{array_name}_{c}"] = []

    for i in range(num_surface_points):
        point = boundary_poly_data.GetPoint(i)
        if is_within_range(point):
            _, idx = kdtree.query(point)
            node_ids.append(idx)
            coordinates.append((point[0], point[1], point[2]))

            for j in range(point_data.GetNumberOfArrays()):
                array = point_data.GetArray(j)
                num_components = array.GetNumberOfComponents()

                if num_components == 1:
                    data_values[point_data.GetArrayName(j)].append(array.GetTuple1(idx))
                else:
                    for c in range(num_components):
                        data_values[f"{point_data.GetArrayName(j)}_{c}"].append(array.GetTuple(idx)[c])

    print(f"Number of airfoil surface points found: {len(node_ids)}")

    df_data = {
        'x': [coord[0] for coord in coordinates],
        'y': [coord[1] for coord in coordinates],
        'z': [coord[2] for coord in coordinates]
    }
    df_data.update(data_values)

    df = pd.DataFrame(df_data)
    df.to_csv(output_csv, index=False)

    print(f"Saved extracted airfoil data to {output_csv}")

extract_airfoil_surface_data("SU2-ROE_2369_449.vtu", 0.0, -0.1, 1.0, 0.1, "SU2-ROE_2369_449_data.csv")

def process_airfoil_data(input_csv, output_upper_csv, output_lower_csv):
    """Sorts airfoil surface data into upper and lower surfaces and saves to separate CSVs."""

    df = pd.read_csv(input_csv)

    # split  upper (z > 0) and lower (z < 0) surfaces to plot easier
    df_upper = df[df["y"] > 0].sort_values(by=["x"], ascending=True)
    df_lower = df[df["y"] < 0].sort_values(by=["x"], ascending=True)

    df_upper.to_csv(output_upper_csv, index=False)
    df_lower.to_csv(output_lower_csv, index=False)

    print(f"Processed {input_csv} -> {output_upper_csv}, {output_lower_csv}")

process_airfoil_data("SU2-ROE_2369_449_data.csv", "SU2-ROE_upper.csv", "SU2-ROE_lower.csv")


def plot_airfoil_comparison(roe_upper, roe_lower, cfl3d_cp, fun3d_cp, cfl3d_cf, fun3d_cf):
    """Plots Coefficient of Pressure and Skin Friction Coefficient Magnitude for SU2-ROE, SU2-JST, CFL3D, and FUN3D."""

    df_roe_upper = pd.read_csv(roe_upper)
    df_roe_lower = pd.read_csv(roe_lower)

    #skin friction magnitude for SU2 data
    for df in [df_roe_upper, df_roe_lower]:
        df["Skin_Friction_Coefficient_Mag"] = np.sqrt(df["Skin_Friction_Coefficient_0"]**2 + 
                                                      df["Skin_Friction_Coefficient_1"]**2 + 
                                                      df["Skin_Friction_Coefficient_2"]**2)

    #cfl3d & fun3d data
    df_cfl3d_cp = pd.read_csv(cfl3d_cp, delimiter=",")
    df_fun3d_cp = pd.read_csv(fun3d_cp, delimiter=",")
    df_cfl3d_cf = pd.read_csv(cfl3d_cf, delimiter=",")
    df_fun3d_cf = pd.read_csv(fun3d_cf, delimiter=",")

    #pressure coefficient plot
    plt.figure(figsize=(8, 6))
    plt.plot(df_cfl3d_cp["x/c"], df_cfl3d_cp["cp"], 'b-', label="CFL3D")
    plt.plot(df_fun3d_cp["x/c"], df_fun3d_cp["cp"], 'r-', label="FUN3D")
    plt.plot(df_roe_upper["x"], df_roe_upper["Pressure_Coefficient"], 'g-', label="SU2-ROE")
    plt.plot(df_roe_lower["x"], df_roe_lower["Pressure_Coefficient"], 'g-')

    plt.xlabel(r"$x/c$")
    plt.ylabel(r"$C_p$")
    plt.title("Airfoil Surface Pressure Coefficient on Finest Grid")
    plt.legend()
    plt.grid()
    plt.gca().invert_yaxis()
    plt.savefig("comp_pressure_coeff.png", dpi=800)

    #skin friction coefficient plot
    plt.figure(figsize=(8, 6))
    plt.plot(df_cfl3d_cf["x/c"], df_cfl3d_cf["cf"], 'b-', label="CFL3D")
    plt.plot(df_fun3d_cf["x/c"], df_fun3d_cf["cf"], 'r-', label="FUN3D")
    plt.plot(df_roe_upper["x"], df_roe_upper["Skin_Friction_Coefficient_Mag"], 'g-', label="SU2-ROE")
    plt.plot(df_roe_lower["x"], df_roe_lower["Skin_Friction_Coefficient_Mag"], 'g-')

    plt.xlabel(r"$x/c$")
    plt.ylabel(r"$C_f$")
    plt.title("Airfoil Surface Skin Friction Coefficient Magnitude on Finest Grid ")
    plt.legend()
    plt.grid()
    plt.savefig("comp_skinfric_coeff.png", dpi=800)

plot_airfoil_comparison(
    "SU2-ROE_upper.csv", "SU2-ROE_lower.csv",
    "CFL3D_cp.csv", "FUN3D_cp.csv",
    "CFL3D_cf.csv", "FUN3D_cf.csv"
)

