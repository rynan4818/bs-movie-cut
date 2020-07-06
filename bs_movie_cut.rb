#! ruby -Ks
# -*- mode:ruby; coding:shift_jis -*-
$KCODE='s'

#==============================================================================
#Project Name    : BeatSaber Movie Cut TOOL
#File Name       : bs_movie_cut.rb  _frm_bs_movie_cut.rb  sub_library.rb
#                : dialog_gui.rb  main_gui_event.rb  main_gui_sub.rb
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


#���ڎ��s����EXE_DIR��ݒ肷��
EXE_DIR = (File.dirname(File.expand_path($0)).sub(/\/$/,'') + '/').gsub(/\//,'\\') unless defined?(EXE_DIR)

#�g�p���C�u����
require 'csv'
require 'rubygems'
require 'sqlite3.rb'                     #SQLite3�̃f�[�^�x�[�X���g�����C�u�����ǂݍ��� (SQLite3::�` ���g����悤�ɂȂ�)
require 'nkf'                            #�����R�[�h�ϊ����C�u�����ǂݍ��� (NKF.�` ���g����悤�ɂȂ�)
require 'base64'
require 'vr/vruby'
require 'vr/vrcontrol'
require 'vr/vrcomctl'
require 'vr/vrddrop.rb'
require 'vr/vrdialog'
require 'vr/clipboard'
require 'vr/vrhandler'
require 'win32ole'
require 'Win32API'
require 'time'
require 'json'

#�T�u�X�N���v�g
require '_frm_bs_movie_cut.rb'
require 'sub_library.rb'
require 'dialog_gui.rb'
require 'main_gui_event.rb'
require 'main_gui_sub.rb'

#�ݒ�ςݒ萔
#EXE_DIR �E�E�E EXE�t�@�C���̂���f�B���N�g��[������\]
#MAIN_RB �E�E�E ���C����ruby�X�N���v�g�t�@�C����
#ERR_LOG �E�E�E �G���[���O�t�@�C����

#�\�t�g�o�[�W����
SOFT_VER        = '2020/07/06'
APP_VER_COOMENT = "BeatSaber Movie Cut TOOL Ver#{SOFT_VER}\r\n for ActiveScriptRuby(1.8.7-p330)\r\nCopyright 2020 Rynan.  (Twitter @rynan4818)"

#�ݒ�t�@�C��
SETTING_FILE = EXE_DIR + 'setting.json'

#���v�f�[�^�o�͗p�e���v���[�g
STAT_TEMPLATE_FILE = EXE_DIR + 'stat_template.txt'
MAPPER_STAT_HTML   = EXE_DIR + 'mapper_stat.html'
ACCURACY_STAT_HTML = EXE_DIR + 'accuracy_stat.html'
MAP_STAT_HTML      = EXE_DIR + 'map_stat.html'

#�T�C�g�ݒ�
BEATSAVER_URL   = "https://beatsaver.com/beatmap/#bsr#"
BEASTSABER_URL  = "https://bsaber.com/songs/#bsr#/"
SCORESABAER_URL = "http://scoresaber.com/api.php?function=get-leaderboards&cat=1&page=1&limit=500&ranked=1"

#�f�t�H���g�ݒ�
#beatsaber�̃f�[�^�x�[�X�t�@�C���� 1,2�͌�������
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
DEFALUT_SIMULTANEOUS_NOTES_TIME = 66 #�����m�[�c�Ɣ��肷�鎞��[ms] 66�E�E�E4�t���[���� 1000ms/60fps*4frame
DEFALUT_MAX_NOTES_DISPLAY = 10       #�ő�\���m�[�c�X�R�A��
DEFALUT_LAST_NOTES_TIME = 2.0       #�Ō�̎����\������[sec]
DEFALUT_SUB_FONT        = "�l�r �S�V�b�N"
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
DEFALUT_STAT_Y_COUNT    = 40  #���v�o�͂���Ƃ���Y���̐�

#�萔
BEATSABER_USERDATA_FOLDER = "[BeatSaber UserData folder]"
SUBTITLE_ALIGNMENT_SETTING = [['1: Bottom left','2: Bottom center','3: Bottom right','5: Top left','6: Top center','7: Top right','9: Middle left',
                              '10: Middle center','11: Middle right'],[1,2,3,5,6,7,9,10,11]]
CURL_TIMEOUT            = 5

$winshell  = WIN32OLE.new("WScript.Shell")
$scoresaber_ranked = nil  #ScoreSaber �̃����N����JSON�f�[�^

#�؂�o���t�@�C���̕ۑ���  .\\OUT\\�͂��̎��s�t�@�C���̂���t�H���_����"OUT"�t�H���_  �t���p�X�ł���  \��\\�ɂ��邱��  ������\\�K�v
DEFAULT_OUT_FOLDER     = ["#DEFAULT#  " + EXE_DIR + "OUT\\","#sample#  D:\\"]

#���C���t�H�[���̋N��
VRLocalScreen.start Form_main
