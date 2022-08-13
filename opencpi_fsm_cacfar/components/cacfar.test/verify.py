#!/usr/bin/env python3

"""
CACFAR : Validate output data for CACFAR (binary data file)

Validate args:
- input file generated uring the previous generate.py generate step
- amount to validate (number of complex signed 16-bit samples)
- amount of training cells
- amount of guard num_cells
- threshold factor post-calc
- output target file

To test the CACFAR component

"""

#from ~/opencpi/projects/cacfar/scripts import cacfar_func.py
import cacfar_func
import math
import numpy as np
import os
import sys

i_file_name      = sys.argv[2]
full_data_width  = int(os.environ.get("OCPI_TEST_SAMPLE_SIZE"))
num_train_cells  = int(os.environ.get("OCPI_TEST_NUM_TRAIN_CELLS"))
num_guard_cells  = int(os.environ.get("OCPI_TEST_NUM_GUARD_CELLS"))
threshold_factor = int(os.environ.get("OCPI_TEST_THRESHOLD_FACTOR"))
o_file_name      = sys.argv[1]

CASE = os.environ.get("OCPI_TEST_test_case")

#dt_iq_pair = np.dtype((np.uint32, {"real_idx":(np.int16,0), "imag_idx":(np.int16,2)}))
#TODO think about how the data is coming into verify?

# Read all of input data file as complex uint32
print ("Input file to validate: ", i_file_name)
ifile = open(i_file_name, 'rb')
idata = np.fromfile(ifile, dtype = np.uint32, count = -1)
idata = idata[2:]
# dtype = dt_iq_pair
ifile.close()

# Read all of output data file as complex uint32
print ("Output file to validate: ", o_file_name)
ofile = open(o_file_name, 'rb')
odata = np.fromfile(ofile, dtype = np.uint32, count = -1)
# dtype = dt_iq_pair
ofile.close()

# TEST #1: test odata is not all zeroes
#if all(odata == 0):
    #print ("Values are all zero")
    #sys.exit(1)

# TEST #2: test odata is the expected amount
if len(odata) != full_data_width:
    print ("Output file length is unexpected")
    print ("Length ofilename = ", len(odata), "while expected length is = ", full_data_width)

# Create complex arrays for both input and outputd data
#i_complex_data = np.array(np.zeros(full_data_width), dtype=np.complex64)
#o_complex_data = np.array(np.zeros(full_data_width), dtype=np.complex64)
#for i in range(1,full_data_width):
    #i_complex_data[i] = complex(idata['real_idx'][i-1], idata['imag_idx'][i-1])

# # Case00: 512 32 bit values in all as ones
if CASE == "case00":
    peak_idx = cacfar_func.CACFAR(idata, full_data_width, num_train_cells, num_guard_cells, threshold_factor)
    peak_idx = np.array(peak_idx, dtype = np.uint32)
    if (peak_idx == odata).all():
        sys.exit(0) # Good
    else:
        print(idata)
        print("PAUSE")
        print(peak_idx)
        print("PAUSE")
        print(odata)
        print("PAUSE")
        print(peak_idx == odata)
        #print(odata)
        sys.exit(1) # Bad

# # Case01 512 32 bit values counting from 0 to 512
if CASE == "case01":
    peak_idx = cacfar_func.CACFAR(idata, full_data_width, num_train_cells, num_guard_cells, threshold_factor)
    if (peak_idx == odata).all():
        sys.exit(0) # Good
    else:
        print(idata)
        print("PAUSE")
        print(peak_idx)
        print("PAUSE")
        print(odata)
        print("PAUSE")
        print(peak_idx == odata)
        sys.exit(1) # Bad

# # Case02: 512 32 bit values coming out from an FFT in [I,Q] format
if CASE == "case02":
    peak_idx = cacfar_func.CACFAR(idata, full_data_width, num_train_cells, num_guard_cells, threshold_factor)
    if (peak_idx == odata).all():
        sys.exit(0) # Good
    else:
        print(idata)
        print("PAUSE")
        print(peak_idx)
        print("PAUSE")
        print(odata)
        print("PAUSE")
        print(peak_idx == odata)
        sys.exit(1) # Bad

# # Case03: 512 32 bit values with a rnage of 0's but also occaisonally some 1's
  #         ensure that peaks ar ebeing detected and thresholded correctly.
if CASE == "case03":
    peak_idx = cacfar_func.CACFAR(idata, full_data_width, num_train_cells, num_guard_cells, threshold_factor)
    if (peak_idx == odata).all():
        sys.exit(0) # Good
    else:
        print(idata)
        print("PAUSE")
        print(peak_idx)
        print("PAUSE")
        print(odata)
        print("PAUSE")
        print(peak_idx == odata)
        sys.exit(1) # Bad

if CASE == "case04":
    peak_idx = cacfar_func.CACFAR(idata, full_data_width, num_train_cells, num_guard_cells, threshold_factor)
    if (peak_idx == odata).all():
        sys.exit(0) # Good
    else:
        print(idata)
        print("PAUSE")
        print(peak_idx)
        print("PAUSE")
        print(odata)
        print("PAUSE")
        print(peak_idx == odata)
        sys.exit(1) # Bad

if CASE == "case05":
    peak_idx = cacfar_func.CACFAR(idata, full_data_width, num_train_cells, num_guard_cells, threshold_factor)
    if (peak_idx == odata).all():
        sys.exit(0) # Good
    else:
        print(idata)
        print("PAUSE")
        print(peak_idx)
        print("PAUSE")
        print(odata)
        print("PAUSE")
        print(peak_idx == odata)
        sys.exit(1) # Bad

if CASE =="case06":
    peak_idx = cacfar_func.CACFAR(idata, full_data_width, num_train_cells, num_guard_cells, threshold_factor)
    if (peak_idx == odata).all():#
        print(idata)
        print("PAUSE")
        print(peak_idx)
        print("PAUSE")
        print(odata)
        print("PAUSE")
        print(peak_idx == odata)
        sys.exit(0) # Good
    else:
        print(idata)
        print("PAUSE")
        print(peak_idx)
        print("PAUSE")
        print(odata)
        print("PAUSE")
        print(peak_idx == odata)
        sys.exit(1) # Bad

# # Case Match Failed
else:
    raise ValueError(f"Unexpected OCPI_TEST_test_case: {CASE}.")
