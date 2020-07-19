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
    self.caption = '�v���C���X�g�쐬'
    self.move(165,75,1011,688)
    addControl(VRButton,'button_cancel',"�L�����Z��",664,584,112,40)
    addControl(VRButton,'button_delete',"�I�����폜",616,360,144,32)
    addControl(VRButton,'button_down',"������",896,360,72,32)
    addControl(VRButton,'button_open',"�J��",896,416,72,24)
    addControl(VRButton,'button_save',"�v���C���X�g��ۑ�",808,584,160,40)
    addControl(VRButton,'button_up',"�グ��",808,360,64,32)
    addControl(VRCheckbox,'checkBox_songname',"�Ȗ����o�͂���",816,472,152,24)
    addControl(VREdit,'edit_author',"",528,472,264,24)
    addControl(VREdit,'edit_description',"",32,528,936,24)
    addControl(VREdit,'edit_image',"",32,416,864,24)
    addControl(VREdit,'edit_title',"",32,472,464,24)
    addControl(VRListbox,'listBox_main',"",24,40,944,312,0x80)
    addControl(VRStatic,'static1',"�J�o�[�摜  (�h���b�O���h���b�v��)",32,392,280,24)
    addControl(VRStatic,'static2',"�^�C�g��",32,448,80,24)
    addControl(VRStatic,'static3',"����",32,504,88,24)
    addControl(VRStatic,'static4',"�쐬��",528,448,64,24)
    addControl(VRStatic,'static5',"�v���C���X�g���e",24,16,144,24)
  end 

end

class Modaldlg_list_option_setting < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = '�ݒ�'
    self.move(160,210,1060,476)
    addControl(VRButton,'button_add',"��ɒǉ�",248,128,104,24)
    addControl(VRButton,'button_cancel',"�L�����Z��",808,368,96,40)
    addControl(VRButton,'button_copy',"�I�������ɃR�s�[",32,128,152,24)
    addControl(VRButton,'button_default',"�I����ݒ�",888,192,128,24)
    addControl(VRButton,'button_del',"�I�����폜",704,128,128,24)
    addControl(VRButton,'button_down',"������",968,80,48,40)
    addControl(VRButton,'button_ok',"OK",928,368,88,40)
    addControl(VRButton,'button_open',"�J��",936,296,80,24)
    addControl(VRButton,'button_override',"�I�����㏑��",440,128,152,24)
    addControl(VRButton,'button_up',"�グ��",968,24,48,40)
    addControl(VRButton,'button_var_copy',"���ɃR�s�[",488,280,104,24)
    addControl(VRCombobox,'comboBox_var',"",488,256,400,260)
    addControl(VREdit,'edit_comment',"",32,256,352,24)
    addControl(VREdit,'edit_default',"",32,192,856,20,0x800)
    addControl(VREdit,'edit_main',"",32,320,984,24)
    addControl(VRListbox,'listBox_main',"",32,24,936,96)
    addControl(VRStatic,'static_comment',"�^�C�g��",32,232,72,24)
    addControl(VRStatic,'static_default',"�f�t�H���g�I��",32,168,144,24)
    addControl(VRStatic,'static_main',"",32,296,240,24)
    addControl(VRStatic,'static_var',"�g�p�\�ϐ�",488,232,104,24)
  end 

end

class Modaldlg_post_comment < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = '���e�R�����g�쐬'
    self.move(360,212,557,424)
    addControl(VRButton,'button_1',"1",32,40,104,24)
    addControl(VRButton,'button_2',"2",168,40,112,24)
    addControl(VRButton,'button_3',"3",312,40,104,24)
    addControl(VRButton,'button_close',"����",424,312,88,40)
    addControl(VRButton,'button_copy',"�N���b�v�{�[�h�ɃR�s�[",200,312,184,40)
    addControl(VRButton,'button_generate',"�p�����[�^�W�J",32,312,128,40)
    addControl(VRCheckbox,'checkBox_save',"�e���v���[�g�ۑ�",360,8,152,24)
    addControl(VRStatic,'static1',"�g�p�\�p�����[�^ = #songname# , #mapper# , #songauthor# , #bsr# , #difficulty# , #score# , #rank# , #miss#",32,264,480,40)
    addControl(VRStatic,'static2',"�e���v���[�g�I��",32,8,144,24)
    addControl(VRText,'text_main',"",32,80,480,184,0x1080)
  end 

