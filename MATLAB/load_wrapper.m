function [ loaded_data ] = load_wrapper( file_name )
%%% will load a file if its filename is provided
%%% USAGE: (save data to var)
%%% x =loadwrapper('<filenam>')

    files = dir(file_name);
    loaded_data = load(files.name, '-ascii');

end
