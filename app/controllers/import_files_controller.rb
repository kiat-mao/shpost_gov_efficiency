class ImportFilesController < ApplicationController
  load_and_authorize_resource :import_file

  def index
    @import_files_grid = initialize_grid(@import_files,
         :order => 'import_files.created_at',
         :order_direction => 'desc')
  end

  def download
    file_path = @import_file.file_path
        
    if !file_path.blank? and File.exist?(file_path)
      io = File.open(file_path)
      filename = File.basename(file_path)
      send_data(io.read, :type => "text/excel;charset=utf-8; header=present",              :filename => filename)
      io.close
    else
      redirect_to import_files_path, :notice => '文件不存在，下载失败！'
    end
  end

  def err_download
    file_path = @import_file.err_file_path
        
    if !file_path.blank? and File.exist?(file_path)
      io = File.open(file_path)
      filename = File.basename(file_path)
      send_data(io.read, :type => "text/excel;charset=utf-8; header=present",              :filename => filename)
      io.close
    else
      redirect_to import_files_path, :notice => '文件不存在，下载失败！'
    end
  end
end