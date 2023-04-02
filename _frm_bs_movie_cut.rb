##__BEGIN_OF_FORMDESIGNER__
## CAUTION!! ## This code was automagically ;-) created by FormDesigner.
## NEVER modify manualy -- otherwise, you'll have a terrible experience.

require 'vr/vrdialog'
require 'vr/vruby'
require 'vr/vrcontrol'
require 'vr/vrcomctl'

class Modaldlg_playlist < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = 'PlayList create'
    self.move(165,75,1011,688)
    addControl(VRButton,'button_cancel',"CANCEL",680,584,112,40)
    addControl(VRButton,'button_delete',"Delete selection",576,360,144,32)
    addControl(VRButton,'button_down',"DOWN",896,360,72,32)
    addControl(VRButton,'button_open',"Open",896,416,72,24)
    addControl(VRButton,'button_save',"PlayList SAVE",840,584,128,40)
    addControl(VRButton,'button_up',"UP",800,360,64,32)
    addControl(VRCheckbox,'checkBox_songname',"Song name output",816,472,152,24)
    addControl(VREdit,'edit_author',"",528,472,264,24)
    addControl(VREdit,'edit_description',"",32,528,936,24)
    addControl(VREdit,'edit_image',"",32,416,864,24)
    addControl(VREdit,'edit_title',"",32,472,464,24)
    addControl(VRListbox,'listBox_main',"",24,40,944,312,0x80)
    addControl(VRStatic,'static1',"Cover Image  (drag and drop OK)",32,392,256,24)
    addControl(VRStatic,'static2',"Title",32,448,48,24)
    addControl(VRStatic,'static3',"Description",32,504,88,24)
    addControl(VRStatic,'static4',"Author",528,448,64,24)
    addControl(VRStatic,'static5',"PlayList",24,16,64,24)
  end 

end

class Modaldlg_list_option_setting < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = 'Setting'
    self.move(160,210,1060,476)
    addControl(VRButton,'button_add',"Add Above",256,128,96,24)
    addControl(VRButton,'button_cancel',"CANCEL",816,368,88,40)
    addControl(VRButton,'button_copy',"Copy Below Selection",32,128,168,24)
    addControl(VRButton,'button_default',"Default Selection",888,192,128,24)
    addControl(VRButton,'button_del',"Delete Selection",704,128,128,24)
    addControl(VRButton,'button_down',"DOWN",968,80,48,40)
    addControl(VRButton,'button_ok',"OK",928,368,88,40)
    addControl(VRButton,'button_open',"OPEN",936,296,80,24)
    addControl(VRButton,'button_override',"Override Selection",440,128,152,24)
    addControl(VRButton,'button_up',"UP",968,24,48,40)
    addControl(VRButton,'button_var_copy',"Copy Below",488,280,104,24)
    addControl(VRCombobox,'comboBox_var',"",488,256,400,260)
    addControl(VREdit,'edit_comment',"",32,256,352,24)
    addControl(VREdit,'edit_default',"",32,192,856,20,0x800)
    addControl(VREdit,'edit_main',"",32,320,984,24)
    addControl(VRListbox,'listBox_main',"",32,24,936,96)
    addControl(VRStatic,'static_comment',"Comments",32,232,128,24)
    addControl(VRStatic,'static_default',"Default",32,168,80,24)
    addControl(VRStatic,'static_main',"",32,296,240,24)
    addControl(VRStatic,'static_notes',"",32,360,752,64)
    addControl(VRStatic,'static_var',"Variable",488,232,112,24)
  end 

end

class Modaldlg_post_comment < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = 'Post commnet generator'
    self.move(360,212,557,421)
    addControl(VRButton,'button_1',"1",32,40,104,24)
    addControl(VRButton,'button_2',"2",168,40,112,24)
    addControl(VRButton,'button_3',"3",312,40,104,24)
    addControl(VRButton,'button_close',"CLOSE",424,312,88,40)
    addControl(VRButton,'button_copy',"Copy clipboard",200,312,136,40)
    addControl(VRButton,'button_generate',"GENERATE",32,312,120,40)
    addControl(VRCheckbox,'checkBox_save',"Save Template",376,16,136,24)
    addControl(VRStatic,'static1',"parameters = #songname# , #mapper# , #songauthor# , #bsr# , #difficulty# , #score# , #rank# , #miss#",32,264,480,40)
    addControl(VRStatic,'static2',"Template",32,16,72,24)
    addControl(VRText,'text_main',"",32,80,480,184,0x1080)
  end 

