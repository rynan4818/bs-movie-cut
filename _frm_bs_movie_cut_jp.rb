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
    self.caption = 'プレイリスト作成'
    self.move(165,75,1011,688)
    addControl(VRButton,'button_cancel',"キャンセル",664,584,112,40)
    addControl(VRButton,'button_delete',"選択を削除",616,360,144,32)
    addControl(VRButton,'button_down',"下げる",896,360,72,32)
    addControl(VRButton,'button_open',"開く",896,416,72,24)
    addControl(VRButton,'button_save',"プレイリストを保存",808,584,160,40)
    addControl(VRButton,'button_up',"上げる",808,360,64,32)
    addControl(VRCheckbox,'checkBox_songname',"曲名も出力する",816,472,152,24)
    addControl(VREdit,'edit_author',"",528,472,264,24)
    addControl(VREdit,'edit_description',"",32,528,936,24)
    addControl(VREdit,'edit_image',"",32,416,864,24)
    addControl(VREdit,'edit_title',"",32,472,464,24)
    addControl(VRListbox,'listBox_main',"",24,40,944,312,0x80)
    addControl(VRStatic,'static1',"カバー画像  (ドラッグ＆ドロップ可)",32,392,280,24)
    addControl(VRStatic,'static2',"タイトル",32,448,80,24)
    addControl(VRStatic,'static3',"説明",32,504,88,24)
    addControl(VRStatic,'static4',"作成者",528,448,64,24)
    addControl(VRStatic,'static5',"プレイリスト内容",24,16,144,24)
  end 

end

class Modaldlg_list_option_setting < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = '設定'
    self.move(160,210,1060,476)
    addControl(VRButton,'button_add',"上に追加",248,128,104,24)
    addControl(VRButton,'button_cancel',"キャンセル",808,368,96,40)
    addControl(VRButton,'button_copy',"選択を下にコピー",32,128,152,24)
    addControl(VRButton,'button_default',"選択を設定",888,192,128,24)
    addControl(VRButton,'button_del',"選択を削除",704,128,128,24)
    addControl(VRButton,'button_down',"下げる",968,80,48,40)
    addControl(VRButton,'button_ok',"OK",928,368,88,40)
    addControl(VRButton,'button_open',"開く",936,296,80,24)
    addControl(VRButton,'button_override',"選択を上書き",440,128,152,24)
    addControl(VRButton,'button_up',"上げる",968,24,48,40)
    addControl(VRButton,'button_var_copy',"下にコピー",488,280,104,24)
    addControl(VRCombobox,'comboBox_var',"",488,256,400,260)
    addControl(VREdit,'edit_comment',"",32,256,352,24)
    addControl(VREdit,'edit_default',"",32,192,856,20,0x800)
    addControl(VREdit,'edit_main',"",32,320,984,24)
    addControl(VRListbox,'listBox_main',"",32,24,936,96)
    addControl(VRStatic,'static_comment',"タイトル",32,232,72,24)
    addControl(VRStatic,'static_default',"デフォルト選択",32,168,144,24)
    addControl(VRStatic,'static_main',"",32,296,240,24)
    addControl(VRStatic,'static_notes',"",32,360,752,64)
    addControl(VRStatic,'static_var',"使用可能変数",488,232,104,24)
  end 

end

class Modaldlg_post_comment < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = '投稿コメント作成'
    self.move(360,212,557,424)
    addControl(VRButton,'button_1',"1",32,40,104,24)
    addControl(VRButton,'button_2',"2",168,40,112,24)
    addControl(VRButton,'button_3',"3",312,40,104,24)
    addControl(VRButton,'button_close',"閉じる",424,312,88,40)
    addControl(VRButton,'button_copy',"クリップボードにコピー",200,312,184,40)
    addControl(VRButton,'button_generate',"パラメータ展開",32,312,128,40)
    addControl(VRCheckbox,'checkBox_save',"テンプレート保存",360,8,152,24)
    addControl(VRStatic,'static1',"使用可能パラメータ = #songname# , #mapper# , #songauthor# , #bsr# , #difficulty# , #score# , #rank# , #miss#",32,264,480,40)
    addControl(VRStatic,'static2',"テンプレート選択",32,8,144,24)
    addControl(VRText,'text_main',"",32,80,480,184,0x1080)
  end 

end

