/**
詰め合わせ系ライブラリ<br><br>
今のところ実装している機能<br>
<ul>
<li>ブラウザ判定</li>
<li>タッチ系イベント名のラッパー変数</li>
</ul>
@class Pocket
@constructor
*/

var Pocket, poke;

Pocket = function() {
  var getUa, more_browserver, supportTouch, ua,
    _this = this;
  supportTouch = "ontouchstart" in window;
  /**
  * event wrapper valiable than touchstart or mousedown
  * タッチとマウスのスタート系イベントラッパー変数
  * @property press
  * @type str
  * @default undefined
  */

  this.press = (supportTouch ? "touchstart" : "mousedown");
  /**
  * event wrapper valiable than touchmove or mousemove
  * タッチとマウスのムーブ系イベントラッパー変数
  * @property move
  * @type str
  * @default undefined
  */

  this.move = (supportTouch ? "touchmove" : "mousemove");
  /**
  * event wrapper valiable than touchend or mouseup
  * タッチとマウスのエンド系イベントラッパー変数
  * @property release
  * @type str
  * @default undefined
  */

  this.release = (supportTouch ? "touchend" : "mouseup");
  getUa = function() {
    var OS, SP, TB, UA, VER, device, name, os, type, ver;
    UA = window.navigator.userAgent.toLowerCase();
    VER = window.navigator.appVersion.toLowerCase();
    OS = window.navigator.platform.toLowerCase();
    SP = "smartphone";
    TB = "tablet";
    if (UA.indexOf("ipad") !== -1 || UA.indexOf("ipod") !== -1 || UA.indexOf("iphone") !== -1) {
      os = "ios";
      if (UA.indexOf("4_") !== -1) {
        ver = 4;
      } else if (UA.indexOf("5_") !== -1) {
        ver = 5;
      } else if (UA.indexOf("6_") !== -1) {
        ver = 6;
      } else if (UA.indexOf("7_") !== -1) {
        ver = 7;
      }
      name = "safari";
      device = "ipad";
      type = TB;
      if (UA.indexOf("ipod") !== -1 || UA.indexOf("iphone") !== -1) {
        device = "ipod";
        type = SP;
        if (UA.indexOf("iphone") !== -1) {
          device = "iphone";
        }
      }
    } else if (UA.indexOf("android") !== -1) {
      os = "android";
      name = "androidbrowser";
      device = "androidtablet";
      type = TB;
      if (UA.indexOf("mobile") !== -1) {
        device = "android";
        type = SP;
      }
    } else if (UA.indexOf("windows phone") !== -1) {
      os = "windowsmobile";
      name = "ie";
      device = "windowsphone";
      type = SP;
      ver = 6;
      if (UA.indexOf("OS 7") !== -1) {
        ver = 7;
      }
    } else {
      os = "unix";
      if (OS.indexOf("win") !== -1) {
        os = "windows";
      }
      if (UA.match(/mac|ppc/)) {
        os = "macos";
      }
      if (UA.indexOf("msie") !== -1 || UA.indexOf("trident") !== -1) {
        name = "ie";
        if (VERSION.indexOf("msie 6.") !== -1) {
          ver = 6;
        } else if (VERSION.indexOf("msie 7.") !== -1) {
          ver = 7;
        } else if (VERSION.indexOf("msie 8.") !== -1) {
          ver = 8;
        } else if (VERSION.indexOf("msie 9.") !== -1) {
          ver = 9;
        } else if (VERSION.indexOf("msie 10.") !== -1) {
          ver = 10;
        } else {
          if (UA.indexOf("trident") !== -1) {
            ver = 11;
          }
        }
      } else if (UA.indexOf("chrome") !== -1) {
        name = "chrome";
      } else if (UA.indexOf("safari") !== -1) {
        name = "safari";
      } else if (UA.indexOf("gecko") !== -1) {
        name = "firefox";
      } else {
        if (UA.indexOf("opera") !== -1) {
          name = "opera";
        }
      }
    }
    return {
      device: "pc",
      type: "pc",
      os: os,
      name: name,
      version: ver
    };
  };
  ua = getUa();
  /**
  * device name
  * 端末名 （PCはPC ipad とか iphone とか android とか）
  * @property device
  * @type str
  * @default undefined
  */

  this.device = ua.device;
  /**
  * os name
  * OS名 （ windows macos unix ios android ）
  * @property os
  * @type str
  * @default undefined
  */

  this.os = ua.os;
  /**
  * device type ( "pc" or "tablet" or "smartphone" )
  * デバイスの種類 （ PC か tablet か smartphone ）
  * @property devicetype
  * @type str
  * @default undefined
  */

  this.devicetype = ua.type;
  /**
  * browser name
  * ブラウザ名
  * @property browser
  * @type str
  * @default undefined
  */

  this.browser = ua.name;
  /**
  * browser version ( suppourt ie or ios )
  * ブラウザのバージョン （IEとiOSしかサポートしてない）
  * @property device
  * @type str
  * @default undefined
  */

  this.browserver = ua.ver;
  this.is_devicetype = function(type) {
    type = type || "pc";
    if (type === "sp") {
      type = "smartphone";
    }
    if (_this.devicetype === type) {
      return true;
    } else {
      return false;
    }
  };
  this.is_browser = function(param) {
    param.name = param.name || "ie";
    param.ver = param.ver || void 0;
    if (_this.browser === param.name) {
      if (param.ver === void 0) {
        if (_this.browserver === param.version) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return false;
    }
  };
  more_browserver = function(param) {
    param.name = param.name || "ie";
    param.ver = param.ver || 6;
    if (_this.browser === param.name) {
      if (param.and === "more") {
        if (_this.browserver >= param.version) {
          return true;
        }
      } else if (param.and === "less") {
        if (_this.browserver <= param.version) {
          return true;
        }
      }
    }
  };
  /**
  * ブラウザが指定バージョンより上のバージョンか否かの判別メソッド
  * 主にIEで使用。パラメータのプロパティに name を入れれば他ブラウザに対応
  * @method andmore
  * @param obj @.name = str browsername @.ver = num version
  * @return boolen 指定バージョンより上のバージョンなら真
  */

  this.and_more = function(param) {
    param.and = param.and || "more";
    return more_browserver(param);
  };
  /**
  * ブラウザが指定バージョンより下のバージョンか否かの判別メソッド
  * 主にIEで使用。パラメータのプロパティに name を入れれば他ブラウザに対応
  * @method andless
  * @param obj @.name = str browsername @.ver = num version
  * @return boolen 指定バージョンより下のバージョンなら真
  */

  this.and_less = function(param) {
    param.and = param.and || "less";
    return more_browserver(param);
  };
  /**
  * デバイスの種類がpcか否かの判別メソッド
  * @method pc
  * @param null
  * @return boolen デバイスタイプがpcなら真
  */

  this.pc = function() {
    return _this.is_devicetype("pc");
  };
  /**
  * デバイスの種類がtabletか否かの判別メソッド
  * @method tablet
  * @param null
  * @return boolen デバイスタイプがtabletなら真
  */

  this.tablet = function() {
    return _this.is_devicetype("tablet");
  };
  /**
  * デバイスの種類がsmartphoneか否かの判別メソッド
  * @method smartphone
  * @param null
  * @return boolen デバイスタイプがsmartphoneなら真
  */

  this.smartphone = function() {
    return _this.is_devicetype("smartphone");
  };
  /**
  * IE6より上のバージョンか否かの判別メソッド
  * @method andmore_ie6
  * @param null
  * @return boolen IE6以上のブラウザなら真
  */

  this.andmore_ie6 = function() {
    return _this.and_more({
      ver: 6
    });
  };
  /**
  * IE7より上のバージョンか否かの判別メソッド
  * @method andmore_ie7
  * @param null
  * @return boolen IE7以上のブラウザなら真
  */

  this.andmore_ie7 = function() {
    return _this.and_more({
      ver: 7
    });
  };
  /**
  * IE8より上のバージョンか否かの判別メソッド
  * @method andmore_ie8
  * @param null
  * @return boolen IE8以上のブラウザなら真
  */

  this.andmore_ie8 = function() {
    return _this.and_more({
      ver: 8
    });
  };
  /**
  * IE9より上のバージョンか否かの判別メソッド
  * @method andmore_ie9
  * @param null
  * @return boolen IE9以上のブラウザなら真
  */

  this.andmore_ie9 = function() {
    return _this.and_more({
      ver: 9
    });
  };
  /**
  * IE6か否かの判別メソッド
  * @method ie6
  * @param null
  * @return boolen IE6なら真
  */

  this.ie = function() {
    return _this.is_browser({
      name: "ie"
    });
  };
  /**
  * IE6か否かの判別メソッド
  * @method ie6
  * @param null
  * @return boolen IE6なら真
  */

  this.ie6 = function() {
    return _this.is_browser({
      name: "ie",
      ver: 6
    });
  };
  /**
  * IE7か否かの判別メソッド
  * @method ie7
  * @param null
  * @return boolen IE7なら真
  */

  this.ie7 = function() {
    return _this.is_browser({
      name: "ie",
      ver: 7
    });
  };
  /**
  * IE8か否かの判別メソッド
  * @method ie8
  * @param null
  * @return boolen IE8なら真
  */

  this.ie8 = function() {
    return _this.is_browser({
      name: "ie",
      ver: 8
    });
  };
  /**
  * IE9か否かの判別メソッド
  * @method ie9
  * @param null
  * @return boolen IE9なら真
  */

  this.ie9 = function() {
    return _this.is_browser({
      name: "ie",
      ver: 9
    });
  };
  /**
  * IE10か否かの判別メソッド
  * @method ie10
  * @param null
  * @return boolen IE10なら真
  */

  this.ie10 = function() {
    return _this.is_browser({
      name: "ie",
      ver: 10
    });
  };
  /**
  * IE11か否かの判別メソッド
  * @method ie11
  * @param null
  * @return boolen IE11なら真
  */

  this.ie11 = function() {
    return _this.is_browser({
      name: "ie",
      ver: 11
    });
  };
  /**
  * firefoxか否かの判別メソッド
  * @method firefox
  * @param null
  * @return boolen firefoxなら真
  */

  this.firefox = function() {
    return _this.is_browser({
      name: "firefox"
    });
  };
  /**
  * chromeか否かの判別メソッド
  * @method chrome
  * @param null
  * @return boolen chromeなら真
  */

  this.chrome = function() {
    return _this.is_browser({
      name: "chrome"
    });
  };
  /**
  * safariか否かの判別メソッド
  * @method safari
  * @param null
  * @return boolen safariなら真
  */

  this.safari = function() {
    return _this.is_browser({
      name: "safari"
    });
  };
  /**
  * operaか否かの判別メソッド
  * @method opera
  * @param null
  * @return boolen operaなら真
  */

  this.opera = function() {
    return _this.is_browser({
      name: "opera"
    });
  };
  return this;
};

poke = new Pocket();
