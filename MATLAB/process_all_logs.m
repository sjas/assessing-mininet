%%% this does some nice batch processing
%%% and make pictures out of it, while at it.

%%% SETTINGS: where are which files
folder_name        = '/cygdrive/c/Users/sjas/work/ktr/MATLAB/itg-logs/';
extension_loadfile = '.dat';
%choose: ps, eps, jpg, png, emf, pdf 
%others are possible, lookup in documentation!
extension_imgfile  = '.png';
prefix_imgfile     = 'pic_';


%%% CODE
% string concatenation and getting a file list
wildcard        = strcat('*', extension_loadfile);
wildcard_string = strcat(folder_name, wildcard);
file_set        = dir(wildcard_string);

% ACTUAL PROCESSING
% loop from 1 through to the amount of rows
for i = 1:length(file_set)
    current_file_name_with_ext = file_set(i).name;
    % create filename for picture by replacing the extension
    temp_picture_file_name    = strrep(current_file_name_with_ext, extension_loadfile, extension_imgfile);
    current_picture_file_name = strcat(prefix_imgfile, temp_picture_file_name);

    % load file with absolute path, 
    % since the file_set provides just the bare filename
    %%% TODO check if this can be done easier with 'file_in_loadpath(<file>)'
    current_file = loadwrapper(strcat(folder_name, current_file_name_with_ext)); 
    parsed_data = processdata(current_file);

    % save image
    saveas(1, current_picture_file_name);

end

% TIDY UP
% clear variables
clear folder_name;
clear extension_loadfile;
clear extension_imgfile;
clear prefix_imgfile;
clear wildcard;
clear wildcard_string;
clear file_set;
clear current_file_name_with_ext;
clear temp_picture_file_name;
clear current_picture_file_name;
clear current_file;
clear parsed_data;
% close gfx window
close all
