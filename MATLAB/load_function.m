function [ loaded_data ] = load_function( file_name )
%%% will load a file if its filename is provided
%%% USAGE: (save data to var)
%%% x = load_function('<filename>')

    files = dir(file_name);
    loaded_data = load(files.name, '-ascii');

end
