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
  
  #subtitle printing(スコアを動画に焼き込み)の有効判定
  def printing_check
    encode_option = @comboBox_ffmpeg.getTextOf(@comboBox_ffmpeg.selectedString).strip.sub(/^#[^#]+#/,'').strip
    if encode_option =~ /-(c|codec|vcodec) +copy/i || encode_option =~ /-(c|codec):(v|V) +copy/i || encode_option =~ /-(c|codec):(v|V):\d +copy/i
      @checkBox_printing.style = 0x58000003
      @checkBox_key_frame.style = 0x50000003
      @printing = false
    else
      @checkBox_printing.style = 0x50000003
      @checkBox_key_frame.style = 0x58000003
      @printing = true
    end
    if encode_option =~ /-(c|codec|acodec) +copy/i || encode_option =~ /-(c|codec):(a|A) +copy/i || encode_option =~ /-(c|codec):(a|A):\d +copy/i
      @checkBox_normalize.style = 0x58000003
      @normalize = false
    else
      @checkBox_normalize.style = 0x50000003
      @normalize = true
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
          unless messageBox("#{file}\r\n#{MOVIE_FILE_TIMESTAMP1_MAIN}",MOVIE_FILE_TIMESTAMP1_TITLE,36) == 6 #はい
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
          if $timestamp_nomsg || messageBox("#{file}\r\n#{MOVIE_FILE_TIMESTAMP2_MAIN}",MOVIE_FILE_TIMESTAMP2_TITLE,36) == 6 #はい
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
  def db_map_load_time(allread, start_time, end_time, search_dir_list, cut_only, ambiguous)
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
      movie_cut_file[record[fields.index("startTime")].to_i] = [out_dir,filename]
    end
    notes_score_check
    #読込済み動画ファイルの取得
    unless cut_only
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
        movie_original_time.push [filename, record[fields.index("create_time")].to_i,
                                  record[fields.index("access_time")].to_i, record[fields.index("write_time")].to_i]
      end
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
      check_path = nil
      check_file = nil
      create_time = nil
      access_time = nil
      write_time = nil
      start_time = cols[@fields.index("startTime")].to_i
      menu_time  = cols[@fields.index("menuTime")].to_i
      movie_original_time.each do |v|
        if (v[1] <= start_time) && (v[3] >= menu_time)
          search_dir_list.each do |dir|
            check_path = dir + v[0]
            if file_idx = movie_file_list_check.index(check_path)
              break
            else
              if File.exist?(check_path)
                movie_file_list_check.push check_path
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
          file = check_path
          file_type = 1
          break
        end
      end
      unless file
        if movie_cut_file[start_time]
          ([movie_cut_file[start_time][0]] + search_dir_list).each do |dir|
            check_file = movie_cut_file[start_time][1]
            check_path = dir + check_file
            if file_idx = movie_file_list_check.index(check_path)
              file = check_path
              file_type = 2
              break
            else
              if File.exist?(check_path)
                file = check_path
                movie_file_list_check.push check_path
                file_idx = movie_file_list_check.size - 1
                file_type = 2
                break
              end
              if ambiguous && (match_file = Dir.glob("#{dir.gsub('\\','/')}*#{File.basename(check_file,'.*')}*.*")) != []
                file = match_file[0].gsub('/','\\\\')
                movie_file_list_check.push file
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
    db_open
    notes_score_check
    @movie_files.each_with_index do |file,file_idx|
      movie_file_list.push "#{file_idx + 1}\t#{file}" #変換元動画ファイル リスト作成
      create_time, access_time, write_time = movie_file_timestamp(file)
      #レコードの取得処理
      sql = "SELECT * FROM MovieCutRecord WHERE startTime < #{write_time} AND menuTime > #{create_time};"
      result = db_execute(sql,false,false)
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
    db_close
    if movie_file_list == []
      @listBox_file.clearStrings
    else
      @listBox_file.setListStrings movie_file_list
    end
  end
  
  #ノーツスコア記録リスト取得
  def notes_score_check
    sql = "SELECT DISTINCT startTime FROM NoteScore;"
    @notes_score_check = {}
    if result = db_execute(sql,false,false)
      @fields,rows = result
      rows.each do |cols|
        @notes_score_check[cols[0]] = 1
      end
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
      temp = []
      if @notes_score_check[cols[@fields.index('startTime')]]
        temp.push ""
      else
        temp.push "!"
      end
      case map_cols[7]
      when 1
        temp.push((file_idx + 1).to_s)
      when 2
        temp.push((file_idx + 1).to_s + "C")
      else
        temp.push ""
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
    #ステータスバーの更新
    file_count = @listBox_file.countStrings
    map_count  = @listBox_map.countStrings
    @statusbar.setTextOf(0,"#{file_count} #{STATUSBAR_FILE}#{"s" if file_count > 1 && !$japanese_mode}",0)
    @statusbar.setTextOf(1,"#{map_count} #{STATUSBAR_MAP}#{"s" if map_count > 1 && !$japanese_mode}",0)
    @statusbar.setTextOf(2,"0 #{STATUSBAR_SELECT}",0)
    @statusbar.setTextOf(3,"",0)
  end

  #リストボックスのソート
  def listbox_sort(sort_target,cnv_type = nil)
    #昇順降順入れ替え
    if @list_sort == sort_target
      @list_desc_order = !@list_desc_order
    else
      @list_desc_order = false
    end
    @list_sort = sort_target
    #リストのソート
    i = 0
    if sort_target == "File"
      @convert_list = @convert_list.sort_by {|a| [a[6].to_i,i += 1] }
    elsif sort_target == "Time"
      @convert_list = @convert_list.sort_by {|a| [(a[1][@fields.index("endTime")].to_i - a[1][@fields.index("startTime")].to_i),i += 1] }
    elsif sort_target == "Diff"
      @convert_list = @convert_list.sort_by do |a|
        [((a[1][@fields.index("endTime")].to_i - a[1][@fields.index("startTime")].to_i) - a[1][@fields.index("length")].to_i),i += 1]
      end
    elsif sort_target == "NotesScore"
      @convert_list = @convert_list.sort_by {|a| [@notes_score_check[a[1][@fields.index('startTime')]].to_i,i += 1] }
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
    $preview_ffmpeg       = DEFALUT_PREVIEW_FFMPEG
    $preview_keycut       = DEFALUT_PREVIEW_KEYCUT
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
    $subtitle_force_style = ""
    $simultaneous_notes_time = DEFALUT_SIMULTANEOUS_NOTES_TIME
    $max_notes_display    = DEFALUT_MAX_NOTES_DISPLAY
    $last_notes_time      = DEFALUT_LAST_NOTES_TIME
    $open_dir             = ""
    $movie_default_extension = "mkv"
    $input_movie_search_dir  = []
    $post_commnet         = DEFALUT_POST_COMMENT
    $ss_option_after      = false
    $max_volume           = 0.0
    if File.exist?(SETTING_FILE)
      setting = JSON.parse(File.read(SETTING_FILE))
      $time_format      = setting['time_format'].to_s         if setting['time_format']
      $beatsaber_dbfile = setting['beatsaber_dbfile'].to_s    if setting['beatsaber_dbfile']
      $preview_tool     = setting['preview_tool'].to_s        if setting['preview_tool']
      $preview_tool_option = setting['preview_tool_option'].to_s if setting['preview_tool_option']
      $preview_file     = setting['preview_file'].to_s        if setting['preview_file']
      $preview_ffmpeg   = setting['preview_ffmpeg'].to_s      if setting['preview_ffmpeg']
      $preview_keycut   = setting['preview_keycut']           if setting['preview_keycut']
      $subtitle_file    = setting['subtitle_file'].to_s       if setting['subtitle_file']
      $offset           = setting['offset'].to_f              if setting['offset']
      $max_volume       = setting['max_volume']               if setting['max_volume']
      $mod_setting_file = setting['mod_setting_file'].to_s    if setting['mod_setting_file']
      $subtitle_font        = setting['subtitle_font']        if setting['subtitle_font']
      $subtitle_font_size   = setting['subtitle_font_size']   if setting['subtitle_font_size']
      $subtitle_alignment   = setting['subtitle_alignment']   if setting['subtitle_alignment']
      $subtitle_red_notes   = setting['subtitle_red_notes']   if setting['subtitle_red_notes']
      $subtitle_blue_notes  = setting['subtitle_blue_notes']  if setting['subtitle_blue_notes']
      $subtitle_cut_format  = setting['subtitle_cut_format']  if setting['subtitle_cut_format']
      $subtitle_miss_format = setting['subtitle_miss_format'] if setting['subtitle_miss_format']
      $subtitle_force_style = setting['subtitle_force_style'] if setting['subtitle_force_style']
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
      $ss_option_after  = setting['ss option after']          unless setting['ss option after'] == nil
      @checkBox_finished.check setting['finished']            unless setting['finished'] == nil
      @checkBox_failed.check setting['failed']                unless setting['failed'] == nil
      @checkBox_pause.check setting['pause']                  unless setting['pause'] == nil
      @checkBox_softFail.check setting['softFail']            unless setting['softFail'] == nil
      @checkBox_miss.check setting['Miss']                    unless setting['Miss'] == nil
      @checkBox_score.check setting['Score']                  unless setting['Score'] == nil
      @checkBox_diff.check setting['Difference']              unless setting['Difference'] == nil
      @checkBox_speed.check setting['Speed']                  unless setting['Speed'] == nil
      @checkBox_length.check setting['Movie length']          unless setting['Movie length'] == nil
      @checkBox_key_frame.check setting['Key frame']          unless setting['Key frame'] == nil
      @checkBox_normalize.check setting['normalize']          unless setting['normalize'] == nil
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
          $ffmpeg_option_select = setting['FFmpeg option select']
        else
          $ffmpeg_option_select = 0
        end
      else
        @comboBox_ffmpeg.setListStrings DEFAULT_FFMPEG_OPTION
        $ffmpeg_option_select = 0
      end
      if setting['Output file name']
        @comboBox_filename.setListStrings setting['Output file name']
        if setting['Output file name select']
          $out_file_name_select = setting['Output file name select']
        else
          $out_file_name_select = 0
        end
      else
        @comboBox_filename.setListStrings DEFAULT_OUT_FILE_NAME
        $out_file_name_select = 0
      end
      if setting['Output folder']
        @comboBox_folder.setListStrings setting['Output folder']
        if setting['Output folder select']
          $out_folder_select = setting['Output folder select']
        else
          $out_folder_select = 0
        end
      else
        @comboBox_folder.setListStrings DEFAULT_OUT_FOLDER
        $out_folder_select = 0
      end
      a = self.windowrect
      self.move(setting['main_form_x'],setting['main_form_y'],a[2],a[3]) if setting['main_form_x'] && setting['main_form_y']
    else
      @comboBox_ffmpeg.setListStrings DEFAULT_FFMPEG_OPTION
      $ffmpeg_option_select = 0
      @comboBox_filename.setListStrings DEFAULT_OUT_FILE_NAME
      $out_file_name_select = 0
      @comboBox_folder.setListStrings DEFAULT_OUT_FOLDER
      $out_folder_select = 0
      @radioBtn_header_cut.check true
      @checkBox_subtitles.check true
    end
    @comboBox_ffmpeg.select($ffmpeg_option_select)
    @comboBox_filename.select($out_file_name_select)
    @comboBox_folder.select($out_folder_select)
  end

  #設定保存
  def setting_save(all = true,part_save = false)  #part_save = 1:FFmpeg option 2:Output file name 3:Output folder
    if File.exist?(SETTING_FILE)
      setting = JSON.parse(File.read(SETTING_FILE))
    else
      setting = {}
    end
    a = self.windowrect
    setting['main_form_x'] = a[0]
    setting['main_form_y'] = a[1]
    setting['Remove non-ASCII code'] = $ascii_mode
    setting['time_format']           = $time_format
    setting['beatsaber_dbfile']      = $beatsaber_dbfile
    setting['preview_tool']          = $preview_tool
    setting['preview_tool_option']   = $preview_tool_option
    setting['preview_ffmpeg']        = $preview_ffmpeg
    setting['preview_keycut']        = $preview_keycut
    setting['time_save']             = $time_save
    setting['timestamp_nomsg']       = $timestamp_nomsg
    setting['use_endtime']           = $use_endtime
    setting['preview_encode']        = $preview_encode
    setting['preview_file']          = $preview_file
    setting['subtitle_file']         = $subtitle_file
    setting['offset']                = $offset
    setting['max_volume']            = $max_volume
    setting['mod_setting_file']      = $mod_setting_file
    setting['subtitle_font']         = $subtitle_font
    setting['subtitle_font_size']    = $subtitle_font_size
    setting['subtitle_alignment']    = $subtitle_alignment
    setting['subtitle_red_notes']    = $subtitle_red_notes
    setting['subtitle_blue_notes']   = $subtitle_blue_notes
    setting['subtitle_cut_format']   = $subtitle_cut_format
    setting['subtitle_miss_format']  = $subtitle_miss_format
    setting['subtitle_force_style']  = $subtitle_force_style
    setting['simultaneous_notes_time'] = $simultaneous_notes_time
    setting['max_notes_display']     = $max_notes_display
    setting['last_notes_time']       = $last_notes_time
    setting['open_dir']              = $open_dir
    setting['movie_default_extension'] = $movie_default_extension
    setting['input_movie_search_dir']  = $input_movie_search_dir
    setting['post_commnet']            = $post_commnet
    setting['japanese_mode']           = $japanese_mode
    setting['new_version_check']       = $new_version_check
    setting['last_version_check']      = $last_version_check
    setting['new_version']             = $new_version
    if all
      setting['finished']              = @checkBox_finished.checked?
      setting['failed']                = @checkBox_failed.checked?
      setting['pause']                 = @checkBox_pause.checked?
      setting['softFail']              = @checkBox_softFail.checked?
      setting['Miss']                  = @checkBox_miss.checked?
      setting['Score']                 = @checkBox_score.checked?
      setting['Difference']            = @checkBox_diff.checked?
      setting['Movie length']          = @checkBox_length.checked?
      setting['with subtitles']        = @checkBox_subtitles.checked?
      setting['subtitle printing']     = @checkBox_printing.checked?
      setting['Key frame']             = @checkBox_key_frame.checked?
      setting['normalize']             = @checkBox_normalize.checked?
      setting['footer cut']            = @radioBtn_footer_cut.checked?
      setting['header cut']            = @radioBtn_header_cut.checked?
      setting['Speed']                 = @checkBox_speed.checked?
      setting['Difference_time']       = @edit_difftime.text.strip.to_i
      setting['Miss edit']             = @edit_miss.text.strip.to_i
      setting['Score edit']            = @edit_score.text.strip.to_f
      setting['Start offset']          = @edit_start_offset.text.strip.to_f
      setting['End offset']            = @edit_end_offset.text.strip.to_f
      setting['length']                = @edit_length.text.strip.to_f
    end
    if part_save == 1 || all
      setting['FFmpeg option'] = []
      @comboBox_ffmpeg.eachString {|a| setting['FFmpeg option'].push a}
      setting['FFmpeg option select']    = @comboBox_ffmpeg.selectedString
    end
    if part_save == 2 || all
      setting['Output file name'] = []
      @comboBox_filename.eachString {|a| setting['Output file name'].push a}
      setting['Output file name select'] = @comboBox_filename.selectedString
    end
    if part_save == 3 || all
      setting['Output folder'] = []
      @comboBox_folder.eachString {|a| setting['Output folder'].push a}
      setting['Output folder select']    = @comboBox_folder.selectedString
    end
    File.open(SETTING_FILE,'w') do |file|
      JSON.pretty_generate(setting).each do |line|
        file.puts line
      end
    end
  end
  
  def key_frame_check(file,startTime,target,stoptime)
    #キーフレーム調査
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
    stert_check_time = "#{ss_time - CHECK_BACK_TIME}%+#{CHECK_LENGTH_TIME}"
    end_check_time   = "#{ss_time + cut_time}%+#{CHECK_LENGTH_TIME}"
    probe_option = %Q! -show_frames -select_streams 0 -show_entries frame=key_frame,pkt_pts_time:side_data= -of csv=p=0 "#{file}"!
    command = %Q!ffprobe -v quiet -read_intervals #{stert_check_time}#{probe_option}!
    puts command
    start_frame_data =`#{command}`
    command = %Q!ffprobe -v quiet -read_intervals #{end_check_time}#{probe_option}!
    puts command
    end_frame_data = `#{command}`
    ss_key_time = 0.0
    start_frame_data.each_line do |line|
      a = line.strip.split(',')
      if a[0] == '1'
        if a[1].to_f < ss_time
          ss_key_time = a[1].to_f
        else
          break
        end
      end
    end
    end_key_time = 0.0
    end_key_get  = false
    end_frame_data.each_line do |line|
      a = line.strip.split(',')
      if a[0] == '1'
        if a[1].to_f < ss_time + cut_time
          next
        else
          end_key_time = a[1].to_f
          end_key_get = true
          break
        end
      end
      end_key_time = a[1].to_f
    end
    puts "#Can't get the end keyframe!#" unless end_key_get
    return [ss_key_time,end_key_time,ss_key_time - ss_time,end_key_time - (ss_time + cut_time)]
  end
  
  def volume_check(file,startTime,target,stoptime)
    #ボリュームレベル調査
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
    command = %Q!ffmpeg -i "#{file}" -ss #{ss_time} -t #{cut_time} -vn -af volumedetect -f null - 2>&1!
    puts command
    puts MAX_VOLUME_CHECK_MES
    volume_data =`#{command}`
    puts volume_data
    volume_data.each_line do |line|
      if line =~ / ?max_volume: *(\-?\d+\.?\d*) *dB/
        return $1.to_f
      end
    end
    return false
  end
  
  #ffmpeg実行処理
  def ffmpeg_run(file,file_name,ffmpeg_option,out_dir,startTime,target,stoptime,str_file = false,vf = true,key_frame_data = nil,max_volume_data= nil)
    create_time = target[3]
    write_time  = target[5]
    movie_start_offset = 0
    movie_end_offset = 0
    movie_start_offset = create_time - startTime if create_time > startTime
    movie_end_offset = stoptime - write_time if stoptime > write_time
    ss_time  = (startTime - create_time + movie_start_offset).to_f / 1000.0 + @edit_start_offset.text.strip.to_f + $offset
    cut_time = (stoptime - startTime - movie_end_offset).to_f / 1000.0 - @edit_start_offset.text.strip.to_f + @edit_end_offset.text.strip.to_f + $offset
    if @checkBox_length.checked?
      length_time = @edit_length.text.strip.to_f
      if cut_time > length_time
        if @radioBtn_header_cut.checked?
          ss_time += cut_time - length_time
        end
        cut_time = length_time
      end
    end
    if key_frame_data
      ss_time = key_frame_data[0]
      cut_time = key_frame_data[1] - key_frame_data[0]
      offset_time = @edit_start_offset.text.strip.to_f + key_frame_data[2]
      timestamp_unixtime_msec = startTime.to_i + (@edit_start_offset.text.strip.to_f * 1000.0).round + (key_frame_data[2] * 1000.0).round
    else
      offset_time = @edit_start_offset.text.strip.to_f
      timestamp_unixtime_msec = startTime.to_i + (@edit_start_offset.text.strip.to_f * 1000.0).round
    end
    offset_time = (offset_time * 1000.0).round.to_f / 1000.0
    #動画切り出し処理
    id = target[1][@fields.index('songHash')]
    title = target[1][@fields.index('songName')].gsub(/"/,'')
    artist = target[1][@fields.index('levelAuthorName')].gsub(/"/,'')
    timestamp = Time.at((timestamp_unixtime_msec / 1000.0).to_i).utc.strftime("%Y-%m-%dT%H:%M:%S")
    timestamp += ".#{"%03d" % (timestamp_unixtime_msec % 1000)}000Z"
    if $ascii_mode
      $KCODE='NONE'
      title.gsub!(/[^ -~\t]/,' ')                    #ASCII 文字以外を空白に変換
      artist.gsub!(/[^ -~\t]/,' ')                   #ASCII 文字以外を空白に変換
      $KCODE='s'
    end
    metadata  = %Q! -metadata "comment"="#{startTime}" -metadata "description"="#{id}" -metadata "title"="#{title}" -metadata "episode_id"="#{file_name.gsub(/"/,'')}"!
    metadata += %Q! -metadata "artist"="#{artist}" -metadata "date"="#{stoptime}" -metadata "keywords"="#{offset_time}" -metadata "composer"="#{cut_time}"!
    metadata += %Q! -metadata "creation_time"="#{timestamp}" -metadata "copyright"="#{$offset}" -metadata "genre"="#{ss_time}" -metadata "synopsis"="#{ffmpeg_option.gsub(/"/,'')}"!
    if $ss_option_after
      ss_option = %Q! -i "#{file}" -ss #{ss_time}!
    else
      ss_option = %Q! -ss #{ss_time} -i "#{file}"!
    end
    af_option = ""
    if max_volume_data
      af_option = " -af volume=#{$max_volume - max_volume_data}dB"
    end
    if str_file && File.exist?(str_file)
      vf_option = ""
      if @checkBox_printing.checked? && @printing && vf
        vf_srt_file = str_file.gsub('\\','\\\\\\\\\\\\\\\\').gsub(':','\\\\\\\\:')
        alignment = SUBTITLE_ALIGNMENT_SETTING[1][$subtitle_alignment]
        if $subtitle_force_style.strip == ""
          add_force_style = ""
        else
          add_force_style = "," + $subtitle_force_style.strip.sub(/^,/,"").sub(/,$/,"").gsub(/\s/,"")
        end
        vf_option = %Q! -vf "subtitles=#{vf_srt_file}:force_style='FontName=#{$subtitle_font},FontSize=#{$subtitle_font_size},Alignment=#{alignment}#{add_force_style}'"!
      end
      if @checkBox_subtitles.checked?
        command = %Q!ffmpeg#{ss_option} -t #{cut_time} -y #{ffmpeg_option}#{vf_option}#{af_option} "#{$subtitle_file}"!
        puts command
        `#{command}`
        command  = %Q!ffmpeg -i "#{$subtitle_file}" -i "#{str_file}" -y -map 0 -map 1 -c:a copy -c:v copy -c:s mov_text -metadata:s:s:0 language=eng !
        command += %Q!-metadata:s:s:0 title="Notes score"#{metadata} "#{out_dir}#{file_name}"!
      else
        command = %Q!ffmpeg#{ss_option} -t #{cut_time} -y #{ffmpeg_option}#{metadata}#{vf_option}#{af_option} "#{out_dir}#{file_name}"!
      end
    else
      command = %Q!ffmpeg#{ss_option} -t #{cut_time} -y #{ffmpeg_option}#{metadata}#{af_option} "#{out_dir}#{file_name}"!
    end
    puts command
    `#{command}`
    SWin::Application.doevents
    return [offset_time,cut_time]
  end
  
  ###字幕ファイル作成
  def movie_sub_create(target,out_dir,file_name,startTime,stoptime,key_frame_data = nil)
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
              cutMultiplier    = rows[rows_idx][fields.index('cutMultiplier')]
              cutDistanceScore = rows[rows_idx][fields.index('cutDistanceScore')]
              noteCutDirection = rows[rows_idx][fields.index('noteCutDirection')]
              noteLine         = rows[rows_idx][fields.index('noteLine')]
              noteLayer        = rows[rows_idx][fields.index('noteLayer')]
              finalScore       = rows[rows_idx][fields.index('finalScore')]
              score            = rows[rows_idx][fields.index('score')]
              currentMaxScore  = rows[rows_idx][fields.index('currentMaxScore')]
              rank             = rows[rows_idx][fields.index('rank')]
              passedNotes      = rows[rows_idx][fields.index('passedNotes')]
              hitNotes         = rows[rows_idx][fields.index('hitNotes')]
              missedNotes      = rows[rows_idx][fields.index('missedNotes')]
              combo            = rows[rows_idx][fields.index('combo')]
              maxCombo         = rows[rows_idx][fields.index('maxCombo')]
              saberSpeed       = rows[rows_idx][fields.index('saberSpeed')]
              passedBombs      = rows[rows_idx][fields.index('passedBombs')]
              hitBombs         = rows[rows_idx][fields.index('hitBombs')]
              batteryEnergy    = rows[rows_idx][fields.index('batteryEnergy')]
              multiplier       = rows[rows_idx][fields.index('multiplier')]
              multiplierProgress  = rows[rows_idx][fields.index('multiplierProgress')]
              cutDistanceToCenter = (rows[rows_idx][fields.index('cutDistanceToCenter')] * 1000.0).round
              noteCount = noteID - passedBombs + 1
              saberSpeedKmPerh    = (saberSpeed * 3.6).round
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
                messageBox(MOVIE_SUB_CREATE_SYNTAXERROR,MOVIE_SUB_CREATE_SYNTAXERROR_TITLE,48)
                return
              rescue Exception => e
                messageBox("#{MOVIE_SUB_CREATE_EXCEPTION}\r\n#{e.inspect}",MOVIE_SUB_CREATE_EXCEPTION_TITLE,48)
                return
              end
            end
          else
            jimaku_end = jimaku_start + ($last_notes_time.to_f * 1000.0).to_i
          end
        end
        #字幕用時間計算
        create_time = target[3]
        write_time  = target[5]
        movie_start_offset = 0
        movie_end_offset = 0
        movie_start_offset = create_time - startTime if create_time > startTime
        movie_end_offset = stoptime - write_time if stoptime > write_time
        movie_start_time  = startTime + movie_start_offset + (@edit_start_offset.text.strip.to_f * 1000.0).to_i + ($offset * 1000.0).to_i
        movie_stop_time   = stoptime - movie_end_offset + (@edit_end_offset.text.strip.to_f * 1000.0).to_i + ($offset * 1000.0).to_i
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
        if key_frame_data
          movie_start_time += (key_frame_data[2] * 1000.0).to_i
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
  
  def select_to_bsr
    unless select = @convert_list[@listBox_map.selectedString]
      messageBox(MAIN_NOT_SELECT_MES, MAIN_NOT_SELECT_MES_TITLE, 48)
      return false
    end
    songHash = select[1][@fields.index('songHash')]
    bsr,beatsaver_data = bsr_search(songHash)
    if bsr == "nil"
      messageBox(SELECT_TO_BSR_NIL_MAIN, SELECT_TO_BSR_NIL_TITLE, 0x30)
      return false
    elsif bsr == "err"
      messageBox(SELECT_TO_BSR_ERR_MAIN, SELECT_TO_BSR_ERR_TITLE, 0x30)
      return false
    else
      return bsr
    end
  end
  
  def accuracy_series(score)
    result = []
    under70 = 0
    score.keys.sort.each do |a|
      if a < 70
        under70 += score[a]
      else
        result.push [a,score[a]]
      end
    end
    result.unshift [69,under70]
    return result
  end
  
end