class Modaldlg_db_view < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = 'データベース閲覧モード'
    self.move(358,215,607,486)
    addControl(VRButton,'button_add_folder',"検索対象フォルダを追加する",312,320,240,32)
    addControl(VRButton,'button_cancel',"キャンセル",336,376,96,40)
    addControl(VRButton,'button_ok',"OK",464,376,88,40)
    addControl(VRCheckbox,'checkBox_allread',"全期間",232,16,88,24)
    addControl(VRCheckbox,'checkBox_ambiguous',"ファイル名のあいまい検索",320,144,232,24)
    addControl(VRCheckbox,'checkBox_cut_only',"カット済み動画のみ検索対象とする",32,384,288,24)
    addControl(VREdit,'edit_end_day',"",472,96,40,32)
    addControl(VREdit,'edit_end_month',"",416,96,40,32)
    addControl(VREdit,'edit_end_year',"",336,96,64,32)
    addControl(VREdit,'edit_start_day',"",184,96,40,32)
    addControl(VREdit,'edit_start_month',"",128,96,40,32)
    addControl(VREdit,'edit_start_year',"",48,96,64,32)
    addControl(VRListbox,'listBox_search_dir',"",32,176,520,114,0x4000)
    addControl(VRStatic,'static1',"開始日時",48,48,88,24)
    addControl(VRStatic,'static10',"動画検索対象フォルダ",32,144,208,24)
    addControl(VRStatic,'static11',"設定の「動画を開くフォルダ」と「出力フォルダ」は自動追加されます",32,296,520,24)
    addControl(VRStatic,'static12',"元動画ファイルはDBにタイムスタンプ保存された物が対象です",24,328,280,40)
    addControl(VRStatic,'static2',"終了日時",336,48,112,24)
    addControl(VRStatic,'static3',"年",72,72,32,24)
    addControl(VRStatic,'static4',"月",136,72,24,24)
    addControl(VRStatic,'static5',"日",200,72,24,24)
    addControl(VRStatic,'static6',"年",360,72,32,24)
    addControl(VRStatic,'static7',"月",432,72,16,24)
    addControl(VRStatic,'static8',"日",480,72,24,24)
    addControl(VRStatic,'static9',"読み込み日時範囲",48,16,152,24)
  end 

end

class Modaldlg_search < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = '検索絞り込み'
    self.move(386,241,456,319)
    addControl(VRButton,'button_author_copy',"カーソルの譜面をコピー",232,96,184,24)
    addControl(VRButton,'button_cancel',"キャンセル",80,216,104,32)
    addControl(VRButton,'button_ok',"OK",256,216,104,32)
    addControl(VRButton,'button_songname_copy',"カーソルの譜面をコピー",232,16,184,24)
    addControl(VREdit,'edit_author',"",24,120,392,32)
    addControl(VREdit,'edit_songname',"",24,40,392,32)
    addControl(VRRadiobutton,'radioBtn_all',"全プレイ対象",24,168,120,24)
    addControl(VRRadiobutton,'radioBtn_ranked',"ランクのみ",168,168,104,24)
    addControl(VRRadiobutton,'radioBtn_unranked',"アンランクのみ",288,168,136,24)
    addControl(VRStatic,'static1',"曲名",24,16,160,24)
    addControl(VRStatic,'static2',"作譜者名",24,96,152,24)
  end 

end

