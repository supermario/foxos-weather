require 'sinatra'
set :public_folder, Proc.new { File.join(root, "") }
