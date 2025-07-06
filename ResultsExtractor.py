"""Extract viscoelastic response from abaqus output ODB"""
import os
import sys
import numpy as np
from odbAccess import openOdb

targetFrequency = float(sys.argv[-1])
filename = str(sys.argv[-2])

MyOdbAdress = filename + '.odb'
MyOdb = openOdb(MyOdbAdress)
MyStep = MyOdb.steps['Step-1']

# Finding the number of elements in ODB file
MyPart = MyOdb.rootAssembly.instances["PART-1-1"]
EleNum = len(MyPart.elements)

MyText_Stress = filename + '_Stress.txt'
MyText_Strain = filename + '_Strain.txt'
MyText_ALLHDE = filename + '_Energy.txt'

# Write S11 component to the stress file
with open(MyText_Stress, 'w') as file:
    # Write the header row
    file.write('Frequency\tS11_Real\tS11_Imag\n')

    for frame in MyStep.frames:
        frequency = frame.frameValue
        if frequency == 0:
            continue

        MyStress = frame.fieldOutputs['S']
        for stress in MyStress.values:
            file.write('{}\t{}\t{}\n'.format(
                frequency, stress.data[0], stress.conjugateData[0]
            ))

# Write E11 component to the strain file
with open(MyText_Strain, 'w') as file:
    # Write the header row
    file.write('Frequency\tE11_Real\tE11_Imag\n')

    for frame in MyStep.frames:
        frequency = frame.frameValue
        if frequency == 0:
            continue

        MyStrain = frame.fieldOutputs['E']
        for strain in MyStrain.values:
            file.write('{}\t{}\t{}\n'.format(
                frequency, strain.data[0], strain.conjugateData[0]
            ))

# Write ALLIE energy to the ALLIE file
with open(MyText_ALLHDE, 'w') as file:
    # Write the header row
    file.write('Frequency\tALLHDE\n')

    # Automatically find the correct key for the assembly
    assembly_key = None
    for key in MyStep.historyRegions.keys():
        if 'Assembly' in key:
            assembly_key = key
            break

    if assembly_key is None:
        raise ValueError("Assembly key not found in history regions")

    MyALLHDE = MyStep.historyRegions[assembly_key].historyOutputs['ALLHDE']
    for value in MyALLHDE.data:
        file.write('{}\t{}\n'.format(
            value[0], value[1]
        ))