end

class Modaldlg_db_view < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = 'Database view mode'
    self.move(358,215,607,482)
    addControl(VRButton,'button_add_folder',"Add a folder to be searched",312,312,240,32)
    addControl(VRButton,'button_cancel',"CANCEL",336,376,88,40)
    addControl(VRButton,'button_ok',"OK",464,376,88,40)
    addControl(VRCheckbox,'checkBox_allread',"All read",232,16,88,24)
    addControl(VRCheckbox,'checkBox_ambiguous',"Ambiguous file name search",328,144,224,32)
    addControl(VRCheckbox,'checkBox_cut_only',"Cut movie only mode",32,376,176,24)
    addControl(VREdit,'edit_end_day',"",472,96,40,32)
    addControl(VREdit,'edit_end_month',"",416,96,40,32)
    addControl(VREdit,'edit_end_year',"",336,96,64,32)
    addControl(VREdit,'edit_start_day',"",184,96,40,32)
    addControl(VREdit,'edit_start_month',"",128,96,40,32)
    addControl(VREdit,'edit_start_year',"",48,96,64,32)
    addControl(VRListbox,'listBox_search_dir',"",32,176,520,96,0x4000)
    addControl(VRStatic,'static1',"Start date",48,48,88,24)
    addControl(VRStatic,'static10',"movie search folder",32,152,208,24)
    addControl(VRStatic,'static11',"Setting of 'Open movie folder' and 'Output folder' is the search target.",32,280,512,24)
    addControl(VRStatic,'static12',"The original video must have a timestamp stored in the database.",32,312,248,40)
    addControl(VRStatic,'static2',"End date",336,48,112,24)
    addControl(VRStatic,'static3',"Year",64,72,32,24)
    addControl(VRStatic,'static4',"Month",128,72,48,24)
    addControl(VRStatic,'static5',"Day",192,72,32,24)
    addControl(VRStatic,'static6',"Year",352,72,32,24)
    addControl(VRStatic,'static7',"Month",408,72,48,24)
    addControl(VRStatic,'static8',"Day",472,72,32,24)
    addControl(VRStatic,'static9',"Date range to read",48,16,152,24)
  end 

end

