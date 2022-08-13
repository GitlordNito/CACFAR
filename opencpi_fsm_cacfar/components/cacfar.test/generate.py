#!/usr/bin/env python3

"""
CACFAR : create input data for CACFAR (binary data file)
"""

import numpy as np
import sys
import os
import math

SAMPLE_SIZE  = int(os.environ.get("OCPI_TEST_SAMPLE_SIZE"))

CASE = os.environ.get("OCPI_TEST_test_case")

SAMPLING_FREQUENCY = int(os.environ.get("OCPI_TEST_SAMPLING_FREQUENCY"))

file_name = sys.argv[1]

if CASE == "case00":
  with open(file_name, "wb") as f:
    data = [1] * SAMPLE_SIZE
    data = np.array([ 4 * len(data), 0] + data, dtype = np.uint32)
    # number of bytes as 32 bit number,the opcode as a 32 bit  number, data
    f.write(data)

elif CASE == "case01":
  with open(file_name, "wb") as f:
    data = [0] * SAMPLE_SIZE
    for i in range(SAMPLE_SIZE):
      data[i] = i
    data = np.array([ 4 * len(data), 0] + data, dtype = np.uint32)
    # number of bytes as 32 bit number,the opcode as a 32 bit  number, data
    f.write(data)

elif CASE == "case02":

  # At what intervals time points are sampled
  sampling_interval = 1 / SAMPLING_FREQUENCY;

  noise = np.random.normal(0,0.25,SAMPLING_FREQUENCY)

  # Begin time period of the signals
  begin_time = 0;

  # End time period of the signals
  end_time = 1;

  # Frequency of the carriers of the singal
  fc_1 = 50; # 50
  fc_2 = 120; # 120

  # Time points
  time = np.arange(begin_time, end_time, sampling_interval)

  # Create the sine waves
  sin_1 = np.sin(2 * np.pi * fc_1 * time)
  sin_2 = np.sin(2 * np.pi * fc_2 * time)

  # Add the sine waves
  sin_t = sin_1 + sin_2 + noise

  # Frequency domain representation
  fft_var = np.fft.fft(sin_t)/len(sin_t) # normalise amplitude
  #print(len([x for x in fft_var]))
  fft_var = fft_var[:len(sin_t) // 2] # exclude sampling frequency
  #print(fft_var)

  fft_var = np.absolute(fft_var)

  fft_var = [int(x * (2 ** 15)) for x in fft_var]
  #print([x for x in fft_var])
  #print(fft_var[48:52:1])
  #print(fft_var[118:122])

  # Additional metrics for plotting with matplotlib
  #tp_count = len(sin_t)
  #values = np.arrange(uint32(tp_count / 2))
  #time_period = tp_count / SAMPLING_FREQUENCY
  #frequencies = values / time_period

  with open(file_name, "wb") as f:
    data = np.array([ 4 * len(fft_var), 0] + fft_var, dtype = np.uint32)
    # number of bytes as 32 bit number,the opcode as a 32 bit  number, data
    # print(len(data))
    f.write(data)

elif CASE == "case03":
  with open(file_name, "wb") as f:
    data = [0] * SAMPLE_SIZE
    for i in range(0 , len(data) , 16):
        data[i] = int(1)
    data = np.array([ 4 * len(data), 0] + data, dtype = np.uint32)
    # number of bytes as 32 bit number,the opcode as a 32 bit  number, data
    # print(len(data))
    f.write(data)

elif CASE == "case04":

  # At what intervals time points are sampled
  sampling_interval = 1 / SAMPLING_FREQUENCY;

  # Begin time period of the signals
  begin_time = 0;

  # End time period of the signals
  end_time = 1;

  # Frequency of the carriers of the singal
  fc_1 = 50; # 50
  fc_2 = 120; # 120

  # Time points
  time = np.arange(begin_time, end_time, sampling_interval)

  # Create the sine waves
  sin_1 = np.sin(2 * np.pi * fc_1 * time)
  sin_2 = np.sin(2 * np.pi * fc_2 * time)

  # Add the sine waves
  sin_t = sin_1 + sin_2

  # Frequency domain representation
  fft_var = np.fft.fft(sin_t)/len(sin_t) # normalise amplitude
  #print(len([x for x in fft_var]))
  fft_var = fft_var[:len(sin_t)//2] # exclude sampling frequency
  #print(fft_var)

  fft_var = np.absolute(fft_var)

  fft_var = [int(x * (2 ** 15)) for x in fft_var]
  #print([x for x in fft_var])
  #print(fft_var[48:52:1])
  #print(fft_var[118:122])

  # Additional metrics for plotting with matplotlib
  #tp_count = len(sin_t)
  #values = np.arrange(uint32(tp_count / 2))
  #time_period = tp_count / SAMPLING_FREQUENCY
  #frequencies = values / time_period

  with open(file_name, "wb") as f:
    data = np.array([ 4 * len(fft_var), 0] + fft_var, dtype = np.uint32)
    # number of bytes as 32 bit number,the opcode as a 32 bit  number, data
    #print(len(data))
    f.write(data)

elif CASE == "case05":

  # At what intervals time points are sampled
  sampling_interval = 1 / SAMPLING_FREQUENCY;

  # Begin time period of the signals
  begin_time = 0;

  # End time period of the signals
  end_time = 1;

  # Frequency of the carriers of the singal
  fc_1 = 2; # 50
  fc_2 = 5; # 120

  # Time points
  time = np.arange(begin_time, end_time, sampling_interval)

  # Create the sine waves
  sin_1 = np.sin(2 * np.pi * fc_1 * time)
  sin_2 = np.sin(2 * np.pi * fc_2 * time)

  # Add the sine waves
  sin_t = sin_1 + sin_2

  # Frequency domain representation
  fft_var = np.fft.fft(sin_t)/len(sin_t) # normalise amplitude
  #print(len([x for x in fft_var]))
  fft_var = fft_var[:len(sin_t)//2] # exclude sampling frequency
  #print(fft_var)
  # TODO take just I then drop the Q'sc
  fft_var = np.absolute(fft_var)

  fft_var = [int(x * (2 ** 15)) for x in fft_var]

  #print([x for x in fft_var])
  #print(fft_var[48:52:1])
  #print(fft_var[118:122])

  # Additional metrics for plotting with matplotlib
  #tp_count = len(sin_t)
  #values = np.arrange(uint32(tp_count / 2))
  #time_period = tp_count / SAMPLING_FREQUENCY
  #frequencies = values / time_period

  with open(file_name, "wb") as f:
    data = np.array([ 4 * len(fft_var), 0] + fft_var, dtype = np.uint32)
    # number of bytes as 32 bit number,the opcode as a 32 bit  number, data
    #print(len(data))
    f.write(data)

elif CASE == "case06":
  with open(file_name, "wb") as f:
    #data = [1] * SAMPLE_SIZE
    data = [1 if x % 2 == 0 else 0 for x in range(2 * SAMPLE_SIZE)]
    #f.write(np.array([ 4 * SAMPLE_SIZE, 0] + data[1 : len(data) : 2], dtype = np.uint32))
    # ^ Write out all the I values as uint32's
    #f.write(np.array([ 4 * SAMPLE_SIZE, 0] + data[1 : len(data) : 2], dtype = np.uint32))
    # ^ Write out all the Q Values as uint32's
    f.write(np.array([ 4 * SAMPLE_SIZE, 0], dtype = np.uint32))
    f.write(np.array(data, dtype= np.int16))


  # max should be 32767 and -32768

else:
  raise ValueError(f"Unexpected OCPI_TEST_test_case: {CASE}.")
