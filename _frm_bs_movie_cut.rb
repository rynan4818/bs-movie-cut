##__BEGIN_OF_FORMDESIGNER__
## CAUTION!! ## This code was automagically ;-) created by FormDesigner.
## NEVER modify manualy -- otherwise, you'll have a terrible experience.

require 'vr/vrdialog'
require 'vr/vruby'
require 'vr/vrcontrol'

class Modaldlg_post_comment < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = 'Post commnet generator'
    self.move(360,212,557,400)
    addControl(VRButton,'button_generate',"GENERATE",32,296,120,40)
    addControl(VRButton,'button_copy',"Copy clipboard",200,296,136,40)
    addControl(VRButton,'button_1',"1",32,24,104,24)
    addControl(VRText,'text_main',"",32,64,480,184,0x1080)
    addControl(VRButton,'button_2',"2",168,24,112,24)
    addControl(VRCheckbox,'checkBox_save',"SAVE",448,24,64,24)
    addControl(VRButton,'button_close',"CLOSE",424,296,88,40)
    addControl(VRStatic,'static1',"parameters = #songname# , #mapper# , #songauthor# , #bsr# , #difficulty# , #score# , #rank# , #miss#",32,248,480,40)
    addControl(VRButton,'button_3',"3",312,24,104,24)
  end 

end

class Modaldlg_db_view < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = 'Database view mode'
    self.move(358,215,607,465)
    addControl(VRStatic,'static4',"Month",128,72,48,24)
    addControl(VRStatic,'static6',"Year",352,72,32,24)
    addControl(VREdit,'edit_end_day',"",472,96,40,32)
    addControl(VRStatic,'static11',"The standard setting of 'Open movie folder' and 'Output folder' is the search target.",32,272,520,48)
    addControl(VREdit,'edit_start_month',"",128,96,40,32)
    addControl(VREdit,'edit_end_year',"",336,96,64,32)
    addControl(VRStatic,'static5',"Day",192,72,32,24)
    addControl(VRStatic,'static1',"Start date",48,48,88,24)
    addControl(VRStatic,'static10',"movie search folder",40,144,208,24)
    addControl(VRStatic,'static3',"Year",64,72,32,24)
    addControl(VRCheckbox,'checkBox_allread',"All read",232,16,88,24)
    addControl(VREdit,'edit_end_month',"",416,96,40,32)
    addControl(VREdit,'edit_start_year',"",48,96,64,32)
    addControl(VRListbox,'listBox_search_dir',"",32,168,520,96)
    addControl(VRStatic,'static7',"Month",408,72,48,24)
    addControl(VRStatic,'static8',"Day",472,72,32,24)
    addControl(VRButton,'button_cancel',"CANCEL",336,360,88,40)
    addControl(VREdit,'edit_start_day',"",184,96,40,32)
    addControl(VRStatic,'static9',"Date range to read",48,16,152,24)
    addControl(VRStatic,'static12',"To add a search target, edit the JSON 'input_movie_search_dir' directly.",32,320,520,24)
    addControl(VRButton,'button_ok',"OK",464,360,88,40)
    addControl(VRStatic,'static2',"End date",336,48,112,24)
  end 

end

class Modaldlg_search < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = 'Search map list'
    self.move(386,241,456,319)
    addControl(VRButton,'button_author_copy',"cursor copy",304,96,112,24)
    addControl(VREdit,'edit_author',"",24,120,392,32)
    addControl(VRButton,'button_ok',"OK",256,216,104,32)
    addControl(VRStatic,'static1',"Song name",24,16,160,24)
    addControl(VRRadiobutton,'radioBtn_all',"All",32,168,48,32)
    addControl(VRStatic,'static2',"Level author name",24,96,152,24)
    addControl(VRRadiobutton,'radioBtn_ranked',"Only Ranked",112,168,112,32)
    addControl(VRButton,'button_songname_copy',"cursor copy",304,16,112,24)
    addControl(VRRadiobutton,'radioBtn_unranked',"Only Unranked",256,168,136,32)
    addControl(VREdit,'edit_songname',"",24,40,392,32)
    addControl(VRButton,'button_cancel',"CANCEL",80,216,104,32)
  end 

end

