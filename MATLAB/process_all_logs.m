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

    % create filename for picture
    current_file_name_with_ext = file_set(i).name;
    temp                       = strsplit(current_file_with_ext, '.');
    current_file_name_bare     = temp(1,1);
    picture_file_name = strcat(current_file_name_bare, extension_imgfile);
    clear temp;

    % load file with absolute path, 
    % since the file_set provides just the bare filename
    %%% TODO check if this can be done easier with 'file_in_loadpath(<file>)'
    current_file = loadwrapper(strcat(folder_name, current_file_with_ext)); 
    %figure(i);
    %TODO
    unused_atm        = processdata(current_file);

    saveas(1, picture_file_name);

    clear unused_atm;
    clear current_file_name_bare;
    clear current_file_with_ext;
    clear picture_file_name;
end

% CLEAN UP
clear file_set;
