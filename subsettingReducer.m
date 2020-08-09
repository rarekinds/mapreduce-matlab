function subsettingReducer(~, intermValList, outKVStore)
  % get all intermediate results from the list
  outVal = {};

  while hasnext(intermValList)
    outVal = [outVal; getnext(intermValList)];
  end
  % Note that this approach assumes the concatenated intermediate values (the
  % subset of the whole data) fit in memory.
    
  add(outKVStore, 'Null', outVal);
end