class Modaldlg_subtitle_setting < VRModalDialog
  include VRContainersSet

  class GroupBox1 < VRGroupbox


    def construct
    end
  end

  def construct
    self.caption = 'スコア字幕用設定'
    self.move(232,88,511,582)
    addControl(GroupBox1,'groupBox1',"焼き込み設定",16,8,464,200)
    addControl(VRButton,'button_cancel',"キャンセル",272,480,96,32)
    addControl(VRButton,'button_consolas',"Consolas",208,72,104,24)
    addControl(VRButton,'button_cut_default',"デフォルト",160,344,88,24)
    addControl(VRButton,'button_miss_default',"デフォルト",160,408,88,24)
    addControl(VRButton,'button_msGothic',"MS ゴシック",80,72,120,24)
    addControl(VRButton,'button_ok',"OK",384,480,88,32)
    addControl(VRCombobox,'comboBox_alignment',"",112,112,328,800)
    addControl(VREdit,'edit_blue_notes',"",320,224,104,24)
    addControl(VREdit,'edit_cut_format',"",24,368,448,24)
    addControl(VREdit,'edit_font',"",80,40,232,24)
    addControl(VREdit,'edit_fontsize',"",400,40,56,24)
    addControl(VREdit,'edit_force_style',"",32,168,424,24)
    addControl(VREdit,'edit_last_notes',"",120,288,48,24)
    addControl(VREdit,'edit_max_score',"",392,328,32,24)
    addControl(VREdit,'edit_miss_format',"",24,432,448,24)
    addControl(VREdit,'edit_red_notes',"",104,224,104,24)
    addControl(VREdit,'edit_sim_notes_time',"",352,288,88,24)
    addControl(VRStatic,'static1',"ﾌｫﾝﾄ",32,40,40,24)
    addControl(VRStatic,'static10',"1000ms/60fps x4frame=66ms",240,280,104,40)
    addControl(VRStatic,'static11',"最後のノーツの表示時間",24,272,96,40)
    addControl(VRStatic,'static12',"秒",176,288,32,24)
    addControl(VRStatic,'static13',"最大同時判定数",272,328,120,24)
    addControl(VRStatic,'static14',"ノーツ",424,328,48,24)
    addControl(VRStatic,'static15',"追加force_styleオプション",32,144,200,24)
    addControl(VRStatic,'static2',"ﾌｫﾝﾄｻｲｽﾞ",328,40,72,24)
    addControl(VRStatic,'static3',"位置",64,112,40,24)
    addControl(VRStatic,'static4',"カットの字幕表示",24,344,136,24)
    addControl(VRStatic,'static5',"赤ノーツ",24,224,80,24)
    addControl(VRStatic,'static6',"青ノーツ",240,224,80,24)
    addControl(VRStatic,'static7',"ミスの字幕表示",24,408,120,24)
    addControl(VRStatic,'static8',"同時ノーツ判定時間",240,256,176,24)
    addControl(VRStatic,'static9',"ﾐﾘ秒",440,288,40,24)
  end 

end

class Modaldlg_modsetting < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = 'mod設定(HTTP Status+Database)'
    self.move(235,57,842,527)
    addControl(VRButton,'button_bs_userfolder',"BeatSaberのUserDataフォルダに設定(デフォルト)",336,120,368,24)
    addControl(VRButton,'button_cancel',"キャンセル",528,432,112,32)
    addControl(VRButton,'button_db_select',"選択",736,120,64,24)
    addControl(VRButton,'button_modsetting_select',"選択",360,56,64,24)
    addControl(VRButton,'button_ok',"OK",688,432,112,32)
    addControl(VRCheckbox,'checkBox_beatmapevent',"beatmapEvent",240,400,144,24)
    addControl(VRCheckbox,'checkBox_bombcut',"bombCut",240,320,144,24)
    addControl(VRCheckbox,'checkBox_bombmissed',"bombMissed",240,360,144,24)
    addControl(VRCheckbox,'checkBox_gccollect',"譜面プレイ開始と終了時にGC Collec(メモリの整理)する",336,192,448,24)
    addControl(VRCheckbox,'checkBox_notecut',"noteCut",56,360,160,24)
    addControl(VRCheckbox,'checkBox_notefullycut',"noteFullyCut",56,400,168,24)
    addControl(VRCheckbox,'checkBox_notemissed',"noteMissed",56,440,160,24)
    addControl(VRCheckbox,'checkBox_notesscore',"ノーツ毎のスコアを記録する",56,192,240,24)
    addControl(VRCheckbox,'checkBox_obstacle',"obstacleEnter,obstacleExit",240,440,256,24)
    addControl(VRCheckbox,'checkBox_scenechange',"シーン変更時",56,280,128,24)
    addControl(VRCheckbox,'checkBox_scorechanged',"scoreChanged",56,320,168,24)
    addControl(VREdit,'edit_dbfile',"",56,96,744,24)
    addControl(VREdit,'edit_mod_setting_file',"",56,32,368,24)
    addControl(VRRadiobutton,'radioBtn_DataRecorder',"DataRecorder",648,32,152,24)
    addControl(VRRadiobutton,'radioBtn_movie_cut_record',"HTTP Statsu+Database",448,32,184,24)
    addControl(VRStatic,'static1',": hello,songStart,finished,failed,menu,pause,resume",184,280,448,24)
    addControl(VRStatic,'static2',"beatsaber.db ファイル",56,72,168,24)
    addControl(VRStatic,'static3',"Beat Saber UserData フォルダ",56,8,232,24)
    addControl(VRStatic,'static5',"HTTPStutusでWebSocket送信するイベント",32,240,328,24)
    addControl(VRStatic,'static6',"mod動作設定",32,152,112,24)
  end 

