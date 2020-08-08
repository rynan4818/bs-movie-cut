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

class Form_main

  include VRDropFileTarget
  include VRDestroySensitive

  ##GUIイベント処理##
  
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
    $main_windowrect = self.windowrect
    setting_load
    printing_check
    if $beatsaber_dbfile
      unless File.exist?($beatsaber_dbfile)
        messageBox("'#{$beatsaber_dbfile}' #{MAIN_SELF_CREATED_DBFILE_CHECK1_MAIN}", MAIN_SELF_CREATED_DBFILE_CHECK1_TITLE,48)
        exit unless VRLocalScreen.openModalDialog(self,nil,Modaldlg_setting,nil,nil)  #設定画面のモーダルダイアログを開く
        setting_save(false)
      end
    else
      messageBox(MAIN_SELF_CREATED_DBFILE_CHECK2_MAIN, MAIN_SELF_CREATED_DBFILE_CHECK2_TITLE,48)
      exit unless VRLocalScreen.openModalDialog(self,nil,Modaldlg_setting,nil,nil)  #設定画面のモーダルダイアログを開く
      setting_save(false)
    end
    exit unless $beatsaber_dbfile
    exit unless File.exist? $beatsaber_dbfile
    db_check
    #リストボックスにタブストップを設定
    #[0x192,タブストップの数,[タブストップの位置,…]]  FormDesignerでstyleのLBS_USETABSTOPSのチェックが必要
    #0x192:LB_SETTABSTOPS  l*:32bit符号つき整数
    @listBox_map.sendMessage(0x192, 12,[7,31,87,109,135,156,188,209,234,260,290,442].pack('l*'))
    @listBox_file.sendMessage(0x192, 1,[24].pack('l*'))
    @statusbar.setparts(4,[80,160,240,-1])
    @statusbar.setTextOf(0,"0 #{STATUSBAR_FILE}",0)
    @statusbar.setTextOf(1,"0 #{STATUSBAR_MAP}",0)
    @statusbar.setTextOf(2,"0 #{STATUSBAR_SELECT}",0)
    @statusbar.setTextOf(3,"",0)
    @static_new_release.caption = "#{NEW_RELEASE_MES}#{$new_version}" if $new_version_check && $new_version
  end
  
  #終了時処理
  def self_destroy
    setting_save(false)
  end

  #ドラッグ＆ドロップ貼り付け
  def self_dropfiles(files)
    @movie_files = files
    listbox_load
  end
  
  #FFmpegオプションの項目変更時処理
  def comboBox_ffmpeg_selchanged
    printing_check
  end
  
  #譜面リスト選択変更時処理
  def listBox_map_selchanged
    select_count = @listBox_map.sendMessage(WMsg::LB_GETSELCOUNT,0,0)
    @statusbar.setTextOf(2,"#{select_count} #{STATUSBAR_SELECT}",0)
    return unless target = @convert_list[@listBox_map.selectedString]
    songAuthorName = target[1][@fields.index('songAuthorName')]
    mode      = target[1][@fields.index('mode')]
    bpm       = target[1][@fields.index('songBPM')]
    njs       = target[1][@fields.index('noteJumpSpeed')]
    length    = target[1][@fields.index('length')].to_i
    notes     = target[1][@fields.index('notesCount')].to_i
    bombs     = target[1][@fields.index('bombsCount')]
    obstacles = target[1][@fields.index('obstaclesCount')]
    instaFail = target[1][@fields.index('instaFail')]          #IF
    be        = target[1][@fields.index('batteryEnergy')]      #BE
    da        = target[1][@fields.index('disappearingArrows')] #DA
    gn        = target[1][@fields.index('ghostNotes')]         #GN
    songSpeed = target[1][@fields.index('songSpeed')]          #FS,SS
    nf        = target[1][@fields.index('noFail')]             #NF
    no        = target[1][@fields.index('obstacles')]          #NO
    nb        = target[1][@fields.index('noBombs')]            #NB
    na        = target[1][@fields.index('noArrows')]           #NA
    sl        = target[1][@fields.index('staticLights')]       #SL
    lh        = target[1][@fields.index('leftHanded')]         #LH
    rd        = target[1][@fields.index('reduceDebris')]       #RD
    nh        = target[1][@fields.index('noHUD')]              #NH
    mod = ""
    mod += "IF," if instaFail == 1
    mod += "BE," if be == 1
    mod += "DA," if da == 1
    mod += "GN," if gn == 1
    mod += "FS," if songSpeed == "Faster"
    mod += "SS," if songSpeed == "Slower"
    mod += "NF," if nf == 1
    mod += "NO," if no == 0
    mod += "NB," if nb == 1
    mod += "NA," if na == 1
    player_setting = ""
    player_setting += "SL," if sl == 1
    player_setting += "LH," if lh == 1
    player_setting += "RD," if rd == 1
    player_setting += "NH," if nh == 1
    if length > 0
      notes_sec = (notes.to_f / (length.to_f / 10000.0)).round.to_f / 10.0
    else
      notes_sec = "err"
    end
    text =  "#{STATUSBAR_INFO_ARTIST}: #{songAuthorName[0,12]}  #{STATUSBAR_INFO_MODE}: #{mode}  NSJ: #{njs.to_f.round}  BPM: #{bpm.to_f.round}  "
    text += "#{STATUSBAR_INFO_NOTES}: #{notes} [#{notes_sec}/s]  #{STATUSBAR_INFO_BOMBS}: #{bombs}  #{STATUSBAR_INFO_OBSTACLES}: #{obstacles}#{'  Mod: ' unless mod == ''}#{mod.sub(/,$/,'')}"
    text += "#{'  Set: ' unless player_setting == ''}#{player_setting.sub(/,$/,'')}"
    @statusbar.setTextOf(3,text,0)
  end

  def button_run_clicked
    Dir.chdir(EXE_DIR)
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
        messageBox(MAIN_BUTTON_RUN_FILE_NAME_SYNTAXERROR, MAIN_BUTTON_RUN_FILE_NAME_SYNTAXERROR_TITLE, 48)
        @button_run.style     = 1342177280
        @static_message.caption = "Paste the file to be converted by drag and drop"
        refresh
        return
      rescue Exception => e
        messageBox("#{MAIN_BUTTON_RUN_FILE_NAME_EXCEPTION}\r\n#{e.inspect}", MAIN_BUTTON_RUN_FILE_NAME_EXCEPTION_TITLE, 48)
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
      if !@printing && @checkBox_key_frame.checked?
        key_frame_data = key_frame_check(file,startTime,target,stoptime)
      else
        key_frame_data = nil
      end
      if @checkBox_printing.checked? && @printing || @checkBox_subtitles.checked?
        movie_sub_create(target,str_dir,str_file,startTime,stoptime,key_frame_data)
        offset_time, cut_time = ffmpeg_run(file,file_name,ffmpeg_option,out_dir,startTime,target,stoptime,str_dir + str_file,true,key_frame_data)
      else
        #字幕ファイル削除
        File.delete str_dir + str_file if File.exist? str_dir + str_file
        offset_time, cut_time = ffmpeg_run(file,file_name,ffmpeg_option,out_dir,startTime,target,stoptime,false,true,key_frame_data)
      end
      #データベースに切り出し記録を残す
      db_open
      sql = "INSERT INTO MovieCutFile(startTime, datetime, out_dir, filename, stoptime, offsetTime, cutTime) VALUES (?, ?, ?, ?, ?, ?, ?);"
      if $ascii_mode
        @db.execute(sql,startTime,Time.now.to_i,out_dir,file_name,stoptime,offset_time + $offset, cut_time)
      else
        @db.execute(utf8cv(sql),startTime,Time.now.to_i,utf8cv(out_dir),utf8cv(file_name),stoptime,offset_time + $offset, cut_time)
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
    listBox_map_selchanged
  end
  
  def button_all_unselect_clicked
    @listBox_map.countStrings.times do |idx|
      @listBox_map.sendMessage(WMsg::LB_SETSEL,0,idx)   #全て未選択状態にする。
    end
    listBox_map_selchanged
  end

  def button_fullcombo_clicked
    @listBox_map.countStrings.times do |idx|
      if @convert_list[idx][1][@fields.index("cleared")] == 'finished' && @convert_list[idx][1][@fields.index("missedNotes")].to_i == 0
        @listBox_map.sendMessage(WMsg::LB_SETSEL,1,idx)   #選択状態にする。
      else
        @listBox_map.sendMessage(WMsg::LB_SETSEL,0,idx)   #未選択状態にする。
      end
    end
    listBox_map_selchanged
  end

  def button_finished_clicked
    @listBox_map.countStrings.times do |idx|
      if @convert_list[idx][1][@fields.index("cleared")] == 'finished'
        @listBox_map.sendMessage(WMsg::LB_SETSEL,1,idx)   #選択状態にする。
      else
        @listBox_map.sendMessage(WMsg::LB_SETSEL,0,idx)   #未選択状態にする。
      end
    end
    listBox_map_selchanged
  end

  def button_filter_clicked
    true_song = {}
    @listBox_map.countStrings.times do |idx|
      songHash = @convert_list[idx][1][@fields.index('songHash')]
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
      true_song[songHash] = true if flag
      unless @checkBox_all_same_song.checked?
        if flag
          @listBox_map.sendMessage(WMsg::LB_SETSEL,1,idx)   #選択状態にする。
        else
          @listBox_map.sendMessage(WMsg::LB_SETSEL,0,idx)   #未選択状態にする。
        end
      end
    end
    if @checkBox_all_same_song.checked?
      @listBox_map.countStrings.times do |idx|
        songHash = @convert_list[idx][1][@fields.index('songHash')]
        if true_song[songHash]
          @listBox_map.sendMessage(WMsg::LB_SETSEL,1,idx)   #選択状態にする。
        else
          @listBox_map.sendMessage(WMsg::LB_SETSEL,0,idx)   #未選択状態にする。
        end
      end
    end
    listBox_map_selchanged
  end

  def button_close_clicked
    close
  end

  def button_preview_clicked
    Dir.chdir(EXE_DIR)
    unless File.exist? $preview_tool.to_s
      messageBox("'#{$preview_tool.to_s}' #{MAIN_BUTTON_PREVIEW_TOOL_CHECK}", MAIN_BUTTON_PREVIEW_TOOL_CHECK_TITLE, 48)
      return
    end
    return unless target = @convert_list[@listBox_map.selectedString]
    case target[7]
    when 1
      file = target[0]
      out_dir  = File.dirname($preview_file.to_s.strip) + "\\"
      file_name = File.basename($preview_file.to_s.strip)
      unless File.directory?(out_dir)
        messageBox("'#{out_dir}'\r\n#{MAIN_BUTTON_PREVIEW_DIR_CHECK}", MAIN_BUTTON_PREVIEW_DIR_CHECK_TITLE, 48)
        return
      end
      if file_name.strip == ''
        messageBox(MAIN_BUTTON_PREVIEW_FILE_CHECK, MAIN_BUTTON_PREVIEW_FILE_CHECK_TITLE, 48)
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
      if !@printing && @checkBox_key_frame.checked?
        key_frame_data = key_frame_check(file,startTime,target,stoptime)
      else
        key_frame_data = nil
      end
      if @checkBox_printing.checked? && @printing && vf || @checkBox_subtitles.checked?
        movie_sub_create(target,str_dir,str_file,startTime,stoptime,key_frame_data)
        ffmpeg_run(file,file_name,ffmpeg_option,out_dir,startTime,target,stoptime,str_dir + str_file,vf,key_frame_data)
      else
        #字幕ファイル削除
        File.delete str_dir + str_file if File.exist? str_dir + str_file
        ffmpeg_run(file,file_name,ffmpeg_option,out_dir,startTime,target,stoptime,str_dir + str_file,vf,key_frame_data)
      end
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
      messageBox("#{MAIN_BUTTON_PREVIEW_ERROR}\r\n#{e.inspect}", MAIN_BUTTON_PREVIEW_ERROR_TITLE, 48)
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

  def button_notes_sort_clicked
    listbox_sort("NotesScore")
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
    listBox_map_selchanged
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
    $main_windowrect = self.windowrect
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
        result = ranked_check(self,target[1][@fields.index('songHash')],target[1][@fields.index('difficulty')],target[1][@fields.index('mode')])
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
      messageBox(MAIN_BUTTON_SEARCH_SCORESABER_CHECK, MAIN_BUTTON_SEARCH_SCORESABER_CHECK_TITLE, 48)
    end
    @convert_list = temp
    listbox_refresh
  end

  def button_open_preview_dir_clicked
    out_dir  = File.dirname($preview_file.to_s.strip) + "\\"
    $winshell.Run("\"#{out_dir}\"") if File.directory?(out_dir)
  end

  def button_ffmpeg_edit_clicked
    $main_windowrect = self.windowrect
    target = []
    @comboBox_ffmpeg.eachString {|a| target.push a}
    Modaldlg_list_option_setting.set(target, false, false, $ffmpeg_option_select, FFMPEG_EDIT_TITLE)
    return unless result = VRLocalScreen.openModalDialog(self,nil,Modaldlg_list_option_setting,nil,nil)
    @comboBox_ffmpeg.setListStrings result[0]
    $ffmpeg_option_select = result[1]
    @comboBox_ffmpeg.select($ffmpeg_option_select)
    setting_save(false,1)
  end

  def button_filename_edit_clicked
    $main_windowrect = self.windowrect
    variable_list = ["time_name","miss","bsr","startTime","endTime","menuTime","cleared","endFlag",
                     "pauseCount","pluginVersion","gameVersion","scene","mode","songName","songSubName",
                     "songAuthorName","levelAuthorName","songHash","songBPM","noteJumpSpeed","songTimeOffset",
                     "start","paused","length","difficulty","notesCount","bombsCount","obstaclesCount",
                     "maxScore","maxRank","environmentName","scorePercentage","score","currentMaxScore",
                     "rank","passedNotes","hitNotes","missedNotes","lastNoteScore","passedBombs","hitBombs",
                     "combo","maxCombo","multiplier","obstacles","instaFail","noFail","batteryEnergy",
                     "disappearingArrows","noBombs","songSpeed","songSpeedMultiplier","noArrows","ghostNotes",
                     "failOnSaberClash","strictAngles","fastNotes","staticLights","leftHanded","playerHeight",
                     "reduceDebris","noHUD","advancedHUD","autoRestart"]
    target = []
    @comboBox_filename.eachString {|a| target.push a}
    Modaldlg_list_option_setting.set(target,variable_list, false, $out_file_name_select, FILENAME_EDIT_TITLE, true, true, OUT_FOLDER_EDIT_NOTES)
    return unless result = VRLocalScreen.openModalDialog(self,nil,Modaldlg_list_option_setting,nil,nil)
    @comboBox_filename.setListStrings result[0]
    $out_file_name_select = result[1]
    @comboBox_filename.select($out_file_name_select)
    setting_save(false,2)
  end

  def button_out_folder_edit_clicked
    $main_windowrect = self.windowrect
    target = []
    @comboBox_folder.eachString {|a| target.push a}
    Modaldlg_list_option_setting.set(target, false, 2, $out_folder_select, OUT_FOLDER_EDIT_TITLE, true)
    return unless result = VRLocalScreen.openModalDialog(self,nil,Modaldlg_list_option_setting,nil,nil)
    @comboBox_folder.setListStrings result[0]
    $out_folder_select = result[1]
    @comboBox_folder.select($out_folder_select)
    setting_save(false,3)
  end

  def button_out_open_clicked
    out_dir = @comboBox_folder.getTextOf(@comboBox_folder.selectedString).strip.sub(/^#[^#]+#/,'').strip
    $winshell.Run("\"#{out_dir}\"") if File.directory?(out_dir)
  end

  def menu_open_clicked
    ext_set = [["Mkv File (*.mkv)","*.mkv"],["Avi File (*.avi)","*.avi"],["mp4 File (*.mp4)","*.mp4"],["All File (*.*)","*.*"]]
    def_ext = "*.#{$movie_default_extension.downcase}"
    if i = ext_set.index {|v| v[1] == def_ext}
      ext_set.unshift ext_set.delete_at(i)
    else
      ext_set.unshift ["#{$movie_default_extension.downcase} File (#{def_ext})",def_ext]
    end
    filenames = SWin::CommonDialog::openFilename(self,ext_set,0x81204, MAIN_MENU_OPEN_TITLE,def_ext,$open_dir) #ファイルを開くダイアログを開く
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
    $main_windowrect = self.windowrect
    a = $ascii_mode
    return unless VRLocalScreen.openModalDialog(self,nil,Modaldlg_setting,nil,nil)  #設定画面のモーダルダイアログを開く
    setting_save(false)
    listbox_load unless a == $ascii_mode
  end
  
  def menu_timestamp_clicked
    $main_windowrect = self.windowrect
    result = VRLocalScreen.openModalDialog(self,nil,Modaldlg_timestamp,nil,nil)#設定画面のモーダルダイアログを開く
    if result
      listbox_load if @movie_files.include?(result)
    end
  end
  
  def menu_version_clicked
    messageBox(APP_VER_COOMENT, MAIN_MENU_VERSION_TITLE, 0)
  end

  def menu_manual_clicked
    open_url(MANUAL_URL)
  end
  
  def menu_release_clicked
    open_url(RELEASE_URL)
  end

  def menu_save_clicked
    setting_save
    messageBox(MAIN_MENU_SAVE, MAIN_MENU_SAVE_TITLE, 0)
  end
  
  def menu_modsetting_clicked
    $main_windowrect = self.windowrect
    return unless VRLocalScreen.openModalDialog(self,nil,Modaldlg_modsetting,nil,nil)  #設定画面のモーダルダイアログを開く
    setting_save(false)
  end
  
  def menu_notescore_clicked
    target = @convert_list[@listBox_map.selectedString]
    unless target
      messageBox(MAIN_NOT_SELECT_MES, MAIN_NOT_SELECT_MES_TITLE, 48)
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
      messageBox(MAIN_NOT_NOTES_SCORE_DB_MES, MAIN_NOT_NOTES_SCORE_DB_MES_TITLE, 48)
      return
    end
    savefile = file_name_check("#{time_name}_#{songName}.csv")
    fn = SWin::CommonDialog::saveFilename(self,[["CSV FIle(*.csv)","*.csv"],["All File(*.*)","*.*"]],0x1004,NOTES_SCORE_FILE_SAVE_TITLE,'*.csv',0,savefile)
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
    $main_windowrect = self.windowrect
    return unless VRLocalScreen.openModalDialog(self,nil,Modaldlg_subtitle_setting,nil,nil)  #設定画面のモーダルダイアログを開く
    setting_save(false)
  end

  def menu_dbopen_clicked
    $main_windowrect = self.windowrect
    search_dir = []
    @comboBox_folder.eachString {|a| search_dir.push a.strip.sub(/^#[^#]+#/,'').strip}
    Modaldlg_db_view.set(search_dir)
    return unless result = VRLocalScreen.openModalDialog(self,nil,Modaldlg_db_view,nil,nil)  #日付範囲画面のモーダルダイアログを開く
    allread, start_time, end_time, search_dir_list, input_movie_search_dir_change, cut_only, ambiguous = result
    db_map_load_time(allread, start_time, end_time, search_dir_list, cut_only, ambiguous)
    setting_save(false) if input_movie_search_dir_change
    listbox_refresh
  end
  
  def menu_copy_bsr_clicked
    if bsr = select_to_bsr
      Clipboard.open(self.hWnd) do |cb|
        cb.setText "!bsr #{bsr}"
      end
      messageBox("#{MAIN_MENU_COPY_BSR}#{bsr}", MAIN_MENU_COPY_BSR_TITLE, 0x40)
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
    $main_windowrect = self.windowrect
    unless target = @convert_list[@listBox_map.selectedString]
      messageBox(MAIN_NOT_SELECT_MES, MAIN_NOT_SELECT_MES_TITLE, 48)
      return
    end
    Modaldlg_post_comment.set(target,@fields)
    return unless result = VRLocalScreen.openModalDialog(self,nil,Modaldlg_post_comment,nil,nil)  #検索画面のモーダルダイアログを開く
    setting_save(false)
  end
  
  def menu_maplist_clicked
    output = []
    file_list = {}
    if @convert_list.size == 0
      messageBox(MAIN_NOT_SELECT_MES2, MAIN_NOT_SELECT_MES2_TITLE, 48)
      return
    end
    @listBox_map.eachSelected do |i|
      file_list[@convert_list[i][6]] = true
      output.push [@listBox_map.getTextOf(i).split("\t"),@convert_list[i]]
    end
    if output.size == 0
      messageBox(MAIN_NOT_SELECT_MES2, MAIN_NOT_SELECT_MES2_TITLE, 48)
      return
    end
    savefile = Time.now.strftime($time_format) + ".csv"
    fn = SWin::CommonDialog::saveFilename(self,[["CSV FIle(*.csv)","*.csv"],["All File(*.*)","*.*"]],0x1004,PLAY_MAP_LIST_FILE_SAVE_TITLE,'*.csv',0,savefile)
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
      record << "File,DateTime,Time,Diff,Speed,Cleared,Rank,Score,Miss,Difficulty,SongName,levelAuthorName,songSubName,songAuthorName,mode,songBPM,noteJumpSpeed,notesCount,bombsCount,obstaclesCount,maxScore,maxRank,environmentName,score,currentMaxScore,passedNotes,hitNotes,missedNotes,passedBombs,hitBombs,combo,maxCombo,multiplier,obstacles,instaFail,noFail,batteryEnergy,disappearingArrows,noBombs,songSpeed,songSpeedMultiplier,noArrows,ghostNotes,failOnSaberClash,strictAngles,fastNotes,staticLights,leftHanded,playerHeight,reduceDebris,noHUD,advancedHUD,autoRestart,levelId,pluginVersion,gameVersion,pauseCount,endFlag,startTime,endTime,menuTime,filename,create_time,access_time,write_time,file_type".split(",")
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
  
  def menu_stat_mapper_clicked
    if @convert_list.size == 0
      messageBox(MAIN_NOT_SELECT_MES3, MAIN_NOT_SELECT_MES3_TITLE, 48)
      return
    end
    #マッパー情報集計
    mapper_name = {}
    mapper_count_temp = {}
    song_count_temp = {}
    time_count_temp = {}
    total_play_count = 0
    total_play_song  = {}
    total_play_time  = 0.0
    category = {}
    fast_time = nil
    last_time = nil
    @listBox_map.eachSelected do |i|
      mapper   = @convert_list[i][1][@fields.index("levelAuthorName")]
      cleared  = @convert_list[i][1][@fields.index("cleared")]
      category[cleared] = true
      mapper_name[mapper.upcase] = mapper
      mapper_count_temp[mapper.upcase] ||= {}
      mapper_count_temp[mapper.upcase][cleared] ||= 0
      mapper_count_temp[mapper.upcase][cleared] += 1
      total_play_count += 1
      songname = @convert_list[i][1][@fields.index("songName")]
      song_count_temp[mapper.upcase] ||= {}
      song_count_temp[mapper.upcase][songname] ||= 0
      song_count_temp[mapper.upcase][songname] += 1
      time = (@convert_list[i][1][@fields.index('endTime')].to_i - @convert_list[i][1][@fields.index('startTime')].to_i).to_f / (1000 * 3600).to_f
      time_count_temp[mapper.upcase] ||= {}
      time_count_temp[mapper.upcase][cleared] ||= 0.0
      time_count_temp[mapper.upcase][cleared] += time
      total_play_time += time
      total_play_song[songname] = true
      start_time = @convert_list[i][1][@fields.index('startTime')].to_i
      fast_time ||= start_time
      last_time ||= start_time
      fast_time = start_time if fast_time > start_time
      last_time = start_time if last_time < start_time
    end
    category = category.keys.sort do |a,b|
      if a =~ /pause/
        -1
      elsif b =~ /pause/
        1
      elsif a =~ /finished/
        1
      elsif b =~ /finished/
        -1
      else
        a<=>b
      end
    end
    #カウント数集計
    mapper_count = []
    mapper_count_temp.each do |k,v|
      mapper_count.push [mapper_name[k],v]
    end
    mapper_count.sort! do |a,b|
      a_chk = 0
      a[1].each {|k,v| a_chk += v}
      b_chk = 0
      b[1].each {|k,v| b_chk += v}
      b_chk <=> a_chk
    end
    mapper_count.slice!(DEFALUT_STAT_Y_COUNT..-1)
    mapper_count_name = []
    mapper_count.each {|a| mapper_count_name.push a[0]}
    mapper_count_series = []
    category.each do |c|
      t = []
      mapper_count.each {|a| t.push a[1][c].to_i}
      mapper_count_series.push({"name" => c, "data" => t})
    end
    #曲数集計
    song_count_series = []
    song_count_temp.each do |k,v|
      song_count_series.push [mapper_name[k],v.size]
    end
    song_count_series.sort! do |a,b|
      b[1] <=> a[1]
    end
    song_count_series.slice!(DEFALUT_STAT_Y_COUNT..-1)
    #プレイ時間数集計
    time_count = []
    time_count_temp.each do |k,v|
      time_count.push [mapper_name[k],v]
    end
    time_count.sort! do |a,b|
      a_chk = 0.0
      a[1].each {|k,v| a_chk += v}
      b_chk = 0.0
      b[1].each {|k,v| b_chk += v}
      b_chk <=> a_chk
    end
    time_count.slice!(DEFALUT_STAT_Y_COUNT..-1)
    time_count_name = []
    time_count.each {|a| time_count_name.push a[0]}
    time_count_series = []
    category.each do |c|
      t = []
      time_count.each {|a| t.push((a[1][c].to_f * 10.0).round / 10.0)}
      time_count_series.push({"name" => c, "data" => t})
    end
    #グラフ用HTML作成
    File.open(STAT_TEMPLATE_FILE,'r') do |temp_f|
      File.open(MAPPER_STAT_HTML,'w') do |out_f|
        out_flag = false
        while line = temp_f.gets
          if line =~ /#MAPPER_START#/
            out_flag = true
            next
          end
          if line =~ /#MAPPER_END#/
            out_flag = false
            next
          end
          if out_flag
            case line
            when /#mapper_count_subtitle#/
              out_f.puts line.sub(/#mapper_count_subtitle#/,"Total play count = #{total_play_count}")
            when /#song_count_subtitle#/
              out_f.puts line.sub(/#song_count_subtitle#/,"Total play song count = #{total_play_song.size}")
            when /#time_count_subtitle#/
              out_f.puts line.sub(/#time_count_subtitle#/,"Total play time = #{(total_play_time * 10.0).round / 10.0}hour")
            when /#mapper_count_name#/
              out_f.print line.sub(/#mapper_count_name#/,"").chop
              JSON.generate(mapper_count_name).each do |json|
                out_f.puts json
              end
            when /#mapper_count_series#/
              out_f.print line.sub(/#mapper_count_series#/,"").chop
              JSON.generate(mapper_count_series).each do |json|
                out_f.puts json
              end
            when /#song_count_series#/
              out_f.print line.sub(/#song_count_series#/,"").chop
              JSON.generate(song_count_series).each do |json|
                out_f.puts json
              end
            when /#time_count_name#/
              out_f.print line.sub(/#time_count_name#/,"").chop
              JSON.generate(time_count_name).each do |json|
                out_f.puts json
              end
            when /#time_count_series#/
              out_f.print line.sub(/#time_count_series#/,"").chop
              JSON.generate(time_count_series).each do |json|
                out_f.puts json
              end
            when /#title#/
              title = Time.at(fast_time / 1000).localtime.strftime("%y/%m/%d") + " - " + Time.at(last_time / 1000).localtime.strftime("%y/%m/%d")
              title += "<br>  Total:#{total_play_count}plays #{(total_play_time * 10.0).round / 10.0}hour #{total_play_song.size}songs #{mapper_name.size}mapper"
              out_f.puts line.sub(/#title#/,title)
            else
              out_f.puts line
            end
          end
        end
      end
    end
    begin
      #外部プログラム呼び出しで、処理待ちしないためWSHのRunを使う
      $winshell.Run(%Q!"#{MAPPER_STAT_HTML}"!)
    rescue Exception => e
      messageBox("#{MAIN_WSH_ERR}\r\n#{e.inspect}", MAIN_WSH_ERR_TITLE, 16)
    end
    
  end
  
  #精度
  def menu_stat_accuracy_clicked
    if @convert_list.size == 0
      messageBox(MAIN_NOT_SELECT_MES2, MAIN_NOT_SELECT_MES2_TITLE, 48)
      return
    end
    if messageBox(STAT_ACCURACY_MODE_OUTPUT, STAT_ACCURACY_MODE_OUTPUT_TITLE, 36) == 6 #はい
      mode_output = true
    else
      mode_output = false
    end
    left_score = {}
    right_score = {}
    left_accuracy_sum = 0
    left_accuracy_count = 0
    right_accuracy_sum = 0
    right_accuracy_count = 0
    accuracy_grid_sum = [[0,0,0,0],[0,0,0,0],[0,0,0,0]]
    accuracy_grid_count = [[0,0,0,0],[0,0,0,0],[0,0,0,0]]
    score = {}
    fast_time = nil
    last_time = nil
    total_play_count = 0
    target_startTime = {}
    note_details = {}
    note_details["Both"] = {}
    note_details["NoteA"] = {}
    note_details["NoteB"] = {}
    startTime = 0
    songname = ""
    levelAuthorName = ""
    songHash = ""
    difficulty = ""
    mode = ""
    scorePercentage = 0.0
    maxCombo = 0
    missedNotes = 0
    passedNotes = 0
    hitNotes = 0
    delta_accuracy = nil
    direction_type = ["Up","Down","Left","Right","UpLeft","UpRight","DownRight","DownLeft","Any"]
    @listBox_map.eachSelected do |i|
      target_startTime[startTime = @convert_list[i][1][@fields.index("startTime")]] = true
      fast_time ||= startTime
      last_time ||= startTime
      fast_time = startTime if fast_time > startTime
      last_time = startTime if last_time < startTime
      if (total_play_count += 1) == 1
        songname = @convert_list[i][1][@fields.index("songName")]
        levelAuthorName = @convert_list[i][1][@fields.index("levelAuthorName")]
        songHash = @convert_list[i][1][@fields.index("songHash")]
        difficulty = @convert_list[i][1][@fields.index("difficulty")]
        mode = @convert_list[i][1][@fields.index("mode")]
        maxCombo = @convert_list[i][1][@fields.index("maxCombo")]
        missedNotes = @convert_list[i][1][@fields.index("missedNotes")]
        scorePercentage = @convert_list[i][1][@fields.index("scorePercentage")]
        passedNotes = @convert_list[i][1][@fields.index("passedNotes")]
        hitNotes = @convert_list[i][1][@fields.index("hitNotes")]
      end
    end
    if total_play_count == 1
      sql =  "SELECT max(scorePercentage) FROM MovieCutRecord WHERE startTime < #{startTime} AND "
      sql += "mode = '#{mode}' AND songHash = '#{songHash}' AND difficulty = '#{difficulty}' AND cleared = 'finished';"
      result = db_execute(sql)
      if result
        fields,rows = result
        if rows[0][0]
          delta_accuracy = ((scorePercentage - rows[0][0]) * 100.0).round / 100.0
        end
      end
    end
    sql =  "SELECT startTime,noteType,afterScore,cutDistanceScore,finalScore,noteCutDirection,noteLine,noteLayer FROM NoteScore "
    sql += "WHERE event = 'noteFullyCut' AND startTime >= #{fast_time} AND startTime <= #{last_time};"
    fast_time = nil
    last_time = nil
    show(0)
    puts "Please wait ..."
    print "Database read ..."
    result = db_execute(sql)
    if result
      fields,rows = result
    else
      show
      return
    end
    if rows.size == 0
      messageBox(STAT_ACCURACY_NOT_MES, STAT_ACCURACY_NOT_MES_TITLE, 48)
      show
      return
    end
    puts " completion"
    print "Counting ."
    start_time_check = {}
    progress = 0
    rows.each do |cols|
      if target_startTime[startTime = cols[fields.index("startTime")]]
        progress += 1
        print "." if (progress % 10000) == 0
        unless start_time_check[startTime]
          start_time_check[startTime] = true
        end
        fast_time ||= startTime
        last_time ||= startTime
        fast_time = startTime if fast_time > startTime
        last_time = startTime if last_time < startTime
        noteType = cols[fields.index("noteType")]
        noteCutDirection = cols[fields.index("noteCutDirection")]
        noteLine =  cols[fields.index("noteLine")].to_i
        noteLayer = cols[fields.index("noteLayer")].to_i
        afterScore = cols[fields.index("afterScore")].to_i
        cutDistanceScore = cols[fields.index("cutDistanceScore")].to_i
        finalScore = cols[fields.index("finalScore")].to_i
        next if finalScore > 115
        beforeScore = finalScore - cutDistanceScore - afterScore
        if noteType == "NoteA"     #赤(左)
          left_score[finalScore] ||= 0
          left_score[finalScore] += 1
          left_accuracy_sum += finalScore
          left_accuracy_count += 1
        elsif noteType == "NoteB"  #青(右)
          right_score[finalScore] ||= 0
          right_score[finalScore] += 1
          right_accuracy_sum += finalScore
          right_accuracy_count += 1
        end
        score[finalScore] ||= 0
        score[finalScore] += 1
        #4レーン通常配置のみ詳細情報を取得
        if direction_type.index(noteCutDirection) && noteLine >= 0 && noteLine <= 3 && noteLayer >= 0 &&
        noteLayer <= 2 && ["NoteA","NoteB"].index(noteType)
          note_details["Both"][noteLayer] ||= {}
          note_details["Both"][noteLayer][noteLine] ||= {}
          note_details["Both"][noteLayer][noteLine][noteCutDirection] ||= []
          note_details["Both"][noteLayer][noteLine][noteCutDirection].push finalScore
          note_details[noteType][noteLayer] ||= {}
          note_details[noteType][noteLayer][noteLine] ||= {}
          note_details[noteType][noteLayer][noteLine][noteCutDirection] ||= []
          note_details[noteType][noteLayer][noteLine][noteCutDirection].push finalScore
          accuracy_grid_sum[noteLayer][noteLine] += finalScore
          accuracy_grid_count[noteLayer][noteLine] += 1
        end
      end
    end
    puts " completion"
    print "Outputting "
    #グラフ用HTML作成
    File.open(STAT_TEMPLATE_FILE,'r') do |temp_f|
      File.open(ACCURACY_STAT_HTML,'w') do |out_f|
        out_flag = false
        while line = temp_f.gets
          if line =~ /#ACCURACY_START#/
            out_flag = true
            next
          end
          if line =~ /#ACCURACY_END#/
            out_flag = false
            next
          end
          if out_flag
            case line
            when /#two_handed_accuracy_series#/
              out_f.print line.sub(/#two_handed_accuracy_series#/,"").chop
              JSON.generate(accuracy_series(score)).each do |json|
                out_f.puts json
              end
            when /#left_hand_accuracy_series#/
              out_f.print line.sub(/#left_hand_accuracy_series#/,"").chop
              JSON.generate(accuracy_series(left_score)).each do |json|
                out_f.puts json
              end
            when /#right_hand_accuracy_series#/
              out_f.print line.sub(/#right_hand_accuracy_series#/,"").chop
              JSON.generate(accuracy_series(right_score)).each do |json|
                out_f.puts json
              end
            when /#title#/
              if total_play_count == 1
                title = Time.at(fast_time / 1000).localtime.strftime("%y/%m/%d")
                if $ascii_mode
                  title += " : #{songname} : #{levelAuthorName}"
                else
                  title += " : #{utf8cv(songname)} : #{utf8cv(levelAuthorName)}"
                end
              else
                title = Time.at(fast_time / 1000).localtime.strftime("%y/%m/%d") + " - " + Time.at(last_time / 1000).localtime.strftime("%y/%m/%d")
                title += "    Total:#{total_play_count}plays"
              end
              out_f.puts line.sub(/#title#/,title)
            when /#accuracy_placement_note#/
              if mode_output
                out_f.puts utf8cv("N:ノーツ数(Notes count)  A:平均値(Average)  S:標準偏差(SD)  M1:最頻値(Mode)  M2:2番目の最頻値(2sd mode)  M3:3番目の最頻値(3sd mode)")
              else
                out_f.puts utf8cv("上段(Upper):ノーツ数(Notes count)  中段(Middle):平均値(Average)  下段(Lower):標準偏差(SD)")
              end
            when /#accuracy_summary#/
              ave_cal = Proc.new do |sum,count,rounding|
                if count > 0
                  (sum.to_f / count.to_f * rounding.to_f).round / rounding.to_f
                else
                  "-"
                end
              end
              out_f.puts "<table border=\"1\" align=\"center\">"
              if total_play_count == 1
                out_f.puts "<tr>"
                out_f.puts "<th>ACCURACY RATIO</th>"
                out_f.puts "<th>DELTA</th>"
                out_f.puts "<th>MAX COMBO</th>"
                out_f.puts "<th>MISSES</th>"
                out_f.puts "<th>BLOQS</th>"
                out_f.puts "</tr>"
                out_f.puts "<tr>"
                out_f.puts "<td>#{scorePercentage}%</td>"
                if delta_accuracy
                  if delta_accuracy > 0.0
                    out_f.puts "<td>+#{delta_accuracy}%</td>"
                  else
                    out_f.puts "<td>#{delta_accuracy}%</td>"
                  end
                else
                  out_f.puts "<td>-</td>"
                end
                out_f.puts "<td>#{maxCombo}</td>"
                out_f.puts "<td>#{missedNotes}</td>"
                out_f.puts "<td>#{hitNotes}/#{passedNotes}</td>"
                out_f.puts "</tr>"
              end
              out_f.puts "<tr>"
              out_f.puts "<th>LEFT HAND ACCURACY</th>"
              out_f.puts "<th>RIGHT HAND ACCURACY</th>"
              out_f.puts "<th>AVERAGE ACCURACY</th>"
              out_f.puts "</tr>"
              out_f.puts "<tr>"
              out_f.puts "<td>#{ave_cal.call(left_accuracy_sum, left_accuracy_count, 100)}</td>"
              out_f.puts "<td>#{ave_cal.call(right_accuracy_sum, right_accuracy_count, 100)}</td>"
              out_f.puts "<td>#{ave_cal.call((left_accuracy_sum + right_accuracy_sum), (left_accuracy_count + right_accuracy_count), 100)}</td>"
              out_f.puts "</tr>"
              out_f.puts "</table>"
              out_f.puts "<table border=\"1\" align=\"center\">"
              out_f.puts "<tr>"
              out_f.puts "<th colspan = \"4\">ACCURACY GRID</th>"
              out_f.puts "</tr>"
              out_f.puts "<tr>"
              out_f.puts "<td>#{ave_cal.call(accuracy_grid_sum[2][0], accuracy_grid_count[2][0], 10)}</td>"
              out_f.puts "<td>#{ave_cal.call(accuracy_grid_sum[2][1], accuracy_grid_count[2][1], 10)}</td>"
              out_f.puts "<td>#{ave_cal.call(accuracy_grid_sum[2][2], accuracy_grid_count[2][2], 10)}</td>"
              out_f.puts "<td>#{ave_cal.call(accuracy_grid_sum[2][3], accuracy_grid_count[2][3], 10)}</td>"
              out_f.puts "</tr>"
              out_f.puts "<tr>"
              out_f.puts "<td>#{ave_cal.call(accuracy_grid_sum[1][0], accuracy_grid_count[1][0], 10)}</td>"
              out_f.puts "<td>#{ave_cal.call(accuracy_grid_sum[1][1], accuracy_grid_count[1][1], 10)}</td>"
              out_f.puts "<td>#{ave_cal.call(accuracy_grid_sum[1][2], accuracy_grid_count[1][2], 10)}</td>"
              out_f.puts "<td>#{ave_cal.call(accuracy_grid_sum[1][3], accuracy_grid_count[1][3], 10)}</td>"
              out_f.puts "</tr>"
              out_f.puts "<tr>"
              out_f.puts "<td>#{ave_cal.call(accuracy_grid_sum[0][0], accuracy_grid_count[0][0], 10)}</td>"
              out_f.puts "<td>#{ave_cal.call(accuracy_grid_sum[0][1], accuracy_grid_count[0][1], 10)}</td>"
              out_f.puts "<td>#{ave_cal.call(accuracy_grid_sum[0][2], accuracy_grid_count[0][2], 10)}</td>"
              out_f.puts "<td>#{ave_cal.call(accuracy_grid_sum[0][3], accuracy_grid_count[0][3], 10)}</td>"
              out_f.puts "</tr>"                                                   
              out_f.puts "</table>"
            when /#note_details#/
              note_div = Proc.new do |line_t,layer_t,line_c,layer_c|
                if line_t == line_c && layer_t == layer_c
                  "<div class=\"placement\"></div>"
                else
                  "<div class=\"space\"></div>"
                end
              end
              if mode_output
                notes_title = "N:"
                ave_title   = "A:"
                sd_title    = "S:"
              else
                notes_title = ""
                ave_title   = ""
                sd_title    = ""
              end
              2.downto(0) do |layer|
                note_details["Both"][layer] ||= {}
                note_details["NoteA"][layer] ||= {}
                note_details["NoteB"][layer] ||= {}
                4.times do |line|
                  note_details["Both"][layer][line] ||= {}
                  note_details["NoteA"][layer][line] ||= {}
                  note_details["NoteB"][layer][line] ||= {}
                  print "."
                  if layer == 1 && line == 2
                    out_f.puts "<tr>"
                    out_f.puts "	<th class = \"border_f\"></th>"
                    out_f.puts "	<th class = \"border_f\" colspan = \"3\"><div class=\"note0\"></div></th>"
                    out_f.puts "	<th class = \"border_f\" colspan = \"3\"><div class=\"note1\"></div></th>"
                    out_f.puts "	<th class = \"border_f\" colspan = \"3\"><div class=\"note2\"></div></th>"
                    out_f.puts "	<th class = \"border_f\" colspan = \"3\"><div class=\"note3\"></div></th>"
                    out_f.puts "	<th class = \"border_f\" colspan = \"3\"><div class=\"note4\"></div></th>"
                    out_f.puts "	<th class = \"border_f\" colspan = \"3\"><div class=\"note5\"></div></th>"
                    out_f.puts "	<th class = \"border_f\" colspan = \"3\"><div class=\"note6\"></div></th>"
                    out_f.puts "	<th class = \"border_f\" colspan = \"3\"><div class=\"note7\"></div></th>"
                    out_f.puts "	<th colspan = \"3\"><div class=\"note8\"></div></th>"
                    out_f.puts "</tr>"
                  end
                  out_f.puts "<tr>"
                  out_f.puts "<td class=\"border_f\">"
                  out_f.puts "<div id=\"tbl-bdr\">"
                  out_f.puts "<table>"
                  out_f.puts "<tr>"
                  out_f.puts "<td>#{note_div.call(line,layer,0,2)}</td>"
                  out_f.puts "<td>#{note_div.call(line,layer,1,2)}</td>"
                  out_f.puts "<td>#{note_div.call(line,layer,2,2)}</td>"
                  out_f.puts "<td>#{note_div.call(line,layer,3,2)}</td>"
                  out_f.puts "</tr>"
                  out_f.puts "<tr>"
                  out_f.puts "<td>#{note_div.call(line,layer,0,1)}</td>"
                  out_f.puts "<td>#{note_div.call(line,layer,1,1)}</td>"
                  out_f.puts "<td>#{note_div.call(line,layer,2,1)}</td>"
                  out_f.puts "<td>#{note_div.call(line,layer,3,1)}</td>"
                  out_f.puts "</tr>"
                  out_f.puts "<tr>"
                  out_f.puts "<td>#{note_div.call(line,layer,0,0)}</td>"
                  out_f.puts "<td>#{note_div.call(line,layer,1,0)}</td>"
                  out_f.puts "<td>#{note_div.call(line,layer,2,0)}</td>"
                  out_f.puts "<td>#{note_div.call(line,layer,3,0)}</td>"
                  out_f.puts "</tr>"
                  out_f.puts "</table>"
                  out_f.puts "</div>"
                  out_f.puts "</td>"
                  direction_type.each do |direction|
                    both = note_details["Both"][layer][line][direction]
                    note_a = note_details["NoteA"][layer][line][direction]
                    note_b = note_details["NoteB"][layer][line][direction]
                    [both,note_a,note_b].each_with_index do |notes,idx|
                      if idx == 2 && direction != "Any"
                        out_f.puts "<td class = \"border_f\">"
                      else
                        out_f.puts "<td>"
                      end
                      if notes
                        out_f.puts "#{notes_title}#{notes.size}<BR>" #ノーツ数
                        ave = notes.inject(:+).to_f / notes.size.to_f
                        out_f.puts "#{ave_title}#{(ave * 10.0).round.to_f / 10.0}<BR>" #平均値
                        sd = Math.sqrt(notes.inject(0) { |a,b| a + (b - ave) ** 2 } / notes.size) #母標準偏差
                        out_f.puts "#{sd_title}#{(sd * 10.0).round.to_f / 10.0}<BR>"#標準偏差
                        if mode_output
                          mode = notes.uniq.sort{|x,y| notes.count(y) <=> notes.count(x) }
                          out_f.puts "M1:#{mode[0]}<BR>"#最頻値
                          out_f.puts "M2:#{mode[1]}<BR>"#2番目の最頻値
                          out_f.puts "M3:#{mode[2]}<BR>"#3番目の最頻値
                        end
                      else
                        out_f.puts "#{notes_title}0"
                      end
                      out_f.puts "</td>"
                    end
                  end
                  out_f.puts "</tr>"
                end
              end
            else
              out_f.puts line
            end
          end
        end
      end
    end
    puts " completion"
    show
    begin
      #外部プログラム呼び出しで、処理待ちしないためWSHのRunを使う
      $winshell.Run(%Q!"#{ACCURACY_STAT_HTML}"!)
    rescue Exception => e
      messageBox("#{MAIN_WSH_ERR}\r\n#{e.inspect}", MAIN_WSH_ERR_TITLE, 16)
    end
    
  end
  
  #プレイリスト作成
  def menu_playlist_clicked
    $main_windowrect = self.windowrect
    if @convert_list.size == 0
      messageBox(MAIN_NOT_SELECT_MES2, MAIN_NOT_SELECT_MES2_TITLE, 48)
      return
    end
    select_list = []
    hash_check = {}
    @listBox_map.eachSelected do |i|
      songHash         = @convert_list[i][1][@fields.index("songHash")]
      songName         = @convert_list[i][1][@fields.index("songName")]
      levelAuthorName  = @convert_list[i][1][@fields.index("levelAuthorName")]
      songAuthorName   = @convert_list[i][1][@fields.index("songAuthorName")]
      next unless songHash =~ /^([0-9A-F]{40})/i
      songHash = $1.upcase
      next if hash_check[songHash]
      hash_check[songHash] = true
      select_list.push [songHash, songName, levelAuthorName, songAuthorName]
    end
    return if select_list.size == 0
    Modaldlg_playlist.set(select_list)
    return unless result = VRLocalScreen.openModalDialog(self,nil,Modaldlg_playlist,nil,nil)
    select_list, songname, image, description, title, author = result
    refresh
    #key(bsr)の追加[テスト用]
    if false
      show(0)
      select_list.size.times do |a|
        bsr,beatsaver_data = bsr_search(select_list[a][0])
        next if bsr == 'err' || bsr == 'nil'
        select_list[a].push bsr
      end
      show
    end
    playlist_data = playlist_convert(select_list, songname, image, description, title, author)
    if playlist_data
      fn = SWin::CommonDialog::saveFilename(self,[["BeatSaber PlayList(*.bplist)","*.bplist"],["all file (*.*)","*.*"]],0x1004,PLAY_LIST_FILE_SAVE_TITLE,'*.bplist',0,title.strip.gsub(/[\\\/:\*\?\"<>|]/,'_'))
      return unless fn
      if File.exist?(fn)
        return unless messageBox(MAIN_MENU_PLAYLIST_OVERWRITE_CHECK, MAIN_MENU_PLAYLIST_OVERWRITE_CHECK_TITLE, 0x0004) == 6
      end
      File.open(fn,'w') do |file|
        JSON.pretty_generate(playlist_data).each do |line|
          file.puts line
        end
      end
    end
  end
  
  def menu_stat_map_clicked
    target = @convert_list[@listBox_map.selectedString]
    unless target
      messageBox(MAIN_NOT_SELECT_MES, MAIN_NOT_SELECT_MES_TITLE, 48)
      return
    end
    songName            =  target[1][@fields.index('songName')]
    levelAuthorName     =  target[1][@fields.index('levelAuthorName')]
    startTime           =  target[1][@fields.index('startTime')]
    sql = "SELECT * FROM NoteScore WHERE startTime = #{startTime};"
    result = db_execute(sql)
    if result
      fields,rows = result
    else
      return
    end
    if rows.size == 0
      messageBox(MAIN_NOT_NOTES_SCORE_DB_MES, MAIN_NOT_NOTES_SCORE_DB_MES_TITLE, 48)
      return
    end
    score_data = []
    ave_cut_data = []
    ave_cut_data_r = []
    ave_cut_data_l = []
    miss_data  = []
    notes_data = []
    notes_count = 0
    sum_cut_score = 0
    sum_cut_score_r = 0
    sum_cut_score_l = 0
    cut_count = 0
    cut_count_r = 0
    cut_count_l = 0
    notes_data_work = []
    rows.each do |cols|
      time = cols[fields.index("time")] - startTime
      cols[fields.index("cutTime")]
      cols[fields.index("passedNotes")]
      cols[fields.index("afterScore")]
      cols[fields.index("cutDistanceScore")]
      if cols[fields.index("event")] == "noteFullyCut"
        sum_cut_score += cols[fields.index("finalScore")]
        cut_count += 1
        if cols[fields.index("noteType")] == "NoteA"
          sum_cut_score_l += cols[fields.index("finalScore")]
          cut_count_l += 1
        elsif cols[fields.index("noteType")] == "NoteB"
          sum_cut_score_r += cols[fields.index("finalScore")]
          cut_count_r += 1
        end
      end
      ave_cut_data.push [time,((sum_cut_score.to_f / cut_count.to_f) * 10.0).round.to_f / 10.0] if cut_count > 0
      ave_cut_data_r.push [time,((sum_cut_score_r.to_f / cut_count_r.to_f) * 10.0).round.to_f / 10.0] if cut_count_r > 0
      ave_cut_data_l.push [time,((sum_cut_score_l.to_f / cut_count_l.to_f) * 10.0).round.to_f / 10.0] if cut_count_l > 0
      scorePercentage = ((cols[fields.index("score")].to_f / cols[fields.index("currentMaxScore")].to_f) * 10000.0).round.to_f / 100.0
      score_data.push [time,scorePercentage]
      miss_data.push  [time,cols[fields.index("missedNotes")]]
      notes_count += 1 unless cols[fields.index("noteType")] == "Bomb"
      notes_data_work.push [time,notes_count]
      before_notes = 0
      notes_data_work.each do |a|
        break if (time - a[0]) < 1000
        before_notes = a[1]
      end
      notes_data.push [time,notes_count - before_notes]
    end
    #グラフ用HTML作成
    File.open(STAT_TEMPLATE_FILE,'r') do |temp_f|
      File.open(MAP_STAT_HTML,'w') do |out_f|
        out_flag = false
        while line = temp_f.gets
          if line =~ /#MAP_START#/
            out_flag = true
            next
          end
          if line =~ /#MAP_END#/
            out_flag = false
            next
          end
          if out_flag
            case line
            when /#scorePercentage_series#/
              out_f.print line.sub(/#scorePercentage_series#/,"").chop
              JSON.generate(score_data).each do |json|
                out_f.puts json
              end
            when /#ave_cut_series#/
              out_f.print line.sub(/#ave_cut_series#/,"").chop
              JSON.generate(ave_cut_data).each do |json|
                out_f.puts json
              end
            when /#ave_cut_r_series#/
              out_f.print line.sub(/#ave_cut_r_series#/,"").chop
              JSON.generate(ave_cut_data_r).each do |json|
                out_f.puts json
              end
            when /#ave_cut_l_series#/
              out_f.print line.sub(/#ave_cut_l_series#/,"").chop
              JSON.generate(ave_cut_data_l).each do |json|
                out_f.puts json
              end
            when /#miss_series#/
              out_f.print line.sub(/#miss_series#/,"").chop
              JSON.generate(miss_data).each do |json|
                out_f.puts json
              end
            when /#notes_series#/
              out_f.print line.sub(/#notes_series#/,"").chop
              JSON.generate(notes_data).each do |json|
                out_f.puts json
              end
            when /#title#/
              title = Time.at(startTime / 1000).localtime.strftime("%y/%m/%d")
              if $ascii_mode
                title += " : #{songName} : #{levelAuthorName}"
              else
                title += " : #{utf8cv(songName)} : #{utf8cv(levelAuthorName)}"
              end
              out_f.puts line.sub(/#title#/,title)
            else
              out_f.puts line
            end
          end
        end
      end
    end
    begin
      #外部プログラム呼び出しで、処理待ちしないためWSHのRunを使う
      $winshell.Run(%Q!"#{MAP_STAT_HTML}"!)
    rescue Exception => e
      messageBox("#{MAIN_WSH_ERR}\r\n#{e.inspect}", MAIN_WSH_ERR_TITLE, 16)
    end
  end
  
  def menu_stat_play_clicked
    result = db_execute("SELECT * FROM MovieCutRecord;")
    if result
      fields,rows = result
    else
      return
    end
    data = {}
    fast_time = nil
    last_time = nil
    total_play_count = 0
    rows.each do |cols|
      startTime   = cols[fields.index("startTime")].to_i
      fast_time ||= startTime
      last_time ||= startTime
      fast_time = startTime if fast_time > startTime
      last_time = startTime if last_time < startTime
      total_play_count += 1
      time = cols[fields.index('endTime')].to_i - cols[fields.index('startTime')].to_i
      hitNotes    = cols[fields.index("hitNotes")].to_i
      missedNotes = cols[fields.index("missedNotes")].to_i
      score       = cols[fields.index("score")].to_i
      t = Time.at(startTime / 1000).localtime
      date = Time.local(t.year,t.mon,t.day).to_i * 1000
      data[date] ||= [0,0,0,0]
      data[date][0] += time
      data[date][1] += hitNotes
      data[date][2] += missedNotes
      data[date][3] += score
    end
    day_time  = []
    day_hit   = []
    day_miss  = []
    day_score = []
    sum_time  = []
    sum_hit   = []
    sum_miss  = []
    sum_score = []
    total_time  = 0
    total_hit   = 0
    total_miss  = 0
    total_socre = 0
    data.keys.sort.each do |date|
      day_time.push  [date,(data[date][0].to_f / (100 * 60 * 60).to_f).round.to_f / 10.0]
      day_hit.push   [date,data[date][1]]
      day_miss.push  [date,data[date][2]]
      day_score.push [date,data[date][3]]
      total_time  += data[date][0]
      total_hit   += data[date][1]
      total_miss  += data[date][2]
      total_socre += data[date][3]
      sum_time.push  [date,(total_time.to_f / (100 * 60 * 60).to_f).round.to_f / 10.0]
      sum_hit.push   [date,total_hit]
      sum_miss.push  [date,total_miss]
      sum_score.push [date,total_socre]
    end
    #グラフ用HTML作成
    File.open(STAT_TEMPLATE_FILE,'r') do |temp_f|
      File.open(PLAY_STAT_HTML,'w') do |out_f|
        out_flag = false
        while line = temp_f.gets
          if line =~ /#PLAY_START#/
            out_flag = true
            next
          end
          if line =~ /#PLAY_END#/
            out_flag = false
            next
          end
          if out_flag
            case line
            when /#day_time_series#/
              out_f.print line.sub(/#day_time_series#/,"").chop
              JSON.generate(day_time).each do |json|
                out_f.puts json
              end
            when /#day_hit_series#/
              out_f.print line.sub(/#day_hit_series#/,"").chop
              JSON.generate(day_hit).each do |json|
                out_f.puts json
              end
            when /#day_miss_series#/
              out_f.print line.sub(/#day_miss_series#/,"").chop
              JSON.generate(day_miss).each do |json|
                out_f.puts json
              end
            when /#day_score_series#/
              out_f.print line.sub(/#day_score_series#/,"").chop
              JSON.generate(day_score).each do |json|
                out_f.puts json
              end
            when /#sum_time_series#/
              out_f.print line.sub(/#sum_time_series#/,"").chop
              JSON.generate(sum_time).each do |json|
                out_f.puts json
              end
            when /#sum_hit_series#/
              out_f.print line.sub(/#sum_hit_series#/,"").chop
              JSON.generate(sum_hit).each do |json|
                out_f.puts json
              end
            when /#sum_miss_series#/
              out_f.print line.sub(/#sum_miss_series#/,"").chop
              JSON.generate(sum_miss).each do |json|
                out_f.puts json
              end
            when /#sum_score_series#/
              out_f.print line.sub(/#sum_score_series#/,"").chop
              JSON.generate(sum_score).each do |json|
                out_f.puts json
              end
            when /#title#/
              title = Time.at(fast_time / 1000).localtime.strftime("%y/%m/%d") + " - " + Time.at(last_time / 1000).localtime.strftime("%y/%m/%d")
              title += "    Total:#{total_play_count}plays"
              out_f.puts line.sub(/#title#/,title)
            else
              out_f.puts line
            end
          end
        end
      end
    end
    begin
      #外部プログラム呼び出しで、処理待ちしないためWSHのRunを使う
      $winshell.Run(%Q!"#{PLAY_STAT_HTML}"!)
    rescue Exception => e
      messageBox("#{MAIN_WSH_ERR}\r\n#{e.inspect}", MAIN_WSH_ERR_TITLE, 16)
    end
  end
  
end
