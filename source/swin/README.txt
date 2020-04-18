VisualuRuby (http://www.osk.3web.ne.jp/~nyasu/software/vrproject.html)
の拡張ライブラリ swin.so を一部改造しています。

openFilename 及び saveFilename の第7引数(デフォルトのファイル名)を渡せるようにしています。


■配布元
http://www.osk.3web.ne.jp/~nyasu/vruby/core.html
vrswin090207.lzh

改造内容
----swincdlg.c-----
91,95c91
< 	if(argc>6 && TYPE(argv[6])==T_STRING) {
< 		lstrcpy(buf,SWIN_API_STR_PTR(argv[6]));
< 	} else {
< 		*buf = 0;
< 	}
---
> 	*buf = 0;
120,124c116
< 	if(argc>6 && TYPE(argv[6])==T_STRING) {
< 		lstrcpy(buf,SWIN_API_STR_PTR(argv[6]));
< 	} else {
< 		*buf = 0;
< 	}
---
> 	*buf = 0;
--------------------