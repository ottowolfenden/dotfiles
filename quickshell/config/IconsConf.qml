pragma Singleton
import QtQuick
import Quickshell.Networking

QtObject {
    readonly property string forward: "chevron_forward"
    readonly property string backward: "chevron_backward"
    readonly property string tick: "check"
    readonly property string appSearchHideButton: "visibility_off"
    readonly property string appSearchOpenInNewWsButton: "open_in_new"
    readonly property var battery: [
        {
            max: 10,
            charging: "battery_charging_full",
            discharging: "battery_alert"
        },
        {
            max: 20,
            charging: "battery_charging_20",
            discharging: "battery_1_bar"
        },
        {
            max: 30,
            charging: "battery_charging_30",
            discharging: "battery_2_bar"
        },
        {
            max: 50,
            charging: "battery_charging_50",
            discharging: "battery_3_bar"
        },
        {
            max: 60,
            charging: "battery_charging_60",
            discharging: "battery_4_bar"
        },
        {
            max: 80,
            charging: "battery_charging_80",
            discharging: "battery_5_bar"
        },
        {
            max: 95,
            charging: "battery_charging_90",
            discharging: "battery_6_bar"
        },
        {
            max: 100,
            charging: "fill:battery_charging_full",
            discharging: "fill:battery_full"
        },
    ]
    readonly property var wifi: [
        {
            connectivity: NetworkConnectivity.Unknown,
            icons: [
                {
                    secured: "signal_wifi_statusbar_not_connected",
                    open: "signal_wifi_statusbar_not_connected"
                }
            ]
        },
        {
            connectivity: NetworkConnectivity.Portal,
            icons: [
                {
                    secured: "perm_scan_wifi",
                    open: "perm_scan_wifi"
                }
            ]
        },
        {
            connectivity: NetworkConnectivity.Limited,
            icons: [
                {
                    secured: "signal_wifi_bad",
                    open: "signal_wifi_bad"
                }
            ]
        },
        {
            connectivity: NetworkConnectivity.None,
            icons: [
                {
                    secured: "signal_wifi_off",
                    open: "signal_wifi_off"
                }
            ]
        },
        {
            connectivity: NetworkConnectivity.Full,
            icons: [
                {
                    max: 0.05,
                    secured: "wifi_lock",
                    open: "signal_wifi_0_bar"
                },
                {
                    max: 0.2,
                    secured: "network_wifi_1_bar_locked",
                    open: "network_wifi_1_bar"
                },
                {
                    max: 0.5,
                    secured: "network_wifi_2_bar_locked",
                    open: "network_wifi_2_bar"
                },
                {
                    max: 0.8,
                    secured: "network_wifi_3_bar_locked",
                    open: "network_wifi_3_bar"
                },
                {
                    max: 1,
                    secured: "fill:wifi_lock",
                    open: "fill:signal_wifi_4_bar"
                },
            ]
        }
    ]
    readonly property var vpn: ({
            on: "vpn_key",
            off: "vpn_key_off"
        })
    readonly property var volume: [
        {
            muted: true,
            icon: "no_sound"
        },
        {
            max: 0,
            icon: "volume_mute"
        },
        {
            max: 35,
            icon: "volume_down"
        },
        {
            max: 100,
            icon: "volume_up"
        }
    ]
    readonly property var bluetooth: ({
            enabled: "bluetooth",
            disabled: "bluetooth_disabled",
            connected: "bluetooth_connected"
        })
    readonly property var mode: {
        "none": "contrast",
        "light": "light_mode",
        "dark": "dark_mode"
    }
    readonly property var power: ({
            onOff: "power_settings_new",
            shutDown: "power_settings_new",
            restart: "restart_alt",
            sleep: "bedtime",
            lock: "lock"
        })
    readonly property var powerProfiles: ["energy_savings_leaf", "balance", "rocket_launch"]
    readonly property var devices: {
        "ac-adapter": "power",
        "audio-card": "music_note",
        "audio-card-analog": "laptop_windows",
        "audio-headphones": "headphones",
        "audio-headset": "headset_mic",
        "audio-input-microphone": "mic",
        "audio-speakers": "laptop_windows",
        "auth-face": "familiar_face_and_zone",
        "auth-fingerprint": "fingerprint",
        "auth-sim": "sim_card",
        "auth-smartcard": "id_card",
        "battery": "battery_full",
        "bluetooth": "bluetooth",
        "camera-photo": "photo_camera",
        "camera-video": "videocam",
        "camera-web": "camera",
        "computer-apple-ipad": "tablet_mac",
        "computer": "laptop_windows",
        "drive-harddisk": "hard_drive_2",
        "drive-harddisk-ieee1394": "hard_drive_2",
        "drive-harddisk-solidstate": "hard_drive",
        "drive-harddisk-system": "hard_drive",
        "drive-harddisk-usb": "security_key",
        "drive-multidisk": "storage",
        "drive-optical": "hard_disk",
        "drive-removable-media": "hard_drive",
        "ebook-reader": "tablet_android",
        "earbud": "earbuds_2",
        "input-dialpad": "dialpad",
        "input-touchpad": "trackpad_input",
        "input-gaming": "sports_esports",
        "input-keyboard": "keyboard",
        "input-mouse": "mouse",
        "input-tablet": "tablet",
        "media-flash": "sd_card",
        "media-floppy": "save",
        "media-optical": "album",
        "media-optical-bd": "album",
        "media-optical-cd-audio": "album",
        "media-optical-cd": "album",
        "media-optical-dvd": "album",
        "media-removable": "security_key",
        "media-tape": "voicemail_2",
        "modem": "router",
        "microphone": "mic",
        "multimedia-player-apple-ipod-touch": "mobile",
        "multimedia-player": "mobile",
        "network-cellular": "cell_tower",
        "network-wired": "polyline",
        "network-wireless": "network_wifi",
        "phone-apple-iphone": "mobile",
        "phone-old": "phone_enabled",
        "phone": "mobile",
        "printer-network": "print",
        "printer": "print",
        "scanner": "scanner",
        "tablet": "tablet",
        "thunderbolt": "electric_bolt",
        "tv": "tv",
        "uninterruptible-power-supply": "power",
        "video-display": "tv",
        "video-joined-displays": "tv_displays",
        "video-single-display": "monitor"
    }
    readonly property var media: ({
            play: "play_arrow",
            pause: "pause",
            skip: "skip_next",
            skipBack: "skip_previous"
        })
    readonly property var brightness: [
        {
            max: 0.2,
            icon: "brightness_empty"
        },
        {
            max: 0.8,
            icon: "brightness_6"
        },
        {
            max: 1,
            icon: "brightness_7"
        },
    ]
    readonly property string search: "search"
    readonly property var searchMode: ({
            default: "search",
            apps: "apps",
            dirs: "folder",
            files: "draft",
            web: "language",
            commands: "terminal"
        })
    readonly property var fileFormats: {
        "markdown": ["md"],
        "article": ["txt"],
        "custom:json": ["json"],
        "gif_box": ["gif", "gifv"],
        "apk_document": ["apk", "aab"],
        "bring_your_own_ip": ["torrent"],
        "subtitles": ["ass", "ssa", "smi", "srt"],
        "custom:file_cursor": ["ani", "cur", "smes"],
        "web": ["mhtml", "maff", "webarchive", "dtd", "chm"],
        "downloading": ["!ut", "crdownload", "opdownload", "part", "partial"],
        "key": ["gxk", "ssh", "pub", "ppk", "nsign", "cer", "crt", "der", "p7b", "p7c", "p12", "pfx", "pem"],
        "link": ["alias", "appref-ms", "desktop", "jnlp", "lnk", "nal", "pif", "sym", "url", "webloc", "website"],
        "map": ["apr", "dem", "e00", "geojson", "topojson", "geotiff", "gpx", "itn", "mxd", "ov2", "shp", "dted", "kml"],
        "deployed_code": ["appx", "app", "dmg", "deb", "hpkg", "ipg", "msi", "rpm", "sis", "sisx", "xap", "appimage", "dll"],
        "terminal": ["sh", "bash", "zsh", "ksh", "csh", "tcsh", "fish", "command", "bat", "cmd", "ps1", "psm1", "psd1", "bashrc", "zshrc"],
        "custom:file_font": ["abf", "bmf", "brfnt", "fnt", "fon", "mgf", "otf", "pfa", "pfb", "pfm", "fond", "sfd", "snf", "tdf", "tfm", "ttf", "ttc", "ufo", "woff", "woff2"],
        "custom:presentation": ["gslides", "key", "keynote", "odp", "otp", "pez", "pot", "prdx", "pps", "ppt", "pptx", "prz", "sdd", "shf", "show", "shw", "slp", "sspss", "sti", "sxi", "thmx", "watch"],
        "video_file": ["braw", "drp", "fcp", "mswmm", "pds", "ppj", "prproj", "aep", "imovieproj", "veg", "veg-bak", "suf", "wlmp", "kdenlive", "vpj", "motn", "imoviemobile", "wfp, wve", "vproj", "flb"],
        "polyline": ["awg", "ai", "cgm", "cmx", "dp", "drawio", "dxf", "e2d", "eps", "gbr", "odg", "renderman", "svg", "stl", "wrl", "sxd", "tgax", "v2d", "vdoc", "vsd", "vsdx", "vnd", "wmf", "emf", "xar"],
        "custom:spreadsheet": ["123", "ab2", "ab3", "aws", "bcsv", "clf", "cell", "gsheet", "numbers", "gnumeric", "lcw", "ods", "ots", "qpw", "pmdx", "sdc", "slk", "stc", "sxc", "tab", "vc", "wk1", "wk3", "wk4", "wks", "wq1", "xlk", "xls", "xlsb", "xlsm", "xlsx", "xlr", "xlt", "xltm", "xlw"],
        "folder_zip": ["7z", "ace", "alz", "arc", "arj", "bz2", "cab", "sea", "ecab", "ezip", "flipchart", "fun", "gz", "g3fc", "lawrence", "lbr", "lzh", "lz", "lzo", "lzma", "lzx", "mbw", "mcaddon", "oar", "pak", "par", "par2", "paf", "pea", "pkg", "pyk", "rar", "rax", "sitx", "tar", "wax", "xz", "z", "zoo", "zip"],
        "movie": ["mp4", "3gp", "aaf", "at3", "asf", "avchd", "avi", "bik", "bk", "cam", "collab", "dvr-ms", "flv", "gmv", "mpeg-1", "mpeg-2", "noa", "fla", "flr", "sol", "str", "m4v", "mkv", "wrap", "mng", "mov", "mpeg", "mpg", "mpe", "thp", "mpeg-4", "mxf", "roq", "nsv", "qmg", "rm", "rmvb", "svi", "smk", "swf", "wmv", "wtv", "yuv", "webm"],
        "music_note": ["8svx", "16svx", "aiff", "aif", "aifc", "au", "bwf", "cdda", "dsf", "wav", "cwav", "qau", "queyeaudio", "qau0", "ra", "flac", "la", "pac", "ape", "ofr", "ofs", "rka", "shn", "tak", "thd", "tta", "wv", "bcwav", "brstm", "dtshd", "dtsma", "ast", "aw", "psf", "ac3", "amr", "mp1", "mp2", "mp3", "spx", "gsm", "wma", "aac", "mpc", "vqf", "swa", "vox", "voc", "smp", "ogg"],
        "database": ["4db", "4dc", "4dd", "4dindy", "4dindx", "4dr", "4dz", "accdb", "accde", "adt", "box", "chml", "daf", "db", "dbf", "dta", "eap", "fdb", "fp", "fp3", "fp5", "fp7", "g3k", "gdb", "gtable", "kexi", "kexic", "kexis", "lbx", "ldb", "lirs", "mda", "mdb", "adp", "mde", "mdf", "myd", "myi", "nv2", "odb", "ora", "pcontact", "pdb", "pdx", "sql", "rec", "rel", "sdb", "sdf", "sqlite", "udl", "wadata", "waindx", "wamodel", "wajournal", "wdb", "wmdb", "avro", "parquet", "orc"],
        "description": ["0", "1st", "600", "602", "abw", "acl", "afp", "ami", "ans", "asc", "aww", "bbeb", "ccf", "cwk", "dbk", "dita", "doc", "docm", "docx", "dot", "dotx", "dwd", "epub", "evtx", "ezw", "fdx", "ftx", "gdoc", "guide", "hwp", "hwpml", "kpub", "log", "lwp", "mbp", "me", "mcw", "mobi", "neis", "nt", "nq", "odm", "odoc", "odt", "osheet", "ott", "omm", "pages", "pap", "per", "pdr", "pdax", "pdf", "protondoc", "quox", "rtf", "rpt", "sdw", "se", "stw", "sxw", "tex", "tmdx", "info", "troff", "uof", "uoml", "via", "wpd", "wps", "wpt", "wrd", "wrf", "wri", "wrix", "xps"],
        "custom:file_3d": ["3dmf", "3dm", "3mf", "3ds", "ac", "amf", "an8", "aoi", "b3d", "bbmodel", "blend", "block", "bmd3", "bdl4", "brres", "bfres", "bcres", "c4d", "cal3d", "ccp4", "cfl", "core3d", "ctm", "dae", "dn", "dpm", "fact", "fbx", "g", "glb", "glm", "gltf", "hec", "io", "iob", "jas", "jmesh", "ldr", "lwo", "lws", "lxf", "lxo", "m3d", "ma", "max", "mb", "mpd", "md2", "md3", "md5", "mesh", "miobject", "miparticle", "mimodel", "mm3d", "mpo", "nif", "nwc", "nwd", "nwf", "obj", "ogex", "ply", "prt", "pov", "r3d", "rwx", "sia", "sldasm", "sldprt", "smd", "tres", "u3d", "usd", "usda", "usdc", "usdz", "vim", "vrml97", "vwx", "wings", "w3d", "x", "x3d", "z3d", "zbmx"],
        "audio_file": ["mod", "mt2", "s3m", "xm", "it", "sng", "gbs", "mid, midi", "fur", "darms", "etf", "gp", "kern", "ly", "mei", "midi", "mus", "musx", "mxl", "mscx", "mscz", "smdl", "cust", "gym", "jam", "niff", "ptb", "pvd", "rmj", "sf2", "sf3", "sf4", "sid", "spc", "txm", "vgm", "ym", "aimppl", "asx", "ram", "xspf", "zpl", "m3u", "pls", "qaua", "als", "alc", "alp", "atmos", "audio", "metadata", "aup", "aup3", "band", "cel", "cau", "cpr", "cwp", "drm", "dwp", "dmkit", "ens", "flm", "grir", "logic", "mmp", "mmr", "mx6hs", "npr", "omf", "omfi", "ptx", "ptf", "pts", "rpp", "rpp-bak", "reapeaks", "ses", "sfk", "sfl", "stf", "snd", "syn", "svp", "ust", "ustx", "vcls", "vpr", "vsq", "vsqx"],
        "image": ["art", "avif", "blp", "bmp", "bti", "c4", "cals", "cd5", "cit", "clip", "cpl", "dds", "dib", "djvu", "exif", "flif", "grf", "icns", "heif", "heic", "ico", "iff", "ilbm", "lbm", "jng", "jbig", "jpeg", "jpg", "jfif", "jp2", "jai", "jaic", "jd", "jfm", "jls", "jnft", "jpp", "jrf", "jps", "jsy", "jxl", "jxr", "jxs", "jxt", "kra", "miff", "msp", "nef", "nitf", "otb", "pbm", "pc1", "pc2", "pc3", "pcx", "pdd", "pdn", "pgf", "pgm", "pi1", "pi2", "pi3", "pict", "pct", "png", "pnj", "pnm", "pns", "ppm", "procreate", "psp", "px", "pxm", "pxr", "pxz", "qfx", "qoi", "rle", "sct", "sgi", "rgb", "int", "bw", "tga", "targa", "icb", "vda", "vst", "pix", "tiff", "tif", "vtf", "webp", "xbm", "xcf", "xpm", "zif"],
        "custom:file_code": ["qml", "xml", "xhtml", "xht", "html", "htm", "a", "adb", "ads", "asm", "s", "ahk", "applescript", "as", "au3", "awk", "b", "bas", "bb", "bmx", "c", "cpp", "cc", "cxx", "cbp", "cs", "csproj", "c3", "c3l", "clj", "cljs", "cob", "cbl", "cjs", "class", "cls", "coffee", "dart", "dba", "dbpro123", "ebuild", "erb", "e", "efs", "el", "for", "ftn", "f", "f77", "f90", "frx", "fth", "go", "ged", "gd", "gm6", "gmd", "gmk", "gool", "hta", "hx", "hxml", "h", "hpp", "hxx", "hs", "i", "ibi", "ici", "ijs", "inc", "ino", "ipynb", "itcl", "java", "js", "jsfl", "jsx", "kt", "l", "lgt", "lua", "lisp", "m", "mm", "m4", "map", "mjs", "ml", "msqr", "n", "nuc", "nud", "nut", "o", "pas", "pp", "p", "php", "php3", "php4", "php5", "phps", "phtml", "piv", "pli", "pl1", "prg", "pro", "pol", "pde", "pl", "pm", "ps1xml", "psc1", "py", "pyc", "pyo", "pyx", "r", "raku", "rakumod", "rakudoc", "rakutest", "nqp", "rb", "rdp", "red", "rex", "rexx", "rs", "reds", "resx", "rc", "rc2", "rkt", "rktl", "resources", "scala", "sci", "sce", "scm", "sd7", "skb", "skc", "skd", "skf", "skg", "ski", "skk", "skm", "sko", "skq", "sks", "skt", "skz", "sln", "spin", "stk", "sb", "sb2", "sb3", "scpt", "scptd", "sdl", "sprite3", "spwn", "svelte", "syjs", "sypy", "tcl", "tns", "torch", "ts", "tscn", "tsx", "up", "vbs", "vap", "vb", "vbg", "vbp", "vip", "vbproj", "vcproj", "vdproj", "vi", "wasm", "wat", "xaml", "xq", "xsl", "y", "css", "less", "sass", "scss", "styl", "stylus", "pcss", "postcss", "sss", "cshtml", "razor"],
        "album": ["iso", "cso", "hdi", "mds", "rom", "vmdk", "dvd", "ex01", "i02", "bws", "mbi", "cfs", "ashdisc", "dbr", "macvm", "d64", "vaporcd", "d01", "wlz", "hd", "vhd", "adi", "dmgpart", "dsk", "daa", "d00", "vhdx", "xvd", "sdi", "md0", "l01", "qcow", "lcd", "vmwarevm", "vfd", "wud", "dcf", "qcow2", "nrg", "ibp", "wim", "toast", "xva", "uibak", "avhd", "e01", "cif", "sub", "i01", "hds", "tib", "bif", "ccd", "bwt", "utm", "disk", "cdm", "ecm", "adz", "dax", "sdsk", "xdi", "ede", "cvbi", "vc4", "ima", "isz", "ipf", "ibdat", "cdi", "mlc", "2mg", "pvm", "mrimg", "img", "uif", "adf", "bwi", "sqfs", "hfv", "sco", "eui", "d81", "apfs", "dvdr", "swm", "hfs", "x64", "p01", "tc", "omg", "cdt", "ndif", "lvi", "tzx", "gbi", "lx01", "b5i", "tap", "pmf", "toc", "fdi", "woz", "edk", "t64", "mfi", "xa", "aff", "imd", "udf", "image", "fdd", "st", "000", "partimg", "ixa", "bwa", "cl5", "rcl", "sparseimage", "hdd", "wmt", "p2g", "vcx", "vco", "ciso", "infinitemacdisk", "pmfx", "pqi", "md1", "pxi", "vdi", "afd", "qed", "nkit", "rpkg", "gcd", "td0", "bwz", "ibadr", "86f", "b6i", "wii", "disc", "i00", "nn", "cue", "flg", "dms", "ibq", "b6t", "ibb", "eda", "c2d", "rdf", "dxp", "pgd", "gi", "edv", "gdrive", "imz", "wbi", "b5t", "cd", "simg", "atr", "volarchive", "winclone", "sparsebundle", "sopt", "lnx", "g41", "xmd", "ncd", "p2i", "fcd", "miniso", "d88", "mir", "ratdvd", "tao", "gkh", "pgx", "fd", "vhdpmem", "d71", "po", "do", "miniroot", "tgc", "cramfs", "ext4", "fat", "afr", "edq", "aa", "nfi", "wil", "dao", "vc8", "vc6", "eds", "xmf", "vbi", "ufs", "k3b"]
    }
    readonly property string otherFileFormat: "draft"
    readonly property var dirs: ({
            default: "folder",
            rootOwned: "custom:folder_lock",
            conf: "folder_managed",
            repo: "folder_code",
            home: "custom:folder_home",
            xdgDOWNLOAD: "custom:folder_downloads",
            xdgDESKTOP: "custom:folder_desktop",
            xdgTEMPLATES: "folder",
            xdgPUBLICSHARE: "folder_supervised",
            xdgDOCUMENTS: "custom:folder_documents",
            xdgMUSIC: "custom:folder_music",
            xdgPICTURES: "custom:folder_pictures",
            xdgVIDEOS: "custom:folder_videos",
            xdgPROJECTS: "folder"
        })
    readonly property string terminal: "terminal"
    readonly property string webSearch: "custom:web_search"
    readonly property string history: "history"
}
