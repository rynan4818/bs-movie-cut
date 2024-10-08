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


#直接実行時にEXE_DIRを設定する
EXE_DIR = (File.dirname(File.expand_path($0)).sub(/\/$/,'') + '/').gsub(/\//,'\\') unless defined?(EXE_DIR)

#使用ライブラリ
require 'csv'
require 'rubygems'
require 'sqlite3.rb'                     #SQLite3のデータベースを使うライブラリ読み込み (SQLite3::〜 が使えるようになる)
require 'nkf'                            #文字コード変換ライブラリ読み込み (NKF.〜 が使えるようになる)
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

#設定済み定数
#EXE_DIR ・・・ EXEファイルのあるディレクトリ[末尾は\]
#MAIN_RB ・・・ メインのrubyスクリプトファイル名
#ERR_LOG ・・・ エラーログファイル名

$winshell  = WIN32OLE.new("WScript.Shell")

#ソフトバージョン
SOFT_VER        = '2024/10/07'
APP_VER_COOMENT = "BeatSaber Movie Cut TOOL Ver#{SOFT_VER}\r\n for ActiveScriptRuby(1.8.7-p330)\r\nCopyright 2020 リュナン [Rynan] (Twitter @rynan4818)"

#設定ファイル
SETTING_FILE = EXE_DIR + 'setting.json'

#統計データ出力用テンプレート
STAT_TEMPLATE_FILE = EXE_DIR + 'stat_template.txt'
MAPPER_STAT_HTML   = EXE_DIR + 'mapper_stat.html'
ACCURACY_STAT_HTML = EXE_DIR + 'accuracy_stat.html'
MAP_STAT_HTML      = EXE_DIR + 'map_stat.html'
PLAY_STAT_HTML     = EXE_DIR + 'play_stat.html'

#サイト設定
BEATSAVER_URL        = "https://beatsaver.com/maps/#bsr#"
BEATSAVER_BYHASH_URL = "https://api.beatsaver.com/maps/hash/"
BEASTSABER_URL       = "https://bsaber.com/songs/#bsr#/"
SCORESABAER_URL      = "https://scoresaber.com/api.php?function=get-leaderboards&cat=1&page=1&limit=500&ranked=1"
NEW_CHECK_URL        = "https://rynan4818.github.io/release_info.json"
MANUAL_URL           = "https://docs.google.com/document/d/1zyJ4o_rPToMF0anGCDlScW0-ZLSYKSyA6VPamWQS-h0"
RELEASE_URL          = "https://github.com/rynan4818/bs-movie-cut/releases"

#キーフレーム調査用
CHECK_BACK_TIME      = 5.0
CHECK_LENGTH_TIME    = 10.0

#デフォルト設定
#beatsaberのデータベースファイル名 1,2は検索順序
DEFALUT_DB_FILE_NAME   = "beatsaber.db"
DEFALUT1_DB_FILE       = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Beat Saber\\UserData\\DataRecorder\\" + DEFALUT_DB_FILE_NAME

DEFALUT_HDT_FILE_NAME  = "HMDDistance.litedb"
DEFAULT_HDT_FILE       = $winshell.SpecialFolders(5).sub(/\\Roaming$/,'') + "\\LocalLow\\Hyperbolic Magnetism\\Beat Saber\\" + DEFALUT_HDT_FILE_NAME

DEFAULT_OBS_LOG_DIR    = $winshell.SpecialFolders(5) + "\\obs-studio\\logs"

DATARECORDER_MOD_SETTING_FILE_NAME = "DataRecorder.json"
HTTPSTATUS_DB_MOD_SETTING_FILE_NAME = "movie_cut_record.json"
DEFAULT_MOD_SETTING_FILE = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Beat Saber\\UserData\\" + DATARECORDER_MOD_SETTING_FILE_NAME
DEFAULT_TIMEFORMAT     = "%Y%m%d-%H%M%S"
DEFAULT_PREVIEW_TOOL   = EXE_DIR + "ffplay.exe"
DEFAULT_PREVIEW_FILE   = EXE_DIR + "temp.mp4"
DEFALUT_PREVIEW_FFMPEG = " -c copy -async 1"
DEFALUT_PREVIEW_KEYCUT = false
DEFAULT_SUBTITLE_FILE  = EXE_DIR + "subtitle_temp.mp4"
DEFAULT_FFMPEG_OPTION  = ["#DEFALUT#  -c copy -async 1",
                          "#Twitter 2Mbps#  -r 40 -c:v libx264 -pix_fmt yuv420p -strict -2 -c:a aac -b:v 1878k -minrate 1878k -maxrate 1878k -bufsize 1878k -b:a 128k -async 1 -vsync cfr -s 1280x720",
                          "#Twitter 15.5Mbps#  -c:v libx264 -pix_fmt yuv420p -strict -2 -c:a aac -b:a 512k -b:v 15360k -async 1",
                          "#Twitter 15.5Mbps NoAudio#  -c:v libx264 -pix_fmt yuv420p -strict -2 -an -b:v 15360k",
                          "#YouTube 7.5Mbps#  -b:v 7.5M -b:a 384k -ar 48000 -r 60 -g 30 -movflags +faststart -c:a aac -profile:a aac_low -ac 2 -c:v libx264 -vf yadif=0:-1:1 -profile:v high  -bf 2 -coder 1 -pix_fmt yuv420p -vsync cfr -async 1",
                          "#YouTube 12Mbps#  -b:v 12M -b:a 384k -ar 48000 -r 60 -g 30 -movflags +faststart -c:a aac -profile:a aac_low -ac 2 -c:v libx264 -vf yadif=0:-1:1 -profile:v high  -bf 2 -coder 1 -pix_fmt yuv420p -vsync cfr -async 1",
                          "#YouTube Shorts#  -vf crop=x=in_w*0.28:y=0:w=in_h*9/16:h=in_h,scale=w=1080:h=1920,yadif=0:-1:1 -b:v 12M -b:a 384k -ar 48000 -r 60 -g 30 -movflags +faststart -c:a aac -profile:a aac_low -ac 2 -c:v libx264 -profile:v high -bf 2 -coder 1 -pix_fmt yuv420p -vsync cfr -async 1",
                          "#YouTube Shorts Stack#  -filter_complex \"[0:v]crop=x=in_w*0.2:y=in_h*0.3:w=in_w*0.4:h=out_w*8/9,scale=w=1080:h=960,yadif=0:-1:1[v0];[0:v]crop=x=in_w*0.6:y=in_h*0.3:w=in_w*0.4:h=out_w*8/9,scale=w=1080:h=960,yadif=0:-1:1[v1];[v0][v1]vstack=inputs=2\" -b:v 12M -b:a 384k -ar 48000 -r 60 -g 30 -movflags +faststart -c:a aac -profile:a aac_low -ac 2 -c:v libx264 -profile:v high -bf 2 -coder 1 -pix_fmt yuv420p -vsync cfr -async 1",
                          "#NVENC_Acopy#  -r 60 -vsync cfr -async 1 -c:a copy -c:v h264_nvenc -b:v 22M",
                          "#NVENC_A512k#  -r 60 -vsync cfr -async 1 -c:a aac -c:v h264_nvenc -b:a 512k -b:v 22M",
                          "#Twitter NVENC 15.5Mbps#  -c:v h264_nvenc -pix_fmt yuv420p -strict -2 -c:a aac -b:a 512k -b:v 15360k -async 1",
                          "#Twitter NVENC 15.5Mbps NoAudio#  -c:v h264_nvenc -pix_fmt yuv420p -strict -2 -an -b:v 15360k",
                          "#NO COPY#  -async 1"]
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
DEFALUT_SUB_CUT_FORMAT  = '"%4d:#{note_type}:%2d+%2d+%2d=%3d" % [noteCount,(beforeScore == nil ? initialScore : beforeScore),afterScore,cutDistanceScore,finalScore]'
DEFALUT_SUB_MISS_FORMAT = '"%4d:#{note_type}:Miss!" % noteCount'
DEFALUT_POST_COMMENT    = ["Song:#songname#\r\nMapper:#mapper#\r\n!bsr #bsr#\r\n\r\n\r\n#BeatSaber\r\n",
                           "#songname# , #mapper# , #songauthor# , #bsr# , #difficulty# , #score# , #rank# , #miss#",
                           "#songname# , #mapper# , #songauthor# , #bsr# , #difficulty# , #score# , #rank# , #miss#"]
DEFALUT_STAT_Y_COUNT    = 40  #統計出力するときのY軸の数

#定数
CURL_TIMEOUT            = 5

$scoresaber_ranked = nil  #ScoreSaber のランク譜面JSONデータ
$obs_log_time = {}        #OBSの動画ファイルの開始終了時間データ

#切り出しファイルの保存先  .\\OUT\\はこの実行ファイルのあるフォルダ下の"OUT"フォルダ  フルパスでも可  \は\\にすること  末尾は\\必要
DEFAULT_OUT_FOLDER     = ["#DEFAULT#  " + EXE_DIR + "OUT\\","#sample#  D:\\"]

#カレントディレクトリを実行ファイルのフォルダにする
Dir.chdir(EXE_DIR)

#設定ファイルの初期読込
$japanese_mode = false
$new_version_check = true
$last_version_check = nil
$new_version = nil
if File.exist?(SETTING_FILE)
  setting = JSON.parse(File.read(SETTING_FILE))
  $japanese_mode = setting['japanese_mode'] unless setting['japanese_mode'] == nil
  $new_version_check = setting['new_version_check'] unless setting['new_version_check'] == nil
  $new_version = setting['new_version'] if setting['new_version'] && setting['new_version'] > SOFT_VER
  $last_version_check = setting['last_version_check']
end

#日本語UIの選択
if $japanese_mode
  require '_frm_bs_movie_cut_jp.rb'
  require 'language_jp.rb'
else
  require '_frm_bs_movie_cut.rb'
  require 'language_en.rb'
end

#最新版のチェック
if $new_version_check && $last_version_check != Time.now.strftime("%Y/%m/%d")
  puts "#{NEW_VERSION_CHECK}"
  begin
    release_info = JSON.parse(`curl.exe --connect-timeout #{CURL_TIMEOUT} #{NEW_CHECK_URL}`)
  rescue
    release_info = {}
  end
  if latestversion = release_info['LatestVersion']
    $new_version = latestversion['bs_movie_cut'] if latestversion['bs_movie_cut'] > SOFT_VER
    if $new_version
      puts "#{NEW_RELEASE_MES} #{$new_version}"
    else
      puts "#{LATEST_MES}"
    end
    $last_version_check = Time.now.strftime("%Y/%m/%d")
  end
end

#サブスクリプトの読込
require 'sub_library.rb'
require 'dialog_gui.rb'
require 'main_gui_event.rb'
require 'main_gui_sub.rb'

#メインフォームの起動
VRLocalScreen.start Form_main
