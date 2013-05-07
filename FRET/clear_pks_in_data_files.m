function clear_pks_in_data_files(file_begin,file_end,dt,level)

for u=file_begin:1:file_end
  load(sprintf('./data_%g.mat',u));
  u
  tags{1}=peak_eater(tags{1},dt,level,0);
  tags{2}=peak_eater(tags{2},dt,level,0);
  
  save(sprintf('data_%g', u+999), 'tags', 'x0', 'y0', 'z0', 't0', 'tags_Desc', 'NIDAQ_Out', 'NIDAQ_Desc','begin_clock');
  clear tags;
end