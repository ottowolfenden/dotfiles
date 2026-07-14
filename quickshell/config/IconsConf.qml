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
            charging: "battery_charging_full",
            discharging: "battery_full",
            fill: true
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
                    secured: "wifi_lock",
                    open: "signal_wifi_4_bar",
                    fill: true
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
        "earbud": "earbud_left",
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
    readonly property var searchMode: ({
            default: "search",
            apps: "apps",
            dirs: "folder",
            files: "draft",
            web: "language",
            command: "terminal"
        })
    readonly property var fileFormats: {
        "csv": ["csv"],
        "tsv": ["tsv"],
        "markdown": ["md"],
        "article": ["txt"],
        "javascript": ["js"],
        "data_object": ["json"],
        "gif_box": ["gif", "gifv"],
        "apk_document": ["apk", "aab"],
        "tag": ["cs", "cshtml", "razor"],
        "bring_your_own_ip": ["torrent"],
        "code_xml": ["xml", "xhtml", "xht"],
        "subtitles": ["ass", "ssa", "smi", "srt"],
        "arrow_selector_tool": ["ani", "cur", "smes"],
        "palette": ["act", "ase", "gpl", "pal", "icc", "icm"],
        "science": ["cml", "mol", "sd", "sdf", "dx", "jdx", "smi"],
        "calculate": ["g3k", "harwell-boeing", "mml", "odf", "sxm"],
        "file_save": ["!ut", "crdownload", "opdownload", "part", "partial"],
        "web": ["html", "htm", "mhtml", "maff", "webarchive", "dtd", "chm"],
        "style": ["css", "less", "sass", "scss", "styl", "stylus", "pcss", "postcss", "sss"],
        "link": ["alias", "appref-ms", "desktop", "jnlp", "lnk", "nal", "pif", "sym", "url", "webloc", "website"],
        "key": ["gxk", "ssh", "pub", "ppk", "nsign", "cer", "crt", "der", "p7b", "p7c", "p12", "pfx", "pem", "pfx"],
        "deployed_code": ["appx", "app", "dmg", "deb", "hpkg", "ipg", "msi", "rpm", "sis", "sisx", "xap", "appimage"],
        "terminal": ["sh", "bash", "zsh", "ksh", "csh", "tcsh", "fish", "command", "bat", "cmd", "ps1", "psm1", "psd1", "bashrc", "zshrc", "sed", "awk"],
        "map": ["apr", "dem", "e00", "geojson", "topojson", "geotiff", "gml", "gpx", "itn", "mxd", "ntf", "ov2", "shp", "tab", "geotiff", "dted", "kml"],
        "font_download": ["abf", "afm", "bdf", "bmf", "brfnt", "fnt", "fon", "mgf", "otf", "pcf", "pfa", "pfb", "pfm", "fond", "sfd", "snf", "tdf", "tfm", "ttf", "ttc", "ufo", "woff"],
        "video_file": ["braw", "drp", "fcp", "mswmm", "pds", "ppj", "prproj", "aep", "imovieproj", "veg", "veg-bak", "suf", "wlmp", "kdenlive", "vpj", "motn", "imoviemobile", "wfp, wve", "vproj", "flb"],
        "slideshow": ["gslides", "key", "keynote", "nb", "nbp", "odp", "otp", "pez", "pot", "prdx", "pps", "ppt", "pptx", "prz", "sdd", "shf", "show", "shw", "slp", "sspss", "sti", "sxi", "thmx", "watch"],
        "polyline": ["amf", "awg", "ai", "cgm", "cdr", "cmx", "dp", "drawio", "dxf", "e2d", "egt", "eps", "fs", "gbr", "odg", "renderman", "svg", "stl", "wrl", "x3d", "sxd", "tgax", "v2d", "vdoc", "vsd", "vsdx", "vnd", "wmf", "emf", "art", "xar"],
        "custom:spreadsheet": ["123", "ab2", "ab3", "aws", "bcsv", "clf", "cell", "csv", "gsheet", "numbers", "gnumeric", "lcw", "ods", "ots", "qpw", "pmdx", "sdc", "slk", "stc", "sxc", "tab", "vc", "wk1", "wk3", "wk4", "wks", "wks", "wq1", "xlk", "xls", "xlsb", "xlsm", "xlsx", "xlr", "xlt", "xltm", "xlw"],
        "folder_zip": ["7z", "ace", "alz", "arc", "arj", "bz2", "cab", "cpt", "sea", "egg", "egt", "ecab", "ezip", "ess", "flipchart", "fun", "gz", "g3fc", "jar", "lawrence", "lbr", "lzh", "lz", "lzo", "lzma", "lzx", "mbw", "mcaddon", "bin", "oar", "pak", "par", "par2", "paf", "pea", "pkg", "pyk", "rar", "rax", "sitx", "tar", "wax", "xz", "z", "zoo", "zip"],
        "movie": ["mp4", "3gp", "aaf", "at3", "asf", "avchd", "avi", "bik/bk", "braw", "cam", "collab", "dat", "dvr-ms", "flv", "gmv", "mpeg-1", "mpeg-2", "noa", "fla", "flr", "sol", "str", "m4v", "mkv", "wrap", "mng", "mov", "mpeg", "mpg", "mpe", "thp", "mpeg-4", "mxf", "roq", "nsv", "qmg", "rm", "rmvb", "svi", "smk", "swf", "wmv", "wtv", "yuv", "webm"],
        "music_note": ["8svx", "16svx", "aiff", "aif", "aifc", "au", "aup3", "bwf", "cdda", "dsf", "dff", "raw", "wav", "cwav", "qau", "queyeaudio", "qau0", "ra", "rm", "flac", "la", "pac", "ape", "ofr", "ofs", "off", "rka", "shn", "tak", "thd", "tta", "wv", "wma", "bcwav", "brstm", "dts", "dtshd", "dtsma", "ast", "aw", "psf", "ac3", "amr", "mp1", "mp2", "mp3", "spx", "gsm", "wma", "aac", "mpc", "vqf", "ots", "swa", "vox", "voc", "dwd", "smp", "ogg"],
        "description": ["0", "1st", "600", "602", "abw", "acl", "afp", "ami", "ans", "asc", "aww", "bbeb", "ccf", "cwk", "dbk", "dita", "doc", "docm", "docx", "dot", "dotx", "dwd", "egt", "epub", "evtx", "ezw", "fdx", "ftm", "ftx", "gdoc", "guide", "hwp", "hwpml", "kpub", "log", "lwp", "mbp", "me", "mcw", "mobi", "nb", "nb", "nbp", "neis", "nt", "nq", "odm", "odoc", "odt", "osheet", "ott", "omm", "pages", "pap", "per", "pdr", "pdax", "pdf", "protondoc", "quox", "rtf", "rpt", "sdw", "se", "stw", "sxw", "tex", "tmdx", "info", "troff", "uof", "uoml", "via", "wpd", "wps", "wpt", "wrd", "wrf", "wri", "wrix", "xhtml", "xht", "xml", "xps"],
        "database": ["4db ", "4dc ", "4dd ", "4dindy ", "4dindx ", "4dr ", "4dz ", "accdb ", "accde ", "adt ", "apr ", "box ", "chml ", "daf ", "dat ", "dat ", "db ", "db ", "dbf ", "dta ", "egt ", "ess ", "eap ", "fdb ", "fdb ", "fp", "fp3", "fp5", "fp7", "frm ", "g3k", "gdb ", "gtable ", "kexi ", "kexic ", "kexis ", "lbx ", "ldb ", "lirs ", "mda ", "mdb ", "adp ", "mde ", "mdf ", "myd ", "myi ", "ncf ", "nsf ", "ntf ", "nv2 ", "odb ", "ora ", "pcontact ", "pdb ", "pdi ", "pdx ", "prc ", "sql ", "rec ", "rel ", "rin ", "sdb ", "sdf ", "sqlite ", "udl ", "wadata ", "waindx ", "wamodel ", "wajournal ", "wdb ", "wmdb ", "avro", "parquet", "orc"],
        "3d": ["3dmf", "3dm", "3mf", "3ds", "abc", "ac", "amf", "an8", "aoi", "asm", "b3d", "bbmodel", "blend", "block", "bmd3", "bdl4", "brres", "bfres", "bcres", "c4d", "cal3d", "ccp4", "cfl", "cob", "core3d", "ctm", "dae", "dff", "dn", "dpm", "dts", "egg", "fact", "fbx", "g", "glb", "glm", "gltf", "hec", "io", "iob", "jas", "jmesh", "ldr", "lwo", "lws", "lxf", "lxo", "m3d", "ma", "max", "mb", "mpd", "md2", "md3", "md5", "mdx", "mesh", "mesh", "miobject", "miparticle", "mimodel", "mm3d", "mpo", "mrc", "nif", "nwc", "nwd", "nwf", "obj", "off", "ogex", "ply", "prc", "prt", "pov", "r3d", "rwx", "sia", "sib", "skp", "sldasm", "sldprt", "smd", "tres", "u3d", "usd", "usda", "usdc", "usdz", "vim", "vrml97", "vue", "vwx", "wings", "w3d", "x", "x3d", "z3d", "zbmx"],
        "audio_file": ["mod", "mt2", "s3m", "xm", "it", "sng", "nsf", "gbs", "mid, midi", "ftm", "btm", "fur", "abc", "darms", "etf", "gp", "kern", "ly", "mei", "midi", "mus", "musx", "mxl", "xml", "mscx", "mscz", "smdl", "sib", "asf", "cust", "gym", "jam", "mng", "niff", "ptb", "pvd", "rmj", "sf2", "sf3", "sf4", "sid", "spc", "txm", "vgm", "ym", "aimppl", "asx", "ram", "xpl", "xspf", "zpl", "m3u", "pls", "qaua", "als", "alc", "alp", "atmos", "audio", "metadata", "aup", "aup3", "band", "cel", "cau", "cpr", "cwp", "drm", "dwp", "dmkit", "ens", "flm", "flp", "grir", "logic", "mmp", "mmr", "mx6hs", "npr", "omf", "omfi", "ptx", "ptf", "pts", "rin", "rpp", "rpp-bak", "reapeaks", "ses", "sfk", "sfl", "sng", "stf", "snd", "syn", "svp", "ust", "ustx", "vcls", "vpr", "vsq", "vsqx"],
        "image": ["art", "avif", "blp", "bmp", "bti", "c4", "cals", "cd5", "cit", "cpt", "clip", "cpl", "dds", "dib", "djvu", "egt", "exif", "flif", "grf", "icns", "heif", "heic", "ico", "iff", "ilbm", "lbm", "jng", "jbig", "jpeg", "jpg", "jfif", "jp2", "jai", "jaic", "jar", "jd", "jfm", "jls", "jnft", "jpp", "jrf", "jps", "jsy", "jxl", "jxr", "jxs", "jxt", "kra", "lbm", "max", "miff", "mng", "msp", "nef", "nitf", "otb", "pbm", "pc1", "pc2", "pc3", "pcf", "pcx", "pdd", "pdn", "pgf", "pgm", "pi1", "pi2", "pi3", "pi2", "pict", "pct", "png", "pnj", "pnm", "pns", "ppm", "procreate", "psp", "px", "pxm", "pxr", "pxz", "qfx", "qoi", "rle", "sct", "sgi", "rgb", "int", "bw", "tga", "targa", "icb", "vda", "vst", "pix", "tiff", "tif", "tiff/ep", "tif", "tiff", "vtf", "webp", "xbm", "xcf", "xpm", "zif"],
        "code_blocks": ["a", "adb", "ads", "asm, s", "ahk", "applescript", "as", "au3", "awk", "b", "bas", "bb", "bmx", "bas", "bat", "btm", "c", "cpp", "cc", "cxx", "c", "cbp", "cs", "csproj", "c3", "c3l", "clj", "cljs", "cls", "cob", "cbl", "cjs", "class", "cls", "cmd", "command", "coffee", "dart", "d", "dba", "dbpro123", "ebuild", "egg", "egt", "erb", "e", "efs", "egt", "el", "fs", "for", "ftn", "f", "f77", "f90", "frm", "frx", "fth", "go", "ged", "gd", "gm6", "gmd", "gmk", "gml", "gool", "hc", "hta", "hx", "hxml", "h", "hpp", "hxx", "hs", "i", "ibi", "ici", "ijs", "inc", "ino", "ipynb", "itcl", "java", "js", "jsfl", "jsx", "kt", "l", "lgt", "lua", "lisp", "m", "m", "m", "mm", "m4", "map", "mjs", "mrc", "ml", "msqr", "n", "nb", "ncf", "nqp", "nuc", "nud", "nut", "o", "p", "pas", "pp", "p", "php", "php3", "php4", "php5", "phps", "phtml", "piv", "pli", "pl1", "prg", "pro", "pol", "pde", "pl", "pm", "ps1", "ps1xml", "psc1", "psd1", "psm1", "py", "pyc", "pyo", "pyx", "r", "r", "raku", "rakumod", "rakudoc", "rakutest", "nqp", "rb", "rdp", "red", "rex", "rexx", "rs", "red", "reds", "resx", "rc", "rc2", "rkt", "rktl", "resources", "scala", "sci", "sce", "scm", "sd7", "skb", "skc", "skd", "skf", "skg", "ski", "skk", "skm", "sko", "skp", "skq", "sks", "skt", "skz", "sln", "spin", "stk", "sb", "sb2", "sb3", "scpt", "scptd", "sdl", "sprite3", "spwn", "svelte", "syjs", "sypy", "tcl", "tns", "torch", "ts", "tscn", "tsx", "up", "vbs", "vue", "vap", "vb", "vbg", "vbp", "vip", "vbproj", "vcproj", "vdproj", "vi", "wasm", "wat", "xaml", "xpl", "xq", "xsl", "y"]
    }
    readonly property string otherFileFormat: "draft"
    readonly property var dirs: ({
            default: "folder",
            rootOwned: "custom:folder_lock",
            conf: "folder_managed",
            repo: "folder_code",
            home: "custom:folder_home"
        })
}