class Modaldlg_search < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = 'Search map list'
    self.move(386,241,456,319)
    addControl(VRButton,'button_author_copy',"cursor copy",304,96,112,24)
    addControl(VRButton,'button_cancel',"CANCEL",80,216,104,32)
    addControl(VRButton,'button_ok',"OK",256,216,104,32)
    addControl(VRButton,'button_songname_copy',"cursor copy",304,16,112,24)
    addControl(VREdit,'edit_author',"",24,120,392,32)
    addControl(VREdit,'edit_songname',"",24,40,392,32)
    addControl(VRRadiobutton,'radioBtn_all',"All",32,168,48,32)
    addControl(VRRadiobutton,'radioBtn_ranked',"Only Ranked",112,168,112,32)
    addControl(VRRadiobutton,'radioBtn_unranked',"Only Unranked",256,168,136,32)
    addControl(VRStatic,'static1',"Song name",24,16,160,24)
    addControl(VRStatic,'static2',"Level author name",24,96,152,24)
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
    self.move(232,88,511,627)
    addControl(GroupBox1,'groupBox1',"Print settings",16,8,464,216)
    addControl(VRButton,'button_cancel',"CANCEL",264,528,96,32)
    addControl(VRButton,'button_consolas',"Consolas",208,72,104,24)
    addControl(VRButton,'button_cut_default',"DEFAULT",176,392,80,24)
    addControl(VRButton,'button_miss_default',"DEFAULT",168,456,80,24)
    addControl(VRButton,'button_msGothic',"MS Gothic",80,72,120,24)
    addControl(VRButton,'button_ok',"OK",384,528,88,32)
    addControl(VRCombobox,'comboBox_alignment',"",112,112,328,800)
    addControl(VREdit,'edit_blue_notes',"",320,248,104,24)
    addControl(VREdit,'edit_cut_format',"",24,416,448,24)
    addControl(VREdit,'edit_font',"",80,40,232,24)
    addControl(VREdit,'edit_fontsize',"",400,40,56,24)
    addControl(VREdit,'edit_force_style',"",32,176,424,24)
    addControl(VREdit,'edit_last_notes',"",112,320,56,24)
    addControl(VREdit,'edit_max_score',"",400,360,32,24)
    addControl(VREdit,'edit_miss_format',"",24,480,448,24)
    addControl(VREdit,'edit_red_notes',"",104,248,104,24)
    addControl(VREdit,'edit_sim_notes_time',"",344,320,88,24)
    addControl(VRStatic,'static1',"Font",32,40,40,24)
    addControl(VRStatic,'static10',"1000ms/60fps x4frame=66ms",240,312,104,40)
    addControl(VRStatic,'static11',"last notes display time",40,288,160,24)
    addControl(VRStatic,'static12',"sec",168,320,32,24)
    addControl(VRStatic,'static13',"Max notescore display",240,360,160,24)
    addControl(VRStatic,'static14',"Notes",432,360,48,24)
    addControl(VRStatic,'static15',"Add force_style option",32,152,176,24)
    addControl(VRStatic,'static2',"Font Size",328,40,72,24)
    addControl(VRStatic,'static3',"Alignment",32,112,72,24)
    addControl(VRStatic,'static4',"Cut subtitle format",24,392,144,24)
    addControl(VRStatic,'static5',"Red notes",24,248,80,24)
    addControl(VRStatic,'static6',"Blue notes",240,248,80,24)
    addControl(VRStatic,'static7',"Miss subtitle format",32,456,144,24)
    addControl(VRStatic,'static8',"Simultaneous notes time",240,288,176,24)
    addControl(VRStatic,'static9',"ms",432,320,40,24)
  end 

end

class Modaldlg_modsetting < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = 'mod Setting(HTTP Status+Database)'
    self.move(235,57,842,527)
    addControl(VRButton,'button_bs_userfolder',"BeatSaber UserData folder",488,120,216,24)
    addControl(VRButton,'button_cancel',"CANCEL",528,432,112,32)
    addControl(VRButton,'button_db_select',"Select",736,120,64,24)
    addControl(VRButton,'button_modsetting_select',"Select",360,56,64,24)
    addControl(VRButton,'button_ok',"OK",688,432,112,32)
    addControl(VRCheckbox,'checkBox_beatmapevent',"beatmapEvent",240,400,144,24)
    addControl(VRCheckbox,'checkBox_bombcut',"bombCut",240,320,144,24)
    addControl(VRCheckbox,'checkBox_bombmissed',"bombMissed",240,360,144,24)
    addControl(VRCheckbox,'checkBox_gccollect',"Scene change GC Collect  (Memory Clearing)",288,192,384,16)
    addControl(VRCheckbox,'checkBox_notecut',"noteCut",56,360,160,24)
    addControl(VRCheckbox,'checkBox_notefullycut',"noteFullyCut",56,400,168,24)
    addControl(VRCheckbox,'checkBox_notemissed',"noteMissed",56,440,160,24)
    addControl(VRCheckbox,'checkBox_notesscore',"Notes score",56,192,184,24)
    addControl(VRCheckbox,'checkBox_obstacle',"obstacleEnter,obstacleExit",240,440,256,24)
    addControl(VRCheckbox,'checkBox_scenechange',"Scene Change",56,280,128,24)
    addControl(VRCheckbox,'checkBox_scorechanged',"scoreChanged",56,320,168,24)
    addControl(VREdit,'edit_dbfile',"",56,96,744,24)
    addControl(VREdit,'edit_mod_setting_file',"",56,32,368,24)
    addControl(VRRadiobutton,'radioBtn_DataRecorder',"DataRecorder",632,32,168,24)
    addControl(VRRadiobutton,'radioBtn_movie_cut_record',"HTTP Statsu+Database",440,32,184,24)
    addControl(VRStatic,'static1',": hello,songStart,finished,failed,menu,pause,resume",184,280,448,24)
    addControl(VRStatic,'static2',"beatsaber.db File",56,72,128,24)
    addControl(VRStatic,'static3',"Beat Saber UserData Folder",56,8,224,24)
    addControl(VRStatic,'static5',"Events sent by HTTP WebSocket.",32,240,328,24)
    addControl(VRStatic,'static6',"Mod behavior settings",32,152,216,24)
  end 

