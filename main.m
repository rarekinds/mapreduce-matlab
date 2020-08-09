%% Analyze diabetes big data by mapreduce
% Create a Datastore
ds =datastore('F:\sample code\myworks\matlab\text mining\mapreduce\dataset_diabetes\dataset_diabetes\diabetic_data.csv', 'TreatAsMissing', 'NA')
ds.SelectedVariableNames = ds.VariableNames([4 5 6 10 12 13 14 15 17 ...
    22 23 25 42 49 50]);
ds.SelectedVariableNames

preview(ds)

%% Run MapReduce
%Use |mapreduce| to apply the map and reduce functions to the datastore
result = mapreduce(ds, @subsettingMapper, @subsettingReducer);

%% Display Results
r = readall(result);
tbl = r.Value{1};
tbl(:,1:10)

tbl(:,[1,7,8,11:end])

%% Rerun MapReduce
%% 
% Create an anonymous function that performs the same selection of rows
% that is hard-coded in |subsettingMapper.m|.
noofproc_med = ...
   @(data) data.time_in_hospital > 4 & ...
   (data.num_lab_procedures - data.num_medications) > 1.50*data.num_medications;

configuredMapper = ...
    @(data, info, intermKVStore) subsettingMapperGeneric(data, info, ...
    intermKVStore, noofproc_med);
%%
% Use |mapreduce| to apply the generic map function to the input datastore.
result2 = mapreduce(ds, configuredMapper, @subsettingReducer);

%%
% |mapreduce| returns an output datastore, |result2|, with files in
% the current folder.

%% Verify MapReduce Results
% Confirm that the generic mapper gets the same result as with the
% hard-wired subsetting logic
r2 = readall(result2);
tbl2 = r2.Value{1};
save tbl2 tbl2;

if isequaln(tbl, tbl2)
    disp('Same results with the configurable mapper.')
else
    disp('Oops, back to the drawing board.')
end