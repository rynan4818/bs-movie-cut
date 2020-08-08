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

class Modaldlg_playlist
  include VRDropFileTarget

  def self.set(select_list)
    @@select_list = select_list
  end
  
  def self_created
    listbox_set = []
    @@select_list.each do |a|
      songHash, songName, levelAuthorName, songAuthorName = a
      listbox_set.push "#{songName[0,39]}\t#{levelAuthorName[0,12]}\t#{songAuthorName[0,12]}\t#{songHash}"
    end
    #リストボックスにタブストップを設定
    #[0x192,タブストップの数,[タブストップの位置,…]]  FormDesignerでstyleのLBS_USETABSTOPSのチェックが必要
    #0x192:LB_SETTABSTOPS  l*:32bit符号つき整数
    @listBox_main.sendMessage(0x192, 3,[152,210,280].pack('l*'))
    @listBox_main.setListStrings(listbox_set)
    @checkBox_songname.check true
    dlg_move(self)
  end
  
  #ドラッグ＆ドロップ貼り付け
  def self_dropfiles(files)
    @edit_image.text = files[0]
  end
  
  def button_delete_clicked
    return if (select_idx = @listBox_main.selectedString) < 0
    @listBox_main.deleteString(select_idx)
    @@select_list.delete_at(select_idx)
  end

  def button_up_clicked
    return if (select_idx = @listBox_main.selectedString) < 0
    select_text = @listBox_main.getTextOf(select_idx)
    @listBox_main.deleteString(select_idx)
    delete_select = @@select_list.delete_at(select_idx)
    if select_idx - 1 >= 0
      idx = select_idx - 1
    else
      idx = 0
    end
    @listBox_main.addString(idx, select_text)
    @@select_list.insert(idx,delete_select)
    @listBox_main.select(idx)
  end

  def button_down_clicked
    return if (select_idx = @listBox_main.selectedString) < 0
    select_text = @listBox_main.getTextOf(select_idx)
    @listBox_main.deleteString(select_idx)
    delete_select = @@select_list.delete_at(select_idx)
    if select_idx + 1 <= @@select_list.size
      idx = select_idx + 1
    else
      idx = @@select_list.size
    end
    @listBox_main.addString(idx, select_text)
    @@select_list.insert(idx,delete_select)
    @listBox_main.select(idx)
  end

  #画像ファイル開くボタン
  def button_open_clicked
    ext_list = [["Image File (*.png;*.jpg;*.jpeg;*.gif)","*.png;*.jpg;*.jpeg;*.gif"],["all file (*.*)","*.*"]]
    fn = SWin::CommonDialog::openFilename(self,ext_list,0x1004,IMAGE_FILE_SELECT_TITLE,'*.png')
    return unless fn
    @edit_image.text = fn
  end

  def button_cancel_clicked
    close(false)
  end

  def button_save_clicked
    close([@@select_list,@checkBox_songname.checked?,@edit_image.text.strip,@edit_description.text.strip,@edit_title.text.strip,@edit_author.text.strip])
  end
  
end


