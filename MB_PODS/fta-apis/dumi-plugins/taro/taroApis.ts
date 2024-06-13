
/**
 * 之前是通过导入taroApis的方式，如下：
 * import * as apis from '@tarojs/taro-h5/dist/taroApis'
 * 但升级到dumi2后，发现部分API会出现 not found 报错，具体原因不明
 * 故参考xrun文档处理方式，改为写死导出api的方式
 */
export default new Set([
  'addCard',
  'addFileToFavorites',
  'addInterceptor',
  'addPhoneCalendar',
  'addPhoneContact',
  'addPhoneRepeatCalendar',
  'addVideoToFavorites',
  'advancedGeneralIdentify',
  'animalClassify',
  'arrayBufferToBase64',
  'authPrivateMessage',
  'authorize',
  'authorizeForMiniProgram',
  'base64ToArrayBuffer',
  'canIUse',
  'canvasGetImageData',
  'canvasPutImageData',
  'canvasToTempFilePath',
  'carClassify',
  'checkIsOpenAccessibility',
  'checkIsSoterEnrolledInDevice',
  'checkIsSupportFacialRecognition',
  'checkIsSupportSoterAuthentication',
  'checkSession',
  'chooseAddress',
  'chooseContact',
  'chooseImage',
  'chooseInvoice',
  'chooseInvoiceTitle',
  'chooseLicensePlate',
  'chooseLocation',
  'chooseMedia',
  'chooseMessageFile',
  'choosePoi',
  'chooseVideo',
  'clearStorage',
  'clearStorageSync',
  'closeBLEConnection',
  'closeBluetoothAdapter',
  'closeSocket',
  'cloud',
  'compressImage',
  'compressVideo',
  'connectSocket',
  'connectWifi',
  'createAnimation',
  'createAudioContext',
  'createBLEConnection',
  'createBLEPeripheralServer',
  'createBufferURL',
  'createCameraContext',
  'createCanvasContext',
  'createInnerAudioContext',
  'createIntersectionObserver',
  'createInterstitialAd',
  'createLivePlayerContext',
  'createLivePusherContext',
  'createMapContext',
  'createMediaAudioPlayer',
  'createMediaContainer',
  'createMediaRecorder',
  'createOffscreenCanvas',
  'createRewardedVideoAd',
  'createSelectorQuery',
  'createTCPSocket',
  'createUDPSocket',
  'createVKSession',
  'createVideoContext',
  'createVideoDecoder',
  'createWebAudioContext',
  'createWorker',
  'disableAlertBeforeUnload',
  'dishClassify',
  'downloadFile',
  'enableAlertBeforeUnload',
  'exitMiniProgram',
  'exitVoIPChat',
  'faceDetect',
  'faceVerifyForPay',
  'getAccountInfoSync',
  'getApp',
  'getAppAuthorizeSetting',
  'getAppBaseInfo',
  'getAvailableAudioSources',
  'getBLEDeviceCharacteristics',
  'getBLEDeviceRSSI',
  'getBLEDeviceServices',
  'getBLEMTU',
  'getBackgroundAudioManager',
  'getBackgroundAudioPlayerState',
  'getBackgroundFetchData',
  'getBackgroundFetchToken',
  'getBatteryInfo',
  'getBatteryInfoSync',
  'getBeacons',
  'getBluetoothAdapterState',
  'getBluetoothDevices',
  'getChannelsLiveInfo',
  'getChannelsLiveNoticeInfo',
  'getClipboardData',
  'getConnectedBluetoothDevices',
  'getConnectedWifi',
  'getCurrentInstance',
  'getCurrentPages',
  'getDeviceInfo',
  'getEnterOptionsSync',
  'getExptInfoSync',
  'getExtConfig',
  'getExtConfigSync',
  'getFileInfo',
  'getFileSystemManager',
  'getFuzzyLocation',
  'getGroupEnterInfo',
  'getHCEState',
  'getImageInfo',
  'getLaunchOptionsSync',
  'getLocalIPAddress',
  'getLocation',
  'getLogManager',
  'getMenuButtonBoundingClientRect',
  'getNFCAdapter',
  'getNetworkType',
  'getOpenUserInfo',
  'getPerformance',
  'getRandomValues',
  'getRealtimeLogManager',
  'getRecorderManager',
  'getSavedFileInfo',
  'getSavedFileList',
  'getScreenBrightness',
  'getSelectedTextRange',
  'getSetting',
  'getShareInfo',
  'getStorage',
  'getStorageInfo',
  'getStorageInfoSync',
  'getStorageSync',
  'getSwanId',
  'getSystemInfo',
  'getSystemInfoAsync',
  'getSystemInfoSync',
  'getSystemSetting',
  'getUpdateManager',
  'getUserCryptoManager',
  'getUserInfo',
  'getUserProfile',
  'getVideoInfo',
  'getWeRunData',
  'getWifiList',
  'getWindowInfo',
  'hideHomeButton',
  'hideKeyboard',
  'hideLoading',
  'hideNavigationBarLoading',
  'hideShareMenu',
  'hideTabBar',
  'hideTabBarRedDot',
  'hideToast',
  'imageAudit',
  'initFaceDetect',
  'initTabBarApis',
  'isBluetoothDevicePaired',
  'isVKSupport',
  'joinVoIPChat',
  'loadFontFace',
  'login',
  'logoClassify',
  'makeBluetoothPair',
  'makePhoneCall',
  'navigateBack',
  'navigateBackMiniProgram',
  'navigateBackSmartProgram',
  'navigateTo',
  'navigateToMiniProgram',
  'navigateToSmartGameProgram',
  'navigateToSmartProgram',
  'nextTick',
  'notifyBLECharacteristicValueChange',
  'objectDetectIdentify',
  'ocrBankCard',
  'ocrDrivingLicense',
  'ocrIdCard',
  'ocrVehicleLicense',
  'offAccelerometerChange',
  'offAppHide',
  'offAppShow',
  'offAudioInterruptionBegin',
  'offAudioInterruptionEnd',
  'offBLECharacteristicValueChange',
  'offBLEConnectionStateChange',
  'offBLEMTUChange',
  'offBLEPeripheralConnectionStateChanged',
  'offBeaconServiceChange',
  'offBeaconUpdate',
  'offBluetoothAdapterStateChange',
  'offBluetoothDeviceFound',
  'offCompassChange',
  'offCopyUrl',
  'offDeviceMotionChange',
  'offError',
  'offGetWifiList',
  'offGyroscopeChange',
  'offHCEMessage',
  'offKeyboardHeightChange',
  'offLocalServiceDiscoveryStop',
  'offLocalServiceFound',
  'offLocalServiceLost',
  'offLocalServiceResolveFail',
  'offLocationChange',
  'offLocationChangeError',
  'offMemoryWarning',
  'offNetworkStatusChange',
  'offNetworkWeakChange',
  'offPageNotFound',
  'offThemeChange',
  'offUnhandledRejection',
  'offUserCaptureScreen',
  'offVoIPChatInterrupted',
  'offVoIPChatMembersChanged',
  'offVoIPChatStateChanged',
  'offVoIPVideoMembersChanged',
  'offWifiConnected',
  'offWindowResize',
  'onAccelerometerChange',
  'onAppHide',
  'onAppShow',
  'onAudioInterruptionBegin',
  'onAudioInterruptionEnd',
  'onBLECharacteristicValueChange',
  'onBLEConnectionStateChange',
  'onBLEMTUChange',
  'onBLEPeripheralConnectionStateChanged',
  'onBackgroundAudioPause',
  'onBackgroundAudioPlay',
  'onBackgroundAudioStop',
  'onBackgroundFetchData',
  'onBeaconServiceChange',
  'onBeaconUpdate',
  'onBluetoothAdapterStateChange',
  'onBluetoothDeviceFound',
  'onCompassChange',
  'onCopyUrl',
  'onDeviceMotionChange',
  'onError',
  'onGetWifiList',
  'onGyroscopeChange',
  'onHCEMessage',
  'onKeyboardHeightChange',
  'onLocalServiceDiscoveryStop',
  'onLocalServiceFound',
  'onLocalServiceLost',
  'onLocalServiceResolveFail',
  'onLocationChange',
  'onLocationChangeError',
  'onMemoryWarning',
  'onNetworkStatusChange',
  'onNetworkWeakChange',
  'onPageNotFound',
  'onSocketClose',
  'onSocketError',
  'onSocketMessage',
  'onSocketOpen',
  'onThemeChange',
  'onUnhandledRejection',
  'onUserCaptureScreen',
  'onVoIPChatInterrupted',
  'onVoIPChatMembersChanged',
  'onVoIPChatSpeakersChanged',
  'onVoIPChatStateChanged',
  'onVoIPVideoMembersChanged',
  'onWifiConnected',
  'onWifiConnectedWithPartialInfo',
  'onWindowResize',
  'openAppAuthorizeSetting',
  'openBluetoothAdapter',
  'openBusinessView',
  'openCard',
  'openChannelsActivity',
  'openChannelsEvent',
  'openChannelsLive',
  'openCustomerServiceChat',
  'openDocument',
  'openEmbeddedMiniProgram',
  'openLocation',
  'openSetting',
  'openSystemBluetoothSetting',
  'openVideoEditor',
  'pageScrollTo',
  'pauseBackgroundAudio',
  'pauseVoice',
  'plantClassify',
  'playBackgroundAudio',
  'playVoice',
  'pluginLogin',
  'preloadSubPackage',
  'previewImage',
  'previewMedia',
  'reLaunch',
  'readBLECharacteristicValue',
  'redirectTo',
  'removeSavedFile',
  'removeStorage',
  'removeStorageSync',
  'removeTabBarBadge',
  'reportAnalytics',
  'reportEvent',
  'reportMonitor',
  'reportPerformance',
  'request',
  'requestOrderPayment',
  'requestPayment',
  'requestPolymerPayment',
  'requestSubscribeMessage',
  'reserveChannelsLive',
  'revokeBufferURL',
  'saveFile',
  'saveFileToDisk',
  'saveImageToPhotosAlbum',
  'saveVideoToPhotosAlbum',
  'scanCode',
  'seekBackgroundAudio',
  'sendHCEMessage',
  'sendSocketMessage',
  'setBLEMTU',
  'setBackgroundColor',
  'setBackgroundFetchToken',
  'setBackgroundTextStyle',
  'setClipboardData',
  'setEnable1v1Chat',
  'setEnableDebug',
  'setInnerAudioOption',
  'setKeepScreenOn',
  'setNavigationBarColor',
  'setNavigationBarTitle',
  'setPageInfo',
  'setScreenBrightness',
  'setStorage',
  'setStorageSync',
  'setTabBarBadge',
  'setTabBarItem',
  'setTabBarStyle',
  'setTopBarText',
  'setVisualEffectOnCapture',
  'setWifiList',
  'setWindowSize',
  'shareFileMessage',
  'shareToWeRun',
  'shareVideoMessage',
  'showActionSheet',
  'showLoading',
  'showModal',
  'showNavigationBarLoading',
  'showRedPackage',
  'showShareImageMenu',
  'showShareMenu',
  'showTabBar',
  'showTabBarRedDot',
  'showToast',
  'startAccelerometer',
  'startBeaconDiscovery',
  'startBluetoothDevicesDiscovery',
  'startCompass',
  'startDeviceMotionListening',
  'startFacialRecognitionVerify',
  'startFacialRecognitionVerifyAndUploadVideo',
  'startGyroscope',
  'startHCE',
  'startLocalServiceDiscovery',
  'startLocationUpdate',
  'startLocationUpdateBackground',
  'startPullDownRefresh',
  'startRecord',
  'startSoterAuthentication',
  'startWifi',
  'stopAccelerometer',
  'stopBackgroundAudio',
  'stopBeaconDiscovery',
  'stopBluetoothDevicesDiscovery',
  'stopCompass',
  'stopDeviceMotionListening',
  'stopFaceDetect',
  'stopGyroscope',
  'stopHCE',
  'stopLocalServiceDiscovery',
  'stopLocationUpdate',
  'stopPullDownRefresh',
  'stopRecord',
  'stopVoice',
  'stopWifi',
  'subscribeVoIPVideoMembers',
  'switchTab',
  'textReview',
  'textToAudio',
  'updateShareMenu',
  'updateVoIPChatMuteConfig',
  'updateWeChatApp',
  'uploadFile',
  'vibrateLong',
  'vibrateShort',
  'writeBLECharacteristicValue',
]);
