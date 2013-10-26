#
# * 細かいユーティリティ詰め合わせ
# * pocket.js
#
###*
詰め合わせ系ライブラリ<br><br>
今のところ実装している機能<br>
<ul>
<li>ブラウザ判定</li>
<li>タッチ系イベント名のラッパー変数</li>
</ul>
@class Pocket
@constructor
###
Pocket = () ->

  # ---------------------------------------------------------
  # touch event wrapper
  # ---------------------------------------------------------
  supportTouch = "ontouchstart" of window

  ###*
  * event wrapper valiable than touchstart or mousedown
  * タッチとマウスのスタート系イベントラッパー変数
  * @property press
  * @type str
  * @default undefined
  ###
  @.press = (if supportTouch then "touchstart" else "mousedown")

  ###*
  * event wrapper valiable than touchmove or mousemove
  * タッチとマウスのムーブ系イベントラッパー変数
  * @property move
  * @type str
  * @default undefined
  ###
  @.move = (if supportTouch then "touchmove" else "mousemove")

  ###*
  * event wrapper valiable than touchend or mouseup
  * タッチとマウスのエンド系イベントラッパー変数
  * @property release
  * @type str
  * @default undefined
  ###
  @.release = (if supportTouch then "touchend" else "mouseup")


  # ---------------------------------------------------------
  # UserAgent Judge function
  # This function made thinking on the basic of "IE proliferate".
  # return { name: name, version: ver, type: type, os: os }
  # ---------------------------------------------------------
  getUa = ->
    UA = window.navigator.userAgent.toLowerCase()
    VER = window.navigator.appVersion.toLowerCase()
    OS = window.navigator.platform.toLowerCase()
    SP = "smartphone"
    TB = "tablet"

    # iOS
    if UA.indexOf("ipad") isnt -1 or UA.indexOf("ipod") isnt -1 or UA.indexOf("iphone") isnt -1
      os = "ios"
      unless UA.indexOf("4_") is -1
        ver = 4
      else unless UA.indexOf("5_") is -1
        ver = 5
      else unless UA.indexOf("6_") is -1
        ver = 6
      else  unless UA.indexOf("7_") is -1
        ver = 7
      name = "safari"
      device = "ipad"
      type = TB
      if UA.indexOf("ipod") isnt -1 or UA.indexOf("iphone") isnt -1
        device = "ipod"
        type = SP
        device = "iphone"  unless UA.indexOf("iphone") is -1

    # Android
    else unless UA.indexOf("android") is -1
      os = "android"
      name = "androidbrowser"
      device = "androidtablet"
      type = TB
      unless UA.indexOf("mobile") is -1
        device = "android"
        type = SP

    # Windows Phone
    else unless UA.indexOf("windows phone") is -1
      os = "windowsmobile"
      name = "ie"
      device = "windowsphone"
      type = SP
      ver = 6
      ver = 7  unless UA.indexOf("OS 7") is -1

    # PC browser
    else
      os = "unix"
      os = "windows" if OS.indexOf("win") isnt -1
      os = "macos"   if UA.match( /mac|ppc/ )

      if UA.indexOf("msie") isnt -1 or UA.indexOf("trident") isnt -1
        name = "ie"
        unless VERSION.indexOf("msie 6.") is -1
          ver = 6
        else unless VERSION.indexOf("msie 7.") is -1
          ver = 7
        else unless VERSION.indexOf("msie 8.") is -1
          ver = 8
        else unless VERSION.indexOf("msie 9.") is -1
          ver = 9
        else unless VERSION.indexOf("msie 10.") is -1
          ver = 10
        else ver = 11  unless UA.indexOf("trident") is -1
      else unless UA.indexOf("chrome") is -1
        name = "chrome"
      else unless UA.indexOf("safari") is -1
        name = "safari"
      else unless UA.indexOf("gecko") is -1
        name = "firefox"
      else name = "opera"  unless UA.indexOf("opera") is -1
    device: "pc"
    type: "pc"
    os: os
    name: name
    version: ver

  ua = getUa()

  ###*
  * device name
  * 端末名 （PCはPC ipad とか iphone とか android とか）
  * @property device
  * @type str
  * @default undefined
  ###
  @.device = ua.device

  ###*
  * os name
  * OS名 （ windows macos unix ios android ）
  * @property os
  * @type str
  * @default undefined
  ###
  @.os = ua.os

  ###*
  * device type ( "pc" or "tablet" or "smartphone" )
  * デバイスの種類 （ PC か tablet か smartphone ）
  * @property devicetype
  * @type str
  * @default undefined
  ###
  @.devicetype = ua.type

  ###*
  * browser name
  * ブラウザ名
  * @property browser
  * @type str
  * @default undefined
  ###
  @.browser = ua.name

  ###*
  * browser version ( suppourt ie or ios )
  * ブラウザのバージョン （IEとiOSしかサポートしてない）
  * @property device
  * @type str
  * @default undefined
  ###
  @.browserver = ua.ver

  # ---------------------------------------------------------
  #端末種類判別関数
  # ---------------------------------------------------------
  @.is_devicetype = ( type ) =>
    type = type or "pc"
    type = "smartphone" if type is "sp"
    if @.devicetype is type
      return true
    else return false

  # ---------------------------------------------------------
  # ブラウザ判別関数
  # ---------------------------------------------------------
  @.is_browser = ( param ) =>
    param.name = param.name or "ie"
    param.ver = param.ver or undefined
    if @.browser is param.name
      if param.ver is undefined
        if @.browserver is param.version
          return true
        else
          return false
      else
        return true
    else
      return false

  # ---------------------------------------------------------
  # 〜より上のバージョンのブラウザ（主にIE）
  # ---------------------------------------------------------
  more_browserver = ( param ) =>
    param.name = param.name or "ie"
    param.ver = param.ver or 6
    if @.browser is param.name
      if param.and is "more"
        return true if @.browserver >= param.version
      else if param.and is "less"
        return true if @.browserver <= param.version

  ###*
  * ブラウザが指定バージョンより上のバージョンか否かの判別メソッド
  * 主にIEで使用。パラメータのプロパティに name を入れれば他ブラウザに対応
  * @method andmore
  * @param obj @.name = str browsername @.ver = num version
  * @return boolen 指定バージョンより上のバージョンなら真
  ###
  @.and_more = ( param ) =>
    param.and = param.and or "more"
    more_browserver( param )

  ###*
  * ブラウザが指定バージョンより下のバージョンか否かの判別メソッド
  * 主にIEで使用。パラメータのプロパティに name を入れれば他ブラウザに対応
  * @method andless
  * @param obj @.name = str browsername @.ver = num version
  * @return boolen 指定バージョンより下のバージョンなら真
  ###
  @.and_less = ( param ) =>
    param.and = param.and or "less"
    more_browserver( param )


  # ---------------------------------------------------------
  # デバイス種別判定
  # ---------------------------------------------------------
  ###*
  * デバイスの種類がpcか否かの判別メソッド
  * @method pc
  * @param null
  * @return boolen デバイスタイプがpcなら真
  ###
  @.pc = => @.is_devicetype( "pc" )

  ###*
  * デバイスの種類がtabletか否かの判別メソッド
  * @method tablet
  * @param null
  * @return boolen デバイスタイプがtabletなら真
  ###
  @.tablet = => @.is_devicetype( "tablet" )

  ###*
  * デバイスの種類がsmartphoneか否かの判別メソッド
  * @method smartphone
  * @param null
  * @return boolen デバイスタイプがsmartphoneなら真
  ###
  @.smartphone = => @.is_devicetype( "smartphone" )


  # ---------------------------------------------------------
  # ブラウザ個別判別
  # ---------------------------------------------------------
  ###*
  * IE6より上のバージョンか否かの判別メソッド
  * @method andmore_ie6
  * @param null
  * @return boolen IE6以上のブラウザなら真
  ###
  @.andmore_ie6 = => @.and_more({ver:6})

  ###*
  * IE7より上のバージョンか否かの判別メソッド
  * @method andmore_ie7
  * @param null
  * @return boolen IE7以上のブラウザなら真
  ###
  @.andmore_ie7 = => @.and_more({ver:7})

  ###*
  * IE8より上のバージョンか否かの判別メソッド
  * @method andmore_ie8
  * @param null
  * @return boolen IE8以上のブラウザなら真
  ###
  @.andmore_ie8 = => @.and_more({ver:8})

  ###*
  * IE9より上のバージョンか否かの判別メソッド
  * @method andmore_ie9
  * @param null
  * @return boolen IE9以上のブラウザなら真
  ###
  @.andmore_ie9 = => @.and_more({ver:9})

  ###*
  * IE6か否かの判別メソッド
  * @method ie6
  * @param null
  * @return boolen IE6なら真
  ###
  @.ie = => @.is_browser({name:"ie"})

  ###*
  * IE6か否かの判別メソッド
  * @method ie6
  * @param null
  * @return boolen IE6なら真
  ###
  @.ie6 = => @.is_browser({name:"ie",ver:6})

  ###*
  * IE7か否かの判別メソッド
  * @method ie7
  * @param null
  * @return boolen IE7なら真
  ###
  @.ie7 = => @.is_browser({name:"ie",ver:7})

  ###*
  * IE8か否かの判別メソッド
  * @method ie8
  * @param null
  * @return boolen IE8なら真
  ###
  @.ie8 = => @.is_browser({name:"ie",ver:8})

  ###*
  * IE9か否かの判別メソッド
  * @method ie9
  * @param null
  * @return boolen IE9なら真
  ###
  @.ie9 = => @.is_browser({name:"ie",ver:9})

  ###*
  * IE10か否かの判別メソッド
  * @method ie10
  * @param null
  * @return boolen IE10なら真
  ###
  @.ie10 = => @.is_browser({name:"ie",ver:10})

  ###*
  * IE11か否かの判別メソッド
  * @method ie11
  * @param null
  * @return boolen IE11なら真
  ###
  @.ie11 = => @.is_browser({name:"ie",ver:11})

  ###*
  * firefoxか否かの判別メソッド
  * @method firefox
  * @param null
  * @return boolen firefoxなら真
  ###
  @.firefox = => @.is_browser({name:"firefox"})

  ###*
  * chromeか否かの判別メソッド
  * @method chrome
  * @param null
  * @return boolen chromeなら真
  ###
  @.chrome = => @.is_browser({name:"chrome"})

  ###*
  * safariか否かの判別メソッド
  * @method safari
  * @param null
  * @return boolen safariなら真
  ###
  @.safari = => @.is_browser({name:"safari"})

  ###*
  * operaか否かの判別メソッド
  * @method opera
  * @param null
  * @return boolen operaなら真
  ###
  @.opera = => @.is_browser({name:"opera"})

  return @

poke = new Pocket()
