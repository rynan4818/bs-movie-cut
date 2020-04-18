/*
###################################
#
# swincdlg.c
# Programmed by nyasu <nyasu@osk.3web.ne.jp>
# Copyright 1999-2005  Nishikawa,Yasuhiro
#
# More information at http://vruby.sourceforge.net/index.html
#
###################################
*/


#include "swin.h"
#include <shlobj.h>

VALUE mSwinComDlg;

static long rgbs[16]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

static unsigned buffersize=8192;

BOOL setopenfilename(OPENFILENAME *pofn,int argc, VALUE* argv,long defmode){  
                                    /* except lpstrFilename and its size*/
	VALUE filter;
	struct Swin *sw;

	if(argc<1){
		rb_raise(rb_eArgError,"no arguments");
		return FALSE;
	}

	memset(pofn, 0, sizeof(OPENFILENAME));   /* Set NULLs of all */
	pofn->lStructSize=sizeof(OPENFILENAME);
	
	if(rb_obj_is_kind_of(argv[0],cSwin)){
		Data_Get_Struct(argv[0], struct Swin, sw);
		pofn->hwndOwner=sw->hWnd;
	} else {
		if(argv[0]!=Qnil){
			rb_raise(rb_eTypeError,"arg0(parent) must be SWin::Window or nil");
			return FALSE;
		}
		pofn->hwndOwner = NULL;
	}


	if(argc>1)if(!rb_obj_is_kind_of(argv[1],rb_cArray)){
		rb_raise(rb_eTypeError,"arg1(filter str) must be Array of String");
		return FALSE;
	}

	pofn->lpstrFilter= TEXT("all(*.*)\0*.*\0\0");  /* default value */
	if(argc>1 && argv[1]!=Qnil){
		filter=rb_ary_join(argv[1],rb_str_new(onebytezero,1));
		filter=rb_str_cat(filter,onebytezero,1);
		pofn->lpstrFilter=SWIN_API_STR_PTR(filter);
	}

	pofn->Flags      = (argc>2 && argv[2]!=Qnil)? NUM2UINT(argv[2]) : defmode;
	pofn->lpstrTitle = (argc>3 && TYPE(argv[3])==T_STRING)? 
	                                   SWIN_API_STR_PTR(argv[3]) : NULL;
	pofn->lpstrDefExt= (argc>4 && TYPE(argv[4])==T_STRING)?
	                                   SWIN_API_STR_PTR(argv[4]) : NULL;
	pofn->lpstrInitialDir= (argc>5 && TYPE(argv[5])==T_STRING)?
	                                   SWIN_API_STR_PTR(argv[5]) : NULL;
	return TRUE;
}

static VALUE
swincdlg_bufsize(VALUE mod){
	return UINT2NUM(buffersize);
}

static VALUE
swincdlg_setbufsize(VALUE mod, VALUE bsize){
	unsigned size;
	size = NUM2UINT(bsize);
	if(size<128) {
		rb_raise(rb_eArgError,"buffer size(%d) is too small,",size);
	}
	buffersize = size;
	return bsize;
}

static VALUE 
swincdlg_OpenFileName(int argc, VALUE* argv, VALUE mod){
	OPENFILENAME ofn;
	int r, mask;
	TCHAR* buf = alloca(buffersize*sizeof(TCHAR));
	if(argc>6 && TYPE(argv[6])==T_STRING) {
		lstrcpy(buf,SWIN_API_STR_PTR(argv[6]));
	} else {
		*buf = 0;
	}

	if(!setopenfilename(&ofn,argc,argv,OFN_FILEMUSTEXIST)) return Qfalse;
	ofn.nMaxFile=buffersize;
	ofn.lpstrFile=buf;

	if(!GetOpenFileName(&ofn)){
		if(!(r=CommDlgExtendedError())) return Qnil;
		rb_raise(rb_eRuntimeError,"CommonDialog Failure code=%d",r);
		return Qfalse;
	} 
	
    mask = OFN_EXPLORER | OFN_ALLOWMULTISELECT;
	if((ofn.Flags & mask) == mask) {
	    int len=0;
        while(!(buf[len]==0 && buf[len+1]==0) && len<buffersize-1){ len++; }
	    return SWIN_OUTAPI_STR_NEW(buf,len);
	}
    return SWIN_OUTAPI_STR_NEW2(buf);
}
static VALUE 
swincdlg_SaveFileName(int argc, VALUE* argv, VALUE mod){
	OPENFILENAME ofn;
	int r;
	TCHAR* buf = alloca(buffersize*sizeof(TCHAR));
	if(argc>6 && TYPE(argv[6])==T_STRING) {
		lstrcpy(buf,SWIN_API_STR_PTR(argv[6]));
	} else {
		*buf = 0;
	}

	if(!setopenfilename(&ofn,argc,argv,OFN_CREATEPROMPT | OFN_OVERWRITEPROMPT))
		return Qfalse;

	ofn.nMaxFile=buffersize;
	ofn.lpstrFile=buf;

	if(!GetSaveFileName(&ofn)){
		if(!(r=CommDlgExtendedError())) return Qnil;
		rb_raise(rb_eRuntimeError,"CommonDialog Failure code=%d",r);
		return Qfalse;
	} 
	
	return SWIN_OUTAPI_STR_NEW2(buf);
}