class Modaldlg_subtitle_setting < VRModalDialog
  include VRContainersSet

  class GroupBox1 < VRGroupbox


    def construct
    end
  end

  def construct
    self.caption = 'Score subtitle setting'
    self.move(232,88,511,489)
    addControl(VRButton,'button_cancel',"CANCEL",256,392,96,32)
    addControl(VRStatic,'static3',"Alignment",32,112,72,24)
    addControl(VRButton,'button_consolas',"Consolas",208,72,104,24)
    addControl(VRButton,'button_msGothic',"MS Gothic",80,72,120,24)
    addControl(VRStatic,'static9',"ms",448,232,32,24)
    addControl(VRCombobox,'comboBox_alignment',"",112,112,328,800)
    addControl(VRStatic,'static8',"Simultaneous notes time",232,200,176,24)
    addControl(VRStatic,'static5',"Red notes",24,168,80,24)
    addControl(VRButton,'button_miss_default',"DEFAULT",168,328,80,24)
    addControl(VRStatic,'static11',"last notes display time",24,216,80,40)
    addControl(VREdit,'edit_blue_notes',"",320,168,104,24)
    addControl(VRStatic,'static12',"sec",176,232,32,24)
    addControl(VRStatic,'static1',"Font",32,40,40,24)
    addControl(VREdit,'edit_sim_notes_time',"",352,232,88,24)
    addControl(VREdit,'edit_last_notes',"",112,232,56,24)
    addControl(VREdit,'edit_red_notes',"",104,168,104,24)
    addControl(VREdit,'edit_font',"",80,40,232,24)
    addControl(VRStatic,'static10',"1000ms/60fps x4frame=66ms",232,224,104,40)
    addControl(VRStatic,'static2',"Font Size",328,40,72,24)
    addControl(VREdit,'edit_cut_format',"",24,296,448,24)
    addControl(VREdit,'edit_fontsize',"",400,40,56,24)
    addControl(VRStatic,'static6',"Blue notes",240,168,80,24)
    addControl(VRButton,'button_ok',"OK",384,392,88,32)
    addControl(VRStatic,'static7',"Miss subtitle format",24,328,144,24)
    addControl(GroupBox1,'groupBox1',"Print settings",16,8,464,144)
    addControl(VREdit,'edit_miss_format',"",24,352,448,24)
    addControl(VRButton,'button_cut_default',"DEFAULT",168,272,80,24)
    addControl(VRStatic,'static4',"Cut subtitle format",24,272,144,24)
  end 

end

class Modaldlg_modsetting < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = 'mod Setting'
    self.move(235,57,842,527)
    addControl(VREdit,'edit_mod_setting_file',"",56,32,744,24)
    addControl(VRStatic,'static5',"Events sent by HTTP WebSocket.",32,240,328,24)
    addControl(VRCheckbox,'checkBox_scenechange',"Scene Change",56,280,128,24)
    addControl(VRCheckbox,'checkBox_bombcut',"bombCut",240,320,144,24)
    addControl(VRButton,'button_cancel',"CANCEL",528,432,112,32)
    addControl(VRButton,'button_modsetting_select',"Select",736,56,64,24)
    addControl(VRStatic,'static2',"beatsaber.db File",56,72,128,24)
    addControl(VRButton,'button_ok',"OK",688,432,112,32)
    addControl(VRCheckbox,'checkBox_notesscore',"Notes score",56,192,184,24)
    addControl(VRCheckbox,'checkBox_notemissed',"noteMissed",56,440,160,24)
    addControl(VRStatic,'static3',"mod setting file",56,8,224,24)
    addControl(VRCheckbox,'checkBox_beatmapevent',"beatmapEvent",240,400,144,24)
    addControl(VRCheckbox,'checkBox_bombmissed',"bombMissed",240,360,144,24)
    addControl(VREdit,'edit_dbfile',"",56,96,744,24)
    addControl(VRCheckbox,'checkBox_notefullycut',"noteFullyCut",56,400,168,24)
    addControl(VRStatic,'static1',": hello,songStart,finished,failed,menu,pause,resume",184,280,448,24)
    addControl(VRButton,'button_bs_userfolder',"BeatSaber UserData folder",488,120,216,24)
    addControl(VRCheckbox,'checkBox_notecut',"noteCut",56,360,160,24)
    addControl(VRCheckbox,'checkBox_obstacle',"obstacleEnter,obstacleExit",240,440,256,24)
    addControl(VRStatic,'static6',"Movie cut record setting",32,152,216,24)
    addControl(VRCheckbox,'checkBox_scorechanged',"scoreChanged",56,320,168,24)
    addControl(VRCheckbox,'checkBox_gccollect',"Scene change GC Collect",288,192,232,24)
    addControl(VRButton,'button_db_select',"Select",736,120,64,24)
  end 

