#! ruby -Ks
# -*- mode:ruby; coding:shift_jis -*-
$KCODE='s'


lib = <<EOS
#! ruby -Ks
# -*- mode:ruby; coding:shift_jis -*-
$KCODE='s'

#Set 'EXE_DIR' directly at runtime  ���ڎ��s����EXE_DIR��ݒ肷��
EXE_DIR = (File.dirname(File.expand_path($0)).sub(/\\/$/,'') + '/').gsub(/\\//,'\\\\') unless defined?(EXE_DIR)

#Available Libraries  �g�p�\���C�u����
#require 'jcode'
#require 'nkf'
#require 'csv'
#require 'fileutils'
#require 'pp'
#require 'date'
#require 'time'
#require 'base64'
#require 'win32ole'
#require 'Win32API'
#require 'vr/vruby'
#require 'vr/vrcontrol'
#require 'vr/vrcomctl'
#require 'vr/clipboard'
#require 'vr/vrddrop.rb'
#require 'json'
#require 'sqlite3'

#Predefined Constants  �ݒ�ςݒ萔
#EXE_DIR ****** Folder with EXE files[It ends with '\\']  EXE�t�@�C���̂���f�B���N�g��[������\\]
#MAIN_RB ****** Main ruby script file name  ���C����ruby�X�N���v�g�t�@�C����
#ERR_LOG ****** Error log file name  �G���[���O�t�@�C����





#The condition is positive when this split is executed directly.
#���̃X�v���N�g�𒼐ڎ��s���ɏ��������ɂȂ�B
if (defined?(ExerbRuntime) ? EXE_DIR + MAIN_RB : $0) == __FILE__
  print "Program execution ended. Press the Enter key."
  STDIN.gets
end

EOS

EXE_DIR   = File.dirname(ExerbRuntime.filepath) + '\\'
MAIN_RB   = File.basename(ExerbRuntime.filepath,'.*') + '.rb'
ERR_LOG   = File.basename(ExerbRuntime.filepath,'.*') + '_err.txt'
core_ruby = EXE_DIR + MAIN_RB
err_log_file = EXE_DIR + ERR_LOG
$LOAD_PATH.push(EXE_DIR.gsub(/\\/,'/').sub(/\/$/,'')) if $Exerb

if File.exist?(core_ruby)
  if File.exist?(err_log_file)
    File.delete(err_log_file)
  end
  begin
    require core_ruby if $Exerb
  rescue Exception => e
    unless e.message == 'exit'
      errmsg = "******** Terminated with error ********\n\n"
      errmsg += "******** Error message ********\n" + e.inspect + "\r\n******** Backtrace ********\r\n"
      e.backtrace.each{|a| errmsg += a + "\n"}
      puts errmsg
      begin
        File.open(err_log_file,'w') do |f|
          errmsg.each do |a|
            f.puts a
          end
        end
        puts "\nError log file = #{err_log_file}"
      rescue
        puts "\nThe error log file could not be created (not writable)."
      end
      print "Press the Enter key."
      STDIN.gets
    end
  end
else
  puts "There is no '#{core_ruby}', I will create it."
  File.open(core_ruby,'w') do |f|
    lib.each do |a|
      f.puts a
    end
  end
  print "Press the Enter key."
  STDIN.gets
end