static VALUE
swincdlg_choosecolor(int argc, VALUE* argv, VALUE mod){
	CHOOSECOLOR cc;
	int r;
	struct Swin *sw;

	if(argc<1){
		rb_raise(rb_eArgError,"no arguments");
		return Qfalse;
	}

	memset(&cc, 0, sizeof(CHOOSECOLOR));   /* Set NULLs of all */
	cc.lStructSize=sizeof(CHOOSECOLOR);
	
	if(rb_obj_is_kind_of(argv[0],cSwin)){
		Data_Get_Struct(argv[0], struct Swin, sw);
		cc.hwndOwner=sw->hWnd;
	} else {
		if(argv[0]!=Qnil){
			rb_raise(rb_eTypeError,"arg0(parent) must be SWin::Window or nil");
			return FALSE;
		}
		cc.hwndOwner = NULL;
	}

	cc.Flags    = (argc>1 && argv[1]!=Qnil)? NUM2UINT(argv[1]) : 0;
	cc.lpCustColors=rgbs;

	if(!ChooseColor(&cc)){
		if(!(r=CommDlgExtendedError())) return Qnil;
		rb_raise(rb_eRuntimeError,"CommonDialog Failure code=%d",r);
		return Qfalse;
	} 

	return UINT2NUM(cc.rgbResult);
}

static VALUE
swincdlg_ChooseFont(int argc,VALUE* argv,VALUE mod){
	CHOOSEFONT cf;
	int r;
	LOGFONT lf;
	struct Swin *sw;
	VALUE robj,font;
	VALUE spec,fontface;
	int style;
  int ff_len;

	if(argc<1){
		rb_raise(rb_eArgError,"no arguments");
		return Qfalse;
	}

	memset(&cf, 0, sizeof(CHOOSEFONT)); 
	cf.lStructSize=sizeof(CHOOSEFONT);

	if(rb_obj_is_kind_of(argv[0],cSwin)){
		Data_Get_Struct(argv[0], struct Swin, sw);
		cf.hwndOwner=sw->hWnd;
	} else {
		if(argv[0]!=Qnil){
			rb_raise(rb_eTypeError,"arg0(parent) must be SWin::Window or nil");
			return FALSE;
		}
		cf.hwndOwner = NULL;
	}

	cf.lpLogFont=&lf;
	cf.Flags = CF_APPLY | CF_SCREENFONTS | CF_EFFECTS;
	cf.nFontType = SCREEN_FONTTYPE;

	if(argc>1){
		if(TYPE(argv[1])!=T_ARRAY || RARRAY_LEN(argv[1])<3){
			rb_raise(rb_eArgError,"font spec fault");
			return Qnil;
		}
		spec = rb_ary_entry(argv[1],0);
		if(TYPE(spec)!=T_ARRAY || RARRAY_LEN(spec)<9){
			rb_raise(rb_eArgError,"font spec fault");
			return Qnil;
		}

		cf.Flags |= CF_INITTOLOGFONTSTRUCT;
        fontface = rb_ary_entry(spec,0);
		fontface = SWIN_API_STR(fontface);
        ff_len = StringValueLen(fontface);
		memcpy(lf.lfFaceName, 
                StringValuePtr(fontface),
                (ff_len<LF_FACESIZE)? ff_len : LF_FACESIZE);
		style = NUM2UINT(rb_ary_entry(spec,2));
		lf.lfHeight     = NUM2INT(rb_ary_entry(spec,1));
		lf.lfItalic     = (style & SWINFONT_ITALIC)? 1 : 0;
		lf.lfUnderline  = (style & SWINFONT_ULINE)? 1 : 0;
		lf.lfStrikeOut  = (style & SWINFONT_STRIKE)? 1 : 0;
		lf.lfWeight     = NUM2INT(rb_ary_entry(spec,3));
		lf.lfWidth      = NUM2INT(rb_ary_entry(spec,4));
		lf.lfEscapement = NUM2INT(rb_ary_entry(spec,5));
		lf.lfOrientation= NUM2INT(rb_ary_entry(spec,6));
		lf.lfPitchAndFamily = NUM2INT(rb_ary_entry(spec,7));
		lf.lfCharSet    = NUM2INT(rb_ary_entry(spec,8));

		cf.iPointSize = NUM2INT(rb_ary_entry(argv[1],1))/10;
		cf.rgbColors  = NUM2INT(rb_ary_entry(argv[1],2));
	}

	if(!ChooseFont(&cf)){
		if(!(r=CommDlgExtendedError())) return Qnil;
		rb_raise(rb_eRuntimeError,"CommonDialog Failure code=%d",r);
		return Qfalse;
	} 

	style = (lf.lfItalic?    SWINFONT_ITALIC:0) |
	        (lf.lfUnderline? SWINFONT_ULINE:0)  |
	        (lf.lfStrikeOut? SWINFONT_STRIKE:0) ;

	robj = rb_ary_new();
	font = rb_ary_new();
	rb_ary_push(font,SWIN_OUTAPI_STR_NEW2(lf.lfFaceName));
	rb_ary_push(font,INT2NUM(lf.lfHeight));
	rb_ary_push(font,INT2NUM(style));
	rb_ary_push(font,INT2NUM(lf.lfWeight));
	rb_ary_push(font,INT2NUM(lf.lfWidth));
	rb_ary_push(font,INT2NUM(lf.lfEscapement));
	rb_ary_push(font,INT2NUM(lf.lfOrientation));
	rb_ary_push(font,INT2NUM(lf.lfPitchAndFamily));
	rb_ary_push(font,INT2NUM(lf.lfCharSet));

	rb_ary_push(robj,font);
	rb_ary_push(robj,INT2NUM(cf.iPointSize));
	rb_ary_push(robj,UINT2NUM(cf.rgbColors));
	return robj;
}

