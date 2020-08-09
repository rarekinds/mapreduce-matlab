function subsettingMapper(data, ~, intermKVStore)
  % Select flights from 1995 and later that had exceptionally long
  % elapsed flight times (including both time on the tarmac and time in 
  % the air).
  idx = data.time_in_hospital > 4 & (data.num_lab_procedures - data.num_medications)...
    > 1.50 * data.num_medications;
  intermVal = data(idx,:);

  add(intermKVStore,'Null',intermVal);
end