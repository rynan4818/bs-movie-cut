##__BEGIN_OF_FORMDESIGNER__
## CAUTION!! ## This code was automagically ;-) created by FormDesigner.
## NEVER modify manualy -- otherwise, you'll have a terrible experience.

require 'vr/vrdialog'
require 'vr/vruby'
require 'vr/vrcontrol'

class Modaldlg_subtitle_setting < VRModalDialog
  include VRContainersSet

  class GroupBox1 < VRGroupbox


    def construct
    end
  end

  def construct
    self.caption = 'Score subtitle setting'
    self.move(232,88,511,489)
    addControl(VRStatic,'static2',"Font Size",328,40,72,24)
    addControl(VRStatic,'static9',"ms",448,232,32,24)
    addControl(VRStatic,'static10',"1000ms/60fps x4frame=66ms",232,224,104,40)
    addControl(VRButton,'button_msGothic',"MS Gothic",80,72,120,24)
    addControl(VREdit,'edit_font',"",80,40,232,24)
    addControl(VRButton,'button_consolas',"Consolas",208,72,104,24)
    addControl(VREdit,'edit_red_notes',"",104,168,104,24)
    addControl(VRStatic,'static3',"Alignment",32,112,72,24)
    addControl(VREdit,'edit_last_notes',"",112,232,56,24)
    addControl(VRStatic,'static4',"Cut subtitle format",24,272,144,24)
    addControl(VREdit,'edit_sim_notes_time',"",352,232,88,24)
    addControl(VREdit,'edit_cut_format',"",24,296,448,24)
    addControl(VRStatic,'static1',"Font",32,40,40,24)
    addControl(VREdit,'edit_miss_format',"",24,352,448,24)
    addControl(VRButton,'button_cancel',"CANCEL",256,392,96,32)
    addControl(GroupBox1,'groupBox1',"Print settings",16,8,464,144)
    addControl(VREdit,'edit_blue_notes',"",320,168,104,24)
    addControl(VRStatic,'static7',"Miss subtitle format",24,328,144,24)
    addControl(VRStatic,'static11',"last notes display time",24,216,80,40)
    addControl(VRButton,'button_cut_default',"DEFAULT",168,272,80,24)
    addControl(VRButton,'button_miss_default',"DEFAULT",168,328,80,24)
    addControl(VRStatic,'static6',"Blue notes",240,168,80,24)
    addControl(VRStatic,'static5',"Red notes",24,168,80,24)
    addControl(VREdit,'edit_fontsize',"",400,40,56,24)
    addControl(VRButton,'button_ok',"OK",384,392,88,32)
    addControl(VRStatic,'static8',"Simultaneous notes time",232,200,176,24)
    addControl(VRStatic,'static12',"sec",176,232,32,24)
    addControl(VRCombobox,'comboBox_alignment',"",112,112,328,800)
  end 

end

class Modaldlg_modsetting < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = 'mod Setting'
    self.move(235,57,842,527)
    addControl(VRCheckbox,'checkBox_notecut',"noteCut",56,360,160,24)
    addControl(VRCheckbox,'checkBox_notefullycut',"noteFullyCut",56,400,168,24)
    addControl(VRCheckbox,'checkBox_beatmapevent',"beatmapEvent",240,400,144,24)
    addControl(VRButton,'button_bs_userfolder',"BeatSaber UserData folder",488,120,216,24)
    addControl(VREdit,'edit_mod_setting_file',"",56,32,744,24)
    addControl(VRButton,'button_modsetting_select',"Select",736,56,64,24)
    addControl(VRCheckbox,'checkBox_gccollect',"Scene change GC Collect",288,192,232,24)
    addControl(VRStatic,'static2',"beatsaber.db File",56,72,128,24)
    addControl(VRCheckbox,'checkBox_notesscore',"Notes score",56,192,184,24)
    addControl(VRCheckbox,'checkBox_bombcut',"bombCut",240,320,144,24)
    addControl(VRStatic,'static6',"Movie cut record setting",32,152,216,24)
    addControl(VREdit,'edit_dbfile',"",56,96,744,24)
    addControl(VRStatic,'static3',"mod setting file",56,8,224,24)
    addControl(VRCheckbox,'checkBox_scenechange',"Scene Change",56,280,128,24)
    addControl(VRCheckbox,'checkBox_scorechanged',"scoreChanged",56,320,168,24)
    addControl(VRStatic,'static1',": hello,songStart,finished,failed,menu,pause,resume",184,280,448,24)
    addControl(VRCheckbox,'checkBox_notemissed',"noteMissed",56,440,160,24)
    addControl(VRButton,'button_cancel',"CANCEL",528,432,112,32)
    addControl(VRCheckbox,'checkBox_obstacle',"obstacleEnter,obstacleExit",240,440,256,24)
    addControl(VRCheckbox,'checkBox_bombmissed',"bombMissed",240,360,144,24)
    addControl(VRStatic,'static5',"Events sent by HTTP WebSocket.",32,240,328,24)
    addControl(VRButton,'button_ok',"OK",688,432,112,32)
    addControl(VRButton,'button_db_select',"Select",736,120,64,24)
  end 

