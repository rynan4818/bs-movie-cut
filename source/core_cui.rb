#! ruby -Ks
# -*- mode:ruby; coding:shift_jis -*-
$KCODE='s'


lib = <<EOS
#! ruby -Ks
# -*- mode:ruby; coding:shift_jis -*-
$KCODE='s'

#���ڎ��s����EXE_DIR��ݒ肷��
EXE_DIR = (File.dirname(File.expand_path($0)).sub(/\\/$/,'') + '/').gsub(/\\//,'\\\\') unless defined?(EXE_DIR)

#�g�p�\���C�u����
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

#�ݒ�ςݒ萔
#EXE_DIR �E�E�E EXE�t�@�C���̂���f�B���N�g��[������\\]
#MAIN_RB �E�E�E ���C����ruby�X�N���v�g�t�@�C����
#ERR_LOG �E�E�E �G���[���O�t�@�C����





#���̃X�v���N�g�𒼐ڎ��s���ɏ��������ɂȂ�B
if (defined?(ExerbRuntime) ? EXE_DIR + MAIN_RB : $0) == __FILE__
  print "�v���O�����̎��s���I�����܂����BEnter�������ĉ������B"
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
      errmsg = "�����������G���[�ňُ�I�����܂����B����������\n\n"
      errmsg += "�����������G���[���b�Z�[�W����������\n" + e.inspect + "\r\n�����������o�b�N�g���[�X����������\r\n"
      e.backtrace.each{|a| errmsg += a + "\n"}
      puts errmsg
      begin
        File.open(err_log_file,'w') do |f|
          errmsg.each do |a|
            f.puts a
          end
        end
        puts "\n�G���[���O�t�@�C��=#{err_log_file}"
      rescue
        puts "\n�G���[���O�t�@�C���͍쐬�o���܂���ł���(�������ݕs��)"
      end
      print "Enter�L�[�������ĉ�����"
      STDIN.gets
    end
  end
else
  puts "#{core_ruby} ������܂���̂ō쐬���܂��B"
  File.open(core_ruby,'w') do |f|
    lib.each do |a|
      f.puts a
    end
  end
  print "Enter�L�[�������ĉ�����"
  STDIN.gets
end
