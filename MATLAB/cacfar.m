%{
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

My_Cifar performs a Cell Averaging(CA) Constant False Alaram Rate (CFAR)
detection

   The CA CFAR is particularly useful for peak detection, finding the
   large peaks of interest which if an FFT was performed on a signal would
   produce the carrier frequency or tones of interest
   there are Three important Equations when considering this:

   T = a * Pn
   T = Threshold
   a = Threshold Factor
   Pn = Noise Power of Training Cells

   a = N * (Pfa ^ (-1/N) -1)
   N = Number of Training Cells%
   Pfa = False Alaram Rate

   PN = 1/N * symsum(xm, m, 1, N)
   https://uk.mathworks.com/help/symbolic/symsum.html#:~:text=example-,F%20%3D%20symsum(%20f%20%2C%20k%20%2C%20a%20%2C%20b%20),the%20default%20variable%20is%20x%20.

   ^ can see from the above that the lower the false alarm rate will lead
   to a higher threshold level.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%}
function [] = My_Cifar(num_train_cells, num_guard_cells, data, prob_false_alarm, plot_frequency)

num_cells = length(data); % num_cells = number of cells by taking the length of the data
num_train_cells_half = round(num_train_cells/2); % half the number of training cells, rounded if odd number
num_guard_cells_half = round(num_guard_cells/2); % half the number of guard cells, rounded incase odd number
num_side = num_train_cells_half + num_guard_cells_half; % number on the side of Cell Under Test (CUT)

alpha = num_train_cells * (prob_false_alarm ^ (-1 / num_train_cells) -1); % threshold factor

peak_idx = zeros(length(data),1); % empty array based on size of data for peak locations

thresh_array = zeros(length(data),1); %empty array based on size of data for thresholding line

for i = 1 + num_side : num_cells - num_side %start from number on side of CUT to the end of other side of CUT, because there is nothing to left and right
%     [max_value, max_index] = max(data(i - num_side : i + num_side + 1 -1));
%     if i ~= i - num_side + max_index -1
%         thresh_array(i) = thresh_array(i - 1);
%         continue
%     end
    
    sum_one = sum(data(i - num_side : i + num_side + 1 - 1));
    sum_two = sum(data(i - num_guard_cells_half : i + num_guard_cells_half + 1 - 1));
    noise_power = (sum_one - sum_two) / num_train_cells
    threshold = alpha * noise_power;
    thresh_array(i) = threshold;
    
    if data(i) > threshold
        peak_idx(i) = data(i)
    end
    
end

figure(1);
plot(plot_frequency, data, plot_frequency, peak_idx, 'o', plot_frequency, thresh_array);

end
