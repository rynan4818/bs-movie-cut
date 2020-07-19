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

#Setting
BEATSABER_USERDATA_FOLDER = "[BeatSaber UserData フォルダ]"
SUBTITLE_ALIGNMENT_SETTING = [['1: 左下','2: 下中央','3: 右下','5: 上左','6: 上中央','7: 上右','9: 中央左',
                              '10: 中央','11: 中央右'],[1,2,3,5,6,7,9,10,11]]

#Message
MOVIE_FILE_TIMESTAMP1_MAIN  = "この動画は未移動・未コピーのオリジナルの録画ファイルですか?\r\nファイルのタイムスタンプをデータベースに保存しますか？"
MOVIE_FILE_TIMESTAMP1_TITLE = "データベースにタイムスタンプを保存"
MOVIE_FILE_TIMESTAMP2_MAIN  = "データベースに記録されているタイムスタンプとは異なります。\r\nデータベースのタイムスタンプを使用しますか？\r\n\r\n(このメッセージは設定で非表示にすることができます)"
MOVIE_FILE_TIMESTAMP2_TITLE = "タイムスタンプがデータベースと異なります"
MOVIE_SUB_CREATE_SYNTAXERROR       = "無効な字幕フォーマットの設定です\r\nSyntax Error"
MOVIE_SUB_CREATE_SYNTAXERROR_TITLE = "字幕フォーマットSyntaxError"
MOVIE_SUB_CREATE_EXCEPTION         = "無効な字幕フォーマットの設定です"
MOVIE_SUB_CREATE_EXCEPTION_TITLE   = "字幕フォーマットエラー"
STATUSBAR_FILE   = "ﾌｧｲﾙ"
STATUSBAR_MAP    = "ﾌﾟﾚｲ"
STATUSBAR_SELECT = "選択"
SELECT_TO_BSR_NIL_MAIN  = "There is no song id"
SELECT_TO_BSR_NIL_TITLE = "No song ID"
SELECT_TO_BSR_ERR_MAIN  = "Not registered on beatsaver."
SELECT_TO_BSR_ERR_TITLE = "No bsr"
NEW_RELEASE_MES   = "最新版があります "
NEW_VERSION_CHECK = "最新版をチェックしています...."
LATEST_MES        = "現在のバージョンが最新です"
MAIN_SELF_CREATED_DBFILE_CHECK1_MAIN  = "ファイルが見つかりません\r\n設定画面を開きますので、データベースファイルを選択して下さい。"
MAIN_SELF_CREATED_DBFILE_CHECK1_TITLE = "データベースファイルが見つかりません"
MAIN_SELF_CREATED_DBFILE_CHECK2_MAIN  = "'beatsaber.db' ファイルが見つかりません\r\n設定画面を開きますので、データベースファイルを選択して下さい。"
MAIN_SELF_CREATED_DBFILE_CHECK2_TITLE = "beatsaber.db ファイルが見つかりません"
MAIN_BUTTON_RUN_FILE_NAME_SYNTAXERROR       = "無効なファイル名設定です\r\nSyntax Error"
MAIN_BUTTON_RUN_FILE_NAME_SYNTAXERROR_TITLE = "ファイル名 SyntaxError"
MAIN_BUTTON_RUN_FILE_NAME_EXCEPTION         = "無効なファイル名設定です"
MAIN_BUTTON_RUN_FILE_NAME_EXCEPTION_TITLE   = "ファイル名 ERROR"
MAIN_BUTTON_PREVIEW_TOOL_CHECK       = "ファイルが見つかりません\r\nメニューのオプションからプレビュー用ツールを設定して下さい。"
MAIN_BUTTON_PREVIEW_TOOL_CHECK_TITLE = "プレビューツールが見つかりません"
MAIN_BUTTON_PREVIEW_DIR_CHECK        = "プレビュー用動画保存フォルダがありません\r\nメニューのオプションからプレビュー用一時動画ファイルを設定して下さい。"
MAIN_BUTTON_PREVIEW_DIR_CHECK_TITLE  = "プレビュー用動画保存フォルダがありません"
MAIN_BUTTON_PREVIEW_FILE_CHECK       = "プレビュー用一時動画ファイルの設定がありません\r\nメニューのオプションから設定して下さい。"
MAIN_BUTTON_PREVIEW_FILE_CHECK_TITLE = "プレビュー用一時動画ファイルの設定がありません"
MAIN_BUTTON_PREVIEW_ERROR            = "プレビューに想定外のエラーが発生しました\r\nWScript.Shell Error"
MAIN_BUTTON_PREVIEW_ERROR_TITLE      = "プレビューエラー"
MAIN_BUTTON_SEARCH_SCORESABER_CHECK       = "ScoreSaberからランク情報が取得できません"
MAIN_BUTTON_SEARCH_SCORESABER_CHECK_TITLE = "ScoreSaberからランク情報取得出来ません"
MAIN_MENU_VERSION_TITLE = "BeatSaber プレイ動画カットツール バージョン情報"
MAIN_MENU_SAVE       = "現在の設定を保存しました"
MAIN_MENU_SAVE_TITLE = "設定保存完了"
MAIN_NOT_SELECT_MES        = "プレイした譜面を選択して下さい"
MAIN_NOT_SELECT_MES_TITLE  = "プレイ譜面が未選択です"
MAIN_NOT_SELECT_MES2       = "プレイした譜面を選択(複数可)して下さい"
MAIN_NOT_SELECT_MES2_TITLE = "プレイ譜面が未選択です"
MAIN_NOT_SELECT_MES3       = "プレイした譜面を複数選択して下さい"
MAIN_NOT_SELECT_MES3_TITLE = "プレイ譜面が未選択です"
MAIN_NOT_NOTES_SCORE_DB_MES       = "ノーツスコア情報がデータベースに記録されていません"
MAIN_NOT_NOTES_SCORE_DB_MES_TITLE = "ノーツスコアがありません"
MAIN_MENU_COPY_BSR       = "コピーしました !bsr "
MAIN_MENU_COPY_BSR_TITLE = "コピーしました"
MAIN_WSH_ERR             = "WScript Shellでエラーが発生しました"
MAIN_WSH_ERR_TITLE       = "ウェブページを開く時にエラーが発生"
MAIN_MENU_PLAYLIST_OVERWRITE_CHECK       = "上書き保存しますか？"
MAIN_MENU_PLAYLIST_OVERWRITE_CHECK_TITLE = "上書き保存確認"
FFMPEG_EDIT_TITLE     = "FFmpegオプション設定"
FILENAME_EDIT_TITLE   = "出力ファイル名設定"
OUT_FOLDER_EDIT_TITLE = "出力フォルダ設定"
DB_OPEN_ERROR_MES     = "データベースがエラーで開けません"
DB_OPEN_ERROR_TITLE   = "データベースオープンエラー"
DB_ERROR_MES          = "データベースがエラーです\r\n"
DB_ERROR_TITLE        = "データベースエラー"
DB_NOPLAY_RECORD       = "プレイ記録がデータベースにありません"
DB_NOPLAY_RECORD_TITLE = "プレイ記録なし"
DLG_POST_COMMENT_BUTTON_COPY       = "投稿用コメントをコピーしました"
DLG_POST_COMMENT_BUTTON_COPY_TITLE = "投稿用コメントコピー"
DLG_MODSETTING_BUTTON_OK_NOT_DIR        = "mod設定ファイルのフォルダが見つかりません\r\nmod設定ファイルの場所を確認して下さい"
DLG_MODSETTING_BUTTON_OK_NOT_DIR_TITLE  = "mod設定ファイルのフォルダが見つかりません"
DLG_MODSETTING_BUTTON_OK_NOT_FILE       = "mod設定ファイルエラー\r\nmod設定ファイルを確認して下さい"
DLG_MODSETTING_BUTTON_OK_NOT_FILE_TITLE = "Mod setting filename error"
DLG_TIMESTAMP_MOVIE_NOT       = "動画ファイルが見つかりません"
DLG_TIMESTAMP_MOVIE_NOT_TITLE = "動画ファイルが見つかりません"
DLG_SETTING_BUTTON_OK_CREATE_NEW_FILE         = "新しいデータベースファイルを作成しますか？"
DLG_SETTING_BUTTON_OK_CREATE_NEW_FILE_TITLE   = "新規データベース作成確認"
DLG_SETTING_BUTTON_OK_DB_FILE_NOT             = "データベースファイルの設定がエラーです\r\n設定画面に戻りますか？"
DLG_SETTING_BUTTON_OK_DB_FILE_NOT_TITLE       = "データベースファイル設定エラー"
DLG_SETTING_BUTTON_OK_PREVIEW_TOOL_NOT        = "プレビューツールの設定がありません\r\n設定画面に戻りますか？"
DLG_SETTING_BUTTON_OK_PREVIEW_TOOL_NOT_TITLE  = "プレビューツール設定エラー"
DLG_SETTING_BUTTON_OK_PREVIEW_TEMP_NOT        = "プレビュー用一時動画ファイルの設定がエラーです\r\n設定画面に戻りますか？"
DLG_SETTING_BUTTON_OK_PREVIEW_TEMP_NOT_TITLE  = "プレビュー用一時動画ファイル設定エラー"
DLG_SETTING_BUTTON_OK_SUBTITLE_TEMP_NOT       = "スコア字幕用一時動画ファイルの設定がエラーです\r\n設定画面に戻りますか？"
DLG_SETTING_BUTTON_OK_SUBTITLE_TEMP_NOT_TITLE = "スコア字幕用一時動画ファイル設定エラー"
MAIN_MENU_OPEN_TITLE     = "動画ファイルを開く"
MOVIE_SEARCH_FOLDER_EDIT = "動画検索フォルダ"
FILE_SELECT_MES          = "選択"
FOLDER_SELECT_MES        = "選択"
NOTES_SCORE_FILE_SAVE_TITLE     = "ノーツスコア保存ファイル"
PLAY_MAP_LIST_FILE_SAVE_TITLE   = "プレイ譜面リスト保存ファイル"
PLAY_LIST_FILE_SAVE_TITLE       = "プレイリスト保存ファイル"
IMAGE_FILE_SELECT_TITLE         = "画像ファイル選択"
MODSETTING_FILE_SELECT_TITLE    = "mod設定ファイル 'movie_cut_record.json' 選択"
DATABASE_FILE_SELECT_TITLE      = "データベースファイル 'beatsaber.db' 選択"
MOVIE_FILE_SELECT_TITLE         = "動画ファイル選択"
SELECT_OPEN_MOVIE_FOLDER_TITLE  = "動画を開くフォルダ選択"
PREVIEW_TOOL_SELECT_TITLE       = "プレビューツール選択"
PREVIEW_TEMP_FILE_SELECT_TITLE  = "プレビュー用一時動画ファイル選択"
SUBTITLE_TEMP_FILE_SELECT_TITLE = "スコア字幕用一時動画ファイル選択"
STATUSBAR_INFO_ARTIST           = "Artist"
STATUSBAR_INFO_MODE             = "Mode"
STATUSBAR_INFO_NOTES            = "Notes"
STATUSBAR_INFO_BOMBS            = "爆弾"
STATUSBAR_INFO_OBSTACLES        = "壁"
