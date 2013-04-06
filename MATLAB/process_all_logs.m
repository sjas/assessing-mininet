%%% this should do some nice batch processing
%%% and make pictures out of it, while at it.

%%% SETTINGS: where are which files
folder_name        = '/cygdrive/c/Users/sjas/work/ktr/MATLAB/itg-logs/';
extension_loadfile = '*.dat';
prefix_imgfile     = 'pic_';
%choose: ps, eps, jpg, png, emf, pdf 
%others are possible, lookup in documentation!
extension_imgfile  = '.png';


%%% CODE
% string concatenation and getting a file list
wildcard_string = strcat(folder_name, extension_loadfile);
file_set        = dir(wildcard_string);

% ACTUAL PROCESSING
% loop from 1 through to the amount of rows
for i = 1:length(file_set)
    current_file_name_with_ext = file_set(i).name;
    % create filename for picture
    temp_picture_file_name     = strcat(prefix_imgfile, current_file_name_with_ext)
    current_picture_file_name  = strcat(temp_picture_file_name, extension_imgfile);

    %string_splits              = strsplit(current_file_name_with_ext, '.');
    %current_file_name_bare     = string_splits(1, 1);
    %current_picture_file_name  = strcat(current_file_name_bare, extension_imgfile);

    % load file with absolute path, 
    % since the file_set provides just the bare filename
    %%% TODO check if this can be done easier with 'file_in_loadpath(<file>)'
    current_file = loadwrapper(strcat(folder_name, current_file_name_with_ext)); 
    parsed_data = processdata(current_file);

    saveas(1, current_picture_file_name);

end

% CLEAN UP
%clear string_splits;
%clear current_file_name_bare;
clear parsed_data;
clear current_file_name_with_ext;
clear current_picture_file_name;
clear file_set;