static VALUE
swincdlg_pagesetup(int argc,VALUE* argv,VALUE mod){
	struct Swin* sw;
	int r;
	VALUE robj;
	DEVMODE* pdevmode;
	PAGESETUPDLG pset;
	
	if(argc<1){
		rb_raise(rb_eArgError,"no arguments");
		return Qfalse;
	}

	memset(&pset,0,sizeof(PAGESETUPDLG));
	pset.lStructSize = sizeof(PAGESETUPDLG);

	if(rb_obj_is_kind_of(argv[0],cSwin)){
		Data_Get_Struct(argv[0], struct Swin, sw);
		pset.hwndOwner=sw->hWnd;
	} else {
		if(argv[0]!=Qnil){
			rb_raise(rb_eTypeError,"arg0(parent) must be SWin::Window or nil");
			return FALSE;
		}
		pset.hwndOwner = NULL;
	}

	r=PageSetupDlg(&pset);
	if(r==0) return Qnil;

	robj = rb_ary_new2(8);
	pdevmode = (DEVMODE*)GlobalLock(pset.hDevMode);
	rb_ary_push(robj,SWIN_OUTAPI_STR_NEW2(pdevmode->dmDeviceName));
	rb_ary_push(robj,rb_str_new((char*)pdevmode,sizeof(DEVMODE)));
	rb_ary_push(robj,INT2NUM(pdevmode->dmPaperSize));
	rb_ary_push(robj,INT2NUM(pdevmode->dmOrientation));
	rb_ary_push(robj,INT2NUM(pdevmode->dmScale));
	rb_ary_push(robj,INT2NUM(pdevmode->dmCopies));
	if(pdevmode->dmColor==DMCOLOR_COLOR){
		rb_ary_push(robj,Qtrue);
	} else {
		rb_ary_push(robj,Qfalse);
	}
	
	GlobalUnlock(pset.hDevMode);

	return robj;
}


static VALUE
swincdlg_printerDlg(int argc,VALUE* argv,VALUE mod){
	struct Swin* sw;
	PRINTDLG pdlg;
	DEVMODE* pdevmode;
	BOOL r;
	VALUE robj;

	if(argc<1){
		rb_raise(rb_eArgError,"no arguments");
		return Qfalse;
	}
	if(rb_obj_is_kind_of(argv[0],cSwin)){
		Data_Get_Struct(argv[0], struct Swin, sw);
		pdlg.hwndOwner=sw->hWnd;
	} else {
		if(argv[0]!=Qnil){
			rb_raise(rb_eTypeError,"arg0(parent) must be SWin::Window or nil");
			return FALSE;
		}
		pdlg.hwndOwner = NULL;
	}

	memset(&pdlg,0,sizeof(PRINTDLG)); 
	pdlg.lStructSize = sizeof(PRINTDLG);

	if(argc>1) 0; /* reserved */
	if(argc>2) pdlg.nMinPage = NUM2INT(argv[2]);
	if(argc>3) pdlg.nMaxPage = NUM2INT(argv[3]);
	if(argc>4) pdlg.nFromPage= NUM2INT(argv[4]);
	if(argc>5) pdlg.nToPage  = NUM2INT(argv[5]);

	r = PrintDlg(&pdlg);

	if(r==0) return Qnil;
	robj = rb_ary_new2(6);
	pdevmode = (DEVMODE*)GlobalLock(pdlg.hDevMode);
	rb_ary_push(robj,SWIN_OUTAPI_STR_NEW2(pdevmode->dmDeviceName));
	GlobalUnlock(pdlg.hDevMode);
	rb_ary_push(robj,INT2NUM(pdlg.Flags));
	rb_ary_push(robj,INT2NUM(pdlg.nFromPage));
	rb_ary_push(robj,INT2NUM(pdlg.nToPage));
	return robj;
}

