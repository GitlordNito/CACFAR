#!/usr/bin/env python3

#import zerolistmaker
import math
import numpy as np

# perform CACFAR function on input data
def CACFAR(input_data, num_cells, num_train_cells, num_guard_cells, threshold_factor):
    """
    Detect peaks with Cell-Averaging (CA) Constant False Alarm Rate (CFAR) algorithm.

    num_cells: The total number of cells, usually 512 or 1024
    num_train: Number of training cells.
    num_guard: Number of guard cells.
    threshold_factor: constant for how regularly or stringently we want detect peaks

    # alpha = num_train_cells * (prob_false_alarm ** (-1 / num_train_cells) -1)
    ^ how the threshold factor can be calucalted if PFA is wanted as user input
    """

    sum_of_left = 0
    sum_of_right = 0

    num_train_cells_half = round(num_train_cells / 2)
    num_guard_cells_half = round(num_guard_cells / 2)
    num_side             = num_train_cells_half + num_guard_cells_half
    # alpha = num_train_cells * (prob_false_alarm ** (-1 / num_train_cells) -1)

    peak_idx     = []

    for i in range (num_cells):
        if i < num_side or i > (num_cells - 1) - num_side:
            peak_idx.append(0)
            continue
        sum_of_left  = np.sum(input_data[i - num_side : i - num_guard_cells_half])
        sum_of_right = np.sum(input_data[i + num_guard_cells_half + 1 : i + num_side + 1])

        noise_power  = (sum_of_left + sum_of_right) // num_train_cells
        threshold    = threshold_factor * noise_power
        #thresh_array[i] = threshold
        if input_data[i] >= threshold:
            peak_idx.append(input_data[i])
        else:
            peak_idx.append(0)
    return peak_idx