end

class Modaldlg_db_view < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = '�f�[�^�x�[�X�{�����[�h'
    self.move(358,215,607,486)
    addControl(VRButton,'button_add_folder',"�����Ώۃt�H���_��ǉ�����",312,320,240,32)
    addControl(VRButton,'button_cancel',"�L�����Z��",336,376,96,40)
    addControl(VRButton,'button_ok',"OK",464,376,88,40)
    addControl(VRCheckbox,'checkBox_allread',"�S����",232,16,88,24)
    addControl(VRCheckbox,'checkBox_ambiguous',"�t�@�C�����̂����܂�����",320,144,232,24)
    addControl(VRCheckbox,'checkBox_cut_only',"�J�b�g�ςݓ���̂݌����ΏۂƂ���",32,384,288,24)
    addControl(VREdit,'edit_end_day',"",472,96,40,32)
    addControl(VREdit,'edit_end_month',"",416,96,40,32)
    addControl(VREdit,'edit_end_year',"",336,96,64,32)
    addControl(VREdit,'edit_start_day',"",184,96,40,32)
    addControl(VREdit,'edit_start_month',"",128,96,40,32)
    addControl(VREdit,'edit_start_year',"",48,96,64,32)
    addControl(VRListbox,'listBox_search_dir',"",32,176,520,114,0x4000)
    addControl(VRStatic,'static1',"�J�n����",48,48,88,24)
    addControl(VRStatic,'static10',"���挟���Ώۃt�H���_",32,144,208,24)
    addControl(VRStatic,'static11',"�ݒ�́u������J���t�H���_�v�Ɓu�o�̓t�H���_�v�͎����ǉ�����܂�",32,296,520,24)
    addControl(VRStatic,'static12',"������t�@�C����DB�Ƀ^�C���X�^���v�ۑ����ꂽ�����Ώۂł�",24,328,280,40)
    addControl(VRStatic,'static2',"�I������",336,48,112,24)
    addControl(VRStatic,'static3',"�N",72,72,32,24)
    addControl(VRStatic,'static4',"��",136,72,24,24)
    addControl(VRStatic,'static5',"��",200,72,24,24)
    addControl(VRStatic,'static6',"�N",360,72,32,24)
    addControl(VRStatic,'static7',"��",432,72,16,24)
    addControl(VRStatic,'static8',"��",480,72,24,24)
    addControl(VRStatic,'static9',"�ǂݍ��ݓ����͈�",48,16,152,24)
  end 

end

class Modaldlg_search < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = '�����i�荞��'
    self.move(386,241,456,319)
    addControl(VRButton,'button_author_copy',"�J�[�\���̕��ʂ��R�s�[",232,96,184,24)
    addControl(VRButton,'button_cancel',"�L�����Z��",80,216,104,32)
    addControl(VRButton,'button_ok',"OK",256,216,104,32)
    addControl(VRButton,'button_songname_copy',"�J�[�\���̕��ʂ��R�s�[",232,16,184,24)
    addControl(VREdit,'edit_author',"",24,120,392,32)
    addControl(VREdit,'edit_songname',"",24,40,392,32)
    addControl(VRRadiobutton,'radioBtn_all',"�S�v���C�Ώ�",24,168,120,24)
    addControl(VRRadiobutton,'radioBtn_ranked',"�����N�̂�",168,168,104,24)
    addControl(VRRadiobutton,'radioBtn_unranked',"�A�������N�̂�",288,168,136,24)
    addControl(VRStatic,'static1',"�Ȗ�",24,16,160,24)
    addControl(VRStatic,'static2',"�안�Җ�",24,96,152,24)
  end 

end