end

class Modaldlg_modsetting2 < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = 'mod Setting(DataRecorder)'
    self.move(235,57,842,268)
    addControl(VRButton,'button_bs_userfolder',"Default folder",576,120,128,24)
    addControl(VRButton,'button_cancel',"CANCEL",528,168,112,32)
    addControl(VRButton,'button_db_select',"Select",736,120,64,24)
    addControl(VRButton,'button_modsetting_select',"Select",352,56,64,24)
    addControl(VRButton,'button_ok',"OK",688,168,112,32)
    addControl(VREdit,'edit_dbfile',"",56,96,744,24)
    addControl(VREdit,'edit_mod_setting_file',"",56,32,360,24)
    addControl(VRRadiobutton,'radioBtn_DataRecorder',"DataRecorder",432,32,144,24)
    addControl(VRRadiobutton,'radioBtn_movie_cut_record',"HTTP Status+Database",584,32,216,24)
    addControl(VRStatic,'static2',"beatsaber.db File",56,72,128,24)
    addControl(VRStatic,'static3',"Beat Saber UserData Folder",56,8,224,24)
  end 

end

class Modaldlg_timestamp < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = 'Timestamp Tool'
    self.move(227,73,663,330)
    addControl(VRButton,'button_cancel',"CANCEL",328,232,120,32)
    addControl(VRButton,'button_end_time',"End time for auto",416,128,168,24)
    addControl(VRButton,'button_fileget',"Get timestamp from movie file",24,232,240,32)
    addControl(VRButton,'button_ok',"OK",480,232,120,32)
    addControl(VRButton,'button_select',"select",552,40,72,24)
    addControl(VREdit,'edit_end_date',"",104,128,104,24)
    addControl(VREdit,'edit_end_msec',"",344,128,64,24)
    addControl(VREdit,'edit_end_time',"",224,128,104,24)
    addControl(VREdit,'edit_moviefile',"",96,40,456,24)
    addControl(VREdit,'edit_start_date',"",104,96,104,24)
    addControl(VREdit,'edit_start_msec',"",344,96,64,24)
    addControl(VREdit,'edit_start_time',"",224,96,104,24)
    addControl(VRStatic,'static1',"Movie file",16,40,80,24)
    addControl(VRStatic,'static10',"Example",24,168,64,32)
    addControl(VRStatic,'static11',"Hour:Min:Sec",224,184,104,24)
    addControl(VRStatic,'static12',"427",344,160,32,16)
    addControl(VRStatic,'static13',"Sec/1000",344,184,72,16)
    addControl(VRStatic,'static14',"Fix database timestamp registration",16,8,256,24)
    addControl(VRStatic,'static15',"or Drag and Drop",496,64,128,24)
    addControl(VRStatic,'static16',"Estimation from video length",416,152,192,24)
    addControl(VRStatic,'static17',"Time zone",336,8,80,24)
    addControl(VRStatic,'static18',"movie length",424,96,96,24)
    addControl(VRStatic,'static2',"Date",104,72,40,24)
    addControl(VRStatic,'static3',"Time",224,72,48,24)
    addControl(VRStatic,'static4',"Start time",24,96,72,24)
    addControl(VRStatic,'static5',"msec",352,72,56,24)
    addControl(VRStatic,'static6',"End time",24,128,64,24)
    addControl(VRStatic,'static7',"2020/1/18",104,160,88,24)
    addControl(VRStatic,'static8',"19:5:22",224,160,80,24)
    addControl(VRStatic,'static9',"Year/Month/Day",96,184,112,24)
    addControl(VRStatic,'static_length',"",520,96,104,24)
    addControl(VRStatic,'static_timezone',"",416,8,216,24)
  end 

end