end

class Modaldlg_modsetting2 < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = 'mod設定(DataRecorder)'
    self.move(235,57,842,268)
    addControl(VRButton,'button_bs_userfolder',"デフォルトに戻す",544,120,160,24)
    addControl(VRButton,'button_cancel',"キャンセル",552,168,112,32)
    addControl(VRButton,'button_db_select',"選択",736,120,64,24)
    addControl(VRButton,'button_modsetting_select',"選択",368,56,64,24)
    addControl(VRButton,'button_ok',"OK",688,168,112,32)
    addControl(VREdit,'edit_dbfile',"",56,96,744,24)
    addControl(VREdit,'edit_mod_setting_file',"",56,32,376,24)
    addControl(VRRadiobutton,'radioBtn_DataRecorder',"DataRecorder",456,32,136,24)
    addControl(VRRadiobutton,'radioBtn_movie_cut_record',"HTTP Status+Database",592,32,192,24)
    addControl(VRStatic,'static2',"beatsaber.db ファイル",56,72,168,24)
    addControl(VRStatic,'static3',"Beat Saber UserData フォルダ",56,8,240,24)
  end 

end

class Modaldlg_timestamp < VRModalDialog
  include VRContainersSet

  def construct
    self.caption = 'タイムスタンプ修正'
    self.move(227,73,663,330)
    addControl(VRButton,'button_cancel',"キャンセル",400,232,96,32)
    addControl(VRButton,'button_end_time',"終了時刻自動取得",416,128,168,24)
    addControl(VRButton,'button_fileget',"動画ファイルからタイムスタンプを取得",24,232,312,32)
    addControl(VRButton,'button_ok',"OK",520,232,96,32)
    addControl(VRButton,'button_select',"選択",552,40,72,24)
    addControl(VREdit,'edit_end_date',"",104,128,104,24)
    addControl(VREdit,'edit_end_msec',"",344,128,64,24)
    addControl(VREdit,'edit_end_time',"",224,128,104,24)
    addControl(VREdit,'edit_moviefile',"",96,40,456,24)
    addControl(VREdit,'edit_start_date',"",104,96,104,24)
    addControl(VREdit,'edit_start_msec',"",344,96,64,24)
    addControl(VREdit,'edit_start_time',"",224,96,104,24)
    addControl(VRStatic,'static1',"動画ﾌｧｲﾙ",24,40,72,24)
    addControl(VRStatic,'static10',"例：",48,168,40,24)
    addControl(VRStatic,'static11',"時:分:秒",224,184,72,24)
    addControl(VRStatic,'static12',"427",344,160,32,16)
    addControl(VRStatic,'static13',"秒/1000",344,184,72,16)
    addControl(VRStatic,'static14',"DBに保存するタイムスタンプを修正",16,8,280,24)
    addControl(VRStatic,'static15',"ドラッグ＆ドロップ可",456,64,168,24)
    addControl(VRStatic,'static16',"動画の長さから推定します",416,152,208,24)
    addControl(VRStatic,'static17',"タイムゾーン",312,8,104,24)
    addControl(VRStatic,'static18',"動画長さ",440,96,72,24)
    addControl(VRStatic,'static2',"日付",104,72,40,24)
    addControl(VRStatic,'static3',"時間",224,72,48,24)
    addControl(VRStatic,'static4',"開始時刻",24,96,72,24)
    addControl(VRStatic,'static5',"ミリ秒",352,72,56,24)
    addControl(VRStatic,'static6',"終了時刻",24,128,64,24)
    addControl(VRStatic,'static7',"2020/1/18",104,160,88,24)
    addControl(VRStatic,'static8',"19:5:22",224,160,80,24)
    addControl(VRStatic,'static9',"年/月/日",112,184,72,24)
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
      addControl(VRCheckbox,'checkBox_preview_keycut',"キーフレーム単位カット",8,52,200,24)
      addControl(VRRadiobutton,'radioBtn_copy',"常にCopy",8,24,96,32)
      addControl(VRRadiobutton,'radioBtn_select',"選択中のオプション",112,24,176,32)
    end
  end

  def construct
    self.caption = '設定'
    self.move(226,71,655,850)
    addControl(GroupBox_Preview,'groupBox_Preview',"プレビュー時のFFmpegオプション",24,462,296,84)
    addControl(VRButton,'button_cancel',"キャンセル",392,746,96,32)
    addControl(VRButton,'button_db_select',"選択",560,40,56,24)
    addControl(VRButton,'button_default',"デフォルト",464,618,88,24)
    addControl(VRButton,'button_hdt_select',"選択",560,96,56,24)
    addControl(VRButton,'button_obs_dir_select',"選択",560,152,56,24)
    addControl(VRButton,'button_ok',"OK",520,746,96,32)
    addControl(VRButton,'button_opendir_select',"選択",488,310,56,24)
    addControl(VRButton,'button_parameter',"パラメータ説明",464,642,152,24)
    addControl(VRButton,'button_preview_select',"選択",376,374,56,24)
    addControl(VRButton,'button_preview_temp',"選択",552,430,64,24)
    addControl(VRButton,'button_subtitle_temp',"選択",552,578,64,24)
    addControl(VRCheckbox,'checkBox_ascii',"ASCII印字可能文字以外を削除",24,738,296,24)
    addControl(VRCheckbox,'checkBox_japanese',"日本語モード (再起動後有効)",376,690,240,24)
    addControl(VRCheckbox,'checkBox_newcheck',"最新バージョンをチェックする",24,690,264,24)
    addControl(VRCheckbox,'checkBox_no_message',"タイムスタンプチェックの確認メッセージを表示せず保存した物を優先する。",24,246,600,24)
    addControl(VRCheckbox,'checkBox_obs_log_check',"OBS Studioのログファイルから動画のタイムスタンプを取得する。",24,184,496,24)
    addControl(VRCheckbox,'checkBox_stop_time_menu',"終了時間にmenuTimeではなくendTimeを使用する。",24,610,400,24)
    addControl(VRCheckbox,'checkBox_timesave',"元動画ファイルのタイムスタンプをデータベースに保存し読込する。(推奨)",24,214,600,24)
    addControl(VREdit,'edit_dbfile',"",24,40,536,24)
    addControl(VREdit,'edit_extension',"mkv",560,310,56,24)
    addControl(VREdit,'edit_hdtfile',"",24,96,536,24)
    addControl(VREdit,'edit_max_volume',"0",520,470,56,24)
    addControl(VREdit,'edit_obs_dir',"",24,152,536,24)
    addControl(VREdit,'edit_offset',"0.0",520,510,56,28)
    addControl(VREdit,'edit_opendir',"",24,310,464,24)
    addControl(VREdit,'edit_preview_temp',"",24,430,528,24)
    addControl(VREdit,'edit_previewtool',"",24,374,352,24)
    addControl(VREdit,'edit_previewtool_option',"",448,374,168,24)
    addControl(VREdit,'edit_subtitle_temp',"",24,578,528,24)
    addControl(VREdit,'edit_time_format',"",104,642,360,24)
    addControl(VRStatic,'static1',"beatsaber.db ファイル",24,16,168,24)
    addControl(VRStatic,'static10',"メニューのファイル→動画を開くで最初に表示するフォルダ",24,286,448,24)
    addControl(VRStatic,'static11',"標準拡張子",544,286,80,24)
    addControl(VRStatic,'static12',"音声の正規化",344,470,96,24)
    addControl(VRStatic,'static13',"dB",584,470,24,24)
    addControl(VRStatic,'static14',"最大値=",456,470,64,24)
    addControl(VRStatic,'static15',"HMDDistance.dat ファイル",24,72,200,24)
    addControl(VRStatic,'static16',"OBS Studioログフォルダ",24,128,192,24)
    addControl(VRStatic,'static2',"時間表記",32,642,72,24)
    addControl(VRStatic,'static3',"(注意:インストールパスはASCII文字以外不可)",24,762,336,24)
    addControl(VRStatic,'static4',"プレビューに使用するツール",24,350,232,24)
    addControl(VRStatic,'static5',"プレビュー用一時動画ファイル (SSD劣化防止の為HDDを推奨)",24,406,464,24)
    addControl(VRStatic,'static6',"カットの全体オフセット",344,514,176,24)
    addControl(VRStatic,'static7',"秒",584,514,32,24)
    addControl(VRStatic,'static8',"スコア字幕用一時動画ファイル [パスに半角空白不可] (SSD劣化防止でHDDを推奨)",24,554,600,24)
    addControl(VRStatic,'static9',"ツール用オプション",448,350,168,24)
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
    self.caption = 'BeatSaber プレイ動画カットツール'
    self.move(160,10,1100,940)
    #$_addControl(VRMenu,'mainmenu1',"",680,0,24,24)
    @mainmenu1 = newMenu.set(
      [
        ["ファイル(&F)",[
          ["動画を開く(&O)", "menu_open"],
          ["最新動画を開く(&L)", "menu_latest_open"],
          ["sep", "_vrmenusep", 2048],
          ["DB閲覧モード(&D)", "menu_dbopen"],
          ["sep", "_vrmenusep", 2048],
          ["閉じる(&X)", "menu_exit"]]
        ],
        ["オプション(&O)",[
          ["設定(&S)", "menu_setting"],
          ["タイムスタンプ修正(&P)", "menu_timestamp"],
          ["mod設定(&M)", "menu_modsetting"],
          ["スコア字幕設定(&T)", "menu_subtitle_setting"],
          ["設定値保存(&V)", "menu_save"]]
        ],
        ["ツール(&T)",[
          ["!bsrコピー(&C)", "menu_copy_bsr"],
          ["投稿用コメント作成(&T)", "menu_post_commnet"],
          ["BeatSaver譜面ページ(&B)", "menu_beatsaver"],
          ["BeastSaber譜面ページ(&S)", "menu_beastsaber"],
          ["選択プレイCSV詳細出力(&M)", "menu_maplist"],
          ["ノーツスコアCSV出力(&N)", "menu_notescore"],
          ["プレイリスト作成(&P)", "menu_playlist"]]
        ],
        ["統計情報(&S)",[
          ["作譜者情報(&M)", "menu_stat_mapper"],
          ["精度情報(&A)", "menu_stat_accuracy"],
          ["プレイ詳細情報(&P)", "menu_stat_map"],
          ["総プレイ情報(&L)", "menu_stat_play"]]
        ],
        ["ヘルプ(&H)",[
          ["マニュアル(&M)", "menu_manual"],
          ["バージョン情報(&V)", "menu_version"],
          ["最新版配布サイト(&L)", "menu_release"]]
        ]
      ]
    )
    setMenu(@mainmenu1,true)
    addControl(GroupBox1,'groupBox1',"選択フィルタ",168,608,712,88)
    addControl(VRButton,'button_all_select',"全選択",24,568,56,32)
    addControl(VRButton,'button_all_unselect',"全解除",88,568,64,32)
    addControl(VRButton,'button_cleared_sort',"クリア",336,128,64,24)
    addControl(VRButton,'button_close',"閉じる",864,816,88,40)
    addControl(VRButton,'button_datetime_sort',"プレイ日時",88,128,104,24)
    addControl(VRButton,'button_diff_sort',"差(秒)",240,128,48,24)
    addControl(VRButton,'button_difficulty',"難易度",544,128,64,24)
    addControl(VRButton,'button_ffmpeg_edit',"設定",144,696,40,24)
    addControl(VRButton,'button_file_sort',"動画",40,128,48,24)
    addControl(VRButton,'button_filename_edit',"設定",144,752,40,24)
    addControl(VRButton,'button_filter',"フィルタ選択",416,656,104,32)
    addControl(VRButton,'button_finished',"クリアを選択",24,608,128,32)
    addControl(VRButton,'button_fullcombo',"フルコンボ選択",24,648,128,32)
    addControl(VRButton,'button_hdt_sort',"HDT",608,128,40,24)
    addControl(VRButton,'button_levelauthor_sort',"作譜者",952,128,120,24)
    addControl(VRButton,'button_miss_sort',"ミス",496,128,48,24)
    addControl(VRButton,'button_notes_sort',"N",24,128,16,24)
    addControl(VRButton,'button_open_preview_dir',"フォルダを開く",944,616,128,24)
    addControl(VRButton,'button_organizing_remove',"選択をリストから削除",360,568,232,32)
    addControl(VRButton,'button_organizing_reset',"リストを初期化",760,568,120,32)
    addControl(VRButton,'button_organizing_reversing',"選択を反転",168,568,152,32)
    addControl(VRButton,'button_out_folder_edit',"設定",144,808,40,24)
    addControl(VRButton,'button_out_open',"開く",776,832,56,24)
    addControl(VRButton,'button_preview',"プレビュー",944,568,128,32)
    addControl(VRButton,'button_rank_sort',"ﾗﾝｸ",400,128,40,24)
    addControl(VRButton,'button_run',"実行",984,816,88,40)
    addControl(VRButton,'button_score_sort',"スコア",440,128,56,24)
    addControl(VRButton,'button_search',"検索",634,568,80,32)
    addControl(VRButton,'button_songname_sort',"曲名",648,128,304,24)
    addControl(VRButton,'button_speed_sort',"速度",288,128,48,24)
    addControl(VRButton,'button_time_sort',"時間",192,128,48,24)
    addControl(VRCheckbox,'checkBox_all_same_song',"同一曲も選択",280,664,128,24)
    addControl(VRCheckbox,'checkBox_diff',"曲時間とプレイ時間の差 ±",576,664,216,24)
    addControl(VRCheckbox,'checkBox_failed',"failed",272,632,64,24)
    addControl(VRCheckbox,'checkBox_finished',"finished",184,632,88,24)
    addControl(VRCheckbox,'checkBox_key_frame',"キーフレーム単位でカットする",560,696,248,24)
    addControl(VRCheckbox,'checkBox_length',"動画長さ制限",848,736,120,32)
    addControl(VRCheckbox,'checkBox_miss',"ミス <=",752,632,80,24)
    addControl(VRCheckbox,'checkBox_normalize',"音声の正規化",368,696,160,24)
    addControl(VRCheckbox,'checkBox_pause',"pause",336,632,72,24)
    addControl(VRCheckbox,'checkBox_printing',"スコアを動画に焼き込む",608,744,200,32)
    addControl(VRCheckbox,'checkBox_score',"スコア >=",600,632,96,24)
    addControl(VRCheckbox,'checkBox_softFail',"softFail",184,664,88,24)
    addControl(VRCheckbox,'checkBox_speed',"標準速度",488,632,96,24)
    addControl(VRCheckbox,'checkBox_subtitles',"スコアを字幕に埋め込む",368,744,200,32)
    addControl(VRCombobox,'comboBox_ffmpeg',"",24,720,808,260)
    addControl(VRCombobox,'comboBox_filename',"",24,776,808,260)
    addControl(VRCombobox,'comboBox_folder',"",24,832,752,260)
    addControl(VREdit,'edit_difftime',"5",792,664,40,24)
    addControl(VREdit,'edit_end_offset',"4.0",976,696,64,32)
    addControl(VREdit,'edit_length',"139.0",976,736,64,32)
    addControl(VREdit,'edit_miss',"10",832,632,32,24)
    addControl(VREdit,'edit_score',"90",696,632,40,24)
    addControl(VREdit,'edit_start_offset',"0.0",976,656,64,32)
    addControl(VRListbox,'listBox_file',"",24,24,1048,96,0x4080)
    addControl(VRListbox,'listBox_map',"",24,152,1048,402,0x888)
    addControl(VRRadiobutton,'radioBtn_footer_cut',"終了調整",968,776,104,24)
    addControl(VRRadiobutton,'radioBtn_header_cut',"開始調整",864,776,88,24)
    addControl(VRStatic,'static1',"秒",832,664,32,24)
    addControl(VRStatic,'static10',"秒",1040,704,32,24)
    addControl(VRStatic,'static12',"秒",1040,744,32,24)
    addControl(VRStatic,'static2',"|",428,630,16,24)
    addControl(VRStatic,'static3',"FFmpegｵﾌﾟｼｮﾝ",24,696,112,24)
    addControl(VRStatic,'static4',"出力ファイル名",24,752,120,24)
    addControl(VRStatic,'static5',"出力フォルダ",24,808,96,24)
    addControl(VRStatic,'static6',"タイムゾーン",768,0,104,24)
    addControl(VRStatic,'static7',"開始ｵﾌｾｯﾄ",896,664,72,24)
    addControl(VRStatic,'static8',"終了ｵﾌｾｯﾄ",896,704,72,24)
    addControl(VRStatic,'static9',"秒",1040,664,24,24)
    addControl(VRStatic,'static_message',"動画ファイルはドラッグ＆ドロップ可",352,0,288,24)
    addControl(VRStatic,'static_new_release',"",24,0,320,24)
    addControl(VRStatic,'tz_static',"",872,0,200,24)
    addControl(VRStatusbar,'statusbar',"",0,859,1084,22,0x3)
  end 

end

##__END_OF_FORMDESIGNER__