class Modaldlg_subtitle_setting < VRModalDialog
  include VRContainersSet

  class GroupBox1 < VRGroupbox


    def construct
    end
  end

  def construct
    self.caption = '�X�R�A�����p�ݒ�'
    self.move(232,88,511,489)
    addControl(GroupBox1,'groupBox1',"�Ă����ݐݒ�",16,8,464,144)
    addControl(VRButton,'button_cancel',"�L�����Z��",256,392,96,32)
    addControl(VRButton,'button_consolas',"Consolas",208,72,104,24)
    addControl(VRButton,'button_cut_default',"�f�t�H���g",160,272,88,24)
    addControl(VRButton,'button_miss_default',"�f�t�H���g",160,328,88,24)
    addControl(VRButton,'button_msGothic',"MS �S�V�b�N",80,72,120,24)
    addControl(VRButton,'button_ok',"OK",384,392,88,32)
    addControl(VRCombobox,'comboBox_alignment',"",112,112,328,800)
    addControl(VREdit,'edit_blue_notes',"",320,168,104,24)
    addControl(VREdit,'edit_cut_format',"",24,296,448,24)
    addControl(VREdit,'edit_font',"",80,40,232,24)
    addControl(VREdit,'edit_fontsize',"",400,40,56,24)
    addControl(VREdit,'edit_last_notes',"",120,232,48,24)
    addControl(VREdit,'edit_max_score',"",376,264,32,24)
    addControl(VREdit,'edit_miss_format',"",24,352,448,24)
    addControl(VREdit,'edit_red_notes',"",104,168,104,24)
    addControl(VREdit,'edit_sim_notes_time',"",352,224,88,24)
    addControl(VRStatic,'static1',"̫��",32,40,40,24)
    addControl(VRStatic,'static10',"1000ms/60fps x4frame=66ms",240,224,104,40)
    addControl(VRStatic,'static11',"�Ō�̃m�[�c�̕\������",24,216,96,40)
    addControl(VRStatic,'static12',"�b",176,232,32,24)
    addControl(VRStatic,'static13',"�ő哯�����萔",256,264,120,24)
    addControl(VRStatic,'static14',"�m�[�c",408,264,48,24)
    addControl(VRStatic,'static2',"̫�Ļ���",328,40,72,24)
    addControl(VRStatic,'static3',"�ʒu",64,112,40,24)
    addControl(VRStatic,'static4',"�J�b�g�̎����\��",24,272,136,24)
    addControl(VRStatic,'static5',"�ԃm�[�c",24,168,80,24)
    addControl(VRStatic,'static6',"�m�[�c",240,168,80,24)
    addControl(VRStatic,'static7',"�~�X�̎����\��",24,328,120,24)
    addControl(VRStatic,'static8',"�����m�[�c���莞��",248,200,176,24)
    addControl(VRStatic,'static9',"�ؕb",440,224,40,24)
  end 

end

class Modaldlg_modsetting < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = 'mod�ݒ�'
    self.move(235,57,842,527)
    addControl(VRButton,'button_bs_userfolder',"BeatSaber��UserData�t�H���_�ɐݒ�(�f�t�H���g)",336,120,368,24)
    addControl(VRButton,'button_cancel',"�L�����Z��",528,432,112,32)
    addControl(VRButton,'button_db_select',"�I��",736,120,64,24)
    addControl(VRButton,'button_modsetting_select',"�I��",736,56,64,24)
    addControl(VRButton,'button_ok',"OK",688,432,112,32)
    addControl(VRCheckbox,'checkBox_beatmapevent',"beatmapEvent",240,400,144,24)
    addControl(VRCheckbox,'checkBox_bombcut',"bombCut",240,320,144,24)
    addControl(VRCheckbox,'checkBox_bombmissed',"bombMissed",240,360,144,24)
    addControl(VRCheckbox,'checkBox_gccollect',"���ʃv���C�J�n�ƏI������GC Collec(�������̐���)����",336,192,448,24)
    addControl(VRCheckbox,'checkBox_notecut',"noteCut",56,360,160,24)
    addControl(VRCheckbox,'checkBox_notefullycut',"noteFullyCut",56,400,168,24)
    addControl(VRCheckbox,'checkBox_notemissed',"noteMissed",56,440,160,24)
    addControl(VRCheckbox,'checkBox_notesscore',"�m�[�c���̃X�R�A���L�^����",56,192,240,24)
    addControl(VRCheckbox,'checkBox_obstacle',"obstacleEnter,obstacleExit",240,440,256,24)
    addControl(VRCheckbox,'checkBox_scenechange',"�V�[���ύX��",56,280,128,24)
    addControl(VRCheckbox,'checkBox_scorechanged',"scoreChanged",56,320,168,24)
    addControl(VREdit,'edit_dbfile',"",56,96,744,24)
    addControl(VREdit,'edit_mod_setting_file',"",56,32,744,24)
    addControl(VRStatic,'static1',": hello,songStart,finished,failed,menu,pause,resume",184,280,448,24)
    addControl(VRStatic,'static2',"beatsaber.db �t�@�C��",56,72,168,24)
    addControl(VRStatic,'static3',"mod�ݒ�t�@�C��",56,8,136,24)
    addControl(VRStatic,'static5',"HTTPStutus��WebSocket���M����C�x���g",32,240,328,24)
    addControl(VRStatic,'static6',"mod����ݒ�",32,152,112,24)
  end 