class Modaldlg_setting < VRModalDialog
  include VRContainersSet

  class GroupBox_Preview < VRGroupbox
    include VRStdControlContainer
    attr_reader :checkBox_preview_keycut
    attr_reader :radioBtn_copy
    attr_reader :radioBtn_select

    def construct
      addControl(VRCheckbox,'checkBox_preview_keycut',"Cut in keyframe units",8,52,200,24)
      addControl(VRRadiobutton,'radioBtn_copy',"Copy",8,24,80,32)
      addControl(VRRadiobutton,'radioBtn_select',"Select encode option",112,24,176,32)
    end
  end

  def construct
    self.caption = 'Setting'
    self.move(226,71,655,799)
    addControl(GroupBox_Preview,'groupBox_Preview',"Preview encode",24,406,296,84)
    addControl(VRButton,'button_cancel',"CANCEL",400,698,96,32)
    addControl(VRButton,'button_db_select',"select",560,40,56,24)
    addControl(VRButton,'button_default',"DEFAULT",464,562,88,24)
    addControl(VRButton,'button_hdt_select',"select",560,96,56,24)
    addControl(VRButton,'button_ok',"OK",520,698,96,32)
    addControl(VRButton,'button_opendir_select',"select",488,254,56,24)
    addControl(VRButton,'button_parameter',"parameter manual",464,586,152,24)
    addControl(VRButton,'button_preview_select',"select",376,318,56,24)
    addControl(VRButton,'button_preview_temp',"select",552,374,64,24)
    addControl(VRButton,'button_subtitle_temp',"select",552,522,64,24)
    addControl(VRCheckbox,'checkBox_ascii',"Remove non-ASCII code",24,682,296,24)
    addControl(VRCheckbox,'checkBox_japanese',"Japanese mode (After restart)",376,634,240,24)
    addControl(VRCheckbox,'checkBox_newcheck',"Check latest version",24,634,288,24)
    addControl(VRCheckbox,'checkBox_no_message',"Do not show message for timestamp check",24,182,328,24)
    addControl(VRCheckbox,'checkBox_stop_time_menu',"Use endtime for stoptime",24,554,216,24)
    addControl(VRCheckbox,'checkBox_timesave',"Saves and reads the original movie file's timestamp the database. (recommended)",24,150,592,24)
    addControl(VREdit,'edit_dbfile',"",24,40,536,24)
    addControl(VREdit,'edit_extension',"mkv",560,254,56,24)
    addControl(VREdit,'edit_hdtfile',"",24,96,536,24)
    addControl(VREdit,'edit_max_volume',"0",512,414,56,24)
    addControl(VREdit,'edit_offset',"0.0",512,450,56,32)
    addControl(VREdit,'edit_opendir',"",24,254,464,24)
    addControl(VREdit,'edit_preview_temp',"",24,374,528,24)
    addControl(VREdit,'edit_previewtool',"",24,318,352,24)
    addControl(VREdit,'edit_previewtool_option',"",448,318,168,24)
    addControl(VREdit,'edit_subtitle_temp',"",24,522,528,24)
    addControl(VREdit,'edit_time_format',"",104,586,360,24)
    addControl(VRStatic,'static1',"beatsaber.db file",24,16,136,24)
    addControl(VRStatic,'static10',"open movie folder",24,230,136,24)
    addControl(VRStatic,'static11',"default extension",544,214,72,40)
    addControl(VRStatic,'static12',"dB",568,414,24,24)
    addControl(VRStatic,'static13',"Audio normalize",344,414,120,24)
    addControl(VRStatic,'static14',"max=",472,414,40,24)
    addControl(VRStatic,'static15',"HMDDistance.dat file",24,72,176,24)
    addControl(VRStatic,'static2',"time format",24,586,80,24)
    addControl(VRStatic,'static3',"(WARNING:tool install path ASCII only)",24,706,288,24)
    addControl(VRStatic,'static4',"preview tool",24,294,112,24)
    addControl(VRStatic,'static5',"preview temporary file (HDD recommended to prevent SSD degradation)",24,350,520,24)
    addControl(VRStatic,'static6',"offset time",432,458,80,24)
    addControl(VRStatic,'static7',"sec",568,458,32,24)
    addControl(VRStatic,'static8',"subtitle temporary file [Cannot use half-width spaces in the path] (HDD recommended)",24,498,608,24)
    addControl(VRStatic,'static9',"preview tool option",448,294,168,24)
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
    self.sizebox=false
    self.maximizebox=false
    self.caption = 'bs movie cut'
    self.move(160,10,1100,940)
    #$_addControl(VRMenu,'mainmenu1',"",664,0,24,24)
    @mainmenu1 = newMenu.set(
      [
        ["File(&F)",[
          ["Open movie(&O)", "menu_open"],
          ["Open latest movie(&L)", "menu_latest_open"],
          ["sep", "_vrmenusep", 2048],
          ["Database view mode(&D)", "menu_dbopen"],
          ["sep", "_vrmenusep", 2048],
          ["Exit(&X)", "menu_exit"]]
        ],
        ["Option(&O)",[
          ["Setting(&S)", "menu_setting"],
          ["Timestamp Tool(&P)", "menu_timestamp"],
          ["Mod setting(&M)", "menu_modsetting"],
          ["Subtitle setting(&T)", "menu_subtitle_setting"],
          ["Setting Save(&V)", "menu_save"]]
        ],
        ["Tool(&T)",[
          ["Copy !bsr(&C)", "menu_copy_bsr"],
          ["Post comment(&T)", "menu_post_commnet"],
          ["BeatSaver page(&B)", "menu_beatsaver"],
          ["BeastSaber page(&S)", "menu_beastsaber"],
          ["Select play to CSV(&M)", "menu_maplist"],
          ["Note scoer to CSV(&N)", "menu_notescore"],
          ["PlayList create(&P)", "menu_playlist"]]
        ],
        ["Statistics(&S)",[
          ["Mapper(&M)", "menu_stat_mapper"],
          ["Accuracy(&A)", "menu_stat_accuracy"],
          ["Map(&P)", "menu_stat_map"],
          ["Play(&L)", "menu_stat_play"]]
        ],
        ["Help(&H)",[
          ["Manual(&M)", "menu_manual"],
          ["Version(&V)", "menu_version"],
          ["Latest Release Site(&L)", "menu_release"]]
        ]
      ]
    )
    setMenu(@mainmenu1,true)
    addControl(GroupBox1,'groupBox1',"Filter",168,600,712,96)
    addControl(VRButton,'button_all_select',"ALL",24,568,56,32)
    addControl(VRButton,'button_all_unselect',"unselect",88,568,64,32)
    addControl(VRButton,'button_cleared_sort',"Cleared",336,128,64,24)
    addControl(VRButton,'button_close',"CLOSE",864,816,88,40)
    addControl(VRButton,'button_datetime_sort',"DateTime",88,128,104,24)
    addControl(VRButton,'button_diff_sort',"Diff",240,128,48,24)
    addControl(VRButton,'button_difficulty',"Difficulty",544,128,64,24)
    addControl(VRButton,'button_ffmpeg_edit',"Edit",144,696,32,24)
    addControl(VRButton,'button_file_sort',"File",40,128,48,24)
    addControl(VRButton,'button_filename_edit',"Edit",144,752,32,24)
    addControl(VRButton,'button_filter',"Filter select",376,648,104,32)
    addControl(VRButton,'button_finished',"finished select",24,608,128,32)
    addControl(VRButton,'button_fullcombo',"full combo select",24,648,128,32)
    addControl(VRButton,'button_hdt_sort',"HDT",608,128,40,24)
    addControl(VRButton,'button_levelauthor_sort',"Level Author",952,128,120,24)
    addControl(VRButton,'button_miss_sort',"Miss",496,128,48,24)
    addControl(VRButton,'button_notes_sort',"N",24,128,16,24)
    addControl(VRButton,'button_open_preview_dir',"Open folder",976,616,96,24)
    addControl(VRButton,'button_organizing_remove',"Remove selection from map list",360,568,232,32)
    addControl(VRButton,'button_organizing_reset',"Reset map list",760,568,120,32)
    addControl(VRButton,'button_organizing_reversing',"Reversing selection",168,568,152,32)
    addControl(VRButton,'button_out_folder_edit',"Edit",144,808,32,24)
    addControl(VRButton,'button_out_open',"OPEN",776,832,56,24)
    addControl(VRButton,'button_preview',"Preview cursor",944,576,128,32)
    addControl(VRButton,'button_rank_sort',"Rank",400,128,40,24)
    addControl(VRButton,'button_run',"RUN",984,816,88,40)
    addControl(VRButton,'button_score_sort',"Score",440,128,56,24)
    addControl(VRButton,'button_search',"Search",632,568,80,32)
    addControl(VRButton,'button_songname_sort',"Song Name",648,128,304,24)
    addControl(VRButton,'button_speed_sort',"Speed",288,128,48,24)
    addControl(VRButton,'button_time_sort',"Time",192,128,48,24)
    addControl(VRCheckbox,'checkBox_all_same_song',"Same song",272,656,104,24)
    addControl(VRCheckbox,'checkBox_diff',"Song and play time difference +-",528,656,256,24)
    addControl(VRCheckbox,'checkBox_failed',"failed",272,624,64,24)
    addControl(VRCheckbox,'checkBox_finished',"finished",184,624,88,24)
    addControl(VRCheckbox,'checkBox_key_frame',"Cut in keyframe units",608,696,168,24)
    addControl(VRCheckbox,'checkBox_length',"movie length",864,736,104,32)
    addControl(VRCheckbox,'checkBox_miss',"Miss <=",752,624,80,24)
    addControl(VRCheckbox,'checkBox_normalize',"Audio normalize",400,696,136,24)
    addControl(VRCheckbox,'checkBox_pause',"pause",336,624,72,24)
    addControl(VRCheckbox,'checkBox_printing',"subtitle printing",608,744,152,32)
    addControl(VRCheckbox,'checkBox_score',"Score >=",608,624,88,24)
    addControl(VRCheckbox,'checkBox_softFail',"softFail",184,656,88,24)
    addControl(VRCheckbox,'checkBox_speed',"Normal Speed",472,624,120,24)
    addControl(VRCheckbox,'checkBox_subtitles',"With score subtitles",400,744,168,32)
    addControl(VRCombobox,'comboBox_ffmpeg',"",24,720,808,260)
    addControl(VRCombobox,'comboBox_filename',"",24,776,808,260)
    addControl(VRCombobox,'comboBox_folder',"",24,832,752,260)
    addControl(VREdit,'edit_difftime',"5",792,656,40,24)
    addControl(VREdit,'edit_end_offset',"4.0",976,696,64,32)
    addControl(VREdit,'edit_length',"139.0",976,736,64,32)
    addControl(VREdit,'edit_miss',"10",832,624,32,24)
    addControl(VREdit,'edit_score',"90",696,624,40,24)
    addControl(VREdit,'edit_start_offset',"0.0",976,656,64,32)
    addControl(VRListbox,'listBox_file',"",24,24,1048,96,0x4080)
    addControl(VRListbox,'listBox_map',"",24,152,1048,402,0x888)
    addControl(VRRadiobutton,'radioBtn_footer_cut',"footer cut",968,776,104,24)
    addControl(VRRadiobutton,'radioBtn_header_cut',"header cut",848,776,112,24)
    addControl(VRStatic,'static1',"sec",842,656,32,24)
    addControl(VRStatic,'static10',"sec",1040,704,32,24)
    addControl(VRStatic,'static12',"sec",1040,744,32,24)
    addControl(VRStatic,'static2',"|",428,622,16,24)
    addControl(VRStatic,'static3',"FFmpeg encode",24,696,112,24)
    addControl(VRStatic,'static4',"Output file name",24,752,120,24)
    addControl(VRStatic,'static5',"Output folder",24,808,96,24)
    addControl(VRStatic,'static6',"Time zone",792,0,72,24)
    addControl(VRStatic,'static7',"Start offset",886,664,80,24)
    addControl(VRStatic,'static8',"End offset",896,704,72,24)
    addControl(VRStatic,'static9',"sec",1040,664,24,24)
    addControl(VRStatic,'static_message',"Paste the file to be converted by drag and drop",304,0,352,24)
    addControl(VRStatic,'static_new_release',"",24,0,272,24)
    addControl(VRStatic,'tz_static',"",872,0,200,24)
    addControl(VRStatusbar,'statusbar',"",0,859,1084,22,0x3)
  end 

end

##__END_OF_FORMDESIGNER__
