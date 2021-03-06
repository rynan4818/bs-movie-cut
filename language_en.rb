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

#Setting
BEATSABER_USERDATA_FOLDER = "[Default folder]"
SUBTITLE_ALIGNMENT_SETTING = [['1: Bottom left','2: Bottom center','3: Bottom right','5: Top left','6: Top center','7: Top right','9: Middle left',
                              '10: Middle center','11: Middle right'],[1,2,3,5,6,7,9,10,11]]

#Message
MOVIE_FILE_TIMESTAMP1_MAIN  = "Is this video an original file of play recording?\r\nDo you want to save the file timestamps in the database?"
MOVIE_FILE_TIMESTAMP1_TITLE = "Save time stamp in database"
MOVIE_FILE_TIMESTAMP2_MAIN  = "It is different from the time stamp recorded in the database.\r\nUse database timestamp?\r\n\r\n(This message can be hidden in the settings)"
MOVIE_FILE_TIMESTAMP2_TITLE = "Timestamp differs from database"
MOVIE_SUB_CREATE_SYNTAXERROR       = "Invalid subtitle format setting\r\nSyntax Error"
MOVIE_SUB_CREATE_SYNTAXERROR_TITLE = "Subtitle format SyntaxError"
MOVIE_SUB_CREATE_EXCEPTION         = "Invalid subtitle format setting"
MOVIE_SUB_CREATE_EXCEPTION_TITLE   = "Subtitle format ERROR"
STATUSBAR_FILE    = "file"
STATUSBAR_MAP     = "play"
STATUSBAR_SELECT  = "select"
SELECT_TO_BSR_NIL_MAIN  = "There is no song id"
SELECT_TO_BSR_NIL_TITLE = "No song ID"
SELECT_TO_BSR_ERR_MAIN  = "Not registered on beatsaver."
SELECT_TO_BSR_ERR_TITLE = "No bsr"
NEW_RELEASE_MES   = "New release ver "
NEW_VERSION_CHECK = "New version check...."
LATEST_MES        = "Current version is the latest."
MAIN_SELF_CREATED_DBFILE_CHECK1_MAIN  = "File not found\r\nOpen the setting screen, change the settings and select the file."
MAIN_SELF_CREATED_DBFILE_CHECK1_TITLE = "db File not found"
MAIN_SELF_CREATED_DBFILE_CHECK2_MAIN  = "'beatsaber.db' File not found\r\nOpen the setting screen, change the settings and select the file."
MAIN_SELF_CREATED_DBFILE_CHECK2_TITLE = "beatsaber.db File not found"
MAIN_BUTTON_RUN_FILE_NAME_SYNTAXERROR       = "Invalid file name setting\r\nSyntax Error"
MAIN_BUTTON_RUN_FILE_NAME_SYNTAXERROR_TITLE = "FILE NAME SyntaxError"
MAIN_BUTTON_RUN_FILE_NAME_EXCEPTION         = "Invalid file name setting"
MAIN_BUTTON_RUN_FILE_NAME_EXCEPTION_TITLE   = "FILE NAME ERROR"
MAIN_BUTTON_PREVIEW_TOOL_CHECK       = "File not found\r\nPlease set from option of menu."
MAIN_BUTTON_PREVIEW_TOOL_CHECK_TITLE = "Preview tool not found"
MAIN_BUTTON_PREVIEW_DIR_CHECK        = "Preview temporary folder not found\r\nPlease set from option of menu."
MAIN_BUTTON_PREVIEW_DIR_CHECK_TITLE  = "Preview temporary folder not found"
MAIN_BUTTON_PREVIEW_FILE_CHECK       = "Preview temporary file setting not found\r\nPlease set from option of menu."
MAIN_BUTTON_PREVIEW_FILE_CHECK_TITLE = "Preview temporary file setting not found"
MAIN_BUTTON_PREVIEW_ERROR            = "Preview error\r\nWScript.Shell Error"
MAIN_BUTTON_PREVIEW_ERROR_TITLE      = "Preview ERROR"
MAIN_BUTTON_SEARCH_SCORESABER_CHECK       = "I can't get rank information from ScoreSaber."
MAIN_BUTTON_SEARCH_SCORESABER_CHECK_TITLE = "Not gets ScoreSaber"
MAIN_MENU_VERSION_TITLE = "bs movie cut Version"
MAIN_MENU_SAVE       = "Current settings saved."
MAIN_MENU_SAVE_TITLE = "Settings saved."
MAIN_NOT_SELECT_MES       = "Select the map you played."
MAIN_NOT_SELECT_MES_TITLE = "Not selected"
MAIN_NOT_SELECT_MES2       = "Select the map you played.(Multiple selections are possible)"
MAIN_NOT_SELECT_MES2_TITLE = "Not selected"
MAIN_NOT_SELECT_MES3       = "Select multiple maps you have played"
MAIN_NOT_SELECT_MES3_TITLE = "Not selected"
MAIN_NOT_NOTES_SCORE_DB_MES       = "No notes score data available."
MAIN_NOT_NOTES_SCORE_DB_MES_TITLE = "Not notes score"
MAIN_MENU_COPY_BSR        = "Copying !bsr "
MAIN_MENU_COPY_BSR_TITLE  = "Copy bsr"
MAIN_WSH_ERR             = "WScript.Shell Error"
MAIN_WSH_ERR_TITLE       = "Web page open ERROR"
MAIN_MENU_PLAYLIST_OVERWRITE_CHECK       = "Do you want to overwrite?"
MAIN_MENU_PLAYLIST_OVERWRITE_CHECK_TITLE = "Overwrite confirmation"
FFMPEG_EDIT_TITLE     = "FFmpeg option settings"
FILENAME_EDIT_TITLE   = "Output filename settings"
OUT_FOLDER_EDIT_TITLE = "Output folder settings"
DB_OPEN_ERROR_MES     = "beatsaber DB File open error"
DB_OPEN_ERROR_TITLE   = "DB FILE OPEN ERROR"
DB_ERROR_MES          = "beatsaber DB error\r\n"
DB_ERROR_TITLE        = "DB ERROR"
DB_NOPLAY_RECORD       = "No play record in database"
DB_NOPLAY_RECORD_TITLE = "No play record"
DLG_POST_COMMENT_BUTTON_COPY       = "Copying Post comment"
DLG_POST_COMMENT_BUTTON_COPY_TITLE = "Copy comment"
DLG_MODSETTING_BUTTON_OK_NOT_DIR        = "Folder not found\r\nSet up the mod setting file."
DLG_MODSETTING_BUTTON_OK_NOT_DIR_TITLE  = "Mod setting folder not found"
DLG_MODSETTING_BUTTON_OK_NOT_FILE       = "filename error\r\nSet up the mod setting file."
DLG_MODSETTING_BUTTON_OK_NOT_FILE_TITLE = "Mod setting filename error"
DLG_TIMESTAMP_MOVIE_NOT       = "Movie file not found"
DLG_TIMESTAMP_MOVIE_NOT_TITLE = "Movie file not found"
DLG_SETTING_BUTTON_OK_CREATE_NEW_FILE         = "Create a new file?"
DLG_SETTING_BUTTON_OK_CREATE_NEW_FILE_TITLE   = "Create a new file?"
DLG_SETTING_BUTTON_OK_DB_FILE_NOT             = "Database file no setting.\r\nReturn the setting?"
DLG_SETTING_BUTTON_OK_DB_FILE_NOT_TITLE       = "Database file no setting"
DLG_SETTING_BUTTON_OK_PREVIEW_TOOL_NOT        = "Preview tool no setting.\r\nReturn the setting?"
DLG_SETTING_BUTTON_OK_PREVIEW_TOOL_NOT_TITLE  = "Preview tool no setting"
DLG_SETTING_BUTTON_OK_PREVIEW_TEMP_NOT        = "Preview temporary file no folder.\r\nReturn the setting?"
DLG_SETTING_BUTTON_OK_PREVIEW_TEMP_NOT_TITLE  = "Preview temporary file no folder"
DLG_SETTING_BUTTON_OK_SUBTITLE_TEMP_NOT       = "Score subtitle temporary file no folder.\r\nReturn the setting?"
DLG_SETTING_BUTTON_OK_SUBTITLE_TEMP_NOT_TITLE = "Score subtitle temporary file no folder"
MAIN_MENU_OPEN_TITLE     = "Movie file select"
MOVIE_SEARCH_FOLDER_EDIT = "Movie search folder"
FILE_SELECT_MES          = " select"
FOLDER_SELECT_MES        = " select"
NOTES_SCORE_FILE_SAVE_TITLE     = "Note Score File Save"
PLAY_MAP_LIST_FILE_SAVE_TITLE   = "Map List File Save"
PLAY_LIST_FILE_SAVE_TITLE       = "Playlist save file"
IMAGE_FILE_SELECT_TITLE         = "Image file select"
MODSETTING_FILE_SELECT_TITLE    = "mod setting file 'movie_cut_record.json' select"
DATABASE_FILE_SELECT_TITLE      = "Database file 'beatsaber.db' select"
MOVIE_FILE_SELECT_TITLE         = "Movie file select"
SELECT_OPEN_MOVIE_FOLDER_TITLE  = "select open movie folder"
PREVIEW_TOOL_SELECT_TITLE       = "Preview tool select"
PREVIEW_TEMP_FILE_SELECT_TITLE  = "Preview temporary file"
SUBTITLE_TEMP_FILE_SELECT_TITLE = "Subtitle temporary file"
STATUSBAR_INFO_ARTIST           = "Artist"
STATUSBAR_INFO_MODE             = "Mode"
STATUSBAR_INFO_NOTES            = "Notes"
STATUSBAR_INFO_BOMBS            = "Bombs"
STATUSBAR_INFO_OBSTACLES        = "Obstacles"
OUT_FOLDER_EDIT_NOTES           = "The 'time_name' variable must be placed somewhere to prevent file name collisions."
STAT_ACCURACY_NOT_MES           = "There's no record of the Notes information."
STAT_ACCURACY_NOT_MES_TITLE     = "No Notes Information"
STAT_ACCURACY_MODE_OUTPUT       = "Does the accuracy of the mode output for each placement?"
STAT_ACCURACY_MODE_OUTPUT_TITLE = "Checking the mode output"
MAX_VOLUME_CHECK_MES            = "(Audio normalization) Measuring maximum volume level... Please wait a moment."
