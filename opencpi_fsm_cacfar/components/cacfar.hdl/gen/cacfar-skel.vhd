-- THIS FILE WAS ORIGINALLY GENERATED ON Thu Jun 23 15:27:28 2022 BST
-- BASED ON THE FILE: cacfar.xml
-- YOU *ARE* EXPECTED TO EDIT IT
-- This file initially contains the architecture skeleton for worker: cacfar

library IEEE; use IEEE.std_logic_1164.all; use ieee.numeric_std.all;
library ocpi; use ocpi.types.all; -- remove this to avoid all ocpi name collisions
architecture rtl of worker is
begin
  ctl_out.finished <= btrue; -- remove or change this line for worker to be finished when appropriate
                             -- workers that are never "finished" need not drive this signal
  -- Skeleton assignments for cacfar's volatile properties
end rtl;
