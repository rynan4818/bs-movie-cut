# bs-movie-cut (BeatSaberプレイ動画カットツール)
このツールは[OBS Studio](https://obsproject.com/ja)などで録画したBeatSaberのゲームプレイ動画を、下記画面の様にプレイした譜面に合わせて自動的に切り出しを行い、プレイ動画の編集や整理を支援する目的で作成しました。

拙作の[Beat Saber HTTP Status +Database](https://github.com/rynan4818/beatsaber-http-status-db)を使用してBeatSaberのプレイ情報をデータベースに記録し、その情報を元に録画した動画を譜面毎に切り分けることが可能です。

![image](https://rynan4818.github.io/bs_movie_cut_image.png)

なお、Beat Saber HTTP Status +Databaseの代わりに[MovieCutRecord](https://github.com/rynan4818/movie-cut-record)を使用したデータベースにも対応していますが、現在作者はMovieCutRecordを使用しておらず機能が劣るため、特に理由がなければ、Beat Saber HTTP Status +Databaseを使用して下さい。

# インストール方法

1. [Beat Saber HTTP Status +Database](https://github.com/rynan4818/beatsaber-http-status-db)のインストールを行って、一度BeatSaberを起動しデータベースを作成しておいて下さい。

2. [リリースページ](https://github.com/rynan4818/bs-movie-cut/releases)から最新のリリースをダウンロードします。または、Gitでクローンもしくは、`Code`から`Downlaod ZIP`しても構いません。
その場合、リリースしていない最新のコミット版が取得出来ます。

![imange](https://rynan4818.github.io/clone_or_download.png)

3. zipを適当なフォルダに解凍します。例：C:\TOOL\bs_movie_cut\
**※注意　フルパスに半角空白' 'が含まれない場所を推奨します。(字幕データの保存で問題が発生します)**\
**※注意　日本語以外のOSを使用している人は、[ASCIIコードの印字可能文字](https://ja.wikipedia.org/wiki/ASCII)のみで構成されているファイルパスに置いて下さい。**\
**※注意　Program Files や Program Files (x86) 以下のフォルダにインストールしないで下さい。**

4. bs_movie_cut.exe へのショートカットを作成してデスクトップに置くか、スタートメニューにピン留め等して起動できるようにして下さい。

# 使用方法

ツールの使用方法は[プレイ動画カットツールマニュアル](https://drive.google.com/open?id=1zyJ4o_rPToMF0anGCDlScW0-ZLSYKSyA6VPamWQS-h0)を参照して下さい。

# 開発者向け

本ツールはRuby ver1.8.7 で動作するように開発しています。

Rubyはスクリプト言語のため、本来はRuby本体のインストールが別途必要ですが、本ツールは加藤勇也氏が製作した[Exerb](http://exerb.osdn.jp/man/README.ja.html)を使用して、実行に必要な各種ライブラリと、実行ファイルと同名のrubyスクリプトファイルを読み込んで起動する[スクリプト](source/core_cui.rb)を、一つの実行ファイル `bs_movie_cut.exe` に変換しています。これにより、ユーザへの配布が容易になり、スクリプト修正時の実行ファイルへの変換作業が不要になるため、スクリプト言語としての開発しやすさを損なうことがないようにしています。

GUIライブラリはにゃす氏が製作した[VisualuRuby](http://www.osk.3web.ne.jp/~nyasu/software/vrproject.html)を使用して作成しています。Win32APIを直接利用しているため、Windowsと親和性が高く、使いやすいライブラリになっていますが、同時に本来OS依存の無いRubyがWindows OS限定の動作となっています。

通常の開発はExerbによるexe化作業は不要なため、特にRuby環境の構築をしなくてもスクリプトの修正やデバッグが可能です。

GUIフォーム画面の修正が必要な場合は、[FormDesigner](https://github.com/rynan4818/formdesigner/releases)を使用して `_frm_bs_movie_cut.rb` 及び `_frm_bs_movie_cut_jp.rb` を読み込むことで編集が可能です。こちらもexe化済みのため、Ruby無しで動作可能です。

別途ライブラリ等を実行ファイルに追加が必要な場合には、下記Ruby開発環境の構築が必要ですが環境を一通り構築するのは大変なため、取り計らいますのでご連絡下さい。

## なぜRuby 1.8.7なのか

なぜ[2013年に引退した1.8.7](https://www.ruby-lang.org/ja/news/2013/06/30/we-retire-1-8-7/)を使用するのか。
私は2002年頃からRubyを触りはじめましたが、Rubyの楽しんでプログラミングするポリシーが好きです。Rubyで出来ることならRubyで作りたいと思っています。また、ちょっと便利なツールを作って人に配布するのが好きです。そんな私にExerbとVisualuRubyと言う最強のタッグはベストマッチしました。
しかし、どちらも1.8.7でサポート終了しており、現在主流のRuby1.9系からの2.*系には対応していません。近い機能を有するものはありますが、デメリットが私にとって致命的なため、今でも1.8.7でExerbとVisualuRubyを使用しています。ただ、古いバージョンはセキュリティ面からも不特定なデータを開いて読むような用途には気をつける必要があります。今回のカットツールでも基本的には自分自身で記録したデータ(データベースや動画)しか触らないため、問題ないと判断しています。

一応、Exerbの後継に近い候補として [Neri](https://github.com/nodai2hITC/neri/blob/master/README.ja.md)が、VisualuRubyの後継として[wrb](https://bitbucket.org/wrb/wrb/src/default/)があり、興味がありますが、まだ試すところまで来ていません。

# ライセンスと著作権について

bs_movie_cut はプログラム本体と各種ライブラリから構成されています。

bs_movie_cutのソースコード及び各種ドキュメントについての著作権は作者であるリュナン(Twitter [@rynan4818](https://twitter.com/rynan4818))が有します。
また、これらのライセンスはMIT License が適用されます。

それ以外のbs_movie_cut.exe に内包しているrubyスクリプトやバイナリライブラリ、同梱のSQLite3のDLLやffmpegの実行ファイルは、それぞれの作者に著作権があります。配布ライセンスは、それぞれ異なるため詳細は下記の入手元を確認して下さい。

# 開発環境、各種ライブラリ入手先

各ツールの入手先、開発者・製作者（敬称略）、ライセンスは以下の通りです。

bs_movie_cut.exe に内包している具体的なライブラリファイルの詳細は [Exerbレシピファイル](source/core_cui.exy) を参照して下さい。

## Ruby本体入手先
- ActiveScriptRuby(1.8.7-p330)
- https://www.artonx.org/data/asr/
- 製作者:arton
- ライセンス：Ruby Licence

## GUIフォームビルダー入手先
- FormDesigner for Project VisualuRuby Ver 060501
- https://ja.osdn.net/projects/fdvr/
- Subversion リポジトリ r71(r65以降)の/formdesigner/trunk を使用
- 開発者:雪見酒
- ライセンス：Ruby Licence

## アイコン素材
- ICONION
- http://iconion.com/ja/

## 使用拡張ライブラリ、ソースコード

### Ruby本体 1.8.7-p330              #開発はActiveScriptRuby(1.8.7-p330)を使用
- https://www.ruby-lang.org/ja/
- 開発者:まつもとゆきひろ
- ライセンス：Ruby Licence

### Exerb                            #開発はActiveScriptRuby(1.8.7-p330)同封版を使用
- http://exerb.osdn.jp/man/README.ja.html
- 開発者:加藤勇也
- ライセンス：LGPL

### gem                              #開発はActiveScriptRuby(1.8.7-p330)同封版を使用
- https://rubygems.org/
- ライセンス：Ruby Licence

### VisualuRuby                      #開発はActiveScriptRuby(1.8.7-p330)同封版を使用 ※swin.soを改造
- http://www.osk.3web.ne.jp/~nyasu/software/vrproject.html
- 開発者:にゃす
- ライセンス：Ruby Licence

### gemライブラリ

#### json-1.4.6-x86-mswin32
- https://rubygems.org/gems/json/versions/1.4.6
- https://rubygems.org/gems/json/versions/1.4.6-x86-mswin32
- 開発者:Florian Frank
- ライセンス：Ruby Licence

#### sqlite3-1.3.3-x86-mswin32-60
- https://rubygems.org/gems/sqlite3/versions/1.3.3
- https://rubygems.org/gems/sqlite3/versions/1.3.3-x86-mswin32-60
- Copyright（c）2004、Jamis Buck（jamis@jamisbuck.org）
- ライセンス：https://github.com/sparklemotion/sqlite3-ruby/blob/master/LICENSE

### DLL

#### libiconv 1.11  (iconv.dll)       #Exerbでbs_movie_cut.exeに内包
- https://www.gnu.org/software/libiconv/
- Copyright (C) 1998, 2019 Free Software Foundation, Inc.
- ライセンス：LGPL

#### SQLite3  (sqlite3.dll)           #Exerbでbs_movie_cut.exeに内包
- https://www.sqlite.org/index.html
- 開発元:D. Richard Hipp
- ライセンス：パブリックドメイン

### 実行ファイル

#### FFmpeg 4.3 win64 Static
- https://ffmpeg.zeranoe.com/builds/
- 製作者:Zeranoe
- ライセンス：GPL3.0

#### curl 7.71.1 for Windows 32bit
- https://curl.haxx.se/windows/
- 製作者:Copyright (c) 1996 - 2020, Daniel Stenberg, daniel@haxx.se, and many contributors, see the THANKS file.
- ライセンス:[The curl license](https://curl.haxx.se/docs/copyright.html)

### その他

#### Highcharts,Highstock
- https://www.highcharts.com/
- © 2020 Highcharts. All rights reserved.
- ライセンス:非商用ライセンス
- 統計情報出力時のグラフ表示に使用、Highcharts及びHighstockのjavascriptコードはCDNで利用
- Highsoftソフトウェア製品は商用では無料ではありません