end

class Modaldlg_timestamp < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = 'Timestamp Tool'
    self.move(227,73,663,330)
    addControl(VRStatic,'static18',"movie length",424,96,96,24)
    addControl(VRStatic,'static10',"Example",24,168,64,32)
    addControl(VRStatic,'static5',"msec",352,72,56,24)
    addControl(VRStatic,'static8',"19:5:22",224,160,80,24)
    addControl(VRStatic,'static3',"Time",224,72,48,24)
    addControl(VRStatic,'static16',"Estimation from video length",416,152,192,24)
    addControl(VRStatic,'static6',"End time",24,128,64,24)
    addControl(VRStatic,'static15',"or Drag and Drop",496,64,128,24)
    addControl(VRStatic,'static14',"Fix database timestamp registration",16,8,256,24)
    addControl(VRStatic,'static_timezone',"",416,8,216,24)
    addControl(VRStatic,'static4',"Start time",24,96,72,24)
    addControl(VREdit,'edit_start_msec',"",344,96,64,24)
    addControl(VREdit,'edit_start_time',"",224,96,104,24)
    addControl(VRStatic,'static11',"Hour/Min/Sec",224,184,104,24)
    addControl(VREdit,'edit_start_date',"",104,96,104,24)
    addControl(VREdit,'edit_end_msec',"",344,128,64,24)
    addControl(VRButton,'button_fileget',"Get timestamp from movie file",24,232,240,32)
    addControl(VREdit,'edit_end_time',"",224,128,104,24)
    addControl(VREdit,'edit_moviefile',"",96,40,456,24)
    addControl(VRStatic,'static17',"Time zone",336,8,80,24)
    addControl(VRButton,'button_ok',"OK",480,232,120,32)
    addControl(VRStatic,'static12',"427",344,160,32,16)
    addControl(VRStatic,'static_length',"",520,96,104,24)
    addControl(VRStatic,'static13',"Sec/1000",344,184,72,16)
    addControl(VRButton,'button_select',"select",552,40,72,24)
    addControl(VRButton,'button_cancel',"CANCEL",328,232,120,32)
    addControl(VRStatic,'static9',"Year/Month/Day",96,184,112,24)
    addControl(VRStatic,'static2',"Date",104,72,40,24)
    addControl(VREdit,'edit_end_date',"",104,128,104,24)
    addControl(VRStatic,'static1',"Movie file",16,40,80,24)
    addControl(VRStatic,'static7',"2020/1/18",104,160,88,24)
    addControl(VRButton,'button_end_time',"End time for auto",416,128,168,24)
  end 

end

