// Shock Boundary Layer Interaction
//
// Mesh sizing factor, the higher 'f', the finer the mesh.
// L1 f=1, L2 f=1.41, L3 f=2
f = 1.41;
//
// Params for the boundary layer (bl) mesh region along the top and bottom plates.
// Size of the regions (*_h), and either number of points (n_*) or spacing (h_*) on the curves.
// Points are concentrated in the region where shock-induced separation is expected (*_sh).
bl_h_1 = 0.0025;
n_bl_1 = 50*f+1;
n_sh = 160*f+1;
n_in = 60*f+1;
n_out = 64*f+1;
rate_1 = 1.1 ^ (1.0/f);
//
bl_h_2 = 0.008;
n_bl_2 = 31*f+1;
h_top = 0.004/f;
rate_2 = 1.25 ^ (1.0/f);
//
// Bottom
Point(1) = {-0.01, 0, 0, h_top / 1.5};
Point(19) = {0, 0, 0, h_top / 1.5};
Point(2) = {0.16544, 0, 0, h_top / 1.5};
Point(3) = {0.31844, 0, 0, h_top / 5};
Point(4) = {0.37, 0, 0, h_top / 5};
Point(5) = {0.523, 0, 0, h_top};
//
Point(6) = {-0.01, 3.5 * bl_h_1, 0, h_top / 1.5};
Point(21) = {0, 3.5 * bl_h_1, 0, h_top / 1.5};
Point(7) = {0.16544, 2.25 * bl_h_1, 0, h_top / 1.5};
Point(8) = {0.31844, bl_h_1, 0, h_top / 5};
Point(9) = {0.37, bl_h_1, 0, h_top / 5};
Point(10) = {0.523, bl_h_1, 0, h_top};
//
// Horizontal lines making up the bottom surface.
Line(1) = {1, 19};
Line(22) = {19, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 5};
//
Line(5) = {5, 10};
//
// Horizontal construction lines to define the inflation layer.
Line(6) = {10, 9};
Line(7) = {9, 8};
Line(8) = {8, 7};
Line(23) = {7, 21};
Line(9) = {21, 6};
//
Line(10) = {6, 1};
//
// Define the transfinite curves and surface for the bottom inflation layer.
Curve Loop(1) = {9, 10, 1, 22, 2, 3, 4, 5, 6, 7, 8, 23};
Plane Surface(1) = {1};
Transfinite Curve {3, -7} = n_sh Using Bump 6;
Transfinite Curve {-10, 5} = n_bl_1 Using Progression rate_1;
Transfinite Surface {1} = {1, 5, 10, 6};
//
// Top, same steps as bottom.
Point(11) = {-0.01, 0.115, 0, h_top};
Point(12) = {0.023, 0.115, 0, h_top / 4};
Point(13) = {0.31844, 0.062906, 0, h_top};
Point(14) = {0.523, 0.062906, 0, h_top};
//
Point(15) = {-0.01, 0.115 - bl_h_2, 0, h_top};
Point(16) = {0.023, 0.115 - bl_h_2, 0, h_top / 4};
Point(17) = {0.31844, 0.062906 - bl_h_2, 0, h_top};
Point(18) = {0.523, 0.062906 - bl_h_2, 0, h_top};
//
Line(11) = {15, 16};
Line(12) = {16, 17};
Line(13) = {17, 18};
//
Line(14) = {18, 14};
//
Line(15) = {14, 13};
Line(16) = {13, 12};
Line(17) = {12, 11};
//
Line(18) = {11, 15};
//
Curve Loop(2) = {11, 12, 13, 14, 15, 16, 17, 18};
Plane Surface(2) = {2};
Transfinite Curve {-16, 12} = 1.5*0.3 / h_top Using Progression (1.015 ^ (1/f));
Transfinite Curve {18, -14} = n_bl_2 Using Progression rate_2;
Transfinite Surface {2} = {15, 18, 14, 11};
//
// Interior part between inflation layers.
Line(19) = {6, 15};
Line(20) = {10, 18};
Curve Loop(3) = {19, 11, 12, 13, -20, 6, 7, 8, 23, 9};
Plane Surface(3) = {3};
Transfinite Curve {19} = (0.115-bl_h_1-bl_h_2) / h_top Using Bump 0.25;
//
// Refinement around the main shock.
Point(20) = {0.34, 0, 0, h_top / 5};
Line(21) = {12, 20};
Field[1] = Distance;
Field[1].CurvesList = {21};
Field[1].Sampling = 100;
Field[2] = Threshold;
Field[2].InField = 1;
Field[2].SizeMin = h_top / 5;
Field[2].SizeMax = h_top;
Field[2].DistMin = 0.75 * h_top * f;
Field[2].DistMax = 2 * h_top * f;
Background Field = 2;
//
Recombine Surface {1, 2, 3};
//
Physical Curve("bottom") = {22, 2, 3, 4};
Physical Curve("inlet") = {10, 19, 18};
Physical Curve("outlet") = {5, 20, 14};
Physical Curve("top") = {16, 15};
Physical Curve("sym") = {17, 1};
Physical Surface("fluid", 22) = {2, 3, 1};