end

class Modaldlg_timestamp < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = '�^�C���X�^���v�C��'
    self.move(227,73,663,330)
    addControl(VRButton,'button_cancel',"�L�����Z��",400,232,96,32)
    addControl(VRButton,'button_end_time',"�I�����������擾",416,128,168,24)
    addControl(VRButton,'button_fileget',"����t�@�C������^�C���X�^���v���擾",24,232,312,32)
    addControl(VRButton,'button_ok',"OK",520,232,96,32)
    addControl(VRButton,'button_select',"�I��",552,40,72,24)
    addControl(VREdit,'edit_end_date',"",104,128,104,24)
    addControl(VREdit,'edit_end_msec',"",344,128,64,24)
    addControl(VREdit,'edit_end_time',"",224,128,104,24)
    addControl(VREdit,'edit_moviefile',"",96,40,456,24)
    addControl(VREdit,'edit_start_date',"",104,96,104,24)
    addControl(VREdit,'edit_start_msec',"",344,96,64,24)
    addControl(VREdit,'edit_start_time',"",224,96,104,24)
    addControl(VRStatic,'static1',"����̧��",24,40,72,24)
    addControl(VRStatic,'static10',"��F",48,168,40,24)
    addControl(VRStatic,'static11',"��:��:�b",224,184,72,24)
    addControl(VRStatic,'static12',"427",344,160,32,16)
    addControl(VRStatic,'static13',"�b/1000",344,184,72,16)
    addControl(VRStatic,'static14',"DB�ɕۑ�����^�C���X�^���v���C��",16,8,280,24)
    addControl(VRStatic,'static15',"�h���b�O���h���b�v��",456,64,168,24)
    addControl(VRStatic,'static16',"����̒������琄�肵�܂�",416,152,208,24)
    addControl(VRStatic,'static17',"�^�C���]�[��",312,8,104,24)
    addControl(VRStatic,'static18',"���撷��",440,96,72,24)
    addControl(VRStatic,'static2',"���t",104,72,40,24)
    addControl(VRStatic,'static3',"����",224,72,48,24)
    addControl(VRStatic,'static4',"�J�n����",24,96,72,24)
    addControl(VRStatic,'static5',"�~���b",352,72,56,24)
    addControl(VRStatic,'static6',"�I������",24,128,64,24)
    addControl(VRStatic,'static7',"2020/1/18",104,160,88,24)
    addControl(VRStatic,'static8',"19:5:22",224,160,80,24)
    addControl(VRStatic,'static9',"�N/��/��",112,184,72,24)
    addControl(VRStatic,'static_length',"",520,96,104,24)
    addControl(VRStatic,'static_timezone',"",416,8,216,24)
  end 

end

