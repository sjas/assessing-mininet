function [ loaded_data ] = loadwrapper( file_name )
%%% will load a file if its filename is provided
%%% USAGE: (save data to var)
%%% x =loadwrapper('<filenam>')

    files = dir(file_name);
     for k = 1:length(files)
         loaded_data = load(files(k).name, '-ascii');
     end

 end
