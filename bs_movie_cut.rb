#! ruby -Ks
# -*- mode:ruby; coding:shift_jis -*-
$KCODE='s'

#==============================================================================
#Project Name    : BeatSaber Movie Cut TOOL
#File Name       : bs_movie_cut.rb  _frm_bs_movie_cut.rb
#Creation Date   : 2020/01/08
# 
#Copyright       : 2020 Rynan. (Twitter @rynan4818)
#License         : LGPL
#Tool            : ActiveScriptRuby(1.8.7-p330)
#                  https://www.artonx.org/data/asr/
#                  FormDesigner for Project VisualuRuby Ver 060501
#                  https://ja.osdn.net/projects/fdvr/
#RubyGems Package: rubygems-update (1.8.21)      https://rubygems.org/
#                  json (1.4.6 x86-mswin32)
#                  sqlite3 (1.3.3 x86-mswin32-60)
#==============================================================================


#直接実行時にEXE_DIRを設定する
EXE_DIR = (File.dirname(File.expand_path($0)).sub(/\/$/,'') + '/').gsub(/\//,'\\') unless defined?(EXE_DIR)

#使用可能ライブラリ
#require 'jcode'
#require 'base64'

require 'csv'
require 'rubygems'
require 'sqlite3.rb'                     #SQLite3のデータベースを使うライブラリ読み込み (SQLite3::～ が使えるようになる)
require 'nkf'                            #文字コード変換ライブラリ読み込み (NKF.～ が使えるようになる)
require 'vr/vruby'
require 'vr/vrcontrol'
require 'vr/vrcomctl'
require 'vr/vrddrop.rb'
require 'vr/vrdialog'
require 'vr/clipboard'
require 'win32ole'
require 'Win32API'
require 'time'
require 'json'
require '_frm_bs_movie_cut.rb'

#設定済み定数
#EXE_DIR ・・・ EXEファイルのあるディレクトリ[末尾は\]
#MAIN_RB ・・・ メインのrubyスクリプトファイル名
#ERR_LOG ・・・ エラーログファイル名

#ソフトバージョン
SOFT_VER        = '2020/06/17'
APP_VER_COOMENT = "BeatSaber Movie Cut TOOL Ver#{SOFT_VER}\r\n for ActiveScriptRuby(1.8.7-p330)\r\nCopyright 2020 Rynan.  (Twitter @rynan4818)"

#設定ファイル
SETTING_FILE = EXE_DIR + 'setting.json'

#サイト設定
BEATSAVER_URL   = "https://beatsaver.com/beatmap/#bsr#"
BEASTSABER_URL  = "https://bsaber.com/songs/#bsr#/"
SCORESABAER_URL = "http://scoresaber.com/api.php?function=get-leaderboards&cat=1&page=1&limit=500&ranked=1"

#デフォルト設定
#beatsaberのデータベースファイル名 1,2は検索順序
DEFALUT_DB_FILE_NAME   = "beatsaber.db"
DEFALUT1_DB_FILE       = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Beat Saber\\UserData\\" + DEFALUT_DB_FILE_NAME
DEFALUT2_DB_FILE       = EXE_DIR + DEFALUT_DB_FILE_NAME

DEFALUT_MOD_SETTING_FILE_NAME = "movie_cut_record.json"
DEFAULT_MOD_SETTING_FILE = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Beat Saber\\UserData\\" + DEFALUT_MOD_SETTING_FILE_NAME
DEFAULT_TIMEFORMAT     = "%Y%m%d-%H%M%S"
DEFAULT_PREVIEW_TOOL   = EXE_DIR + "ffplay.exe"
DEFAULT_PREVIEW_FILE   = EXE_DIR + "temp.mp4"
DEFAULT_SUBTITLE_FILE  = EXE_DIR + "subtitle_temp.mp4"
DEFAULT_FFMPEG_OPTION  = ["#DEFALUT#  -c copy","#Twitter#  -vcodec libx264 -pix_fmt yuv420p -strict -2 -acodec aac -ab 256k -vb 10240k","#NO COPY#  "]
DEFAULT_OUT_FILE_NAME  = ['#DEFALUT#  #{time_name}_#{cleared}_#{songName}_#{levelAuthorName}_#{difficulty}_#{rank}_#{scorePercentage}%_#{miss}.mp4',
                          '#SongNameTop#  #{songName}_#{levelAuthorName}_#{cleared}_#{difficulty}_#{rank}_#{scorePercentage}%_#{miss}_#{time_name}.mp4',
                          '#bsrTop#  #{bsr}_#{songName}_#{levelAuthorName}_#{cleared}_#{difficulty}_#{rank}_#{scorePercentage}%_#{miss}_#{time_name}.mp4']
DEFALUT_SIMULTANEOUS_NOTES_TIME = 66 #同時ノーツと判定する時間[ms] 66・・・4フレーム分 1000ms/60fps*4frame
DEFALUT_MAX_NOTES_DISPLAY = 10       #最大表示ノーツスコア数
DEFALUT_LAST_NOTES_TIME = 2.0       #最後の字幕表示時間[sec]
DEFALUT_SUB_FONT        = "ＭＳ ゴシック"
DEFALUT_SUB_FONT2       = "Consolas"
DEFALUT_SUB_FONT_SIZE   = 20
DEFALUT_SUB_ALIGNMENT   = 0
DEFALUT_SUB_RED_NOTES   = "Red "
DEFALUT_SUB_BLUE_NOTES  = "Blue"
DEFALUT_SUB_CUT_FORMAT  = '"%4d:#{note_type}:%2d+%2d+%2d=%3d" % [noteID,(beforeScore == nil ? initialScore : beforeScore),afterScore,cutDistanceScore,finalScore]'
DEFALUT_SUB_MISS_FORMAT = '"%4d:#{note_type}:Miss!" % noteID'
DEFALUT_POST_COMMENT    = ["Song:#songname#\r\nMapper:#mapper#\r\n!bsr #bsr#\r\n\r\n\r\n#BeatSaber\r\n",
                           "#songname# , #mapper# , #songauthor# , #bsr# , #difficulty# , #score# , #rank# , #miss#",
                           "#songname# , #mapper# , #songauthor# , #bsr# , #difficulty# , #score# , #rank# , #miss#"]

#定数
BEATSABER_USERDATA_FOLDER = "[BeatSaber UserData folder]"
SUBTITLE_ALIGNMENT_SETTING = [['1: Bottom left','2: Bottom center','3: Bottom right','5: Top left','6: Top center','7: Top right','9: Middle left',
                              '10: Middle center','11: Middle right'],[1,2,3,5,6,7,9,10,11]]
CURL_TIMEOUT            = 5

$winshell  = WIN32OLE.new("WScript.Shell")
$scoresaber_ranked = nil  #ScoreSaber のランク譜面JSONデータ

#切り出しファイルの保存先  .\\OUT\\はこの実行ファイルのあるフォルダ下の"OUT"フォルダ  フルパスでも可  \は\\にすること  末尾は\\必要
DEFAULT_OUT_FOLDER     = ["#DEFAULT#  " + EXE_DIR + "OUT\\","#sample#  D:\\"]

#SJIS → UTF-8変換#
def utf8cv(str)
  if str.kind_of?(String)                       #引数に渡された内容が文字列の場合のみ変換処理をする
    return NKF.nkf('-w --ic=CP932 -m0 -x',str)  #NKFを使ってSJISをUTF-8に変換して返す
  else
    return str                                  #文字列以外の場合はそのまま返す
  end
end

#UTF-8 → SJIS変換#
def sjiscv(str)
  if str.kind_of?(String)                       #引数に渡された内容が文字列の場合のみ変換処理をする
    return NKF.nkf('-W --oc=CP932 -m0 -x',str)  #NKFを使ってUTF-8をSJISに変換して返す
  else
    return str                                  #文字列以外の場合はそのまま返す
  end
end


#配列内の全ての文字列の文字コードを(UTF-8 → SJIS変換)変更する#
#再帰処理で、配列内の配列にある文字列も全て変換する
def array_sjiscnv(data)
  ar = []                                       #変換後の配列を用意する
  if data.kind_of?(Array)                       #引数に渡された内容が配列の場合は、配列を展開する(配列以外が渡された場合にエラーになるので必要)
    data.each do |a|                            #配列を展開して、一つづつaに取り出して繰り返し処理をする
      if a.kind_of?(Array)                      #展開された内容が、更に配列の場合は再帰処理で変換処理する
        ar.push array_sjiscnv(a)                #再帰処理で自分自身(array_sjiscnv)を呼び出して、文字変換結果を変換後の配列の末尾に追加する
      else
        ar.push sjiscv(a)                       #UTF-8 → SJIS変換した結果を変換後の配列の末尾に追加する
      end
    end
  else
    ar.push sjiscv(a)                           #配列以外の場合は変換結果を変換後の配列の末尾に追加する
  end
  return ar                                     #変換後の配列を返す
end

#配列内の全ての文字列の文字コード(SJIS → UTF-8変換)変更#
#再帰処理で、配列内の配列にある文字列も全て変換する
def array_utf8cnv(data)
  ar = []                                       #変換後の配列を用意する
  if data.kind_of?(Array)                       #引数に渡された内容が配列の場合は、配列を展開する(配列以外が渡された場合にエラーになるので必要)
    data.each do |a|                            #配列を展開して、一つづつaに取り出して繰り返し処理をする
      if a.kind_of?(Array)                      #展開された内容が、更に配列の場合は再帰処理で変換処理する
        ar.push array_utf8cnv(a)                #再帰処理で自分自身(array_utf8cnv)を呼び出して、文字変換結果を変換後の配列の末尾に追加する
      else
        ar.push utf8cv(a)                       #SJIS → UTF-8変換した結果を変換後の配列の末尾に追加する
      end
    end
  else
    ar.push utf8cv(a)                           #配列以外の場合は変換結果を変換後の配列の末尾に追加する
  end
  return ar                                     #変換後の配列を返す
end

###ファイルのタイムスタンプをミリ秒取得
def get_file_timestamp(file)
  #ファイルのタイムスタンプをミリ秒で取得するためWIN32APIを使用する
  create_file              = Win32API.new('kernel32', 'CreateFile', 'PIIIIII', 'I')
  get_file_time            = Win32API.new('kernel32', 'GetFileTime', 'IPPP', 'I')
  close_handle             = Win32API.new('kernel32', 'CloseHandle', 'I', 'I')
  file_time_to_system_time = Win32API.new('kernel32', 'FileTimeToSystemTime', 'PP', 'I')

  # 構造体を返してもらう場所を確保
  lp_creation_time    = "\0" * 4 * 2  # FILETIME = DWORD * 2
  lp_last_access_time = "\0" * 4 * 2  # FILETIME = DWORD * 2
  lp_last_write_time  = "\0" * 4 * 2  # FILETIME = DWORD * 2
  lp_system_time      = "\0" * 2 * 8  # SYSTEMTIME = WORD * 8

  h_file = create_file.call(file, 0x80000000, 0, 0, 3, 0, 0)
  get_file_time.call(h_file, lp_creation_time, lp_last_access_time, lp_last_write_time)
  close_handle.call(h_file)

  #作成時刻
  file_time_to_system_time.call(lp_creation_time, lp_system_time)
  year, mon, wday, day, hour, min, sec, msec =  lp_system_time.unpack('S8')
  create_time =  Time.gm(year, mon, day, hour, min, sec).to_i * 1000 + msec

  #最終アクセス時刻
  file_time_to_system_time.call(lp_last_access_time, lp_system_time)
  year, mon, wday, day, hour, min, sec, msec =  lp_system_time.unpack('S8')
  access_time = Time.gm(year, mon, day, hour, min, sec).to_i * 1000 + msec

  #最終書き込み時刻
  file_time_to_system_time.call(lp_last_write_time, lp_system_time)
  year, mon, wday, day, hour, min, sec, msec =  lp_system_time.unpack('S8')
  write_time = Time.gm(year, mon, day, hour, min, sec).to_i * 1000 + msec
  return([create_time,access_time,write_time])
end

###beatsaberのデータベースを開く処理###
def db_open
  #データーベースのオープン処理
  begin                                               #例外処理(begin～rescue内でエラーが発生した場合はrescueの処理が実行される
    if $ascii_mode
      #SQLite3のデータベース(*.db)を開いてインスタンス変数@dbでアクセスできるようにする。
      @db = SQLite3::Database.new($beatsaber_dbfile)
    else
      #ファイル名が全角文字があるのでUTF-8に変換して渡す
      @db = SQLite3::Database.new(utf8cv($beatsaber_dbfile))  
    end
  rescue Exception => e                               #エラー内容がeに入る
    if e.inspect =~ /unable to open database file/    #エラー内容がデータベースが開けない内容の場合
      messageBox("beatsaber DB File open error\r\n#{$beatsaber_dbfile}","DB FILE OPEN ERROR",48)
    else
      messageBox("beatsaber DB error:" + e.inspect,"DB ERROR",16)
    end
  end
end

def db_column_check(table,column,type)
  #データベースのカラムチェック
  sql = "PRAGMA table_info('#{table}');"
  fields, *rows = @db.execute2(sql)
  column_check = true
  rows.each do |row|
    if column == row[fields.index('name')]
      column_check = false
      break
    end
  end
  if column_check && rows.size > 0
    sql = "ALTER TABLE #{table} ADD COLUMN #{column} #{type};"
    @db.execute(sql)
  end
end

def db_check
  #データベースチェック
  db_open
  sql = "CREATE TABLE IF NOT EXISTS MovieOriginalTime(" +
        "filename TEXT NOT NULL PRIMARY KEY," +
        "create_time INTEGER NOT NULL," +
        "access_time INTEGER NOT NULL," +
        "write_time INTEGER NOT NULL);"
  @db.execute(sql)
  sql = "CREATE TABLE IF NOT EXISTS MovieCutFile(" +
        "datetime INTEGER NOT NULL," +
        "startTime INTEGER NOT NULL," +
        "out_dir TEXT NOT NULL," +
        "filename TEXT NOT NULL," +
        "stoptime INTEGER NOT NULL);"
  @db.execute(sql)
  db_column_check('MovieCutRecord','levelId','TEXT')
  db_column_check('NoteScore','beforeScore','INTEGER')
  @db.close
end

def db_execute(sql,db_open_flag = true,db_close_flag = true,no_table_mes = true)
  #データベースSQL実行
  db_open if db_open_flag
  begin
    if $ascii_mode
      fields, *rows = @db.execute2(sql)
    else
      fields, *rows = array_sjiscnv(@db.execute2(utf8cv(sql)))
    end
  rescue Exception => e
    @db.close if db_close_flag
    if e.inspect =~ /no such table/
      messageBox("No play record in database","No play record",48) if no_table_mes
      return "no_table" unless no_table_mes
    else
      messageBox("beatsaber DB error:" + e.inspect,"DB ERROR",16)
    end
    return false
  end
  @db.close if db_close_flag
  return [fields,rows]
end

def file_name_check(file_name)
  if $ascii_mode
    $KCODE='NONE'
    file_name.gsub!(/[^ -~\t]/,' ')                   #ASCII 文字以外を空白に変換
    file_name.gsub!(/[\\\/:\*\?\"<>\|]/,' ')          #ファイル名に使えない文字を空白に変換
    $KCODE='s'
  else
    file_name.gsub!("\\","￥") #ファイル名に使えない文字を全角に変換
    file_name.gsub!("/","／")  #ファイル名に使えない文字を全角に変換
    file_name.gsub!(":","：")  #ファイル名に使えない文字を全角に変換
    file_name.gsub!("*","＊")  #ファイル名に使えない文字を全角に変換
    file_name.gsub!("?","？")  #ファイル名に使えない文字を全角に変換
    file_name.gsub!("\"","￥") #ファイル名に使えない文字を全角に変換
    file_name.gsub!("<","＜")  #ファイル名に使えない文字を全角に変換
    file_name.gsub!(">","＞")  #ファイル名に使えない文字を全角に変換
    file_name.gsub!("|","｜")  #ファイル名に使えない文字を全角に変換
  end
  return file_name
end

def bsr_search(songHash)
  beatsaver_data = {}
  if songHash =~ /^[0-9A-F]{40}/i
    begin
      beatsaver_data = JSON.parse(`curl.exe --connect-timeout #{CURL_TIMEOUT} https://beatsaver.com/api/maps/by-hash/#{songHash[0,40]}`)
      bsr = beatsaver_data['key']
    rescue
      bsr = 'err'
    end
  else
    bsr = 'nil'
  end
  return [bsr,beatsaver_data]
end

def ranked_check(song_hash,difficulty,mode)
  unless $scoresaber_ranked
    SCORESABAER_URL =~ /limit=(\d+)/
    limit = $1.to_i
    $scoresaber_ranked = {"songs" => []}
    page = 0
    begin
      begin
        page += 1
        url = SCORESABAER_URL.sub(/page=1/,"page=#{page}")
        temp = JSON.parse(`curl.exe --connect-timeout #{CURL_TIMEOUT * 4} #{url}`)
        $scoresaber_ranked["songs"] += temp["songs"]
        rank_map_count = $scoresaber_ranked["songs"].size
      end while rank_map_count >= limit * page
      puts "Rank map count = #{rank_map_count}"
    rescue
      $scoresaber_ranked = {}
      puts "ScoreSaber ERROR!"
    end
  end
  if $scoresaber_ranked == {}
    return false
  else
    $scoresaber_ranked["songs"].each do |song|
      return 1 if song["id"] == song_hash && song["diff"] == "_#{difficulty.sub(/\+/,"Plus")}_#{mode}" && song["ranked"] == 1
    end
  end
  return 2
end

def open_url(url)
  begin
    #外部プログラム呼び出しで、処理待ちしないためWSHのRunを使う
    $winshell.Run(%Q!"#{url}"!)
  rescue Exception => e
    messageBox("WScript.Shell Error\r\n#{e.inspect}","Web page open ERROR",16)
  end
end

class Modaldlg_post_comment

  def self.set(target,fields)
    @@target = target
    @@fields = fields
  end
  
  def self_created
    @save = false
    @defalut_style = @checkBox_save.style
    template(0)
    self.caption += " : " + @@target[1][@@fields.index("songName")]
  end
  
  def template(idx)
    if @checkBox_save.checked?
      $post_commnet[idx] = @text_main.text.gsub(/\r\n/,"\n").gsub(/\n/,"\r\n")
      @checkBox_save.check(false)
      @save = true
    else
      @text_main.text = $post_commnet[idx].gsub(/\r\n/,"\n").gsub(/\n/,"\r\n")
    end
    if @checkBox_save.style == 0x58000003
      @checkBox_save.style = 0x50000003
      @button_generate.style = 1342177280
      refresh(true)
    end
  end
  
  def button_1_clicked
    template(0)
  end

  def button_2_clicked
    template(1)
  end

  def button_3_clicked
    template(2)
  end

  def button_generate_clicked
    @checkBox_save.check(false)
    @checkBox_save.style = 0x58000003
    @button_generate.style = 1476395008
    refresh(true)
    parameter = ["#songname#" , "#mapper#" , "#songauthor#" , "#bsr#" , "#difficulty#" , "#score#" , "#rank#" , "#miss#"]
    convert   = [@@target[1][@@fields.index("songName")]]
    convert.push @@target[1][@@fields.index("levelAuthorName")]
    convert.push @@target[1][@@fields.index("songAuthorName")]
    convert.push bsr_search(@@target[1][@@fields.index("songHash")])[0]
    convert.push @@target[1][@@fields.index("difficulty")]
    convert.push @@target[1][@@fields.index("scorePercentage")]
    convert.push @@target[1][@@fields.index("rank")]
    convert.push @@target[1][@@fields.index("missedNotes")]
    generate_text = @text_main.text.gsub(/\r\n/,"\n").gsub(/\n/,"\r\n")
    parameter.each_with_index do |param,idx|
      generate_text = generate_text.gsub(Regexp.new("#{Regexp.escape(param)}"),convert[idx].to_s)
    end
    @text_main.text = generate_text
  end

  def button_copy_clicked
    Clipboard.open(self.hWnd) do |cb|
      cb.setText @text_main.text.gsub(/\r\n/,"\n").gsub(/\n/,"\r\n")
    end
    messageBox("Copying Post comment","Copy comment",0x40)
  end

  def button_close_clicked
    close(@save)
  end

end

class Modaldlg_db_view

  def self.set(search_dir)
    @@search_dir = []
    search_dir.each do |dir|
      @@search_dir.push dir.strip.sub(/\\$/,'') + '\\'
    end
  end

  def self_created
    #データベースに登録済みのファイルのタイムスタンプの確認
    sql = "SELECT MIN(startTime) FROM MovieCutRecord;"
    fields, startdate = db_execute(sql, true, false)
    if startdate.size == 0
      @db.close
      return
    end
    startdate = startdate[0][0].to_i / 1000
    @edit_start_year.text  = Time.at(startdate).localtime.strftime("%Y")
    @edit_start_month.text = Time.at(startdate).localtime.strftime("%m").to_i.to_s
    @edit_start_day.text   = Time.at(startdate).localtime.strftime("%d").to_i.to_s
    sql = "SELECT MAX(menuTime) FROM MovieCutRecord;"
    fields, enddate = db_execute(sql, false, true)
    enddate = enddate[0][0].to_i / 1000
    @edit_end_year.text  = Time.at(enddate).localtime.strftime("%Y")
    @edit_end_month.text = Time.at(enddate).localtime.strftime("%m").to_i.to_s
    @edit_end_day.text   = Time.at(enddate).localtime.strftime("%d").to_i.to_s
    @checkBox_allread.check true
    @edit_start_year.readonly = true
    @edit_start_month.readonly = true
    @edit_start_day.readonly = true
    @edit_end_year.readonly = true
    @edit_end_month.readonly = true
    @edit_end_day.readonly = true
    @search_dir_list = []
    @search_dir_list.push $open_dir.strip.sub(/\\$/,'') + '\\' unless $open_dir.strip == ""
    @search_dir_list += @@search_dir if @@search_dir.size > 0
    $input_movie_search_dir.each do |dir|
      @search_dir_list.push dir.strip.sub(/\\$/,'') + '\\'
    end
    @listBox_search_dir.setListStrings @search_dir_list
  end
  
  def button_cancel_clicked
    close(false)
  end

  def button_ok_clicked
    start_time = Time.local(@edit_start_year.text,@edit_start_month.text,@edit_start_day.text,0,0,0).gmtime.to_i * 1000
    end_time = Time.local(@edit_end_year.text,@edit_end_month.text,@edit_end_day.text,23,59,59).gmtime.to_i * 1000
    close([@checkBox_allread.checked?, start_time, end_time, @search_dir_list])
  end
  
  def checkBox_allread_clicked
    if @checkBox_allread.checked?
      @edit_start_year.readonly = true
      @edit_start_month.readonly = true
      @edit_start_day.readonly = true
      @edit_end_year.readonly = true
      @edit_end_month.readonly = true
      @edit_end_day.readonly = true
    else
      @edit_start_year.readonly = false
      @edit_start_month.readonly = false
      @edit_start_day.readonly = false
      @edit_end_year.readonly = false
      @edit_end_month.readonly = false
      @edit_end_day.readonly = false
    end
  end
  
end

class Modaldlg_search

  def self.set(target,fields)
    @@target = target
    @@fields = fields
  end

  def self_created
    @radioBtn_all.check(true)
  end
  
  def button_songname_copy_clicked
    return unless @@target
    @edit_songname.text = @@target[1][@@fields.index("songName")]
  end

  def button_author_copy_clicked
    return unless @@target
    @edit_author.text = @@target[1][@@fields.index("levelAuthorName")]
  end

  def button_cancel_clicked
    close(false)
  end

  def button_ok_clicked
    if @radioBtn_ranked.checked?
      ranked = 1
    elsif @radioBtn_unranked.checked?
      ranked = 2
    else
      ranked = 0
    end
    close([@edit_songname.text.strip,@edit_author.text.strip,ranked])
  end

end

class Modaldlg_subtitle_setting

  def self_created
    @button_msGothic.caption = DEFALUT_SUB_FONT
    @button_consolas.caption = DEFALUT_SUB_FONT2
    alignment = SUBTITLE_ALIGNMENT_SETTING[0]
    @comboBox_alignment.setListStrings(alignment)
    @comboBox_alignment.select($subtitle_alignment)
    @edit_font.text = $subtitle_font
    @edit_fontsize.text = $subtitle_font_size.to_s
    @edit_red_notes.text = $subtitle_red_notes
    @edit_blue_notes.text = $subtitle_blue_notes
    @edit_cut_format.text = $subtitle_cut_format
    @edit_miss_format.text = $subtitle_miss_format
    @edit_sim_notes_time.text = $simultaneous_notes_time.to_s
    @edit_last_notes.text = $last_notes_time.to_s
    @edit_max_score.text = $max_notes_display.to_s
    if $ascii_mode
      @button_msGothic.style = 0x8000000
      if @edit_font.text == DEFALUT_SUB_FONT
        @edit_font.text = DEFALUT_SUB_FONT2
      end
    end
  end

  def button_msGothic_clicked
    @edit_font.text = DEFALUT_SUB_FONT
  end

  def button_consolas_clicked
    @edit_font.text = DEFALUT_SUB_FONT2
  end

  def button_cut_default_clicked
    @edit_cut_format.text = DEFALUT_SUB_CUT_FORMAT
  end

  def button_miss_default_clicked
    @edit_miss_format.text = DEFALUT_SUB_MISS_FORMAT
  end

  def button_cancel_clicked
    close(false)
  end

  def button_ok_clicked
    $subtitle_font = @edit_font.text
    $subtitle_font_size = @edit_fontsize.text.to_i
    $subtitle_alignment = @comboBox_alignment.selectedString
    $subtitle_red_notes = @edit_red_notes.text
    $subtitle_blue_notes = @edit_blue_notes.text
    $subtitle_cut_format = @edit_cut_format.text
    $subtitle_miss_format = @edit_miss_format.text
    $simultaneous_notes_time = @edit_sim_notes_time.text.to_i
    $max_notes_display  = @edit_max_score.text.to_i
    $last_notes_time    = @edit_last_notes.text.to_f
    close(true)
  end

end

class Modaldlg_modsetting
  
  def form_setting
    setting = JSON.parse(File.read(@edit_mod_setting_file.text.strip))
    if setting['dbfile'] && File.directory?(File.dirname(setting['dbfile']))
      @edit_dbfile.text = setting['dbfile']
      @edit_dbfile.readonly = false
    else
      @edit_dbfile.text = BEATSABER_USERDATA_FOLDER
      @edit_dbfile.readonly = true
    end
    @edit_dbfile.text  ? true : setting['dbfile']
    @checkBox_scenechange.check setting['http_scenechange'] == nil ? true : setting['http_scenechange']
    @checkBox_scorechanged.check setting['http_scorechanged'] == nil ? true : setting['http_scorechanged']
    @checkBox_notecut.check setting['http_notecut'] == nil ? true : setting['http_notecut']
    @checkBox_notefullycut.check setting['http_notefullycut'] == nil ? true : setting['http_notefullycut']
    @checkBox_notemissed.check setting['http_notemissed'] == nil ? true : setting['http_notemissed']
    @checkBox_bombcut.check setting['http_bombcut'] == nil ? true : setting['http_bombcut']
    @checkBox_bombmissed.check setting['http_bombmissed'] == nil ? true : setting['http_bombmissed']
    @checkBox_beatmapevent.check setting['http_beatmapevent'] == nil ? true : setting['http_beatmapevent']
    @checkBox_obstacle.check setting['http_obstacle'] == nil ? true : setting['http_obstacle']
    @checkBox_notesscore.check setting['db_notes_score'] == nil ? true : setting['db_notes_score']
    @checkBox_gccollect.check setting['gc_collect'] == nil ? true : setting['gc_collect']
  end

  def setting_load
    if File.exist?($mod_setting_file.strip)
      @edit_mod_setting_file.text = $mod_setting_file.strip
      form_setting
    else
      default_load
    end
  end
  
  def setting_save
    if File.exist?(@edit_mod_setting_file.text.strip)
      setting = JSON.parse(File.read(@edit_mod_setting_file.text.strip))
    else
      setting = {}
    end
  end
  
  def default_load
    folder = File.dirname($mod_setting_file)
    if File.directory?(folder)
      @edit_mod_setting_file.text = folder + "\\" + DEFALUT_MOD_SETTING_FILE_NAME
    else
      @edit_mod_setting_file.text = ""
    end
    @edit_dbfile.text = BEATSABER_USERDATA_FOLDER
    @edit_dbfile.readonly = true
    @checkBox_notesscore.check true
    @checkBox_gccollect.check true
    @checkBox_scenechange.check true
    @checkBox_scorechanged.check true
    @checkBox_notecut.check true
    @checkBox_notefullycut.check true
    @checkBox_notemissed.check true
    @checkBox_bombcut.check true
    @checkBox_bombmissed.check true
    @checkBox_beatmapevent.check true
    @checkBox_obstacle.check true
  end
  
  def self_created
    setting_load
  end
  
  def button_modsetting_select_clicked
    folder = File.dirname(@edit_mod_setting_file.text)
    folder = "" unless File.directory?(folder)
    file = File.basename(@edit_mod_setting_file.text)
    file = DEFALUT_MOD_SETTING_FILE_NAME if file.strip == ""
    filename = SWin::CommonDialog::openFilename(self,[["json File (*.json)","*.json"],["All File (*.*)","*.*"]],0x4,"movie_cut_record.json select","*.json",folder,file)
    return unless filename
    @edit_mod_setting_file.text = filename
    form_setting if File.exist?(filename)
  end

  def button_db_select_clicked
    if @edit_dbfile.text == BEATSABER_USERDATA_FOLDER
      folder = File.dirname(@edit_mod_setting_file.text)
      file = DEFALUT_DB_FILE_NAME
    else
      folder = File.dirname(@edit_dbfile.text)
      folder = File.dirname($beatsaber_dbfile) unless File.directory?(folder)
      file = File.basename(@edit_dbfile.text)
      file = File.basename($beatsaber_dbfile) if file.strip == ""
      end
    filename = SWin::CommonDialog::openFilename(self,[["db File (*.db)","*.db"],["All File (*.*)","*.*"]],0x4,"beatsaber.db select","*.db",folder,file)
    return unless filename
    if (File.dirname(@edit_mod_setting_file.text) + "\\" + DEFALUT_DB_FILE_NAME) =~ /#{Regexp.escape(filename)}/i
      @edit_dbfile.text = BEATSABER_USERDATA_FOLDER
      @edit_dbfile.readonly = true
    else
      @edit_dbfile.text = filename
      @edit_dbfile.readonly = false
      end
  end

  def button_bs_userfolder_clicked
    @edit_dbfile.text = BEATSABER_USERDATA_FOLDER
    @edit_dbfile.readonly = true
  end
  
  def button_cancel_clicked
    close(false)
  end
  
  def button_ok_clicked
    folder = File.dirname(@edit_mod_setting_file.text)
    unless File.directory?(folder)
      messageBox("'#{folder.to_s}' Folder not found\r\nSet up the mod setting file.","Mod setting folder not found",48)
      return
    end
    file = File.basename(@edit_mod_setting_file.text)
    if file.strip == ""
      messageBox("'#{@edit_mod_setting_file.text}' filename error\r\nSet up the mod setting file.","Mod setting filename error",48)
      return
    end
    if File.exist?(@edit_mod_setting_file.text)
      setting = JSON.parse(File.read(@edit_mod_setting_file.text))
    else
      setting = {}
    end
    if @edit_dbfile.text == BEATSABER_USERDATA_FOLDER
      setting['dbfile'] = nil
    else
      setting['dbfile'] = @edit_dbfile.text.strip
    end
    setting['http_scenechange'] = @checkBox_scenechange.checked?
    setting['http_scorechanged'] = @checkBox_scorechanged.checked?
    setting['http_notecut'] = @checkBox_notecut.checked?
    setting['http_notefullycut'] = @checkBox_notefullycut.checked?
    setting['http_notemissed'] = @checkBox_notemissed.checked?
    setting['http_bombcut'] = @checkBox_bombcut.checked?
    setting['http_bombmissed'] = @checkBox_bombmissed.checked?
    setting['http_beatmapevent'] = @checkBox_beatmapevent.checked?
    setting['http_obstacle'] = @checkBox_obstacle.checked?
    setting['db_notes_score'] = @checkBox_notesscore.checked?
    setting['gc_collect'] = @checkBox_gccollect.checked?
    $mod_setting_file = @edit_mod_setting_file.text.strip
    File.open($mod_setting_file,'w') do |file|
      JSON.pretty_generate(setting).each do |line|
        file.puts line
      end
    end
    close(true)
  end
  
end

class Modaldlg_timestamp
  include VRDropFileTarget

  def self_created
    @static_timezone.caption = Time.now.zone
    @access_time = false
  end
  #ドラッグ＆ドロップ貼り付け
  def self_dropfiles(files)
    start_time_check(files[0])
  end
  
  def end_time_check
    if File.exist? @edit_moviefile.text.strip
      check_json = `ffprobe -v quiet -of json -show_format "#{@edit_moviefile.text.strip}"`
      probe = JSON.parse(check_json)
      duration = probe['format']['duration'].to_f
      length_h = duration.to_i / 3600
      length_m = (duration.to_i - (length_h * 3600)) / 60
      length_s = duration.to_i - ((length_h * 3600) + (length_m * 60))
      length_msec = duration.to_s.sub(/^\d+\.(\d{1,3})\d*$/,'\1').to_i
      @static_length.caption = "#{length_h}:#{length_m}:#{length_s}.#{length_msec}"
      end_time = Time.parse("#{@edit_start_date.text} #{@edit_start_time.text}") + duration.to_i
      msec = @edit_start_msec.text.to_i + length_msec
      if msec >= 1000
        end_time += 1
        msec -= 1000
      end
      @edit_end_date.text = end_time.strftime("%Y/%m/%d")
      @edit_end_time.text = end_time.strftime("%H:%M:%S")
      @edit_end_msec.text = msec.to_s
    else
      messageBox("Movie file not found","Movie file not found",48)
    end
  end
  
  def start_time_check(filename)
    @access_time = false
    @edit_moviefile.text = filename
    filename = File.basename(filename)
    if filename =~ /(\d{4})\D?(\d{2})\D?(\d{2})\D*(\d{2})\D?(\d{2})\D?(\d{2}){0,1}/
      @edit_start_date.text = "#{$1}/#{$2}/#{$3}"
      if $6
        sec = $6
      else
        sec = '00'
      end
      @edit_start_time.text = "#{$4}:#{$5}:#{sec}"
      @edit_start_msec.text = '0'
      end_time_check
    end
    
  end
  
  def button_select_clicked
    filename = SWin::CommonDialog::openFilename(self,[["Mkv File (*.mkv)","*.mkv"],["Avi File (*.avi)","*.avi"],["mp4 File (*.mp4)","*.mp4"],["All File (*.*)","*.*"]],0x1004,"Movie file select","*.mkv") #ファイルを開くダイアログを開く
    return unless filename                               #ファイルが選択されなかった場合、キャンセルされた場合は戻る
    return unless File.exist?(filename)                  #filenameのファイルが存在しなければ戻る
    start_time_check(filename)
  end
  
  def button_cancel_clicked
    close(false)
  end
  
  def button_ok_clicked
    start_time = Time.parse("#{@edit_start_date.text} #{@edit_start_time.text}").to_i * 1000 + @edit_start_msec.text.to_i
    end_time   = Time.parse("#{@edit_end_date.text} #{@edit_end_time.text}").to_i * 1000 + @edit_end_msec.text.to_i
    filename = File.basename(@edit_moviefile.text.strip)
    ##データベース処理
    db_open
    #データベースに登録済みのファイルのタイムスタンプの確認
    sql = "SELECT * FROM MovieOriginalTime WHERE filename = '#{filename}';"
    if $ascii_mode
      fields, *rows = @db.execute2(sql)
    else
      fields, *rows = array_sjiscnv(@db.execute2(utf8cv(sql)))
    end
    #データベースの更新
    if @access_time
      access_time = @access_time
    else
      access_time = end_time
    end
    if rows.size == 0
      sql = "INSERT INTO MovieOriginalTime(filename, create_time, access_time, write_time) VALUES (?, ?, ?, ?);"
      if $ascii_mode
        @db.execute(sql,filename,start_time,access_time,end_time)
      else
        @db.execute(utf8cv(sql),utf8cv(filename),start_time,access_time,end_time)
      end
    else
      sql = "UPDATE MovieOriginalTime SET create_time = ?, access_time = ?, write_time = ? WHERE filename = ?;"
      if $ascii_mode
        @db.execute(sql,start_time,access_time,end_time,filename)
      else
        @db.execute(utf8cv(sql),start_time,access_time,end_time,utf8cv(filename))
      end
    end
    @db.close
    close(@edit_moviefile.text.strip)
  end
  def button_end_time_clicked
    end_time_check
  end
  def button_fileget_clicked
    if File.exist? @edit_moviefile.text.strip
      create_time, @access_time, write_time = get_file_timestamp(@edit_moviefile.text.strip)
      start_time = Time.at(create_time / 1000)
      end_time   = Time.at(write_time / 1000)
      @edit_start_date.text = start_time.strftime("%Y/%m/%d")
      @edit_start_time.text = start_time.strftime("%H:%M:%S")
      @edit_start_msec.text = (create_time % 1000).to_s
      @edit_end_date.text = end_time.strftime("%Y/%m/%d")
      @edit_end_time.text = end_time.strftime("%H:%M:%S")
      @edit_end_msec.text = (write_time % 1000).to_s
    end
  end
end


class Modaldlg_setting

  def self_created
    @edit_dbfile.text        = $beatsaber_dbfile.to_s
    @edit_previewtool.text   = $preview_tool.to_s
    @edit_previewtool_option.text = $preview_tool_option.to_s
    @edit_time_format.text   = $time_format.to_s
    @edit_preview_temp.text  = $preview_file.to_s
    @edit_subtitle_temp.text = $subtitle_file.to_s
    @edit_offset.text        = $offset.to_s
    @edit_opendir.text       = $open_dir.to_s
    @edit_extension.text     = $movie_default_extension.to_s
    @checkBox_timesave.check $time_save
    @checkBox_ascii.check    $ascii_mode
    @checkBox_no_message.check $timestamp_nomsg
    @checkBox_stop_time_menu.check $use_endtime
    @groupBox_Preview.radioBtn_copy.check true unless $preview_encode
    @groupBox_Preview.radioBtn_select.check $preview_encode
  end
  
  def button_db_select_clicked
    folder = nil
    if $beatsaber_dbfile
      if File.exist? $beatsaber_dbfile
        folder = File.dirname($beatsaber_dbfile)
        file   = File.basename($beatsaber_dbfile)
      else
        folder = File.dirname($beatsaber_dbfile)
        if File.directory? folder
          file = DEFALUT_DB_FILE_NAME
        end
      end
    end
    unless folder
      if File.directory? File.dirname(DEFALUT1_DB_FILE)
        folder = File.dirname(DEFALUT1_DB_FILE)
        file = DEFALUT_DB_FILE_NAME
      elsif File.directory? EXE_DIR
        folder = EXE_DIR
        file = DEFALUT_DB_FILE_NAME
      else
        folder = ''
        file = DEFALUT_DB_FILE_NAME
      end
    end
    #ファイルを開くダイアログを開く(第7引数のデフォルトファイル名は標準のVisualuRubyだと対応していない、swin.soの改造が必要
    filename = SWin::CommonDialog::openFilename(self,[["db File (*.db)","*.db"],["All File (*.*)","*.*"]],0x4,"beatsaber.db select","*.db",folder,file)
    return unless filename                               #ファイルが選択されなかった場合、キャンセルされた場合は戻る
    @edit_dbfile.text = filename
  end

  def button_opendir_select_clicked
    if @edit_opendir.text.to_s.strip == ""
      defalut = nil
    else
      defalut = @edit_opendir.text.to_s.strip
    end
    folder = SWin::CommonDialog::selectDirectory(self,title="select open movie folder",defalut,1)
    return unless folder                                 #ファイルが選択されなかった場合、キャンセルされた場合は戻る
    return unless File.exist?(folder)                    #folderのファイルが存在しなければ戻る
    @edit_opendir.text = folder
  end

  def button_cancel_clicked
    close(false)
  end

  def button_default_clicked
    @edit_time_format.text = DEFAULT_TIMEFORMAT
  end

  def button_ok_clicked
    if File.exist? @edit_dbfile.text.to_s.strip
      $beatsaber_dbfile = @edit_dbfile.text.to_s.strip
    else
      if @edit_dbfile.text.to_s.strip != '' && File.directory?(File.dirname(@edit_dbfile.text.to_s.strip))
        if messageBox("#{$beatsaber_dbfile}\r\nCreate a new file?","Create a new file?",36) == 6 #はい
          $beatsaber_dbfile = @edit_dbfile.text.to_s.strip
          db_check
        else
          if messageBox("Database file no setting.\r\nReturn the setting?","Database file no setting",36) == 6 #はい
            return
          end
        end
      else
        if messageBox("Database file no setting.\r\nReturn the setting?","Database file no setting",36) == 6 #はい
          return
        end
      end
    end
    if File.exist? @edit_previewtool.text.to_s.strip
      $preview_tool = @edit_previewtool.text.to_s.strip
    else
      if messageBox("Preview tool no setting.\r\nReturn the setting?","Preview tool no setting",36) == 6 #はい
        return
      end
    end
    if File.directory?(File.dirname(@edit_preview_temp.text.to_s.strip))
      $preview_file = @edit_preview_temp.text.to_s.strip
    else
      if messageBox("Preview temporary file no folder.\r\nReturn the setting?","Preview temporary file no folder",36) == 6 #はい
        return
      end
    end
    if File.directory?(File.dirname(@edit_subtitle_temp.text.to_s.strip))
      $subtitle_file = @edit_subtitle_temp.text.to_s.strip
    else
      if messageBox("Score subtitle temporary file no folder.\r\nReturn the setting?","Score subtitle temporary file no folder",36) == 6 #はい
        return
      end
    end
    $preview_tool_option = @edit_previewtool_option.text.to_s.strip
    $offset       = @edit_offset.text.strip.to_f
    $time_format  = @edit_time_format.text.to_s.strip
    $open_dir      = @edit_opendir.text.to_s.strip
    $movie_default_extension = @edit_extension.text.to_s.strip
    $time_save    = @checkBox_timesave.checked?
    $ascii_mode   = @checkBox_ascii.checked?
    $timestamp_nomsg = @checkBox_no_message.checked?
    $use_endtime = @checkBox_stop_time_menu.checked?
    $preview_encode = @groupBox_Preview.radioBtn_select.checked?
    close(true)
  end

  def button_preview_select_clicked
    folder   = File.dirname(@edit_previewtool.text.to_s.strip)
    folder   = EXE_DIR unless File.directory?(folder)
    filename = File.basename(@edit_previewtool.text.to_s.strip)
    filename = 'ffplay.exe' if filename.strip == ''
    filename = SWin::CommonDialog::openFilename(self,[["exe File (*.exe)","*.exe"],["All File (*.*)","*.*"]],0x1004,"Preview tool select","*.exe",folder,filename)
    return unless filename                               #ファイルが選択されなかった場合、キャンセルされた場合は戻る
    return unless File.exist?(filename)                  #filenameのファイルが存在しなければ戻る
    @edit_previewtool.text = filename
  end

  def button_parameter_clicked
    open_url("https://docs.ruby-lang.org/ja/1.8.7/method/Time/i/strftime.html")
  end
  
  def button_preview_temp_clicked
    folder   = File.dirname(@edit_preview_temp.text.to_s.strip)
    folder   = EXE_DIR unless File.directory?(folder)
    filename = File.basename(@edit_preview_temp.text.to_s.strip)
    filename = 'temp.mp4' if filename.strip == ''
    #ファイルを開くダイアログを開く(第7引数のデフォルトファイル名は標準のVisualuRubyだと対応していない、swin.soの改造が必要
    filename = SWin::CommonDialog::openFilename(self,[["mp4 File (*.mp4)","*.mp4"],["All File (*.*)","*.*"]],0x4,"Preview temporary file","*.mp4",folder,filename)
    return unless filename                               #ファイルが選択されなかった場合、キャンセルされた場合は戻る
    @edit_preview_temp.text = filename
  end
  
  def button_subtitle_temp_clicked
    folder   = File.dirname(@edit_subtitle_temp.text.to_s.strip)
    folder   = EXE_DIR unless File.directory?(folder)
    filename = File.basename(@edit_subtitle_temp.text.to_s.strip)
    filename = 'temp.mp4' if filename.strip == ''
    #ファイルを開くダイアログを開く(第7引数のデフォルトファイル名は標準のVisualuRubyだと対応していない、swin.soの改造が必要
    filename = SWin::CommonDialog::openFilename(self,[["mp4 File (*.mp4)","*.mp4"],["All File (*.*)","*.*"]],0x4,"Subtitle temporary file","*.mp4",folder,filename)
    return unless filename                               #ファイルが選択されなかった場合、キャンセルされた場合は戻る
    @edit_subtitle_temp.text = filename
  end
  
end

class Form_main
  include VRDropFileTarget
  #起動時処理
  def self_created
    if $Exerb
      #アイコンの設定
      extractIconA = Win32API.new('shell32','ExtractIconA','LPI','L')
      myIconData = extractIconA.Call(0, "#{EXE_DIR}#{File.basename(MAIN_RB, '.*')}.exe", 0)
      sendMessage(128, 0, myIconData)
    end
    self.caption += "  Ver #{SOFT_VER}"
    @tz_static.caption = Time.now.zone
    @movie_files = []        #動画リスト
    @convert_list = []       #切り出しマップリスト
    @original_convert_list = [] #データベースから読みだした初期値
    @list_sort = nil         #リストのソート対象
    @list_desc_order = false #リストの降順
    setting_load
    printing_check
    if $beatsaber_dbfile
      unless File.exist?($beatsaber_dbfile)
        messageBox("'#{$beatsaber_dbfile}' File not found\r\nOpen the setting screen, change the settings and select the file.","db File not found",48)
        exit unless VRLocalScreen.openModalDialog(self,nil,Modaldlg_setting,nil,nil)  #設定画面のモーダルダイアログを開く
        setting_save(false)
      end
    else
      messageBox("'beatsaber.db' File not found\r\nOpen the setting screen, change the settings and select the file.","beatsaber.db File not found",48)
      exit unless VRLocalScreen.openModalDialog(self,nil,Modaldlg_setting,nil,nil)  #設定画面のモーダルダイアログを開く
      setting_save(false)
    end
    exit unless $beatsaber_dbfile
    exit unless File.exist? $beatsaber_dbfile
    db_check
    #リストボックスにタブストップを設定
    #[0x192,タブストップの数,[タブストップの位置,…]]  FormDesignerでstyleのLBS_USETABSTOPSのチェックが必要
    #0x192:LB_SETTABSTOPS  l*:32bit符号つき整数
    @listBox_map.sendMessage(0x192, 11,[24,80,102,128,149,181,202,227,253,283,435].pack('l*'))
    @listBox_file.sendMessage(0x192, 1,[24].pack('l*'))
  end

  #ドラッグ＆ドロップ貼り付け
  def self_dropfiles(files)
    @movie_files = files
    listbox_load
  end
  
  def comboBox_ffmpeg_selchanged
    printing_check
  end

  #subtitle printingの有効判定
  def printing_check
    encode_option = @comboBox_ffmpeg.getTextOf(@comboBox_ffmpeg.selectedString).strip.sub(/^#[^#]+#/,'').strip
    if encode_option =~ /-c +copy/i || encode_option =~ /-c:v +copy/i || encode_option =~ /-c:v:\d +copy/i
      @checkBox_printing.style = 0x58000003
      @printing = false
    else
      @checkBox_printing.style = 0x50000003
      @printing = true
    end
    refresh(true)
  end
  
  #動画ファイルのタイムスタンプ取得処理
  def movie_file_timestamp(file,db_save_check = false)
    create_time, access_time, write_time = get_file_timestamp(file)
    ##データベース処理
    if $time_save
      #データベースに登録済みのファイルのタイムスタンプの確認
      sql = "SELECT * FROM MovieOriginalTime WHERE filename = '#{File.basename(file)}';"
      if $ascii_mode
        fields, *rows = @db.execute2(sql)
      else
        fields, *rows = array_sjiscnv(@db.execute2(utf8cv(sql)))
      end
      #データベースに未登録の時に追加する
      if rows.size == 0
        save = true
        if db_save_check
          unless messageBox("#{file}\r\nIs this video an original file of play recording?\r\nDo you want to save the file timestamps in the database?",
             "Save time stamp in database",36) == 6 #はい
            save = false
          end
        end
        if save
          sql = "INSERT INTO MovieOriginalTime(filename, create_time, access_time, write_time) VALUES (?, ?, ?, ?);"
          if $ascii_mode
            @db.execute(sql,File.basename(file),create_time,access_time,write_time)
          else
            @db.execute(utf8cv(sql),utf8cv(File.basename(file)),create_time,access_time,write_time)
          end
        end
      else
        unless create_time == rows[0][fields.index("create_time")].to_i &&
               access_time == rows[0][fields.index("access_time")].to_i &&
               write_time  == rows[0][fields.index("write_time")].to_i
          if $timestamp_nomsg || messageBox("#{file}\r\nIt is different from the time stamp recorded in the database.\r\nUse database timestamp?\r\n\r\n(This message can be hidden in the settings.)",
             "Timestamp differs from database",36) == 6 #はい
            create_time = rows[0][fields.index("create_time")].to_i
            access_time = rows[0][fields.index("access_time")].to_i
            write_time  = rows[0][fields.index("write_time")].to_i
          end
        end
      end
    end
    return [create_time, access_time, write_time]
  end
  
  
  #指定期間を元に、データベースからmap情報の読み込み
  def db_map_load_time(allread, start_time, end_time, search_dir_list)
    @original_convert_list = []
    @convert_list = []
    movie_file_list = []
    movie_file_list_check = []
    movie_cut_file = {}
    movie_original_time = []
    #カット済み記録の取得
    sql = "SELECT * FROM MovieCutFile;"
    result = db_execute(sql,true,false)
    if result
      fields,rows = result
    else
      return
    end
    rows.each do |record|
      out_dir = record[fields.index("out_dir")]
      filename = record[fields.index("filename")]
      unless $ascii_mode
        out_dir = sjiscv(out_dir)
        filename = sjiscv(filename)
      end
      movie_cut_file[record[fields.index("startTime")].to_i] = [out_dir,filename]
    end
    #読込済み動画ファイルの取得
    sql = "SELECT * FROM MovieOriginalTime;"
    result = db_execute(sql,false,false)
    if result
      fields,rows = result
    else
      return
    end
    rows.each do |record|
      filename = record[fields.index("filename")]
      filename = sjiscv(filename) unless $ascii_mode
      movie_original_time.push [filename, record[fields.index("create_time")].to_i, record[fields.index("access_time")].to_i, record[fields.index("write_time")].to_i]
    end
    #レコードの取得処理
    if allread
      sql = "SELECT * FROM MovieCutRecord;"
    else
      sql = "SELECT * FROM MovieCutRecord WHERE startTime >= #{start_time} AND menuTime <= #{end_time};"
    end
    result = db_execute(sql,false)
    if result
      @fields,rows = result
    else
      return
    end
    rows.each_with_index do |cols,idx|
      file = nil
      file_idx = nil
      file_type = nil
      check_file = nil
      create_time = nil
      access_time = nil
      write_time = nil
      start_time = cols[@fields.index("startTime")].to_i
      menu_time  = cols[@fields.index("menuTime")].to_i
      movie_original_time.each do |v|
        if (v[1] <= start_time) && (v[3] >= menu_time)
          search_dir_list.each do |dir|
            check_file = dir + v[0]
            if file_idx = movie_file_list_check.index(check_file)
              break
            else
              if File.exist?(check_file)
                movie_file_list_check.push check_file
                file_idx = movie_file_list_check.size - 1
                break
              end
            end
          end
        end
        if file_idx
          create_time = v[1]
          access_time = v[2]
          write_time  = v[3]
          file = check_file
          file_type = 1
          break
        end
      end
      unless file
        if movie_cut_file[start_time]
          ([movie_cut_file[start_time][0]] + search_dir_list).each do |dir|
            check_file = dir + movie_cut_file[start_time][1]
            if file_idx = movie_file_list_check.index(check_file)
              file = check_file
              file_type = 2
              break
            else
              if File.exist?(check_file)
                file = check_file
                movie_file_list_check.push check_file
                file_idx = movie_file_list_check.size - 1
                file_type = 2
                break
              end
            end
          end
        end
      end
      map_data = [file,cols,idx,create_time,access_time,write_time,file_idx,file_type]
      @convert_list.push map_data
      @original_convert_list.push map_data
    end
    movie_file_list_check.each_with_index do |file,i|
      movie_file_list.push "#{i + 1}\t#{file}"
    end
    if movie_file_list == []
      @listBox_file.clearStrings
    else
      @listBox_file.setListStrings movie_file_list
    end
  end
  
  
  #動画ファイルを元に、データベースからmap情報の読み込み
  def db_map_load_movie
    @original_convert_list = []
    @convert_list = []
    movie_file_list = []
    listBox_map_idx_end = 0  #リストボックスの最終追加場所(idx)
    @movie_files.each_with_index do |file,file_idx|
      movie_file_list.push "#{file_idx + 1}\t#{file}" #変換元動画ファイル リスト作成
      db_open
      create_time, access_time, write_time = movie_file_timestamp(file)
      #レコードの取得処理
      sql = "SELECT * FROM MovieCutRecord WHERE startTime > #{create_time} AND menuTime < #{write_time};"
      result = db_execute(sql,false)
      if result
        @fields,rows = result
      else
        return
      end
      rows.each_with_index do |cols,idx|
        map_data = [file,cols,listBox_map_idx_end + idx,create_time,access_time,write_time,file_idx,1]
        @convert_list.push map_data
        @original_convert_list.push map_data
      end
      listBox_map_idx_end += rows.size
    end
    if movie_file_list == []
      @listBox_file.clearStrings
    else
      @listBox_file.setListStrings movie_file_list
    end
  end
  
  #動画の読み込み＆リストボックス更新
  def listbox_load
    db_map_load_movie
    listbox_refresh
  end
  
  #リストボックスの更新
  def listbox_refresh
    map_list = []
    @convert_list.each do |map_cols|
      cols = map_cols[1]
      file_idx = map_cols[6]
      time = ((cols[@fields.index('endTime')].to_i - cols[@fields.index('startTime')].to_i) / 1000).to_i
      min = time.div(60)
      sec = time % 60
      length = (cols[@fields.index('length')].to_i / 1000).to_i
      case map_cols[7]
      when 1
        temp = [(file_idx + 1).to_s]
      when 2
        temp = [(file_idx + 1).to_s + "C"]
      else
        temp = [""]
      end
      temp.push Time.at(cols[@fields.index('startTime')].to_i / 1000).localtime.strftime("%y/%m/%d %H:%M")
      temp.push "#{min}:%02d" % sec
      temp.push((time - length).to_s)
      speed = ((cols[@fields.index("songSpeedMultiplier")].to_f * 10.0).round.to_f / 10.0)
      if speed == 1.0
        temp.push 1
      else
        temp.push speed
      end
      temp.push cols[@fields.index("cleared")]
      temp.push cols[@fields.index("rank")].to_s
      temp.push cols[@fields.index("scorePercentage")].to_s
      temp.push cols[@fields.index("missedNotes")].to_s
      temp.push cols[@fields.index("difficulty")].to_s
      temp.push cols[@fields.index("songName")].to_s[0,39]
      temp.push cols[@fields.index("levelAuthorName")].to_s[0,12]
      if $ascii_mode
        $KCODE='NONE'
        temp = temp.join("\t").gsub(/[^ -~\t]/,' ')
        $KCODE='s'
      else
        temp = temp.join("\t")
      end
      map_list.push temp
    end
    #リストボックスに項目追加
    if map_list == []
      @listBox_map.clearStrings
    else
      @listBox_map.setListStrings map_list
    end
  end

  #リストボックスのソート
  def listbox_sort(sort_target,cnv_type = nil)
    i = 0
    if @list_sort == sort_target
      @list_desc_order = !@list_desc_order
    else
      @list_desc_order = false
    end
    @list_sort = sort_target
    if sort_target == "File"
      @convert_list = @convert_list.sort_by {|a| [a[6].to_i,i += 1] }
    elsif sort_target == "Time"
      @convert_list = @convert_list.sort_by {|a| [(a[1][@fields.index("endTime")].to_i - a[1][@fields.index("startTime")].to_i),i += 1] }
    elsif sort_target == "Diff"
      @convert_list = @convert_list.sort_by {|a| [((a[1][@fields.index("endTime")].to_i - a[1][@fields.index("startTime")].to_i) - a[1][@fields.index("length")].to_i),i += 1] }
    else
      if cnv_type == "i"
        @convert_list = @convert_list.sort_by {|a| [a[1][@fields.index(sort_target)].to_i,i += 1] }
      elsif cnv_type == "f"
        @convert_list = @convert_list.sort_by {|a| [a[1][@fields.index(sort_target)].to_f,i += 1] }
      else
        @convert_list = @convert_list.sort_by {|a| [a[1][@fields.index(sort_target)].to_s,i += 1] }
      end
    end
    @convert_list.reverse! if @list_desc_order
    listbox_refresh
  end

  #設定読出し
  def setting_load
    $time_format          = DEFAULT_TIMEFORMAT
    $beatsaber_dbfile     = nil
    $preview_tool         = DEFAULT_PREVIEW_TOOL
    $preview_tool_option  = ""
    $preview_file         = DEFAULT_PREVIEW_FILE
    $subtitle_file        = DEFAULT_SUBTITLE_FILE
    $mod_setting_file     = DEFAULT_MOD_SETTING_FILE
    $ascii_mode           = false
    $time_save            = true
    $offset               = 0.0
    $timestamp_nomsg      = false
    $use_endtime          = false
    $preview_encode       = false
    $subtitle_font        = DEFALUT_SUB_FONT
    $subtitle_font_size   = DEFALUT_SUB_FONT_SIZE
    $subtitle_alignment   = DEFALUT_SUB_ALIGNMENT
    $subtitle_red_notes   = DEFALUT_SUB_RED_NOTES
    $subtitle_blue_notes  = DEFALUT_SUB_BLUE_NOTES
    $subtitle_cut_format  = DEFALUT_SUB_CUT_FORMAT
    $subtitle_miss_format = DEFALUT_SUB_MISS_FORMAT
    $simultaneous_notes_time = DEFALUT_SIMULTANEOUS_NOTES_TIME
    $max_notes_display    = DEFALUT_MAX_NOTES_DISPLAY
    $last_notes_time      = DEFALUT_LAST_NOTES_TIME
    $open_dir             = ""
    $movie_default_extension = "mkv"
    $input_movie_search_dir  = []
    $post_commnet         = DEFALUT_POST_COMMENT
    if File.exist?(SETTING_FILE)
      setting = JSON.parse(File.read(SETTING_FILE))
      $time_format      = setting['time_format'].to_s         if setting['time_format']
      $beatsaber_dbfile = setting['beatsaber_dbfile'].to_s    if setting['beatsaber_dbfile']
      $preview_tool     = setting['preview_tool'].to_s        if setting['preview_tool']
      $preview_tool_option = setting['preview_tool_option'].to_s if setting['preview_tool_option']
      $preview_file     = setting['preview_file'].to_s        if setting['preview_file']
      $subtitle_file    = setting['subtitle_file'].to_s       if setting['subtitle_file']
      $offset           = setting['offset'].to_f              if setting['offset']
      $mod_setting_file = setting['mod_setting_file'].to_s    if setting['mod_setting_file']
      $subtitle_font        = setting['subtitle_font']        if setting['subtitle_font']
      $subtitle_font_size   = setting['subtitle_font_size']   if setting['subtitle_font_size']
      $subtitle_alignment   = setting['subtitle_alignment']   if setting['subtitle_alignment']
      $subtitle_red_notes   = setting['subtitle_red_notes']   if setting['subtitle_red_notes']
      $subtitle_blue_notes  = setting['subtitle_blue_notes']  if setting['subtitle_blue_notes']
      $subtitle_cut_format  = setting['subtitle_cut_format']  if setting['subtitle_cut_format']
      $subtitle_miss_format = setting['subtitle_miss_format'] if setting['subtitle_miss_format']
      $simultaneous_notes_time = setting['simultaneous_notes_time'] if setting['simultaneous_notes_time']
      $max_notes_display    = setting['max_notes_display']    if setting['max_notes_display']
      $last_notes_time      = setting['last_notes_time']      if setting['last_notes_time']
      $open_dir             = setting['open_dir']             if setting['open_dir']
      $movie_default_extension = setting['movie_default_extension']  if setting['movie_default_extension']
      $input_movie_search_dir  = setting['input_movie_search_dir']  if setting['input_movie_search_dir']
      $post_commnet         = setting['post_commnet']         if setting['post_commnet']
      $ascii_mode       = setting['Remove non-ASCII code']    unless setting['Remove non-ASCII code'] == nil
      $time_save        = setting['time_save']                unless setting['time_save'] == nil
      $timestamp_nomsg  = setting['timestamp_nomsg']          unless setting['timestamp_nomsg'] == nil
      $use_endtime      = setting['use_endtime']              unless setting['use_endtime'] == nil
      $preview_encode   = setting['preview_encode']           unless setting['preview_encode'] == nil
      @checkBox_finished.check setting['finished']            unless setting['finished'] == nil
      @checkBox_failed.check setting['failed']                unless setting['failed'] == nil
      @checkBox_pause.check setting['pause']                  unless setting['pause'] == nil
      @checkBox_miss.check setting['Miss']                    unless setting['Miss'] == nil
      @checkBox_score.check setting['Score']                  unless setting['Score'] == nil
      @checkBox_diff.check setting['Difference']              unless setting['Difference'] == nil
      @checkBox_speed.check setting['Speed']                  unless setting['Speed'] == nil
      @checkBox_length.check setting['Movie length']          unless setting['Movie length'] == nil
      @radioBtn_footer_cut.check setting['footer cut']        unless setting['footer cut'] == nil
      @radioBtn_header_cut.check setting['header cut']        unless setting['header cut'] == nil
      @radioBtn_header_cut.check true                         unless setting['header cut'] || setting['footer cut']
      if setting['with subtitles'] == nil
        @checkBox_subtitles.check true
      else
        @checkBox_subtitles.check setting['with subtitles']
      end
      @checkBox_printing.check setting['subtitle printing']   unless setting['subtitle printing'] == nil
      @edit_miss.text  = setting['Miss edit'].to_s            if setting['Miss edit']
      @edit_score.text = setting['Score edit'].to_s           if setting['Score edit']
      @edit_difftime.text = setting['Difference_time'].to_s   if setting['Difference_time']
      @edit_start_offset.text = setting['Start offset'].to_s  if setting['Start offset']
      @edit_end_offset.text   = setting['End offset'].to_s    if setting['End offset']
      @edit_length.text       = setting['length'].to_s        if setting['length']
      if setting['FFmpeg option']
        @comboBox_ffmpeg.setListStrings setting['FFmpeg option']
        if setting['FFmpeg option select']
          @comboBox_ffmpeg.select(setting['FFmpeg option select'])
        else
          @comboBox_ffmpeg.select(0)
        end
      else
        @comboBox_ffmpeg.setListStrings DEFAULT_FFMPEG_OPTION
        @comboBox_ffmpeg.select(0)
      end
      if setting['Output file name']
        @comboBox_filename.setListStrings setting['Output file name']
        if setting['Output file name select']
          @comboBox_filename.select(setting['Output file name select'])
        else
          @comboBox_filename.select(0)
        end
      else
        @comboBox_filename.setListStrings DEFAULT_OUT_FILE_NAME
        @comboBox_filename.select(0)
      end
      if setting['Output folder']
        @comboBox_folder.setListStrings setting['Output folder']
        if setting['Output folder select']
          @comboBox_folder.select(setting['Output folder select'])
        else
          @comboBox_folder.select(0)
        end
      else
        @comboBox_folder.setListStrings DEFAULT_OUT_FOLDER
        @comboBox_folder.select(0)
      end
    else
      @comboBox_ffmpeg.setListStrings DEFAULT_FFMPEG_OPTION
      @comboBox_ffmpeg.select(0)
      @comboBox_filename.setListStrings DEFAULT_OUT_FILE_NAME
      @comboBox_filename.select(0)
      @comboBox_folder.setListStrings DEFAULT_OUT_FOLDER
      @comboBox_folder.select(0)
      @radioBtn_header_cut.check true
      @checkBox_subtitles.check true
    end
  end

  #設定保存
  def setting_save(all = true)
    if File.exist?(SETTING_FILE)
      setting = JSON.parse(File.read(SETTING_FILE))
    else
      setting = {}
    end
    setting['Remove non-ASCII code'] = $ascii_mode
    setting['time_format']           = $time_format
    setting['beatsaber_dbfile']      = $beatsaber_dbfile
    setting['preview_tool']          = $preview_tool
    setting['preview_tool_option']   = $preview_tool_option
    setting['time_save']             = $time_save
    setting['timestamp_nomsg']       = $timestamp_nomsg
    setting['use_endtime']           = $use_endtime
    setting['preview_encode']        = $preview_encode
    setting['preview_file']          = $preview_file
    setting['subtitle_file']         = $subtitle_file
    setting['offset']                = $offset
    setting['mod_setting_file']      = $mod_setting_file
    setting['subtitle_font']         = $subtitle_font
    setting['subtitle_font_size']    = $subtitle_font_size
    setting['subtitle_alignment']    = $subtitle_alignment
    setting['subtitle_red_notes']    = $subtitle_red_notes
    setting['subtitle_blue_notes']   = $subtitle_blue_notes
    setting['subtitle_cut_format']   = $subtitle_cut_format
    setting['subtitle_miss_format']  = $subtitle_miss_format
    setting['simultaneous_notes_time'] = $simultaneous_notes_time
    setting['max_notes_display']     = $max_notes_display
    setting['last_notes_time']       = $last_notes_time
    setting['open_dir']              = $open_dir
    setting['movie_default_extension'] = $movie_default_extension
    setting['input_movie_search_dir']  = $input_movie_search_dir
    setting['post_commnet']            = $post_commnet
    if all
      setting['finished']              = @checkBox_finished.checked?
      setting['failed']                = @checkBox_failed.checked?
      setting['pause']                 = @checkBox_pause.checked?
      setting['Miss']                  = @checkBox_miss.checked?
      setting['Score']                 = @checkBox_score.checked?
      setting['Difference']            = @checkBox_diff.checked?
      setting['Movie length']          = @checkBox_length.checked?
      setting['with subtitles']        = @checkBox_subtitles.checked?
      setting['subtitle printing']     = @checkBox_printing.checked?
      setting['footer cut']            = @radioBtn_footer_cut.checked?
      setting['header cut']            = @radioBtn_header_cut.checked?
      setting['Speed']                 = @checkBox_speed.checked?
      setting['Difference_time']       = @edit_difftime.text.strip.to_i
      setting['Miss edit']             = @edit_miss.text.strip.to_i
      setting['Score edit']            = @edit_score.text.strip.to_f
      setting['Start offset']          = @edit_start_offset.text.strip.to_f
      setting['End offset']            = @edit_end_offset.text.strip.to_f
      setting['length']                = @edit_length.text.strip.to_f
      setting['FFmpeg option'] = []
      @comboBox_ffmpeg.eachString {|a| setting['FFmpeg option'].push a}
      setting['Output file name'] = []
      @comboBox_filename.eachString {|a| setting['Output file name'].push a}
      setting['Output folder'] = []
      @comboBox_folder.eachString {|a| setting['Output folder'].push a}
      setting['FFmpeg option select']    = @comboBox_ffmpeg.selectedString
      setting['Output file name select'] = @comboBox_filename.selectedString
      setting['Output folder select']    = @comboBox_folder.selectedString
    end
    File.open(SETTING_FILE,'w') do |file|
      JSON.pretty_generate(setting).each do |line|
        file.puts line
      end
    end
  end
  
  #ffmpeg実行処理
  def ffmpeg_run(file,file_name,ffmpeg_option,out_dir,startTime,target,stoptime,str_file = false,vf = true)
      create_time = target[3]
      ss_time  = (startTime - create_time).to_f / 1000.0 + @edit_start_offset.text.strip.to_f + $offset
      cut_time = (stoptime - startTime).to_f / 1000.0 - @edit_start_offset.text.strip.to_f + @edit_end_offset.text.strip.to_f + $offset
      if @checkBox_length.checked?
        length_time = @edit_length.text.strip.to_f
        if cut_time > length_time
          if @radioBtn_header_cut.checked?
            ss_time += cut_time - length_time
          end
          cut_time = length_time
        end
      end
      id = target[1][@fields.index('songHash')]
      title = target[1][@fields.index('songName')].gsub(/"/,'')
      artist = target[1][@fields.index('levelAuthorName')].gsub(/"/,'')
      if $ascii_mode
        $KCODE='NONE'
        title.gsub!(/[^ -~\t]/,' ')                    #ASCII 文字以外を空白に変換
        artist.gsub!(/[^ -~\t]/,' ')                   #ASCII 文字以外を空白に変換
        $KCODE='s'
      end
      metadata  = %Q! -metadata "comment"="#{startTime}" -metadata "description"="#{id}" -metadata "title"="#{title}" !
      metadata += %Q!-metadata "artist"="#{artist}" -metadata "date"="#{stoptime}"!
      if str_file && File.exist?(str_file)
        vf_option = ""
        if @checkBox_printing.checked? && @printing && vf
          vf_srt_file = str_file.gsub('\\','\\\\\\\\\\\\\\\\').gsub(':','\\\\\\\\:')
          alignment = SUBTITLE_ALIGNMENT_SETTING[1][$subtitle_alignment]
          vf_option = " -vf \"subtitles=#{vf_srt_file}:force_style='FontName=#{$subtitle_font},FontSize=#{$subtitle_font_size},Alignment=#{alignment}'\""
        end
        if @checkBox_subtitles.checked?
          command = %Q!ffmpeg -ss #{ss_time} -i "#{file}" -t #{cut_time} -y #{ffmpeg_option}#{vf_option} "#{$subtitle_file}"!
          puts command
          `#{command}`
          command = %Q!ffmpeg -i "#{$subtitle_file}" -i "#{str_file}" -y -map 0 -map 1 -c copy -c:s mov_text -metadata:s:s:0 language=eng -metadata:s:s:0 title="Notes score"#{metadata} "#{out_dir}#{file_name}"!
        else
          command = %Q!ffmpeg -ss #{ss_time} -i "#{file}" -t #{cut_time} -y #{ffmpeg_option}#{metadata}#{vf_option} "#{out_dir}#{file_name}"!
        end
      else
        command = %Q!ffmpeg -ss #{ss_time} -i "#{file}" -t #{cut_time} -y #{ffmpeg_option}#{metadata} "#{out_dir}#{file_name}"!
      end
      puts command
      `#{command}`
    SWin::Application.doevents
  end
  
  ###字幕ファイル作成
  def movie_sub_create(target,out_dir,file_name,startTime,stoptime)
    #字幕ファイル削除
    File.delete out_dir + file_name if File.exist? out_dir + file_name
    #DBから字幕データ取得
    sql = "SELECT * FROM NoteScore WHERE startTime = #{startTime};"
    result = db_execute(sql,true,true,false)
    if result
      return if result == "no_table"
      fields,rows = result
    else
      return
    end
    return if rows.size == 0
    #cutTimeを優先し、timeを若い順に並べ替え
    rows = rows.sort do |a,b|
      hikaku_a = a[fields.index('cutTime')]
      hikaku_b = b[fields.index('cutTime')]
      hikaku_a = a[fields.index('time')] unless a[fields.index('cutTime')]
      hikaku_b = b[fields.index('time')] unless b[fields.index('cutTime')]
      hikaku_a <=> hikaku_b
    end
    #同時ノーツ判定処理
    douji = []        #同時表示字幕
    out_list = []     #1字幕単位のリスト
    cut_before = 0
    rows.each_with_index do |record,idx|
      if record[fields.index('event')] == 'noteFullyCut' || record[fields.index('event')] == 'noteMissed'
        if record[fields.index('event')] == 'noteFullyCut'
          cuttime = record[fields.index('cutTime')].to_i
        else
          cuttime = record[fields.index('time')].to_i
        end
        if douji.size < $max_notes_display && (cuttime - cut_before) <= $simultaneous_notes_time.to_i  #同時ノーツ判定
          douji.push idx
        else
          douji.push idx
          out_list.push douji unless cut_before == 0
          douji = [idx]
        end
        cut_before = cuttime
      end
    end
    douji.push false
    out_list.push douji
    #字幕ファイル出力
    File.open(out_dir + file_name,'w') do |file|
      counter = 1
      out_list.each do |douji|
        #字幕データ作成
        jimaku = []
        jimaku_start = 0
        jimaku_end = 0
        douji.each_with_index do |rows_idx,idx|
          if rows_idx
            if idx == 0
              if rows[rows_idx][fields.index('event')] == 'noteFullyCut'
                jimaku_start = rows[rows_idx][fields.index('cutTime')]
              else
                jimaku_start = rows[rows_idx][fields.index('time')]
              end
            end
            if idx == (douji.size - 1)
              if rows[rows_idx][fields.index('event')] == 'noteFullyCut'
                jimaku_end = rows[rows_idx][fields.index('cutTime')]
              else
                jimaku_end = rows[rows_idx][fields.index('time')]
              end
            else
              noteID           = rows[rows_idx][fields.index('noteID')]
              noteType         = rows[rows_idx][fields.index('noteType')]
              initialScore     = rows[rows_idx][fields.index('initialScore')]
              beforeScore      = rows[rows_idx][fields.index('beforeScore')]
              afterScore       = rows[rows_idx][fields.index('afterScore')]
              cutDistanceScore = rows[rows_idx][fields.index('cutDistanceScore')]
              finalScore       = rows[rows_idx][fields.index('finalScore')]
              score            = rows[rows_idx][fields.index('score')]
              currentMaxScore  = rows[rows_idx][fields.index('currentMaxScore')]
              rank             = rows[rows_idx][fields.index('rank')]
              passedNotes      = rows[rows_idx][fields.index('passedNotes')]
              hitNotes         = rows[rows_idx][fields.index('hitNotes')]
              missedNotes      = rows[rows_idx][fields.index('missedNotes')]
              combo            = rows[rows_idx][fields.index('combo')]
              saberSpeed       = rows[rows_idx][fields.index('saberSpeed')].round
              cutDistanceToCenter = (rows[rows_idx][fields.index('cutDistanceToCenter')] * 1000.0).round
              if noteType == 'NoteA'
                note_type = $subtitle_red_notes
              elsif noteType == 'NoteB'
                note_type = $subtitle_blue_notes
              end
              begin
                if rows[rows_idx][fields.index('event')] == 'noteMissed'
                  eval("jimaku.push #{$subtitle_miss_format}")
                else
                  eval("jimaku.push #{$subtitle_cut_format}")
                end
              rescue SyntaxError    #SyntaxErrorのrescueはクラス指定しないと取得できない
                messageBox("Invalid subtitle format setting\r\nSyntax Error","Subtitle format SyntaxError",48)
                return
              rescue Exception => e
                messageBox("Invalid subtitle format setting\r\n#{e.inspect}","Subtitle format ERROR",48)
                return
              end
            end
          else
            jimaku_end = jimaku_start + ($last_notes_time.to_f * 1000.0).to_i
          end
        end
        #字幕用時間計算
        create_time = target[3]
        movie_start_time  = startTime + (@edit_start_offset.text.strip.to_f * 1000.0).to_i + ($offset * 1000.0).to_i
        movie_stop_time   = stoptime + (@edit_end_offset.text.strip.to_f * 1000.0).to_i + ($offset * 1000.0).to_i
        cut_time = movie_stop_time - movie_start_time
        if @checkBox_length.checked?
          length_time = (@edit_length.text.strip.to_f * 1000.0).to_i
          if cut_time > length_time
            if @radioBtn_header_cut.checked?
              movie_start_time += cut_time - length_time
            end
            movie_stop_time =  movie_start_time + length_time
          end
        end
        next if (jimaku_start - movie_start_time) < 0
        break if (jimaku_start - movie_stop_time) > 0
        jimaku_end = movie_stop_time if (jimaku_end - movie_stop_time) > 0
        if @edit_end_offset.text.strip.to_f > 0.0
          check_time = movie_stop_time - (@edit_end_offset.text.strip.to_f * 1000.0).to_i
          jimaku_end = check_time if (jimaku_end - check_time) > 0
        end
        start_h = (jimaku_start - movie_start_time) / 3600000
        start_h_amari = (jimaku_start - movie_start_time) % 3600000
        start_m = start_h_amari / 60000
        start_m_amari = start_h_amari % 60000
        start_s = start_m_amari / 1000
        start_ms = start_m_amari % 1000
        end_h = (jimaku_end - movie_start_time) / 3600000
        end_h_amari = (jimaku_end - movie_start_time) % 3600000
        end_m = end_h_amari / 60000
        end_m_amari = end_h_amari % 60000
        end_s = end_m_amari / 1000
        end_ms = end_m_amari % 1000
        #字幕ファイル書き込み
        file.puts counter
        file.puts "%02d:%02d:%02d,%03d --> %02d:%02d:%02d,%03d" % [start_h,start_m,start_s,start_ms,end_h,end_m,end_s,end_ms]
        jimaku.each do |line|
          file.puts line
        end
        file.puts
        counter += 1
      end
    end
  end

  ##GUIイベント処理##
  def button_run_clicked
    @button_run.style     = 1476395008
    refresh
    @static_message.caption = "### Now converting!! ###"
    show(0)
    @convert_list.each_with_index do |target,idx|
      #マップ リストボックスの選択状態確認
      sel = 0
      @listBox_map.eachSelected do |i|
        sel = 1 if i == idx
      end
      next if sel == 0
      next unless target[7] == 1
      #データベースカラムの読み出し
      startTime           =  target[1][@fields.index('startTime')]
      endTime             =  target[1][@fields.index('endTime')]
      menuTime            =  target[1][@fields.index('menuTime')]
      cleared             =  target[1][@fields.index('cleared')]
      endFlag             =  target[1][@fields.index('endFlag')]
      pauseCount          =  target[1][@fields.index('pauseCount')]
      pluginVersion       =  target[1][@fields.index('pluginVersion')]
      gameVersion         =  target[1][@fields.index('gameVersion')]
      scene               =  target[1][@fields.index('scene')]
      mode                =  target[1][@fields.index('mode')]
      songName            =  target[1][@fields.index('songName')]
      songSubName         =  target[1][@fields.index('songSubName')]
      songAuthorName      =  target[1][@fields.index('songAuthorName')]
      levelAuthorName     =  target[1][@fields.index('levelAuthorName')]
      songHash            =  target[1][@fields.index('songHash')]
      songBPM             =  target[1][@fields.index('songBPM')]
      noteJumpSpeed       =  target[1][@fields.index('noteJumpSpeed')]
      songTimeOffset      =  target[1][@fields.index('songTimeOffset')]
      start               =  target[1][@fields.index('start')]
      paused              =  target[1][@fields.index('paused')]
      length              =  target[1][@fields.index('length')]
      difficulty          =  target[1][@fields.index('difficulty')]
      notesCount          =  target[1][@fields.index('notesCount')]
      bombsCount          =  target[1][@fields.index('bombsCount')]
      obstaclesCount      =  target[1][@fields.index('obstaclesCount')]
      maxScore            =  target[1][@fields.index('maxScore')]
      maxRank             =  target[1][@fields.index('maxRank')]
      environmentName     =  target[1][@fields.index('environmentName')]
      scorePercentage     =  target[1][@fields.index('scorePercentage')]
      score               =  target[1][@fields.index('score')]
      currentMaxScore     =  target[1][@fields.index('currentMaxScore')]
      rank                =  target[1][@fields.index('rank')]
      passedNotes         =  target[1][@fields.index('passedNotes')]
      hitNotes            =  target[1][@fields.index('hitNotes')]
      missedNotes         =  target[1][@fields.index('missedNotes')]
      lastNoteScore       =  target[1][@fields.index('lastNoteScore')]
      passedBombs         =  target[1][@fields.index('passedBombs')]
      hitBombs            =  target[1][@fields.index('hitBombs')]
      combo               =  target[1][@fields.index('combo')]
      maxCombo            =  target[1][@fields.index('maxCombo')]
      multiplier          =  target[1][@fields.index('multiplier')]
      obstacles           =  target[1][@fields.index('obstacles')]
      instaFail           =  target[1][@fields.index('instaFail')]
      noFail              =  target[1][@fields.index('noFail')]
      batteryEnergy       =  target[1][@fields.index('batteryEnergy')]
      disappearingArrows  =  target[1][@fields.index('disappearingArrows')]
      noBombs             =  target[1][@fields.index('noBombs')]
      songSpeed           =  target[1][@fields.index('songSpeed')]
      songSpeedMultiplier =  target[1][@fields.index('songSpeedMultiplier')]
      noArrows            =  target[1][@fields.index('noArrows')]
      ghostNotes          =  target[1][@fields.index('ghostNotes')]
      failOnSaberClash    =  target[1][@fields.index('failOnSaberClash')]
      strictAngles        =  target[1][@fields.index('strictAngles')]
      fastNotes           =  target[1][@fields.index('fastNotes')]
      staticLights        =  target[1][@fields.index('staticLights')]
      leftHanded          =  target[1][@fields.index('leftHanded')]
      playerHeight        =  target[1][@fields.index('playerHeight')]
      reduceDebris        =  target[1][@fields.index('reduceDebris')]
      noHUD               =  target[1][@fields.index('noHUD')]
      advancedHUD         =  target[1][@fields.index('advancedHUD')]
      autoRestart         =  target[1][@fields.index('autoRestart')]
      
      ##分割処理
      time_name = Time.at(startTime.to_i / 1000).localtime.strftime($time_format)
      
      if cleared == 'finished' && missedNotes.to_i == 0
        miss = "FULLCOMBO"
      else
        miss = "Miss#{missedNotes}"
      end
      file_name = ''
      #分割後のファイル名決定
      file_name_code = '"' + @comboBox_filename.getTextOf(@comboBox_filename.selectedString).strip.sub(/^#[^#]+#/,'').strip + '"'
      #bsrの取得
      if file_name_code =~ /bsr/
        bsr,beatsaver_data = bsr_search(songHash)
      end
      begin
        eval("file_name = " + file_name_code)
      rescue SyntaxError    #SyntaxErrorのrescueはクラス指定しないと取得できない
        messageBox("Invalid file name setting\r\nSyntax Error","FILE NAME SyntaxError",48)
        @button_run.style     = 1342177280
        @static_message.caption = "Paste the file to be converted by drag and drop"
        refresh
        return
      rescue Exception => e
        messageBox("Invalid file name setting\r\n#{e.inspect}","FILE NAME ERROR",48)
        @button_run.style     = 1342177280
        @static_message.caption = "Paste the file to be converted by drag and drop"
        refresh
        return
      end
      
      file_name = file_name_check(file_name)
      file     = target[0]
      ffmpeg_option = ' ' + @comboBox_ffmpeg.getTextOf(@comboBox_ffmpeg.selectedString).strip.sub(/^#[^#]+#/,'').strip
      out_dir       = @comboBox_folder.getTextOf(@comboBox_folder.selectedString).strip.sub(/^#[^#]+#/,'').strip
      if $use_endtime
        stoptime = endTime
      else
        stoptime = menuTime
      end
      str_dir = File.dirname($subtitle_file.to_s.strip) + "\\"
      str_file = File.basename($subtitle_file, ".*") + '.srt'
    if @checkBox_printing.checked? && @printing || @checkBox_subtitles.checked?
        movie_sub_create(target,str_dir,str_file,startTime,stoptime)
        ffmpeg_run(file,file_name,ffmpeg_option,out_dir,startTime,target,stoptime,str_dir + str_file)
      else
        #字幕ファイル削除
        File.delete str_dir + str_file if File.exist? str_dir + str_file
        ffmpeg_run(file,file_name,ffmpeg_option,out_dir,startTime,target,stoptime)
      end
      #データベースに切り出し記録を残す
      db_open
      sql = "INSERT INTO MovieCutFile(startTime, datetime, out_dir, filename, stoptime) VALUES (?, ?, ?, ?, ?);"
      if $ascii_mode
        @db.execute(sql,startTime,Time.now.to_i,out_dir,file_name,stoptime)
      else
        @db.execute(utf8cv(sql),startTime,Time.now.to_i,utf8cv(out_dir),utf8cv(file_name),stoptime)
      end
      @db.close
    end
    show
    @button_run.style     = 1342177280
    @static_message.caption = "Paste the file to be converted by drag and drop"
    refresh
  end
  
  #all select ボタン
  def button_all_select_clicked
    @listBox_map.countStrings.times do |idx|
      @listBox_map.sendMessage(WMsg::LB_SETSEL,1,idx)   #全て選択状態にする。
    end
  end
  
  def button_all_unselect_clicked
    @listBox_map.countStrings.times do |idx|
      @listBox_map.sendMessage(WMsg::LB_SETSEL,0,idx)   #全て未選択状態にする。
    end
  end

  def button_fullcombo_clicked
    @listBox_map.countStrings.times do |idx|
      if @convert_list[idx][1][@fields.index("cleared")] == 'finished' && @convert_list[idx][1][@fields.index("missedNotes")].to_i == 0
        @listBox_map.sendMessage(WMsg::LB_SETSEL,1,idx)   #選択状態にする。
      else
        @listBox_map.sendMessage(WMsg::LB_SETSEL,0,idx)   #未選択状態にする。
      end
    end
  end

  def button_finished_clicked
    @listBox_map.countStrings.times do |idx|
      if @convert_list[idx][1][@fields.index("cleared")] == 'finished'
        @listBox_map.sendMessage(WMsg::LB_SETSEL,1,idx)   #選択状態にする。
      else
        @listBox_map.sendMessage(WMsg::LB_SETSEL,0,idx)   #未選択状態にする。
      end
    end
  end

  def button_filter_clicked
    @listBox_map.countStrings.times do |idx|
      time = ((@convert_list[idx][1][@fields.index('endTime')].to_i - @convert_list[idx][1][@fields.index('startTime')].to_i) / 1000).to_i
      length = (@convert_list[idx][1][@fields.index('length')].to_i / 1000).to_i
      flag = false
      flag = true if @checkBox_finished.checked?  && @convert_list[idx][1][@fields.index("cleared")] == 'finished'
      flag = true if @checkBox_failed.checked?    && @convert_list[idx][1][@fields.index("cleared")] == 'failed'
      flag = true if @checkBox_pause.checked?     && @convert_list[idx][1][@fields.index("cleared")] == 'pause'
      flag = false if @checkBox_miss.checked?     && @convert_list[idx][1][@fields.index("missedNotes")].to_i > @edit_miss.text.to_i
      flag = false if @checkBox_score.checked?    && @convert_list[idx][1][@fields.index("scorePercentage")].to_f < @edit_score.text.to_f
      flag = false if @checkBox_diff.checked?     && (time - length).abs > @edit_difftime.text.to_i
      flag = false if @checkBox_speed.checked?    && @convert_list[idx][1][@fields.index("songSpeedMultiplier")].to_f != 1.0
      if flag
        @listBox_map.sendMessage(WMsg::LB_SETSEL,1,idx)   #選択状態にする。
      else
        @listBox_map.sendMessage(WMsg::LB_SETSEL,0,idx)   #未選択状態にする。
      end
    end
  end

  def button_close_clicked
    close
  end

  def button_preview_clicked
    unless File.exist? $preview_tool.to_s
      messageBox("'#{$preview_tool.to_s}' File not found\r\nPlease set from option of menu.","Preview tool not found",48)
      return
    end
    return unless target = @convert_list[@listBox_map.selectedString]
    case target[7]
    when 1
      file = target[0]
      out_dir  = File.dirname($preview_file.to_s.strip) + "\\"
      file_name = File.basename($preview_file.to_s.strip)
      unless File.directory?(out_dir)
        messageBox("'#{folder}'\r\mPreview temporary folder not found\r\nPlease set from option of menu.","Preview temporary folder not found",48)
        return
      end
      if file_name.strip == ''
        messageBox("Preview temporary file setting not found\r\nPlease set from option of menu.","Preview temporary file setting not found",48)
        return
      end
      if $preview_encode
        ffmpeg_option = ' ' + @comboBox_ffmpeg.getTextOf(@comboBox_ffmpeg.selectedString).strip.sub(/^#[^#]+#/,'').strip
        vf = true
      else
        ffmpeg_option = " -c copy"
        vf = false
      end
      startTime           =  target[1][@fields.index('startTime')]
      endTime             =  target[1][@fields.index('endTime')]
      menuTime            =  target[1][@fields.index('menuTime')]
      if $use_endtime
        stoptime = endTime
      else
        stoptime = menuTime
      end
      @button_preview.style     = 1476395008
      show(0)
      refresh
      str_dir = File.dirname($subtitle_file.to_s.strip) + "\\"
      str_file = File.basename($subtitle_file, ".*") + '.srt'
      movie_sub_create(target,str_dir,str_file,startTime,stoptime)
      ffmpeg_run(file,file_name,ffmpeg_option,out_dir,startTime,target,stoptime,str_dir + str_file,vf)
      @button_preview.style     = 1342177280
      refresh
      show
      preview_movie = out_dir + file_name
    when 2
      preview_movie = target[0]
    else
      return
    end
    begin
      #外部プログラム呼び出しで、処理待ちしないためWSHのRunを使う
      option = ""
      option = " " + $preview_tool_option.strip unless $preview_tool_option.strip == ""
      $winshell.Run(%Q!"#{$preview_tool.to_s}"#{option} "#{preview_movie}"!)
    rescue Exception => e
      messageBox("Preview error\r\nWScript.Shell Error\r\n#{e.inspect}","Preview ERROR",48)
    end
  end
  
  def button_file_sort_clicked
    listbox_sort("File")
  end
  
  def button_datetime_sort_clicked
    listbox_sort("startTime","i")
  end

  def button_time_sort_clicked
    listbox_sort("Time")
  end

  def button_diff_sort_clicked
    listbox_sort("Diff")
  end

  def button_speed_sort_clicked
    listbox_sort("songSpeedMultiplier","f")
  end

  def button_cleared_sort_clicked
    listbox_sort("cleared")
  end

  def button_rank_sort_clicked
    listbox_sort("rank")
  end

  def button_score_sort_clicked
    listbox_sort("scorePercentage","f")
  end

  def button_miss_sort_clicked
    listbox_sort("missedNotes","i")
  end

  def button_difficulty_clicked
    listbox_sort("difficulty")
  end

  def button_songname_sort_clicked
    listbox_sort("songName")
  end

  def button_levelauthor_sort_clicked
    listbox_sort("levelAuthorName")
  end

  def button_organizing_reversing_clicked
    @listBox_map.countStrings.times do |idx|
      select = false
      @listBox_map.eachSelected do |i|
        if i == idx
          select = true
          break
        end
      end
      if select
        @listBox_map.sendMessage(WMsg::LB_SETSEL,0,idx)
      else
        @listBox_map.sendMessage(WMsg::LB_SETSEL,1,idx)
      end
    end
  end

  def button_organizing_remove_clicked
    temp = []
    @convert_list.each_with_index do |target,idx|
      select = false
      @listBox_map.eachSelected do |i|
        if idx == i
          select = true
          break
        end
      end
      unless select
        temp.push target
      end
    end
    @convert_list = temp
    listbox_refresh
  end

  def button_organizing_reset_clicked
    @convert_list = []
    @original_convert_list.each {|map_data| @convert_list.push map_data}
    listbox_refresh
  end

  def button_search_clicked
    Modaldlg_search.set(@convert_list[@listBox_map.selectedString],@fields)
    return unless result = VRLocalScreen.openModalDialog(self,nil,Modaldlg_search,nil,nil)  #検索画面のモーダルダイアログを開く
    songname,level_author,ranked = result
    return if songname == "" && level_author == "" && ranked == 0
    temp = []
    scoresaber_check = true
    @convert_list.each do |target|
      flag1 = false
      flag2 = false
      flag3 = false
      if songname == ""
        flag1 = true
      else
        if target[1][@fields.index('songName')] =~ Regexp.new("#{Regexp.escape(songname)}",Regexp::IGNORECASE)
          flag1 = true
        else
          flag1 = false
        end
      end
      if level_author == ""
        flag2 = true
      else
        if target[1][@fields.index('levelAuthorName')] =~ Regexp.new("#{Regexp.escape(level_author)}",Regexp::IGNORECASE)
          flag2 = true
        else
          flag2 = false
        end
      end
      if ranked == 0
        flag3 = true
      else
        result = ranked_check(target[1][@fields.index('songHash')],target[1][@fields.index('difficulty')],target[1][@fields.index('mode')])
        case result
        when 1
          if ranked == 1
            flag3 =true
          else
            flag3 = false
          end
        when 2
          if ranked == 2
            flag3 = true
          else
            flag3 = false
          end
        else
          flag3 = true
          scoresaber_check = false
        end
      end
      temp.push target if flag1 && flag2 && flag3
    end
    unless scoresaber_check
      messageBox("I can't get rank information from ScoreSaber.","Not gets ScoreSaber",48)
    end
    @convert_list = temp
    listbox_refresh
  end

  def button_open_preview_dir_clicked
    out_dir  = File.dirname($preview_file.to_s.strip) + "\\"
    $winshell.Run("\"#{out_dir}\"") if File.directory?(out_dir)
  end

  def menu_open_clicked
    ext_set = [["Mkv File (*.mkv)","*.mkv"],["Avi File (*.avi)","*.avi"],["mp4 File (*.mp4)","*.mp4"],["All File (*.*)","*.*"]]
    def_ext = "*.#{$movie_default_extension}"
    if i = ext_set.index {|v| v[1] == def_ext}
      ext_set.unshift ext_set.delete_at(i)
    else
      ext_set.unshift ["#{$movie_default_extension} File (#{def_ext})",def_ext]
    end
    filenames = SWin::CommonDialog::openFilename(self,ext_set,0x81204,"Movie file select",def_ext,$open_dir) #ファイルを開くダイアログを開く
    return unless filenames                               #ファイルが選択されなかった場合、キャンセルされた場合は戻る
    if filenames =~ /\000/
      folder,*files = filenames.split("\000")
    else
      folder = File.dirname(filenames)
      files  = [File.basename(filenames)]
    end
    @movie_files = []
    files.each do |file|
      @movie_files.push "#{folder}\\#{file}"
    end
    listbox_load
  end
  
  def menu_exit_clicked
    close
  end

  def menu_setting_clicked
    a = $ascii_mode
    return unless VRLocalScreen.openModalDialog(self,nil,Modaldlg_setting,nil,nil)  #設定画面のモーダルダイアログを開く
    setting_save(false)
    listbox_load unless a == $ascii_mode
  end
  
  def menu_timestamp_clicked
    result = VRLocalScreen.openModalDialog(self,nil,Modaldlg_timestamp,nil,nil)#設定画面のモーダルダイアログを開く
    if result
      listbox_load if @movie_files.include?(result)
    end
  end
  
  def menu_version_clicked
    messageBox(APP_VER_COOMENT ,"bs movie cut Version",0)
  end

  def menu_save_clicked
    setting_save
    messageBox("Current settings saved." ,"Settings saved.",0)
  end
  
  def menu_modsetting_clicked
    return unless VRLocalScreen.openModalDialog(self,nil,Modaldlg_modsetting,nil,nil)  #設定画面のモーダルダイアログを開く
    setting_save(false)
  end
  
  def menu_notescore_clicked
    target = @convert_list[@listBox_map.selectedString]
    unless target
      messageBox("Please select a map.","Not selected",48)
      return
    end
    songName            =  target[1][@fields.index('songName')]
    startTime           =  target[1][@fields.index('startTime')]
    time_name = Time.at(startTime.to_i / 1000).localtime.strftime($time_format)
    sql = "SELECT * FROM NoteScore WHERE startTime = #{startTime};"
    result = db_execute(sql)
    if result
      fields,rows = result
    else
      return
    end
    if rows.size == 0
      messageBox("No notes score data available.","Not notes score",48)
      return
    end
    savefile = file_name_check("#{time_name}_#{songName}.csv")
    fn = SWin::CommonDialog::saveFilename(self,[["CSV FIle(*.csv)","*.csv"],["All File(*.*)","*.*"]],0x1004,'Note Score File Save','*.csv',0,savefile)
    return unless fn
    CSV.open(fn,'w') do |record|
      record << "unixTime,movieTime,event,score,score%,rank,hitNotes,missedNotes,combo,batteryEnergy,noteID,noteType,noteCutDirection,noteLine,noteLayer,beforeScore,initialScore,afterScore,cutDistanceScore,finalScore,cutMultiplier,saberSpeed,saberType,timeDeviation,cutDirectionDeviation,cutDistanceToCenter,timeToNextBasicNote".split(",")
      record << "時間(unixtime ms),動画時間,イベント,スコア,スコア%,ランク,ヒット数,ミス数,コンボ数,ライフ,ノーツID,ノーツ種類,ノーツ矢印,水平位置(→),垂直位置(↑),カット前角度スコア,カット前スコア,カット後スコア,中心分スコア,合計スコア,コンボ乗数,セイバー速度,セイバー種類,最適時間からオフセット,完全角度からのオフセット,中心からのカット距離,次のノーツまでの時間".split(",") unless $ascii_mode
      rows.each do |cols|
        line = []
        line << cols[fields.index("time")]
        movie_time = ((cols[fields.index("time")] - startTime).to_f / 1000.0).round
        movie_time_min = movie_time / 60
        movie_time_sec = movie_time % 60
        line << "#{movie_time_min}:#{movie_time_sec}"
        line << cols[fields.index("event")]
        line << cols[fields.index("score")]
        line << (cols[fields.index("score")].to_f / cols[fields.index("currentMaxScore")].to_f * 1000.0).round / 10.0
        line << cols[fields.index("rank")]
        line << cols[fields.index("hitNotes")]
        line << cols[fields.index("missedNotes")]
        line << cols[fields.index("combo")]
        line << cols[fields.index("batteryEnergy")]
        line << cols[fields.index("noteID")]
        line << cols[fields.index("noteType")]
        line << cols[fields.index("noteCutDirection")]
        line << cols[fields.index("noteLine")]
        line << cols[fields.index("noteLayer")]
        line << cols[fields.index("beforeScore")]
        line << cols[fields.index("initialScore")]
        line << cols[fields.index("afterScore")]
        line << cols[fields.index("cutDistanceScore")]
        line << cols[fields.index("finalScore")]
        line << cols[fields.index("cutMultiplier")]
        line << cols[fields.index("saberSpeed")]
        line << cols[fields.index("saberType")]
        line << cols[fields.index("timeDeviation")]
        line << cols[fields.index("cutDirectionDeviation")]
        line << cols[fields.index("cutDistanceToCenter")]
        line << cols[fields.index("timeToNextBasicNote")]
        record << line
      end
    end
  end
  
  def menu_subtitle_setting_clicked
    return unless VRLocalScreen.openModalDialog(self,nil,Modaldlg_subtitle_setting,nil,nil)  #設定画面のモーダルダイアログを開く
    setting_save(false)
  end

  def menu_dbopen_clicked
    search_dir = []
    @comboBox_folder.eachString {|a| search_dir.push a.strip.sub(/^#[^#]+#/,'').strip}
    Modaldlg_db_view.set(search_dir)
    return unless result = VRLocalScreen.openModalDialog(self,nil,Modaldlg_db_view,nil,nil)  #日付範囲画面のモーダルダイアログを開く
    allread, start_time, end_time, search_dir_list = result
    db_map_load_time(allread, start_time, end_time, search_dir_list)
    listbox_refresh
  end
  
  def select_to_bsr
    return false unless select = @convert_list[@listBox_map.selectedString]
    songHash = select[1][@fields.index('songHash')]
    bsr,beatsaver_data = bsr_search(songHash)
    if bsr == "nil"
      messageBox("There is no song id","No song ID",0x30)
      return false
    elsif bsr == "err"
      messageBox("Not registered on beatsaver.","No bsr",0x30)
      return false
    else
      return bsr
    end
  end
  
  def menu_copy_bsr_clicked
    if bsr = select_to_bsr
      Clipboard.open(self.hWnd) do |cb|
        cb.setText "!bsr #{bsr}"
      end
      messageBox("Copying !bsr #{bsr}","Copy bsr",0x40)
    end
  end
  
  def menu_beatsaver_clicked
    if bsr = select_to_bsr
      open_url(BEATSAVER_URL.sub(/#bsr#/,bsr))
    end
  end
  
  def menu_beastsaber_clicked
    if bsr = select_to_bsr
      open_url(BEASTSABER_URL.sub(/#bsr#/,bsr))
    end
  end
  
  def menu_post_commnet_clicked
    return unless target = @convert_list[@listBox_map.selectedString]
    Modaldlg_post_comment.set(target,@fields)
    return unless result = VRLocalScreen.openModalDialog(self,nil,Modaldlg_post_comment,nil,nil)  #検索画面のモーダルダイアログを開く
    setting_save(false)
  end
  
  def menu_maplist_clicked
    output = []
    file_list = {}
    @listBox_map.eachSelected do |i|
      file_list[@convert_list[i][6]] = true
      output.push [@listBox_map.getTextOf(i).split("\t"),@convert_list[i]]
    end
    return if output.size == 0
    savefile = Time.now.strftime($time_format) + ".csv"
    fn = SWin::CommonDialog::saveFilename(self,[["CSV FIle(*.csv)","*.csv"],["All File(*.*)","*.*"]],0x1004,'Map List File Save','*.csv',0,savefile)
    return unless fn
    CSV.open(fn,'w') do |record|
      list_file = []
      @listBox_file.countStrings.times do |i|
        list_file << @listBox_file.getTextOf(i).split("\t") if file_list[i]
      end
      if list_file.size > 0
        record << "File,MovieFile".split(",")
        list_file.each { |a| record << a }
        record << []
        record << []
      end
      record << "File,DateTime,Time,Diff,Speed,Cleared,Rank,Score,Miss,Difficulty,SongName,levelAuthorName,songSubName,songAuthorName,mode,songBPM,noteJumpSpeed,notesCount,bombsCount,obstaclesCount,songName,maxScore,maxRank,environmentName,score,currentMaxScore,passedNotes,hitNotes,missedNotes,passedBombs,hitBombs,combo,maxCombo,multiplier,obstacles,instaFail,noFail,batteryEnergy,disappearingArrows,noBombs,songSpeed,songSpeedMultiplier,noArrows,ghostNotes,failOnSaberClash,strictAngles,fastNotes,staticLights,leftHanded,playerHeight,reduceDebris,noHUD,advancedHUD,autoRestart,levelId,pluginVersion,gameVersion,pauseCount,endFlag,startTime,endTime,menuTime,filename,create_time,access_time,write_time,file_type".split(",")
      output.each do |out_target|
        line = []
        line << out_target[0][0] #File
        line << out_target[0][1] #DateTime
        line << out_target[0][2] #Time
        line << out_target[0][3] #Diff
        line << out_target[0][4] #Speed
        line << out_target[0][5] #Cleared
        line << out_target[0][6] #Rank
        line << out_target[0][7] #Score
        line << out_target[0][8] #Miss
        line << out_target[0][9] #Difficulty
        line << out_target[1][1][@fields.index("songName")]
        line << out_target[1][1][@fields.index("levelAuthorName")]
        line << out_target[1][1][@fields.index("songSubName")]
        line << out_target[1][1][@fields.index("songAuthorName")]
        line << out_target[1][1][@fields.index("mode")]
        line << out_target[1][1][@fields.index("songBPM")]
        line << out_target[1][1][@fields.index("noteJumpSpeed")]
        line << out_target[1][1][@fields.index("notesCount")]
        line << out_target[1][1][@fields.index("bombsCount")]
        line << out_target[1][1][@fields.index("obstaclesCount")]
        line << out_target[1][1][@fields.index("songName")]
        line << out_target[1][1][@fields.index("maxScore")]
        line << out_target[1][1][@fields.index("maxRank")]
        line << out_target[1][1][@fields.index("environmentName")]
        line << out_target[1][1][@fields.index("score")]
        line << out_target[1][1][@fields.index("currentMaxScore")]
        line << out_target[1][1][@fields.index("passedNotes")]
        line << out_target[1][1][@fields.index("hitNotes")]
        line << out_target[1][1][@fields.index("missedNotes")]
        line << out_target[1][1][@fields.index("passedBombs")]
        line << out_target[1][1][@fields.index("hitBombs")]
        line << out_target[1][1][@fields.index("combo")]
        line << out_target[1][1][@fields.index("maxCombo")]
        line << out_target[1][1][@fields.index("multiplier")]
        line << out_target[1][1][@fields.index("obstacles")]
        line << out_target[1][1][@fields.index("instaFail")]
        line << out_target[1][1][@fields.index("noFail")]
        line << out_target[1][1][@fields.index("batteryEnergy")]
        line << out_target[1][1][@fields.index("disappearingArrows")]
        line << out_target[1][1][@fields.index("noBombs")]
        line << out_target[1][1][@fields.index("songSpeed")]
        line << out_target[1][1][@fields.index("songSpeedMultiplier")]
        line << out_target[1][1][@fields.index("noArrows")]
        line << out_target[1][1][@fields.index("ghostNotes")]
        line << out_target[1][1][@fields.index("failOnSaberClash")]
        line << out_target[1][1][@fields.index("strictAngles")]
        line << out_target[1][1][@fields.index("fastNotes")]
        line << out_target[1][1][@fields.index("staticLights")]
        line << out_target[1][1][@fields.index("leftHanded")]
        line << out_target[1][1][@fields.index("playerHeight")]
        line << out_target[1][1][@fields.index("reduceDebris")]
        line << out_target[1][1][@fields.index("noHUD")]
        line << out_target[1][1][@fields.index("advancedHUD")]
        line << out_target[1][1][@fields.index("autoRestart")]
        line << out_target[1][1][@fields.index("levelId")]
        line << out_target[1][1][@fields.index("pluginVersion")]
        line << out_target[1][1][@fields.index("gameVersion")]
        line << out_target[1][1][@fields.index("pauseCount")]
        line << out_target[1][1][@fields.index("endFlag")]
        line << out_target[1][1][@fields.index("startTime")]
        line << out_target[1][1][@fields.index("endTime")]
        line << out_target[1][1][@fields.index("menuTime")]
        line << out_target[1][0] #filename
        line << out_target[1][3] #create_time
        line << out_target[1][4] #access_time
        line << out_target[1][5] #write_time
        line << out_target[1][6] #file_type
        record << line
      end
    end
  end
  
end

VRLocalScreen.start Form_main




##このスプリクトを直接実行時に条件が正になる。
#if (defined?(ExerbRuntime) ? EXE_DIR + MAIN_RB : $0) == __FILE__
#  require 'win32ole'
#  wsh = WIN32OLE.new('WScript.Shell')
#  wsh.Popup("プログラムの実行を終了しました。", 0, "情報", 0 + 64 + 0x40000)
#end