class Modaldlg_setting < VRModalDialog
  include VRContainersSet

  class GroupBox_Preview < VRGroupbox
    include VRStdControlContainer
    attr_reader :radioBtn_copy
    attr_reader :radioBtn_select

    def construct
      addControl(VRRadiobutton,'radioBtn_copy',"Copy",8,24,80,32)
      addControl(VRRadiobutton,'radioBtn_select',"Select encode option",112,24,176,32)
    end
  end

  def construct
    self.caption = 'Setting'
    self.move(226,71,655,634)
    addControl(VRCheckbox,'checkBox_stop_time_menu',"Use endtime for stoptime",24,464,216,24)
    addControl(VRStatic,'static2',"time format",24,496,80,24)
    addControl(VRButton,'button_cancel',"CANCEL",408,544,96,32)
    addControl(VRStatic,'static10',"open movie folder",24,160,136,24)
    addControl(VREdit,'edit_opendir',"",24,184,464,24)
    addControl(VRStatic,'static8',"score subtitle temporary file",24,408,248,24)
    addControl(VRButton,'button_opendir_select',"select",488,184,56,24)
    addControl(VRCheckbox,'checkBox_ascii',"Remove non-ASCII code",24,528,296,24)
    addControl(VREdit,'edit_offset',"0.0",512,360,56,32)
    addControl(GroupBox_Preview,'groupBox_Preview',"Preview encode",24,336,296,64)
    addControl(VREdit,'edit_preview_temp',"",24,304,528,24)
    addControl(VRStatic,'static5',"preview temporary file",24,280,232,24)
    addControl(VRCheckbox,'checkBox_no_message',"Do not show message for timestamp check",24,112,328,24)
    addControl(VREdit,'edit_dbfile',"",24,40,536,24)
    addControl(VRButton,'button_preview_select',"select",376,248,56,24)
    addControl(VRButton,'button_parameter',"parameter manual",464,496,152,24)
    addControl(VRButton,'button_preview_temp',"select",552,304,64,24)
    addControl(VREdit,'edit_time_format',"",104,496,360,24)
    addControl(VRStatic,'static3',"(WARNING:tool install path ASCII only)",24,552,288,24)
    addControl(VRButton,'button_default',"DEFAULT",464,472,88,24)
    addControl(VRButton,'button_subtitle_temp',"select",552,432,64,24)
    addControl(VREdit,'edit_extension',"mkv",560,184,56,24)
    addControl(VRStatic,'static4',"preview tool",24,224,112,24)
    addControl(VRStatic,'static1',"beatsaber.db file",24,16,136,24)
    addControl(VREdit,'edit_previewtool',"",24,248,352,24)
    addControl(VREdit,'edit_subtitle_temp',"",24,432,528,24)
    addControl(VRStatic,'static9',"preview tool option",448,224,168,24)
    addControl(VRCheckbox,'checkBox_timesave',"Saves and reads the original movie file's timestamp the database.",24,80,480,24)
    addControl(VRButton,'button_db_select',"select",560,40,56,24)
    addControl(VRStatic,'static6',"offset time",432,368,80,24)
    addControl(VRButton,'button_ok',"OK",520,544,96,32)
    addControl(VRStatic,'static7',"sec",568,368,32,24)
    addControl(VREdit,'edit_previewtool_option',"",448,248,168,24)
    addControl(VRStatic,'static11',"default extension",544,144,72,40)
  end 

end