class Modaldlg_list_option_setting

  def self.set(target, variable_list, file_type, defalut_idx, caption, main_empty_check = false, comment = true, notes = "")
    @@target = target
    @@variable_list = variable_list    #false --- no variaboe , strarray
    @@file_type = file_type            #false --- no file or folder , 1 --- file , 2 --- folder
    @@caption = caption
    @@main_empty_check = main_empty_check
    @@defalut_idx = defalut_idx
    @@comment = comment
    @@notes = notes
  end
  
  def edit_main_text
    if @@file_type == 2
      return @edit_main.text.strip.sub(/\\$/,'') + '\\'
    else
      return @edit_main.text.strip
    end
  end
  
  def comment_text
    if @@comment
      return "##{@edit_comment.text.gsub(/#/,'')}#  "
    else
      return ""
    end
  end
  
  def self_created
    self.caption = @@caption
    @static_main.caption = @@caption
    @static_notes.caption = @@notes
    @listBox_main.setListStrings(@@target)
    if @@variable_list
      @comboBox_var.setListStrings(@@variable_list)
      @comboBox_var.select(0)
    else
      @button_var_copy.style = 0x8000000
      @comboBox_var.style = 0x8000000
      @static_var.style = 0x8000000
    end
    @button_open.style =  0x8000000 unless @@file_type
    if @@defalut_idx
      @edit_default.text = @listBox_main.getTextOf(@@defalut_idx)
    else
      @static_default.style = 0x8000000
      @edit_default.style = 0x8000000
      @button_default.style = 0x8000000
    end
    unless @@comment
      @static_comment.style = 0x8000000
      @edit_comment.style = 0x8000000
    end
    dlg_move(self)
  end
  
  def button_copy_clicked
    return if (select_idx = @listBox_main.selectedString) < 0
    select_text = @listBox_main.getTextOf(select_idx)
    if @@comment
      select_text =~ /^#([^#]+)# *(.+)$/
      @edit_comment.text = $1
      @edit_main.text = $2
    else
      @edit_main.text = select_text
    end
  end

  def button_add_clicked
    return if @@comment && @edit_comment.text.gsub(/#/,'').strip == ''
    return if @@main_empty_check && @edit_main.text.strip == ''
    select_idx = @listBox_main.countStrings if (select_idx = @listBox_main.selectedString) < 0
    @listBox_main.addString(select_idx, comment_text + edit_main_text)
    @listBox_main.select(select_idx)
  end

  def button_del_clicked
    return if (select_idx = @listBox_main.selectedString) < 0
    @listBox_main.deleteString(select_idx)
  end

  def button_override_clicked
    return if @@comment && @edit_comment.text.gsub(/#/,'').strip == ''
    return if @@main_empty_check && @edit_main.text.strip == ''
    return if (select_idx = @listBox_main.selectedString) < 0
    @listBox_main.deleteString(select_idx)
    @listBox_main.addString(select_idx, comment_text + edit_main_text)
    @listBox_main.select(select_idx)
  end

  def button_up_clicked
    return if (select_idx = @listBox_main.selectedString) < 0
    select_text = @listBox_main.getTextOf(select_idx)
    @listBox_main.deleteString(select_idx)
    if select_idx - 1 >= 0
      idx = select_idx - 1
    else
      idx = 0
    end
    @listBox_main.addString(idx, select_text)
    @listBox_main.select(idx)
  end

  def button_down_clicked
    return if (select_idx = @listBox_main.selectedString) < 0
    select_text = @listBox_main.getTextOf(select_idx)
    @listBox_main.deleteString(select_idx)
    if select_idx + 1 <= @listBox_main.countStrings
      idx = select_idx + 1
    else
      idx = @listBox_main.countStrings
    end
    @listBox_main.addString(idx, select_text)
    @listBox_main.select(idx)
  end

  def button_default_clicked
    return if (select_idx = @listBox_main.selectedString) < 0
    @edit_default.text = @listBox_main.getTextOf(select_idx)
    @@defalut_idx = select_idx
  end

  def button_var_copy_clicked
    return if (select_idx = @comboBox_var.selectedString) < 0
    @edit_main.replaceSel('#{' + @comboBox_var.getTextOf(select_idx) + '}')
  end

  def button_open_clicked
    if @@file_type == 1
      if @edit_main.text.to_s.strip == ""
        defalut = nil
      else
        defalut = @edit_main.text.to_s.strip
        defalut = nil unless File.file?(defalut)
        defalut_dir = File.dirname(defalut)
        defalut_file = File.basename(defalut)
      end
      filename = SWin::CommonDialog::openFilename(self, [["All File (*.*)","*.*"]], 0x1004, @@caption + FILE_SELECT_MES, "*.*", defalut_dir, defalut_file)
      return unless filename                               #ファイルが選択されなかった場合、キャンセルされた場合は戻る
      return unless File.exist?(filename)                  #filenameのファイルが存在しなければ戻る
      @edit_main.text = filename
    elsif @@file_type == 2
      if @edit_main.text.to_s.strip == ""
        defalut = nil
      else
        defalut = @edit_main.text.to_s.strip
        defalut = nil unless File.directory?(defalut)
      end
      folder = SWin::CommonDialog::selectDirectory(self, @@caption + FOLDER_SELECT_MES, defalut, 1)
      return unless folder                                 #フォルダが選択されなかった場合、キャンセルされた場合は戻る
      return unless File.exist?(folder)                    #folderのファイルが存在しなければ戻る
      @edit_main.text = folder.sub(/\\$/,"") + "\\"
    end
  end

  def button_cancel_clicked
    close(false)
  end

  def button_ok_clicked
    result = []
    @listBox_main.eachString {|a| result.push a}
    close([result,@@defalut_idx])
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
    dlg_move(self)
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
    messageBox(DLG_POST_COMMENT_BUTTON_COPY, DLG_POST_COMMENT_BUTTON_COPY_TITLE, 0x40)
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

  def search_dir_set
    @search_dir_list = []
    @search_dir_list.push $open_dir.strip.sub(/\\$/,'') + '\\' unless $open_dir.strip == ""
    @search_dir_list += @@search_dir if @@search_dir.size > 0
    $input_movie_search_dir.each do |dir|
      @search_dir_list.push dir.strip.sub(/\\$/,'') + '\\'
    end
    @listBox_search_dir.setListStrings @search_dir_list
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
    @checkBox_ambiguous.check true
    @edit_start_year.readonly = true
    @edit_start_month.readonly = true
    @edit_start_day.readonly = true
    @edit_end_year.readonly = true
    @edit_end_month.readonly = true
    @edit_end_day.readonly = true
    @input_movie_search_dir_change = false
    search_dir_set
    dlg_move(self)
  end
  
  def button_cancel_clicked
    close(false)
  end

  def button_ok_clicked
    start_time = Time.local(@edit_start_year.text,@edit_start_month.text,@edit_start_day.text,0,0,0).gmtime.to_i * 1000
    end_time = Time.local(@edit_end_year.text,@edit_end_month.text,@edit_end_day.text,23,59,59).gmtime.to_i * 1000
    close([@checkBox_allread.checked?, start_time, end_time, @search_dir_list,@input_movie_search_dir_change,
           @checkBox_cut_only.checked?, @checkBox_ambiguous.checked?])
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
  
  def button_add_folder_clicked
    $main_windowrect = self.windowrect
    Modaldlg_list_option_setting.set($input_movie_search_dir,false,2,false, MOVIE_SEARCH_FOLDER_EDIT,true,false)
    return unless result = VRLocalScreen.openModalDialog(self,nil,Modaldlg_list_option_setting,nil,nil)
    $input_movie_search_dir = result[0]
    search_dir_set
    @input_movie_search_dir_change = true
  end
  
end

class Modaldlg_search

  def self.set(target,fields)
    @@target = target
    @@fields = fields
  end

  def self_created
    @radioBtn_all.check(true)
    dlg_move(self)
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
    dlg_move(self)
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
    dlg_move(self)
  end
  
  def button_modsetting_select_clicked
    folder = File.dirname(@edit_mod_setting_file.text)
    folder = "" unless File.directory?(folder)
    file = File.basename(@edit_mod_setting_file.text)
    file = DEFALUT_MOD_SETTING_FILE_NAME if file.strip == ""
    filename = SWin::CommonDialog::openFilename(self,[["json File (*.json)","*.json"],["All File (*.*)","*.*"]],0x4,MODSETTING_FILE_SELECT_TITLE,"*.json",folder,file)
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
    filename = SWin::CommonDialog::openFilename(self,[["db File (*.db)","*.db"],["All File (*.*)","*.*"]],0x4,DATABASE_FILE_SELECT_TITLE,"*.db",folder,file)
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
      messageBox("'#{folder.to_s}' #{DLG_MODSETTING_BUTTON_OK_NOT_DIR}", DLG_MODSETTING_BUTTON_OK_NOT_DIR_TITLE, 48)
      return
    end
    file = File.basename(@edit_mod_setting_file.text)
    if file.strip == ""
      messageBox("'#{@edit_mod_setting_file.text}' #{DLG_MODSETTING_BUTTON_OK_NOT_FILE}", DLG_MODSETTING_BUTTON_OK_NOT_FILE_TITLE, 48)
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
    dlg_move(self)
  end
  #ドラッグ＆ドロップ貼り付け
  def self_dropfiles(files)
    start_time_check(files[0])
  end
  
  def end_time_check
    if File.exist? @edit_moviefile.text.strip
      Dir.chdir(EXE_DIR)
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
      messageBox(DLG_TIMESTAMP_MOVIE_NOT, DLG_TIMESTAMP_MOVIE_NOT_TITLE,48)
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
    ext_set = [["Mkv File (*.mkv)","*.mkv"],["Avi File (*.avi)","*.avi"],["mp4 File (*.mp4)","*.mp4"],["All File (*.*)","*.*"]]
    def_ext = "*.#{$movie_default_extension.downcase}"
    if i = ext_set.index {|v| v[1] == def_ext}
      ext_set.unshift ext_set.delete_at(i)
    else
      ext_set.unshift ["#{$movie_default_extension.downcase} File (#{def_ext})",def_ext]
    end
    filename = SWin::CommonDialog::openFilename(self,ext_set,0x1004,MOVIE_FILE_SELECT_TITLE,def_ext,$open_dir) #ファイルを開くダイアログを開く
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
    else
      messageBox(DLG_TIMESTAMP_MOVIE_NOT, DLG_TIMESTAMP_MOVIE_NOT_TITLE,48)
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
    @edit_extension.text     = $movie_default_extension.to_s.downcase
    @checkBox_timesave.check $time_save
    @checkBox_ascii.check    $ascii_mode
    @checkBox_no_message.check $timestamp_nomsg
    @checkBox_stop_time_menu.check $use_endtime
    @checkBox_japanese.check $japanese_mode
    @checkBox_newcheck.check $new_version_check
    @groupBox_Preview.radioBtn_copy.check true unless $preview_encode
    @groupBox_Preview.radioBtn_select.check $preview_encode
    dlg_move(self)
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
    filename = SWin::CommonDialog::openFilename(self,[["db File (*.db)","*.db"],["All File (*.*)","*.*"]],0x4,DATABASE_FILE_SELECT_TITLE,"*.db",folder,file)
    return unless filename                               #ファイルが選択されなかった場合、キャンセルされた場合は戻る
    @edit_dbfile.text = filename
  end

  def button_opendir_select_clicked
    if @edit_opendir.text.to_s.strip == ""
      defalut = nil
    else
      defalut = @edit_opendir.text.to_s.strip
    end
    folder = SWin::CommonDialog::selectDirectory(self,SELECT_OPEN_MOVIE_FOLDER_TITLE,defalut,1)
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
        if messageBox("#{$beatsaber_dbfile}\r\n#{DLG_SETTING_BUTTON_OK_CREATE_NEW_FILE}", DLG_SETTING_BUTTON_OK_CREATE_NEW_FILE_TITLE, 36) == 6 #はい
          $beatsaber_dbfile = @edit_dbfile.text.to_s.strip
          db_check
        else
          if messageBox(DLG_SETTING_BUTTON_OK_DB_FILE_NOT, DLG_SETTING_BUTTON_OK_DB_FILE_NOT_TITLE, 36) == 6 #はい
            return
          end
        end
      else
        if messageBox(DLG_SETTING_BUTTON_OK_DB_FILE_NOT, DLG_SETTING_BUTTON_OK_DB_FILE_NOT_TITLE, 36) == 6 #はい
          return
        end
      end
    end
    if File.exist? @edit_previewtool.text.to_s.strip
      $preview_tool = @edit_previewtool.text.to_s.strip
    else
      if messageBox(DLG_SETTING_BUTTON_OK_PREVIEW_TOOL_NOT, DLG_SETTING_BUTTON_OK_PREVIEW_TOOL_NOT_TITLE, 36) == 6 #はい
        return
      end
    end
    if File.directory?(File.dirname(@edit_preview_temp.text.to_s.strip))
      $preview_file = @edit_preview_temp.text.to_s.strip
    else
      if messageBox(DLG_SETTING_BUTTON_OK_PREVIEW_TEMP_NOT, DLG_SETTING_BUTTON_OK_PREVIEW_TEMP_NOT_TITLE, 36) == 6 #はい
        return
      end
    end
    if File.directory?(File.dirname(@edit_subtitle_temp.text.to_s.strip))
      $subtitle_file = @edit_subtitle_temp.text.to_s.strip
    else
      if messageBox(DLG_SETTING_BUTTON_OK_SUBTITLE_TEMP_NOT, DLG_SETTING_BUTTON_OK_SUBTITLE_TEMP_NOT_TITLE, 36) == 6 #はい
        return
      end
    end
    $preview_tool_option = @edit_previewtool_option.text.to_s.strip
    $offset       = @edit_offset.text.strip.to_f
    $time_format  = @edit_time_format.text.to_s.strip
    $open_dir      = @edit_opendir.text.to_s.strip
    $movie_default_extension = @edit_extension.text.to_s.strip.downcase
    $time_save    = @checkBox_timesave.checked?
    $ascii_mode   = @checkBox_ascii.checked?
    $timestamp_nomsg = @checkBox_no_message.checked?
    $use_endtime = @checkBox_stop_time_menu.checked?
    $preview_encode = @groupBox_Preview.radioBtn_select.checked?
    $japanese_mode = @checkBox_japanese.checked?
    $new_version_check = @checkBox_newcheck.checked?
    close(true)
  end

  def button_preview_select_clicked
    folder   = File.dirname(@edit_previewtool.text.to_s.strip)
    folder   = EXE_DIR unless File.directory?(folder)
    filename = File.basename(@edit_previewtool.text.to_s.strip)
    filename = 'ffplay.exe' if filename.strip == ''
    filename = SWin::CommonDialog::openFilename(self,[["exe File (*.exe)","*.exe"],["All File (*.*)","*.*"]],0x1004,PREVIEW_TOOL_SELECT_TITLE,"*.exe",folder,filename)
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
    filename = SWin::CommonDialog::openFilename(self,[["mp4 File (*.mp4)","*.mp4"],["All File (*.*)","*.*"]],0x4,PREVIEW_TEMP_FILE_SELECT_TITLE,"*.mp4",folder,filename)
    return unless filename                               #ファイルが選択されなかった場合、キャンセルされた場合は戻る
    @edit_preview_temp.text = filename
  end
  
  def button_subtitle_temp_clicked
    folder   = File.dirname(@edit_subtitle_temp.text.to_s.strip)
    folder   = EXE_DIR unless File.directory?(folder)
    filename = File.basename(@edit_subtitle_temp.text.to_s.strip)
    filename = 'temp.mp4' if filename.strip == ''
    #ファイルを開くダイアログを開く(第7引数のデフォルトファイル名は標準のVisualuRubyだと対応していない、swin.soの改造が必要
    filename = SWin::CommonDialog::openFilename(self,[["mp4 File (*.mp4)","*.mp4"],["All File (*.*)","*.*"]],0x4,SUBTITLE_TEMP_FILE_SELECT_TITLE,"*.mp4",folder,filename)
    return unless filename                               #ファイルが選択されなかった場合、キャンセルされた場合は戻る
    @edit_subtitle_temp.text = filename
  end
  
end