class Modaldlg_setting < VRModalDialog
  include VRContainersSet

  class GroupBox_Preview < VRGroupbox
    include VRStdControlContainer
    attr_reader :radioBtn_copy
    attr_reader :radioBtn_select

    def construct
      addControl(VRRadiobutton,'radioBtn_copy',"���Copy",8,24,96,32)
      addControl(VRRadiobutton,'radioBtn_select',"�I�𒆂̃I�v�V����",112,24,176,32)
    end
  end

  def construct
    self.caption = '�ݒ�'
    self.move(226,71,655,704)
    addControl(GroupBox_Preview,'groupBox_Preview',"�v���r���[����FFmpeg�I�v�V����",24,336,296,64)
    addControl(VRButton,'button_cancel',"�L�����Z��",392,600,96,32)
    addControl(VRButton,'button_db_select',"�I��",560,40,56,24)
    addControl(VRButton,'button_default',"�f�t�H���g",464,472,88,24)
    addControl(VRButton,'button_ok',"OK",520,600,96,32)
    addControl(VRButton,'button_opendir_select',"�I��",488,184,56,24)
    addControl(VRButton,'button_parameter',"�p�����[�^����",464,496,152,24)
    addControl(VRButton,'button_preview_select',"�I��",376,248,56,24)
    addControl(VRButton,'button_preview_temp',"�I��",552,304,64,24)
    addControl(VRButton,'button_subtitle_temp',"�I��",552,432,64,24)
    addControl(VRCheckbox,'checkBox_ascii',"ASCII�󎚉\�����ȊO���폜",24,592,296,24)
    addControl(VRCheckbox,'checkBox_japanese',"���{�ꃂ�[�h (�ċN����L��)",376,544,240,24)
    addControl(VRCheckbox,'checkBox_newcheck',"�ŐV�o�[�W�������`�F�b�N����",24,544,264,24)
    addControl(VRCheckbox,'checkBox_no_message',"�^�C���X�^���v�`�F�b�N�̊m�F���b�Z�[�W��\�������ۑ���������D�悷��B",24,112,600,24)
    addControl(VRCheckbox,'checkBox_stop_time_menu',"�I�����Ԃ�menuTime�ł͂Ȃ�endTime���g�p����B",24,464,400,24)
    addControl(VRCheckbox,'checkBox_timesave',"������t�@�C���̃^�C���X�^���v���f�[�^�x�[�X�ɕۑ����Ǎ�����B(����)",24,80,600,24)
    addControl(VREdit,'edit_dbfile',"",24,40,536,24)
    addControl(VREdit,'edit_extension',"mkv",560,184,56,24)
    addControl(VREdit,'edit_offset',"0.0",520,360,56,32)
    addControl(VREdit,'edit_opendir',"",24,184,464,24)
    addControl(VREdit,'edit_preview_temp',"",24,304,528,24)
    addControl(VREdit,'edit_previewtool',"",24,248,352,24)
    addControl(VREdit,'edit_previewtool_option',"",448,248,168,24)
    addControl(VREdit,'edit_subtitle_temp',"",24,432,528,24)
    addControl(VREdit,'edit_time_format',"",104,496,360,24)
    addControl(VRStatic,'static1',"beatsaber.db �t�@�C��",24,16,168,24)
    addControl(VRStatic,'static10',"���j���[�̃t�@�C����������J���ōŏ��ɕ\������t�H���_",24,160,448,24)
    addControl(VRStatic,'static11',"�W���g���q",544,160,80,24)
    addControl(VRStatic,'static2',"���ԕ\�L",32,496,72,24)
    addControl(VRStatic,'static3',"(����:�C���X�g�[���p�X��ASCII�����ȊO�s��)",24,616,336,24)
    addControl(VRStatic,'static4',"�v���r���[�Ɏg�p����c�[��",24,224,232,24)
    addControl(VRStatic,'static5',"�v���r���[�p�ꎞ����t�@�C�� (SSD�򉻖h�~�̈�HDD�𐄏�)",24,280,464,24)
    addControl(VRStatic,'static6',"�J�b�g�̑S�̃I�t�Z�b�g",344,368,176,24)
    addControl(VRStatic,'static7',"�b",584,368,32,24)
    addControl(VRStatic,'static8',"�X�R�A�����p�ꎞ����t�@�C�� [�p�X�ɔ��p�󔒕s��] (SSD�򉻖h�~��HDD�𐄏�)",24,408,600,24)
    addControl(VRStatic,'static9',"�c�[���p�I�v�V����",448,224,168,24)
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
    self.caption = 'BeatSaber �v���C����J�b�g�c�[��'
    self.move(160,10,1060,940)
    #$_addControl(VRMenu,'mainmenu1',"",680,0,24,24)
    @mainmenu1 = newMenu.set(
      [
        ["�t�@�C��(&F)",[
          ["������J��(&O)", "menu_open"],
          ["sep", "_vrmenusep", 2048],
          ["DB�{�����[�h(&D)", "menu_dbopen"],
          ["sep", "_vrmenusep", 2048],
          ["����(&X)", "menu_exit"]]
        ],
        ["�I�v�V����(&O)",[
          ["�ݒ�(&S)", "menu_setting"],
          ["�^�C���X�^���v�C��(&T)", "menu_timestamp"],
          ["mod�ݒ�(&M)", "menu_modsetting"],
          ["�X�R�A�����ݒ�(&T)", "menu_subtitle_setting"],
          ["�ݒ�l�ۑ�(&V)", "menu_save"]]
        ],
        ["�c�[��(&T)",[
          ["!bsr�R�s�[(&C)", "menu_copy_bsr"],
          ["���e�p�R�����g�쐬(&P)", "menu_post_commnet"],
          ["BeatSaver���ʃy�[�W(&B)", "menu_beatsaver"],
          ["BeastSaber���ʃy�[�W(&S)", "menu_beastsaber"],
          ["�I���v���CCSV�ڍ׏o��(&M)", "menu_maplist"],
          ["�m�[�c�X�R�ACSV�o��(&N)", "menu_notescore"],
          ["�v���C���X�g�쐬(&P)", "menu_playlist"]]
        ],
        ["���v���(&S)",[
          ["�안�ҏ��(&M)", "menu_stat_mapper"],
          ["���x���(&A)", "menu_stat_accuracy"],
          ["�v���C�ڍ׏��(&M)", "menu_stat_map"],
          ["���v���C���(&P)", "menu_stat_play"]]
        ],
        ["�w���v(&H)",[
          ["�}�j���A��(&M)", "menu_manual"],
          ["�o�[�W�������(&N)", "menu_version"],
          ["�ŐV�Ŕz�z�T�C�g(&L)", "menu_release"]]
        ]
      ]
    )
    setMenu(@mainmenu1,true)
    addControl(GroupBox1,'groupBox1',"�I���t�B���^",168,608,672,88)
    addControl(VRButton,'button_all_select',"�S�I��",24,568,56,32)
    addControl(VRButton,'button_all_unselect',"�S����",88,568,64,32)
    addControl(VRButton,'button_cleared_sort',"�N���A",336,128,64,24)
    addControl(VRButton,'button_close',"����",824,816,88,40)
    addControl(VRButton,'button_datetime_sort',"�v���C����",88,128,104,24)
    addControl(VRButton,'button_diff_sort',"��(�b)",240,128,48,24)
    addControl(VRButton,'button_difficulty',"��Փx",544,128,64,24)
    addControl(VRButton,'button_ffmpeg_edit',"�ݒ�",144,696,40,24)
    addControl(VRButton,'button_file_sort',"����",40,128,48,24)
    addControl(VRButton,'button_filename_edit',"�ݒ�",144,752,40,24)
    addControl(VRButton,'button_filter',"�t�B���^�I��",376,656,104,32)
    addControl(VRButton,'button_finished',"�N���A��I��",24,608,128,32)
    addControl(VRButton,'button_fullcombo',"�t���R���{�I��",24,648,128,32)
    addControl(VRButton,'button_levelauthor_sort',"�안��",912,128,120,24)
    addControl(VRButton,'button_miss_sort',"�~�X",496,128,48,24)
    addControl(VRButton,'button_notes_sort',"N",24,128,16,24)
    addControl(VRButton,'button_open_preview_dir',"�t�H���_���J��",904,616,128,24)
    addControl(VRButton,'button_organizing_remove',"�I�������X�g����폜",336,568,232,32)
    addControl(VRButton,'button_organizing_reset',"���X�g��������",680,568,120,32)
    addControl(VRButton,'button_organizing_reversing',"�I���𔽓]",168,568,152,32)
    addControl(VRButton,'button_out_folder_edit',"�ݒ�",144,808,40,24)
    addControl(VRButton,'button_out_open',"�J��",736,832,56,24)
    addControl(VRButton,'button_preview',"�v���r���[",904,568,128,32)
    addControl(VRButton,'button_rank_sort',"�ݸ",400,128,40,24)
    addControl(VRButton,'button_run',"���s",944,816,88,40)
    addControl(VRButton,'button_score_sort',"�X�R�A",440,128,56,24)
    addControl(VRButton,'button_search',"����",584,568,80,32)
    addControl(VRButton,'button_songname_sort',"�Ȗ�",608,128,304,24)
    addControl(VRButton,'button_speed_sort',"���x",288,128,48,24)
    addControl(VRButton,'button_time_sort',"����",192,128,48,24)
    addControl(VRCheckbox,'checkBox_all_same_song',"����Ȃ��I��",184,664,168,24)
    addControl(VRCheckbox,'checkBox_diff',"�Ȏ��Ԃƃv���C���Ԃ̍� �}",536,664,216,24)
    addControl(VRCheckbox,'checkBox_failed',"failed",272,632,64,24)
    addControl(VRCheckbox,'checkBox_finished',"finished",184,632,88,24)
    addControl(VRCheckbox,'checkBox_length',"���撷������",808,736,120,32)
    addControl(VRCheckbox,'checkBox_miss',"�~�X <=",712,632,80,24)
    addControl(VRCheckbox,'checkBox_pause',"pause",336,632,72,24)
    addControl(VRCheckbox,'checkBox_printing',"�X�R�A�𓮉�ɏĂ�����",568,744,200,32)
    addControl(VRCheckbox,'checkBox_score',"�X�R�A >=",560,632,96,24)
    addControl(VRCheckbox,'checkBox_speed',"�W�����x",448,632,96,24)
    addControl(VRCheckbox,'checkBox_subtitles',"�X�R�A�������ɖ��ߍ���",328,744,200,32)
    addControl(VRCombobox,'comboBox_ffmpeg',"",24,720,768,260)
    addControl(VRCombobox,'comboBox_filename',"",24,776,768,260)
    addControl(VRCombobox,'comboBox_folder',"",24,832,712,260)
    addControl(VREdit,'edit_difftime',"5",752,664,40,24)
    addControl(VREdit,'edit_end_offset',"4.0",936,696,64,32)
    addControl(VREdit,'edit_length',"139.0",936,736,64,32)
    addControl(VREdit,'edit_miss',"10",792,632,32,24)
    addControl(VREdit,'edit_score',"90",656,632,40,24)
    addControl(VREdit,'edit_start_offset',"0.0",936,656,64,32)
    addControl(VRListbox,'listBox_file',"",24,24,1008,96,0x4080)
    addControl(VRListbox,'listBox_map',"",24,152,1008,402,0x888)
    addControl(VRRadiobutton,'radioBtn_footer_cut',"�I������",928,776,104,24)
    addControl(VRRadiobutton,'radioBtn_header_cut',"�J�n����",824,776,88,24)
    addControl(VRStatic,'static1',"�b",792,664,32,24)
    addControl(VRStatic,'static10',"�b",1000,704,32,24)
    addControl(VRStatic,'static12',"�b",1000,744,32,24)
    addControl(VRStatic,'static2',"|",408,630,16,24)
    addControl(VRStatic,'static3',"FFmpeg��߼��",24,696,112,24)
    addControl(VRStatic,'static4',"�o�̓t�@�C����",24,752,120,24)
    addControl(VRStatic,'static5',"�o�̓t�H���_",24,808,96,24)
    addControl(VRStatic,'static6',"�^�C���]�[��",728,0,104,24)
    addControl(VRStatic,'static7',"�J�n�̾��",856,664,72,24)
    addControl(VRStatic,'static8',"�I���̾��",856,704,72,24)
    addControl(VRStatic,'static9',"�b",1000,664,24,24)
    addControl(VRStatic,'static_message',"����t�@�C���̓h���b�O���h���b�v��",352,0,288,24)
    addControl(VRStatic,'static_new_release',"",24,0,320,24)
    addControl(VRStatic,'tz_static',"",832,0,200,24)
    addControl(VRStatusbar,'statusbar',"",0,859,1044,22,0x3)
  end 

end

##__END_OF_FORMDESIGNER__