class Form_main < VRForm
  include VRMenuUseable if defined? VRMenuUseable
  include VRMenuUseable

  class GroupBox1 < VRGroupbox


    def construct
    end
  end

  def construct
    self.caption = 'bs movie cut'
    self.move(160,10,1060,940)
    #$_addControl(VRMenu,'mainmenu1',"",664,0,24,24)
    @mainmenu1 = newMenu.set(
      [
        ["&File",[
          ["&Open movie", "menu_open"],
          ["sep", "_vrmenusep", 2048],
          ["&Database view mode", "menu_dbopen"],
          ["sep", "_vrmenusep", 2048],
          ["E&xit", "menu_exit"]]
        ],
        ["&Option",[
          ["&Setting", "menu_setting"],
          ["&Timestamp Tool", "menu_timestamp"],
          ["&Mod setting", "menu_modsetting"],
          ["Sub&title setting", "menu_subtitle_setting"],
          ["Setting Sa&ve", "menu_save"]]
        ],
        ["&Tool",[
          ["&Copy !bsr", "menu_copy_bsr"],
          ["&Post comment", "menu_post_commnet"],
          ["&BeatSaver page", "menu_beatsaver"],
          ["Beast&Saber page", "menu_beastsaber"],
          ["&Map list to CSV", "menu_maplist"],
          ["&Note scoer to CSV", "menu_notescore"]]
        ],
        ["&Help",[
          ["Versio&n", "menu_version"]]
        ]
      ]
    )
    setMenu(@mainmenu1,true)
    addControl(VRButton,'button_time_sort',"Time",176,128,48,24)
    addControl(VRButton,'button_organizing_reset',"Reset map list",680,568,120,32)
    addControl(VRCheckbox,'checkBox_pause',"pause",184,672,72,24)
    addControl(VRCheckbox,'checkBox_speed',"Normal Speed",384,640,120,24)
    addControl(VREdit,'edit_score',"90",608,640,40,24)
    addControl(VREdit,'edit_end_offset',"4.0",920,696,64,32)
    addControl(VRButton,'button_score_sort',"Score",424,128,56,24)
    addControl(VRButton,'button_miss_sort',"Miss",480,128,48,24)
    addControl(VRButton,'button_fullcombo',"full combo select",24,648,128,32)
    addControl(VRButton,'button_all_unselect',"unselect",88,568,64,32)
    addControl(VREdit,'edit_start_offset',"0.0",920,656,64,32)
    addControl(VRButton,'button_organizing_reversing',"Reversing selection",168,568,152,32)
    addControl(VRStatic,'static11',"*Edit these 3 settings directly in the JSON.",424,808,320,24)
    addControl(VRButton,'button_organizing_remove',"Remove selection from map list",336,568,232,32)
    addControl(GroupBox1,'groupBox1',"Filter",168,616,632,96)
    addControl(VRCombobox,'comboBox_folder',"",24,832,744,260)
    addControl(VRButton,'button_preview',"Preview cursor",888,568,128,32)
    addControl(VRRadiobutton,'radioBtn_header_cut',"header cut",792,776,112,24)
    addControl(VRListbox,'listBox_file',"",24,24,992,96,0x4080)
    addControl(VRButton,'button_filter',"Filter select",296,672,104,32)
    addControl(VRStatic,'static9',"sec",984,664,32,24)
    addControl(VRCheckbox,'checkBox_printing',"subtitle printing",568,744,152,32)
    addControl(VRStatic,'static12',"sec",984,744,32,24)
    addControl(VRButton,'button_cleared_sort',"Cleared",320,128,64,24)
    addControl(VRRadiobutton,'radioBtn_footer_cut',"footer cut",912,776,104,24)
    addControl(VRStatic,'static7',"Start offset",832,664,80,24)
    addControl(VRButton,'button_close',"CLOSE",800,816,88,40)
    addControl(VREdit,'edit_miss',"10",744,640,32,24)
    addControl(VRStatic,'static4',"Output file name",24,752,184,24)
    addControl(VRCheckbox,'checkBox_finished',"finished",184,640,88,24)
    addControl(VRCombobox,'comboBox_ffmpeg',"",24,720,744,260)
    addControl(VRStatic,'static6',"Time zone",752,0,80,24)
    addControl(VRStatic,'static10',"sec",984,704,32,24)
    addControl(VRButton,'button_diff_sort',"Diff",224,128,48,24)
    addControl(VRStatic,'tz_static',"",832,0,184,24)
    addControl(VRButton,'button_speed_sort',"Speed",272,128,48,24)
    addControl(VRCombobox,'comboBox_filename',"",24,776,744,260)
    addControl(VRCheckbox,'checkBox_diff',"Song and play time difference +-",448,680,256,24)
    addControl(VRStatic,'static5',"Output folder",24,808,192,24)
    addControl(VREdit,'edit_difftime',"5",704,680,40,24)
    addControl(VRButton,'button_file_sort',"File",24,128,48,24)
    addControl(VRStatic,'static8',"End offset",840,704,72,24)
    addControl(VRButton,'button_difficulty',"Difficulty",528,128,64,24)
    addControl(VRCheckbox,'checkBox_subtitles',"With score subtitles",360,744,168,32)
    addControl(VRCheckbox,'checkBox_score',"Score >=",520,640,88,24)
    addControl(VRStatic,'static1',"sec",744,680,32,24)
    addControl(VRCheckbox,'checkBox_miss',"Miss <=",664,640,80,24)
    addControl(VRButton,'button_run',"RUN",928,816,88,40)
    addControl(VRCheckbox,'checkBox_length',"movie length",808,736,104,32)
    addControl(VRButton,'button_finished',"finished select",24,608,128,32)
    addControl(VRButton,'button_songname_sort',"Song Name",592,128,304,24)
    addControl(VRButton,'button_datetime_sort',"DateTime",72,128,104,24)
    addControl(VRButton,'button_levelauthor_sort',"Level Author",896,128,120,24)
    addControl(VRListbox,'listBox_map',"",24,152,992,402,0x888)
    addControl(VRButton,'button_all_select',"ALL",24,568,56,32)
    addControl(VRButton,'button_search',"Search",584,568,80,32)
    addControl(VRStatic,'static3',"FFmpeg encode",24,696,128,24)
    addControl(VRButton,'button_rank_sort',"Rank",384,128,40,24)
    addControl(VRStatic,'static_message',"Paste the file to be converted by drag and drop",304,0,352,24)
    addControl(VREdit,'edit_length',"139.0",920,736,64,32)
    addControl(VRCheckbox,'checkBox_failed',"failed",272,640,64,24)
    addControl(VRButton,'button_open_preview_dir',"preview folder",904,616,112,24)
  end 

end

##__END_OF_FORMDESIGNER__