int CALLBACK BrowseForFolderCallbackProc(HWND hwnd,UINT uMsg,LPARAM lParam,LPARAM lpData){
	if(uMsg==BFFM_INITIALIZED){
		SendMessage(hwnd,BFFM_SETSELECTION,(WPARAM)TRUE,lpData);
	}
	return 0;
}

static VALUE
swincdlg_browseforfolder(int argc,VALUE* argv,VALUE mod){
	struct Swin* sw;
	TCHAR* title;
	TCHAR* initdir;
	int flag;
	TCHAR buffer[MAX_PATH];
	TCHAR pathbuffer[MYMAXPATH*2];

	BROWSEINFO binfo;
	LPITEMIDLIST idlist;
	
	if(argc<1){
		rb_raise(rb_eArgError,"no arguments");
		return Qfalse;
	}
	if(rb_obj_is_kind_of(argv[0],cSwin)){
		Data_Get_Struct(argv[0], struct Swin, sw);
		binfo.hwndOwner=sw->hWnd;
	} else {
		if(argv[0]!=Qnil){
			rb_raise(rb_eTypeError,"arg0(parent) must be SWin::Window or nil");
			return FALSE;
		}
		binfo.hwndOwner = NULL;
	}

	title = (argc>1 && argv[1]!=Qnil)? SWIN_API_STR_PTR(argv[1]) : TEXT("Select directory");
	flag  = (argc>3)? NUM2UINT(argv[3]) : BIF_RETURNONLYFSDIRS;
	if(argc>2 && argv[2]!=Qnil){
		path_conv_to_win(SWIN_API_STR_PTR(argv[2]),pathbuffer);
		initdir=pathbuffer;
	} else {
		initdir = NULL;
	}

	binfo.pidlRoot=NULL;
	binfo.pszDisplayName=buffer;
	binfo.lpszTitle=title;
	binfo.ulFlags=flag;
	binfo.lpfn = (initdir)? &BrowseForFolderCallbackProc : NULL;
	binfo.lParam=(LPARAM)initdir;
	binfo.iImage=0;
  idlist = SHBrowseForFolder(&binfo);
	if(idlist==NULL){
		return Qnil;
	}
	SHGetPathFromIDList(idlist,buffer); 
	CoTaskMemFree(idlist);
	return 	SWIN_OUTAPI_STR_NEW2(buffer);
}

static VALUE
swincdlg_extError(VALUE mod){
	return INT2NUM(CommDlgExtendedError());
}

void Init_CDlg(){
	mSwinComDlg = rb_define_module_under(mSwin,"CommonDialog");

	rb_define_singleton_method(mSwinComDlg,
                             "openFilename",swincdlg_OpenFileName,-1);
	rb_define_singleton_method(mSwinComDlg,
                             "saveFilename",swincdlg_SaveFileName,-1);

	rb_define_singleton_method(mSwinComDlg,
                             "chooseColor",swincdlg_choosecolor,-1);
	rb_define_singleton_method(mSwinComDlg,
                             "chooseFont",swincdlg_ChooseFont,-1);
	rb_define_singleton_method(mSwinComDlg,
                             "setPrinter",swincdlg_printerDlg,-1);
	rb_define_singleton_method(mSwinComDlg,
                             "pageSetup",swincdlg_pagesetup,-1);
	rb_define_singleton_method(mSwinComDlg,
                             "selectDirectory",swincdlg_browseforfolder,-1);

	rb_define_singleton_method(mSwinComDlg,"buffer_size",swincdlg_bufsize,0);
	rb_define_singleton_method(mSwinComDlg,"buffer_size=",
	                          swincdlg_setbufsize,1);

	rb_define_singleton_method(mSwinComDlg,"extError",swincdlg_extError,0);
}

