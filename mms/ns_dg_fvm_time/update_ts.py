#!/usr/bin/python

## \file update_ts.py
#  \brief Python script for automatically updating the TIME_STEP in a
#   the SU2 config files
#  \author Thomas D. Economon
#  \version 7.2.1
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
import re #regular expressions
from os import fsync

parser=OptionParser()
parser.add_option("-f", "--file", dest="filename", default="lam_mms_unst.cfg",
                  help="write configuration to FILE", metavar="FILE")
parser.add_option("-t", "--tStep", dest="tStep", default=1e-6,
                  help="time step for the unsteady solver", metavar="TIME_STEP")
parser.add_option("-m", "--tMarch", dest="tMarch", default="TIME_STEPPING",
                  help="time marching scheme for the unsteady solver", metavar="TIME_MARCHING")


(options, args)=parser.parse_args()

# function update_config, inspired by post : https://stackoverflow.com/a/5305696
def update_config(filename, dico):
    regex = '(('+'|'.join(dico.keys())+')\s*=)[^\r\n]*?(\r?\n|\r)'
    pat = re.compile(regex)

    def jojo(mat, dic=dico):
        return dic[mat.group(2)].join(mat.group(1, 3))

    #read
    with open(filename, 'rb') as f:
        content = f.read()

    #write
    with open(filename, 'wb') as f:
        f.write(pat.sub(jojo, content))


vars = ["TIME_STEP", "TIME_MARCHING"]
new_values = [options.tStep, options.tMarch]
changes = dict(zip(vars, new_values))


update_config(options.filename, changes)
