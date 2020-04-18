#! ruby -Ks
# -*- mode:ruby; coding:shift_jis -*-
$KCODE='s'


lib = <<EOS
#! ruby -Ks
# -*- mode:ruby; coding:shift_jis -*-
$KCODE='s'

#直接実行時にEXE_DIRを設定する
EXE_DIR = (File.dirname(File.expand_path($0)).sub(/\\/$/,'') + '/').gsub(/\\//,'\\\\') unless defined?(EXE_DIR)

#使用可能ライブラリ
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

#設定済み定数
#EXE_DIR ・・・ EXEファイルのあるディレクトリ[末尾は\\]
#MAIN_RB ・・・ メインのrubyスクリプトファイル名
#ERR_LOG ・・・ エラーログファイル名





#このスプリクトを直接実行時に条件が正になる。
if (defined?(ExerbRuntime) ? EXE_DIR + MAIN_RB : $0) == __FILE__
  print "プログラムの実行を終了しました。Enterを押して下さい。"
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
      errmsg = "★★★★★エラーで異常終了しました。★★★★★\n\n"
      errmsg += "★★★★★エラーメッセージ★★★★★\n" + e.inspect + "\r\n★★★★★バックトレース★★★★★\r\n"
      e.backtrace.each{|a| errmsg += a + "\n"}
      puts errmsg
      begin
        File.open(err_log_file,'w') do |f|
          errmsg.each do |a|
            f.puts a
          end
        end
        puts "\nエラーログファイル=#{err_log_file}"
      rescue
        puts "\nエラーログファイルは作成出来ませんでした(書き込み不可)"
      end
      print "Enterキーを押して下さい"
      STDIN.gets
    end
  end
else
  puts "#{core_ruby} がありませんので作成します。"
  File.open(core_ruby,'w') do |f|
    lib.each do |a|
      f.puts a
    end
  end
  print "Enterキーを押して下さい"
  STDIN.gets
end
