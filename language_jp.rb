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
BEATSABER_USERDATA_FOLDER = "[BeatSaber UserData �t�H���_]"
SUBTITLE_ALIGNMENT_SETTING = [['1: ����','2: ������','3: �E��','5: �㍶','6: �㒆��','7: ��E','9: ������',
                              '10: ����','11: �����E'],[1,2,3,5,6,7,9,10,11]]

#Message
MOVIE_FILE_TIMESTAMP1_MAIN  = "���̓���͖��ړ��E���R�s�[�̃I���W�i���̘^��t�@�C���ł���?\r\n�t�@�C���̃^�C���X�^���v���f�[�^�x�[�X�ɕۑ����܂����H"
MOVIE_FILE_TIMESTAMP1_TITLE = "�f�[�^�x�[�X�Ƀ^�C���X�^���v��ۑ�"
MOVIE_FILE_TIMESTAMP2_MAIN  = "�f�[�^�x�[�X�ɋL�^����Ă���^�C���X�^���v�Ƃ͈قȂ�܂��B\r\n�f�[�^�x�[�X�̃^�C���X�^���v���g�p���܂����H\r\n\r\n(���̃��b�Z�[�W�͐ݒ�Ŕ�\���ɂ��邱�Ƃ��ł��܂�)"
MOVIE_FILE_TIMESTAMP2_TITLE = "�^�C���X�^���v���f�[�^�x�[�X�ƈقȂ�܂�"
MOVIE_SUB_CREATE_SYNTAXERROR       = "�����Ȏ����t�H�[�}�b�g�̐ݒ�ł�\r\nSyntax Error"
MOVIE_SUB_CREATE_SYNTAXERROR_TITLE = "�����t�H�[�}�b�gSyntaxError"
MOVIE_SUB_CREATE_EXCEPTION         = "�����Ȏ����t�H�[�}�b�g�̐ݒ�ł�"
MOVIE_SUB_CREATE_EXCEPTION_TITLE   = "�����t�H�[�}�b�g�G���["
STATUSBAR_FILE   = "̧��"
STATUSBAR_MAP    = "��ڲ"
STATUSBAR_SELECT = "�I��"
SELECT_TO_BSR_NIL_MAIN  = "There is no song id"
SELECT_TO_BSR_NIL_TITLE = "No song ID"
SELECT_TO_BSR_ERR_MAIN  = "Not registered on beatsaver."
SELECT_TO_BSR_ERR_TITLE = "No bsr"
NEW_RELEASE_MES   = "�ŐV�ł�����܂� "
NEW_VERSION_CHECK = "�ŐV�ł��`�F�b�N���Ă��܂�...."
LATEST_MES        = "���݂̃o�[�W�������ŐV�ł�"
MAIN_SELF_CREATED_DBFILE_CHECK1_MAIN  = "�t�@�C����������܂���\r\n�ݒ��ʂ��J���܂��̂ŁA�f�[�^�x�[�X�t�@�C����I�����ĉ������B"
MAIN_SELF_CREATED_DBFILE_CHECK1_TITLE = "�f�[�^�x�[�X�t�@�C����������܂���"
MAIN_SELF_CREATED_DBFILE_CHECK2_MAIN  = "'beatsaber.db' �t�@�C����������܂���\r\n�ݒ��ʂ��J���܂��̂ŁA�f�[�^�x�[�X�t�@�C����I�����ĉ������B"
MAIN_SELF_CREATED_DBFILE_CHECK2_TITLE = "beatsaber.db �t�@�C����������܂���"
MAIN_BUTTON_RUN_FILE_NAME_SYNTAXERROR       = "�����ȃt�@�C�����ݒ�ł�\r\nSyntax Error"
MAIN_BUTTON_RUN_FILE_NAME_SYNTAXERROR_TITLE = "�t�@�C���� SyntaxError"
MAIN_BUTTON_RUN_FILE_NAME_EXCEPTION         = "�����ȃt�@�C�����ݒ�ł�"
MAIN_BUTTON_RUN_FILE_NAME_EXCEPTION_TITLE   = "�t�@�C���� ERROR"
MAIN_BUTTON_PREVIEW_TOOL_CHECK       = "�t�@�C����������܂���\r\n���j���[�̃I�v�V��������v���r���[�p�c�[����ݒ肵�ĉ������B"
MAIN_BUTTON_PREVIEW_TOOL_CHECK_TITLE = "�v���r���[�c�[����������܂���"
MAIN_BUTTON_PREVIEW_DIR_CHECK        = "�v���r���[�p����ۑ��t�H���_������܂���\r\n���j���[�̃I�v�V��������v���r���[�p�ꎞ����t�@�C����ݒ肵�ĉ������B"
MAIN_BUTTON_PREVIEW_DIR_CHECK_TITLE  = "�v���r���[�p����ۑ��t�H���_������܂���"
MAIN_BUTTON_PREVIEW_FILE_CHECK       = "�v���r���[�p�ꎞ����t�@�C���̐ݒ肪����܂���\r\n���j���[�̃I�v�V��������ݒ肵�ĉ������B"
MAIN_BUTTON_PREVIEW_FILE_CHECK_TITLE = "�v���r���[�p�ꎞ����t�@�C���̐ݒ肪����܂���"
MAIN_BUTTON_PREVIEW_ERROR            = "�v���r���[�ɑz��O�̃G���[���������܂���\r\nWScript.Shell Error"
MAIN_BUTTON_PREVIEW_ERROR_TITLE      = "�v���r���[�G���["
MAIN_BUTTON_SEARCH_SCORESABER_CHECK       = "ScoreSaber���烉���N��񂪎擾�ł��܂���"
MAIN_BUTTON_SEARCH_SCORESABER_CHECK_TITLE = "ScoreSaber���烉���N���擾�o���܂���"
MAIN_MENU_VERSION_TITLE = "BeatSaber �v���C����J�b�g�c�[�� �o�[�W�������"
MAIN_MENU_SAVE       = "���݂̐ݒ��ۑ����܂���"
MAIN_MENU_SAVE_TITLE = "�ݒ�ۑ�����"
MAIN_NOT_SELECT_MES        = "�v���C�������ʂ�I�����ĉ�����"
MAIN_NOT_SELECT_MES_TITLE  = "�v���C���ʂ����I���ł�"
MAIN_NOT_SELECT_MES2       = "�v���C�������ʂ�I��(������)���ĉ�����"
MAIN_NOT_SELECT_MES2_TITLE = "�v���C���ʂ����I���ł�"
MAIN_NOT_SELECT_MES3       = "�v���C�������ʂ𕡐��I�����ĉ�����"
MAIN_NOT_SELECT_MES3_TITLE = "�v���C���ʂ����I���ł�"
MAIN_NOT_NOTES_SCORE_DB_MES       = "�m�[�c�X�R�A��񂪃f�[�^�x�[�X�ɋL�^����Ă��܂���"
MAIN_NOT_NOTES_SCORE_DB_MES_TITLE = "�m�[�c�X�R�A������܂���"
MAIN_MENU_COPY_BSR       = "�R�s�[���܂��� !bsr "
MAIN_MENU_COPY_BSR_TITLE = "�R�s�[���܂���"
MAIN_WSH_ERR             = "WScript Shell�ŃG���[���������܂���"
MAIN_WSH_ERR_TITLE       = "�E�F�u�y�[�W���J�����ɃG���[������"
MAIN_MENU_PLAYLIST_OVERWRITE_CHECK       = "�㏑���ۑ����܂����H"
MAIN_MENU_PLAYLIST_OVERWRITE_CHECK_TITLE = "�㏑���ۑ��m�F"
FFMPEG_EDIT_TITLE     = "FFmpeg�I�v�V�����ݒ�"
FILENAME_EDIT_TITLE   = "�o�̓t�@�C�����ݒ�"
OUT_FOLDER_EDIT_TITLE = "�o�̓t�H���_�ݒ�"
DB_OPEN_ERROR_MES     = "�f�[�^�x�[�X���G���[�ŊJ���܂���"
DB_OPEN_ERROR_TITLE   = "�f�[�^�x�[�X�I�[�v���G���["
DB_ERROR_MES          = "�f�[�^�x�[�X���G���[�ł�\r\n"
DB_ERROR_TITLE        = "�f�[�^�x�[�X�G���["
DB_NOPLAY_RECORD       = "�v���C�L�^���f�[�^�x�[�X�ɂ���܂���"
DB_NOPLAY_RECORD_TITLE = "�v���C�L�^�Ȃ�"
DLG_POST_COMMENT_BUTTON_COPY       = "���e�p�R�����g���R�s�[���܂���"
DLG_POST_COMMENT_BUTTON_COPY_TITLE = "���e�p�R�����g�R�s�["
DLG_MODSETTING_BUTTON_OK_NOT_DIR        = "mod�ݒ�t�@�C���̃t�H���_��������܂���\r\nmod�ݒ�t�@�C���̏ꏊ���m�F���ĉ�����"
DLG_MODSETTING_BUTTON_OK_NOT_DIR_TITLE  = "mod�ݒ�t�@�C���̃t�H���_��������܂���"
DLG_MODSETTING_BUTTON_OK_NOT_FILE       = "mod�ݒ�t�@�C���G���[\r\nmod�ݒ�t�@�C�����m�F���ĉ�����"
DLG_MODSETTING_BUTTON_OK_NOT_FILE_TITLE = "Mod setting filename error"
DLG_TIMESTAMP_MOVIE_NOT       = "����t�@�C����������܂���"
DLG_TIMESTAMP_MOVIE_NOT_TITLE = "����t�@�C����������܂���"
DLG_SETTING_BUTTON_OK_CREATE_NEW_FILE         = "�V�����f�[�^�x�[�X�t�@�C�����쐬���܂����H"
DLG_SETTING_BUTTON_OK_CREATE_NEW_FILE_TITLE   = "�V�K�f�[�^�x�[�X�쐬�m�F"
DLG_SETTING_BUTTON_OK_DB_FILE_NOT             = "�f�[�^�x�[�X�t�@�C���̐ݒ肪�G���[�ł�\r\n�ݒ��ʂɖ߂�܂����H"
DLG_SETTING_BUTTON_OK_DB_FILE_NOT_TITLE       = "�f�[�^�x�[�X�t�@�C���ݒ�G���["
DLG_SETTING_BUTTON_OK_PREVIEW_TOOL_NOT        = "�v���r���[�c�[���̐ݒ肪����܂���\r\n�ݒ��ʂɖ߂�܂����H"
DLG_SETTING_BUTTON_OK_PREVIEW_TOOL_NOT_TITLE  = "�v���r���[�c�[���ݒ�G���["
DLG_SETTING_BUTTON_OK_PREVIEW_TEMP_NOT        = "�v���r���[�p�ꎞ����t�@�C���̐ݒ肪�G���[�ł�\r\n�ݒ��ʂɖ߂�܂����H"
DLG_SETTING_BUTTON_OK_PREVIEW_TEMP_NOT_TITLE  = "�v���r���[�p�ꎞ����t�@�C���ݒ�G���["
DLG_SETTING_BUTTON_OK_SUBTITLE_TEMP_NOT       = "�X�R�A�����p�ꎞ����t�@�C���̐ݒ肪�G���[�ł�\r\n�ݒ��ʂɖ߂�܂����H"
DLG_SETTING_BUTTON_OK_SUBTITLE_TEMP_NOT_TITLE = "�X�R�A�����p�ꎞ����t�@�C���ݒ�G���["
MAIN_MENU_OPEN_TITLE     = "����t�@�C�����J��"
MOVIE_SEARCH_FOLDER_EDIT = "���挟���t�H���_"
FILE_SELECT_MES          = "�I��"
FOLDER_SELECT_MES        = "�I��"
NOTES_SCORE_FILE_SAVE_TITLE     = "�m�[�c�X�R�A�ۑ��t�@�C��"
PLAY_MAP_LIST_FILE_SAVE_TITLE   = "�v���C���ʃ��X�g�ۑ��t�@�C��"
PLAY_LIST_FILE_SAVE_TITLE       = "�v���C���X�g�ۑ��t�@�C��"
IMAGE_FILE_SELECT_TITLE         = "�摜�t�@�C���I��"
MODSETTING_FILE_SELECT_TITLE    = "mod�ݒ�t�@�C�� 'movie_cut_record.json' �I��"
DATABASE_FILE_SELECT_TITLE      = "�f�[�^�x�[�X�t�@�C�� 'beatsaber.db' �I��"
MOVIE_FILE_SELECT_TITLE         = "����t�@�C���I��"
SELECT_OPEN_MOVIE_FOLDER_TITLE  = "������J���t�H���_�I��"
PREVIEW_TOOL_SELECT_TITLE       = "�v���r���[�c�[���I��"
PREVIEW_TEMP_FILE_SELECT_TITLE  = "�v���r���[�p�ꎞ����t�@�C���I��"
SUBTITLE_TEMP_FILE_SELECT_TITLE = "�X�R�A�����p�ꎞ����t�@�C���I��"
STATUSBAR_INFO_ARTIST           = "Artist"
STATUSBAR_INFO_MODE             = "Mode"
STATUSBAR_INFO_NOTES            = "Notes"
STATUSBAR_INFO_BOMBS            = "���e"
STATUSBAR_INFO_OBSTACLES        = "��"