end

class Modaldlg_timestamp < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = 'Timestamp Tool'
    self.move(227,73,663,330)
    addControl(VREdit,'edit_start_date',"",104,96,104,24)
    addControl(VRStatic,'static6',"End time",24,128,64,24)
    addControl(VRStatic,'static11',"Hour/Min/Sec",224,184,104,24)
    addControl(VRStatic,'static18',"movie length",424,96,96,24)
    addControl(VRStatic,'static5',"msec",352,72,56,24)
    addControl(VRStatic,'static13',"Sec/1000",344,184,72,16)
    addControl(VRStatic,'static7',"2020/1/18",104,160,88,24)
    addControl(VREdit,'edit_start_msec',"",344,96,64,24)
    addControl(VRStatic,'static2',"Date",104,72,40,24)
    addControl(VRStatic,'static4',"Start time",24,96,72,24)
    addControl(VREdit,'edit_end_time',"",224,128,104,24)
    addControl(VRStatic,'static8',"19:5:22",224,160,80,24)
    addControl(VREdit,'edit_end_date',"",104,128,104,24)
    addControl(VRButton,'button_cancel',"CANCEL",328,232,120,32)
    addControl(VRStatic,'static_length',"",520,96,104,24)
    addControl(VRStatic,'static1',"Movie file",16,40,80,24)
    addControl(VRButton,'button_end_time',"End time for auto",416,128,168,24)
    addControl(VRStatic,'static15',"or Drag and Drop",496,64,128,24)
    addControl(VRButton,'button_select',"select",552,40,72,24)
    addControl(VRStatic,'static12',"427",344,160,32,16)
    addControl(VRStatic,'static3',"Time",224,72,48,24)
    addControl(VRStatic,'static_timezone',"",416,8,216,24)
    addControl(VRStatic,'static14',"Fix database timestamp registration",16,8,256,24)
    addControl(VRStatic,'static9',"Year/Month/Day",96,184,112,24)
    addControl(VRStatic,'static10',"Example",24,168,64,32)
    addControl(VREdit,'edit_moviefile',"",96,40,456,24)
    addControl(VRStatic,'static16',"Estimation from video length",416,152,192,24)
    addControl(VRButton,'button_ok',"OK",480,232,120,32)
    addControl(VRStatic,'static17',"Time zone",336,8,80,24)
    addControl(VRButton,'button_fileget',"Get timestamp from movie file",24,232,240,32)
    addControl(VREdit,'edit_end_msec',"",344,128,64,24)
    addControl(VREdit,'edit_start_time',"",224,96,104,24)
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
    self.move(226,71,656,572)
    addControl(VRStatic,'static3',"(WARNING:tool install path ASCII only)",32,488,288,24)
    addControl(VRStatic,'static1',"beatsaber.db file",24,16,136,24)
    addControl(VRStatic,'static6',"offset time",440,280,80,24)
    addControl(VREdit,'edit_dbfile',"",24,40,536,24)
    addControl(VRStatic,'static7',"sec",576,280,32,24)
    addControl(VRButton,'button_preview_select',"select",552,168,64,24)
    addControl(VRCheckbox,'checkBox_no_message',"Do not show message for timestamp check",24,112,328,24)
    addControl(VREdit,'edit_subtitle_temp',"",24,352,528,24)
    addControl(GroupBox_Preview,'groupBox_Preview',"Preview encode",24,256,296,64)
    addControl(VRButton,'button_ok',"OK",520,480,96,32)
    addControl(VRButton,'button_preview_temp',"select",552,224,64,24)
    addControl(VRStatic,'static5',"preview temporary file",24,200,232,24)
    addControl(VRCheckbox,'checkBox_stop_time_menu',"Use endtime for stoptime",24,400,216,24)
    addControl(VRButton,'button_default',"DEFAULT",464,408,88,24)
    addControl(VRButton,'button_cancel',"CANCEL",408,480,96,32)
    addControl(VRCheckbox,'checkBox_timesave',"Saves and reads the original movie file's timestamp the database.",24,80,480,24)
    addControl(VRStatic,'static2',"time format",24,432,80,24)
    addControl(VRButton,'button_subtitle_temp',"select",552,352,64,24)
    addControl(VREdit,'edit_offset',"0.0",520,272,56,32)
    addControl(VRCheckbox,'checkBox_ascii',"Remove non-ASCII code",24,464,296,24)
    addControl(VRStatic,'static4',"preview tool",24,144,112,24)
    addControl(VREdit,'edit_previewtool',"",24,168,528,24)
    addControl(VREdit,'edit_time_format',"",104,432,360,24)
    addControl(VREdit,'edit_preview_temp',"",24,224,528,24)
    addControl(VRStatic,'static8',"score subtitle temporary file",24,328,248,24)
    addControl(VRButton,'button_parameter',"parameter manual",464,432,152,24)
    addControl(VRButton,'button_db_select',"select",560,40,56,24)
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
    self.move(200,30,911,994)
    #$_addControl(VRMenu,'mainmenu1',"",416,16,24,24)
    @mainmenu1 = newMenu.set(
      [
        ["&File",[
          ["&Open", "menu_open"],
          ["sep", "_vrmenusep", 2048],
          ["E&xit", "menu_exit"]]
        ],
        ["&Option",[
          ["&Setting", "menu_setting"],
          ["&Timestamp Tool", "menu_timestamp"],
          ["&Mod setting", "menu_modsetting"],
          ["&Subtitle setting", "menu_subtitle_setting"],
          ["Setting Save", "menu_save"],
          ["&Note scoer", "menu_notescore"]]
        ],
        ["&Help",[
          ["Versio&n", "menu_version"]]
        ]
      ]
    )
    setMenu(@mainmenu1,true)
    addControl(VRCheckbox,'checkBox_score',"Score >=",392,672,88,24)
    addControl(VRButton,'button_run',"RUN",784,864,88,40)
    addControl(VRRadiobutton,'radioBtn_footer_cut',"footer cut",768,792,104,24)
    addControl(VRButton,'button_preview',"Preview cursor",744,608,128,32)
    addControl(VRStatic,'static6',"Time zone",608,16,80,24)
    addControl(VRCheckbox,'checkBox_failed',"failed",360,632,88,24)
    addControl(GroupBox1,'groupBox1',"Filter",232,600,432,152)
    addControl(VRCombobox,'comboBox_folder',"",32,880,568,260)
    addControl(VRListbox,'listBox_file',"",24,48,850,114,0x4080)
    addControl(VRCombobox,'comboBox_filename',"",32,824,568,260)
    addControl(VRStatic,'static3',"FFmpeg encode option",32,744,200,24)
    addControl(VRStatic,'static1',"sec",568,712,48,24)
    addControl(VRStatic,'static_message',"Paste the file to be converted by drag and drop",24,16,352,24)
    addControl(VREdit,'edit_length',"139.0",768,752,64,32)
    addControl(VREdit,'edit_miss',"10",336,672,40,24)
    addControl(VREdit,'edit_end_offset',"4.0",768,712,64,32)
    addControl(VREdit,'edit_start_offset',"0.0",768,672,64,32)
    addControl(VRStatic,'static11',"*Edit these 3 settings directly in the JSON.",256,856,320,24)
    addControl(VRCheckbox,'checkBox_pause',"pause",456,632,72,24)
    addControl(VRStatic,'static8',"End offset",688,720,72,24)
    addControl(VRCheckbox,'checkBox_length',"movie length",656,760,104,24)
    addControl(VRRadiobutton,'radioBtn_header_cut',"header cut",648,792,112,16)
    addControl(VRStatic,'static4',"Output file name",32,800,184,24)
    addControl(VRCheckbox,'checkBox_finished',"finished",256,632,88,24)
    addControl(VRButton,'button_fullcombo',"FULL COMBO only select",24,648,192,32)
    addControl(VRButton,'button_close',"CLOSE",664,864,88,40)
    addControl(VRButton,'button_all_select',"all select",24,608,80,32)
    addControl(VRStatic,'static12',"sec",840,760,32,24)
    addControl(VRCheckbox,'checkBox_miss',"Miss <=",256,672,80,32)
    addControl(VRStatic,'static7',"Start offset",680,680,80,24)
    addControl(VRCheckbox,'checkBox_subtitles',"With score subtitles",232,800,168,16)
    addControl(VRButton,'button_all_unselect',"all unselect",120,608,88,32)
    addControl(VREdit,'edit_difftime',"5",520,712,40,24)
    addControl(VRButton,'button_filter',"Filter select",528,624,120,40)
    addControl(VRCombobox,'comboBox_ffmpeg',"",32,768,568,260)
    addControl(VRStatic,'static9',"sec",840,680,32,24)
    addControl(VRStatic,'static5',"Output folder",32,856,192,24)
    addControl(VREdit,'edit_score',"90",480,672,40,24)
    addControl(VRStatic,'static10',"sec",840,720,32,24)
    addControl(VRStatic,'tz_static',"",688,16,184,24)
    addControl(VRCheckbox,'checkBox_diff',"Song and play time difference +-",256,704,264,40)
    addControl(VRCheckbox,'checkBox_speed',"Normal Speed",536,672,120,24)
    addControl(VRCheckbox,'checkBox_printing',"subtitle printing",432,800,136,24)
    addControl(VRButton,'button_finished',"finished only select",24,688,192,32)
    addControl(VRStatic,'static2',"File  Time  Diff Speed Cleared Rank Score Miss    Difficulty   Song Name                                 Level Author Name",24,168,848,24)
    addControl(VRListbox,'listBox_map',"",24,192,850,402,0x888)
  end 

end

##__END_OF_FORMDESIGNER__
