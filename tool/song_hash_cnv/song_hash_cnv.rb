#! ruby -Ks
# -*- mode:ruby; coding:shift_jis -*-
$KCODE='s'
#直接実行時にEXE_DIRを設定する
EXE_DIR = (File.dirname(File.expand_path($0)).sub(/\/$/,'') + '/').gsub(/\//,'\\') unless defined?(EXE_DIR)

require 'rubygems'
require 'json'
require 'sqlite3.rb'
require 'digest/sha1'
require 'nkf'                            #文字コード変換ライブラリ読み込み (NKF.～ が使えるようになる)

#設定済み定数
#EXE_DIR ・・・ EXEファイルのあるディレクトリ[末尾は\]
#MAIN_RB ・・・ メインのrubyスクリプトファイル名
#ERR_LOG ・・・ エラーログファイル名

song_dir = ARGV[0]
beatsaber_dbfile = EXE_DIR + 'beatsaber.db'
$change_count = 0

unless File.exist?(beatsaber_dbfile)
  puts "Put the beatsaber.db file in the same folder."
  puts "Press the Enter key to Exit."
  a = STDIN.gets
  exit
end

unless song_dir && FileTest.directory?(song_dir)
  puts "Please paste the folder where map is saved and start it."
  puts "Press the Enter key to Exit."
  a = STDIN.gets
  exit
end

$KCODE='NONE'
if beatsaber_dbfile =~ /[^ -~\t]/
  beatsaber_dbfile = NKF.nkf('-w --ic=CP932 -m0 -x',beatsaber_dbfile)
  puts "There are non-ASCII characters in the installation path, so try to convert to UTF-8."
end
$KCODE='s'

$db = SQLite3::Database.new(beatsaber_dbfile)
$err_map = []

#譜面ハッシュ読み込み処理
def map_read(map_dir)
  if FileTest.directory?(map_dir)
    Dir.foreach(map_dir) do |file|      # 中身を一覧
      next if /^\.+$/ =~ file           # 上位ディレクトリと自身を対象から外す
      map_read(map_dir.sub(/\/+$/,"") + "/" + file)
    end
  else
    if map_dir =~ /\/info.dat$/i
      if File.exist?(map_dir)
        puts map_dir.gsub(/\//,'\\')
        info_file = File.read(map_dir)
        hash_file = info_file
        begin
          info_data = JSON.parse(info_file)
        rescue
          puts "****map data read error!****"
          $err_map.push map_dir
          return
        end
        return unless info_data['_difficultyBeatmapSets'] #作成途中譜面などは除外
        info_data['_difficultyBeatmapSets'].each do |beatmap_sets|
          beatmap_sets['_difficultyBeatmaps'].each do |beatmap|
            beatmap_file = File.dirname(map_dir) + "/" + beatmap['_beatmapFilename']
            if File.exist?(beatmap_file)
              hash_file += File.read(beatmap_file)
            end
          end
        end
        hash_data = Digest::SHA1.hexdigest(hash_file).upcase
        old_hash  = 'custom_level_' + hash_data[0,19]
        sql = "UPDATE MovieCutRecord SET songHash = ? WHERE songHash = ? AND songName = ? AND levelAuthorName = ?;"
        $db.execute(sql,hash_data,old_hash,info_data['_songName'],info_data['_levelAuthorName'])
        sql = "SELECT changes();"
        changes = $db.execute(sql)
        if changes[0][0].to_i > 0
          puts "SongHash update =#{changes[0][0]}"
          $change_count += changes[0][0].to_i
        end
      end
    end
  end
end

map_read(song_dir.gsub(/\\/,'/'))
$db.close
unless $err_map == []
  puts
  puts "*****The following map data has been skipped due to an error*****"
  $err_map.each do |map_dir|
    puts map_dir.gsub(/\//,'\\')
  end
end
puts
puts "#{$err_map.size} data skipped." unless $err_map == []
puts "#{$change_count} data updated."
puts "Press the Enter key to finish."
a = STDIN.gets
