#! ruby -Ks
# -*- mode:ruby; coding:shift_jis -*-
$KCODE='s'

#==============================================================================
#Project Name    : BeatSaber Movie Cut TOOL
#File Name       : bs_movie_cut.rb  _frm_bs_movie_cut.rb  sub_library.rb
#                : dialog_gui.rb  main_gui_event.rb  main_gui_sub.rb
#                : language_en.rb  language_jp.rb
#Creation Date   : 2020/01/08
# 
#Copyright       : 2020 リュナン (Twitter @rynan4818)
#License         : MIT License
#Tool            : ActiveScriptRuby(1.8.7-p330)
#                  https://www.artonx.org/data/asr/
#                  FormDesigner for Project VisualuRuby Ver 060501
#                  https://ja.osdn.net/projects/fdvr/
#RubyGems Package: rubygems-update (1.8.21)      https://rubygems.org/
#                  json (1.4.6 x86-mswin32)
#                  sqlite3 (1.3.3 x86-mswin32-60)
#==============================================================================

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

###obsのログの読み取りと録画情報の取得
def obs_log_check()
  return unless $obs_log_dir
  return unless File.directory?($obs_log_dir)
  Dir.glob("#{$obs_log_dir}\\*.txt".gsub(/\\/,'/')) do |logfile|
    next if $obs_log_time[logfile] == File.size(logfile)
    File.open(logfile,"r") do |f|
      year = 0
      mon = 0
      day = 0
      while line = f.gets
        if line =~ /Current Date\/Time: *(\d+)-(\d+)-(\d+)[, ]+(\d+):(\d+):(\d+) *$/i
          year = $1.to_i
          mon = $2.to_i
          day = $3.to_i
          hour = $4.to_i
        end
        next if year == 0
        if line =~ /^(\d+):(\d+):(\d+)\.(\d+):.+ffmpeg muxer.+Writing file *'(.+)' *...$/i
          start_time = Time.local(year, mon, day, $1.to_i, $2.to_i, $3.to_i).to_i * 1000 + $4.to_i
          if $1.to_i < hour
            start_time += 60*60*24*1000
          end
          movie_file = $5.gsub('/','\\\\')
          $obs_log_time[movie_file] ||= {}
          $obs_log_time[movie_file][:start_time] = start_time
        end
        if line =~ /^(\d+):(\d+):(\d+)\.(\d+):.+ffmpeg muxer.+Output of file *'(.+)' *stopped$/i
          end_time = Time.local(year, mon, day, $1.to_i, $2.to_i, $3.to_i).to_i * 1000 + $4.to_i
          movie_file = $5.gsub('/','\\\\')
          next if $obs_log_time[movie_file] == nil
          while $obs_log_time[movie_file][:start_time] > end_time
            end_time += 60*60*24*1000
          end
          $obs_log_time[movie_file][:end_time] = end_time
        end
      end
    end
    $obs_log_time[logfile] = File.size(logfile)
  end
end

###beatsaberのデータベースを開く処理###
def db_open
  #データーベースのオープン処理
  begin                                               #例外処理(begin〜rescue内でエラーが発生した場合はrescueの処理が実行される
    if $ascii_mode
      #SQLite3のデータベース(*.db)を開いてインスタンス変数@dbでアクセスできるようにする。
      @db = SQLite3::Database.new($beatsaber_dbfile)
    else
      #ファイル名が全角文字があるのでUTF-8に変換して渡す
      @db = SQLite3::Database.new(utf8cv($beatsaber_dbfile))  
    end
  rescue Exception => e                               #エラー内容がeに入る
    if e.inspect =~ /unable to open database file/    #エラー内容がデータベースが開けない内容の場合
      messageBox("#{DB_OPEN_ERROR_MES}\r\n#{$beatsaber_dbfile}",DB_OPEN_ERROR_TITLE,48)
    else
      messageBox(DB_ERROR_MES + e.inspect,DB_ERROR_TITLE,16)
    end
  end
end

def db_close
  @db.close
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
  db_column_check('MovieCutFile','offsetTime','REAL')
  db_column_check('MovieCutFile','cutTime','REAL')
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
      messageBox(DB_NOPLAY_RECORD, DB_NOPLAY_RECORD_TITLE, 48) if no_table_mes
      return "no_table" unless no_table_mes
    else
      messageBox(DB_ERROR_MES + e.inspect, DB_ERROR_TITLE, 16)
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
  Dir.chdir(EXE_DIR)
  beatsaver_data = {}
  if songHash =~ /^[0-9A-F]{40}/i
    begin
      beatsaver_data = JSON.parse(`curl.exe --connect-timeout #{CURL_TIMEOUT} #{BEATSAVER_BYHASH_URL}#{songHash[0,40]}`)
      bsr = beatsaver_data['id']
    rescue
      bsr = 'err'
    end
  else
    bsr = 'nil'
  end
  return [bsr,beatsaver_data]
end

def ranked_check(main_self,song_hash,difficulty,mode)
  Dir.chdir(EXE_DIR)
  unless $scoresaber_ranked
    SCORESABAER_URL =~ /limit=(\d+)/
    limit = $1.to_i
    $scoresaber_ranked = {"songs" => []}
    page = 0
    main_self.show(0)
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
    main_self.show
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
    messageBox("#{MAIN_WSH_ERR}\r\n#{e.inspect}", MAIN_WSH_ERR_TITLE, 16)
  end
end

#プレイリスト作成
def playlist_convert(select_list,name_output,image_file,description,title,author)
  bplist_data = {}
  songs_array = []
  select_list.each do |a|
    songHash, songName, levelAuthorName, songAuthorName, bsr = a
    song_data = {}
    if name_output
      if $ascii_mode
        song_data['songName'] = songName.strip
      else
        song_data['songName'] = utf8cv(songName.strip)
      end
    end
    song_data['key'] = bsr if bsr
    song_data['hash'] = songHash
    songs_array.push song_data
  end
  bplist_data['songs'] = songs_array
  if $ascii_mode
    bplist_data['playlistTitle'] = title
    bplist_data['playlistDescription'] = description
    bplist_data['playlistAuthor'] = author
  else
    bplist_data['playlistTitle'] = utf8cv(title)
    bplist_data['playlistDescription'] = utf8cv(description)
    bplist_data['playlistAuthor'] = utf8cv(author)
  end
  if File.exist?(image_file)
    image_data = File.open(image_file, "rb") {|f| f.read }
    image_base64 = Base64.encode64(image_data).split().join()
    if File.extname(image_file) =~ /\.png$/i
      type = 'png'
    else
      type = 'undefined'
    end
    bplist_data['image'] = "data:image/#{type};base64,#{image_base64}"
  else
    bplist_data['image'] = '1'
  end
  return bplist_data
end

#ダイアログの起動時位置調整
def dlg_move(dlg_self)
  m = $main_windowrect
  d = dlg_self.windowrect
  cx = m[0] + (m[2] / 2)
  cy = m[1] + (m[3] / 2)
  x = cx - (d[2] / 2)
  y = cy - (d[3] / 2)
  dlg_self.move(x, y, d[2], d[3])
end
