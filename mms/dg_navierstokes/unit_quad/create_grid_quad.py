#!/usr/bin/python

## \file square.py
#  \brief Python script for creating a .su2 mesh of a simple square domain
#         composed out of quadrilateral elements of certain polynomial degree.
#  \author Thomas D. Economon, Edwin van der Weide
#  \version 6.2.0 "Falcon"
#
# The current SU2 release has been coordinated by the
# SU2 International Developers Society <www.su2devsociety.org>
# with selected contributions from the open-source community.
#
# The main research teams contributing to the current release are:
#  - Prof. Juan J. Alonso's group at Stanford University.
#  - Prof. Piero Colonna's group at Delft University of Technology.
#  - Prof. Nicolas R. Gauger's group at Kaiserslautern University of Technology.
#  - Prof. Alberto Guardone's group at Polytechnic University of Milan.
#  - Prof. Rafael Palacios' group at Imperial College London.
#  - Prof. Vincent Terrapon's group at the University of Liege.
#  - Prof. Edwin van der Weide's group at the University of Twente.
#  - Lab. of New Concepts in Aeronautics at Tech. Institute of Aeronautics.
#
# Copyright 2012-2019, Francisco D. Palacios, Thomas D. Economon,
#                      Tim Albring, and the SU2 contributors.
#
# SU2 is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# SU2 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with SU2. If not, see <http://www.gnu.org/licenses/>.


# Import the option parser and parse input options
from optparse import OptionParser

parser=OptionParser()
parser.add_option("-f", "--file", dest="filename", default="square.su2",
                  help="write mesh to FILE", metavar="FILE")
parser.add_option("-n", "--nElem", dest="nElem", default=2,
                  help="use this NELEM in x- and y- direction", metavar="NELEM")
parser.add_option("-p", "--pDegr", dest="pDegr", default=1,
                  help="use this PDEGR polynomial degree", metavar="PDEGR")
(options, args)=parser.parse_args()

# Lengths for non-square domains
Lx = 1.0
Ly = 1.0

# Store the number of elements, polynomial degree and number of nodes.
nElem = int(options.nElem)
mElem = nElem
pDegr = int(options.pDegr)

nNode = pDegr*nElem + 1
mNode = nNode

# Set the type for the interior elements and the boundary elements
KindElem  = 9 + 100*(pDegr-1)
KindBound = 3 + 100*(pDegr-1)

# Open the output mesh file.
Mesh_File = open(options.filename,"w")

# Write the dimension of the problem and the number of interior elements
Mesh_File.write( "%\n" )
Mesh_File.write( "% Problem dimension\n" )
Mesh_File.write( "%\n" )
Mesh_File.write( "NDIME= 2\n" )
Mesh_File.write( "%\n" )
Mesh_File.write( "% Inner element connectivity\n" )
Mesh_File.write( "%\n" )
Mesh_File.write( "NELEM= %s\n" % (nElem*mElem))

# Write the element connectivity for linear elements.
if pDegr == 1:
    iElem = 0
    for jNode in range(mElem):
        for iNode in range(nElem):
            iPoint = jNode*nNode + iNode
            jPoint = jNode*nNode + iNode + 1
            kPoint = (jNode + 1)*nNode + (iNode + 1)
            lPoint = (jNode + 1)*nNode + iNode
            Mesh_File.write( "%s  %s  %s  %s  %s  %s\n" % (KindElem, iPoint, jPoint, kPoint, lPoint, iElem) )
            iElem = iElem + 1
else:
    iElem = 0
    for jNode in range(mElem):
        for iNode in range(nElem):
            Mesh_File.write( "%s" % (KindElem) )
            for jPol in range(pDegr+1):
                startInd = (jNode*pDegr+jPol)*nNode + iNode*pDegr
                for iPol in range(pDegr+1):
                    Mesh_File.write( "  %s" % (startInd+iPol) )
            Mesh_File.write( "  %s\n" % (iElem) )
            iElem = iElem + 1


# Compute the number of nodes and write the node coordinates
nPoint = (nNode)*(mNode)
Mesh_File.write( "%\n" )
Mesh_File.write( "% Node coordinates\n" )
Mesh_File.write( "%\n" )
Mesh_File.write( "NPOIN= %s\n" % ((nNode)*(mNode)) )
iPoint = 0
for jNode in range(mNode):
    for iNode in range(nNode):
        Mesh_File.write( "%15.14f \t %15.14f \t %s\n" % (Lx*float(iNode)/float(nNode-1), Ly*float(jNode)/float(mNode-1), iPoint) )
        iPoint = iPoint + 1

# Write the header information for the boundary markers
Mesh_File.write( "%\n" )
Mesh_File.write( "% Boundary elements\n" )
Mesh_File.write( "%\n" )
Mesh_File.write( "NMARK= 4\n" )

# Write the boundary information for each marker
Mesh_File.write( "MARKER_TAG= BottomBoundary\n" )
Mesh_File.write( "MARKER_ELEMS= %s\n" % (nElem))
for iElem in range(nElem):
    Mesh_File.write( "%s" % (KindBound) )
    for iPol in range(pDegr+1):
        Mesh_File.write( "  %s" % (iElem*pDegr + iPol) )
    Mesh_File.write( "\n" )
Mesh_File.write( "MARKER_TAG= RightBoundary\n" )
Mesh_File.write( "MARKER_ELEMS= %s\n" % (mElem))
for jElem in range(mElem):
    Mesh_File.write( "%s" % (KindBound) )
    for jPol in range(pDegr+1):
        Mesh_File.write( "  %s" % ((jElem*pDegr + jPol)*nNode + nNode-1) )
    Mesh_File.write( "\n" )
Mesh_File.write( "MARKER_TAG= TopBoundary\n" )
Mesh_File.write( "MARKER_ELEMS= %s\n" % (nElem))
for iElem in range(nElem):
    Mesh_File.write( "%s" % (KindBound) )
    for iPol in range(pDegr+1):
        Mesh_File.write( "  %s" % ((nNode*mNode - 1) - (iElem*pDegr + iPol)) )
    Mesh_File.write( "\n" )
Mesh_File.write( "MARKER_TAG= LeftBoundary\n" )
Mesh_File.write( "MARKER_ELEMS= %s\n" % (mElem))
for jElem in range(mElem-1, -1, -1):
    Mesh_File.write( "%s" % (KindBound) )
    for jPol in range(pDegr, -1, -1):
        Mesh_File.write( "  %s" % ((jElem*pDegr + jPol)*nNode) )
    Mesh_File.write( "\n" )

# Close the mesh file and exit
Mesh_File.close()
