import QtQuick 2.1
import qb.components 1.0
import BasicUIControls 1.0

Screen {
  id : homeWizardScreen2
  screenTitle : qsTr("HomeWizard Thuisbatterijen")

// ---- Properties

// -------- Control properties

  property bool debug : false // used to (de)activate app.log messages

  property bool activeMe : false  // used to enable/disable calls to updateScreenData()

// -------- Screen properties

  property variant days : ["Zondag", "Maandag", "Dinsdag", "Woensdag", "Donderdag", "Vrijdag", "Zaterdag" ]

  property int rowHeight : isNxt ?  45 :  36
  property int name_width : isNxt ? 190 : 152
  property int watts_width : isNxt ? 150 : 120
  property int kWh_width : isNxt ? 175 : 140
  property int level_width : isNxt ? 70 : 48
  property int wifi_width : isNxt ? 100 : 80
  property int buttonWidth : isNxt ? 105 :  84

  property int buttonborderwidth : 0
  property int buttonmargin : 4
  property int textmargin : 10

  property int namebuttonborderwidth : 0

// ---- Functions

// -------- Function onVisibleChanged

  onVisibleChanged: {

    if (visible) {

//  List all properties of some object to find what you can change
//      app.dumpProperties(scrollbar.childrenRect, "scrollbar.childrenRect")
//      app.dumpProperties(inputIP, "inputIP")

      app.activeScreen = 2

      activeMe = true

      appSetupScreen.visible = false
      batterySettingsPanel.visible = false
      batterySettingsPanelHelp.visible = false

      batterySettingsPanelHelp.visible = true
      var i = 0
      for (i = 0 ; i < 9 ; i++ ) {
        batterySettingsPanelHelp.visible = batterySettingsPanelHelp.visible
          && ( ! app.batteryActive[i] )
      }

      updateScreenConfiguration()
      updateScreenData()

    } else {
      app.settingsActive = false
      activeMe = false
    }
  }

// -------- Function onDimStateChanged

  onDimStateChanged: {
    if (dimState){
      activeMe = false
    }
  }

// -------- Function updateScreenConfiguration

  function updateScreenConfiguration() {

    if ( activeMe ) {

      row_0.visible = ( app.batteryActive[0] && app.batteryVisible[0])
      row_1.visible = ( app.batteryActive[1] && app.batteryVisible[1])
      row_2.visible = ( app.batteryActive[2] && app.batteryVisible[2])
      row_3.visible = ( app.batteryActive[3] && app.batteryVisible[3])

      batteryName_0.buttonText = app.batteryName[0];
      batteryName_1.buttonText = app.batteryName[1];
      batteryName_2.buttonText = app.batteryName[2];
      batteryName_3.buttonText = app.batteryName[3];

      // Setup Screen

      p0.checked = (app.homeWizardDataOnTile == app.homeWizardDataOnTileLogo)
      p1.checked = (app.homeWizardDataOnTile == app.homeWizardDataOnTileText)
      p2.checked = (app.homeWizardDataOnTile == app.homeWizardDataOnTileNow)
      p3.checked = (app.homeWizardDataOnTile == app.homeWizardDataOnTileP1Meter)
      p4.checked = (app.homeWizardDataOnTile == app.homeWizardDataOnTileP1MeterBatteryLevel)

      // k1 .. k5 for kWh selection
      k1.checked = (app.batterykWhColumn == app.kWhToday)
      k2.checked = (app.batterykWhColumn == app.kWhWeek)
      k3.checked = (app.batterykWhColumn == app.kWhMonth)
      k4.checked = (app.batterykWhColumn == app.kWhMinOffset)
      k5.checked = (app.batterykWhColumn == app.kWhTotal)

      kWhDecimalsvalue.text = app.batterykWhDecimals

      // w1 .. w2 for wifi strength scale
      w1.checked = (app.batterywifidBm)
      w2.checked = (! app.batterywifidBm)

    }
  }

// -------- Function updateScreenData

  function wattsNow(index) {
    return ( app.batteryWatts[index].toFixed(1) )
  }

  function kWhImportValue(index) {
    var result = 0
    switch ( app.batterykWhColumn )  {
      case app.kWhToday:
        result = (app.batteryKWHImport[index] - app.batteryKWHImportYesterday[index]).toFixed(app.batterykWhDecimals)
        break;
      case app.kWhWeek:
        result = (app.batteryKWHImport[index] - app.batteryKWHImportLastWeek[index]).toFixed(app.batterykWhDecimals)
        break;
      case app.kWhMonth:
        result = (app.batteryKWHImport[index] - app.batteryKWHImportLastMonth[index]).toFixed(app.batterykWhDecimals)
        break;
      case app.kWhMinOffset: // deviceKWHOffset
        result = (app.batteryKWHImport[index] - app.batteryKWHImportOffset[index]).toFixed(app.batterykWhDecimals)
        break;
      case app.kWhTotal:
        result = app.batteryKWHImport[index].toFixed(app.batterykWhDecimals)
    }
    // just after startup every app.batteryKWHImport[index] is 0 and calculated results are negative ;-)
    if ( result < 0 ) { result = 0 }
    return result
  }

  function kWhExportValue(index) {
    var result = 0
    switch ( app.batterykWhColumn )  {
      case app.kWhToday:
        result = (app.batteryKWHExport[index] - app.batteryKWHExportYesterday[index]).toFixed(app.batterykWhDecimals)
        break;
      case app.kWhWeek:
        result = (app.batteryKWHExport[index] - app.batteryKWHExportLastWeek[index]).toFixed(app.batterykWhDecimals)
        break;
      case app.kWhMonth:
        result = (app.batteryKWHExport[index] - app.batteryKWHExportLastMonth[index]).toFixed(app.batterykWhDecimals)
        break;
      case app.kWhMinOffset: // deviceKWHOffset
        result = (app.batteryKWHExport[index] - app.batteryKWHExportOffset[index]).toFixed(app.batterykWhDecimals)
        break;
      case app.kWhTotal:
        result = app.batteryKWHExport[index].toFixed(app.batterykWhDecimals)
    }
    // just after startup every app.batteryKWHExport[index] is 0 and calculated results are negative ;-)
    if ( result < 0 ) { result = 0 }
    return result
  }

  function updateScreenData() {

    if ( activeMe ) {

      var showError = ! ( app.deviceOke[0] && app.deviceOke[1] &&
                              app.deviceOke[2] && app.deviceOke[3] &&
                              app.deviceOke[4] && app.deviceOke[5] &&
                              app.deviceOke[6] && app.deviceOke[7] &&
                              app.deviceOke[8] )

      energysocketsScreenButton.buttonActiveColor = showError ? app.errorColor : "#dcdcdc"

      setup_IP_0.buttonActiveColor = app.batteryOke[0] ? "#cdcdcd" : app.errorColor
      setup_IP_1.buttonActiveColor = app.batteryOke[1] ? "#cdcdcd" : app.errorColor
      setup_IP_2.buttonActiveColor = app.batteryOke[2] ? "#cdcdcd" : app.errorColor
      setup_IP_3.buttonActiveColor = app.batteryOke[3] ? "#cdcdcd" : app.errorColor

      battery_level_0_Text.text = app.batteryLevel[0] + " %"
      battery_level_1_Text.text = app.batteryLevel[1] + " %"
      battery_level_2_Text.text = app.batteryLevel[2] + " %"
      battery_level_3_Text.text = app.batteryLevel[3] + " %"

      batteryWatts_0_Text.text = wattsNow(0) + " Watt"
      batteryWatts_1_Text.text = wattsNow(1) + " Watt"
      batteryWatts_2_Text.text = wattsNow(2) + " Watt"
      batteryWatts_3_Text.text = wattsNow(3) + " Watt"

      batteryKWHImport_0_Text.text = kWhImportValue(0) + " kWh"
      batteryKWHImport_1_Text.text = kWhImportValue(1) + " kWh"
      batteryKWHImport_2_Text.text = kWhImportValue(2) + " kWh"
      batteryKWHImport_3_Text.text = kWhImportValue(3) + " kWh"

      batteryKWHExport_0_Text.text = kWhExportValue(0) + " kWh"
      batteryKWHExport_1_Text.text = kWhExportValue(1) + " kWh"
      batteryKWHExport_2_Text.text = kWhExportValue(2) + " kWh"
      batteryKWHExport_3_Text.text = kWhExportValue(3) + " kWh"

      if ( app.batterywifidBm ) {
        battery_wifi_0_Text.text = app.battery_wifi[0]+" dBm"
        battery_wifi_1_Text.text = app.battery_wifi[1]+" dBm"
        battery_wifi_2_Text.text = app.battery_wifi[2]+" dBm"
        battery_wifi_3_Text.text = app.battery_wifi[3]+" dBm"
      } else { // I have seen signal strengtsh of -40 dBm on batteries
        battery_wifi_0_Text.text = Math.min(100, Math.max(0, ( (parseFloat(app.battery_wifi[0]) + 90) * 2) ) ) +" %"
        battery_wifi_1_Text.text = Math.min(100, Math.max(0, ( (parseFloat(app.battery_wifi[1]) + 90) * 2) ) ) +" %"
        battery_wifi_2_Text.text = Math.min(100, Math.max(0, ( (parseFloat(app.battery_wifi[2]) + 90) * 2) ) ) +" %"
        battery_wifi_3_Text.text = Math.min(100, Math.max(0, ( (parseFloat(app.battery_wifi[3]) + 90) * 2) ) ) +" %"
      }

      var ii = 0
      var count = 0
      var level = 0
      var watts = 0
      var kWhImport = 0
      var kWhExport = 0
      for ( ii = 0; ii < 4; ii++) {
        if (app.batteryActive[ii]) {
          if ( app.batteryIP.indexOf(app.batteryIP[ii]) == ii ) {
            count=count+1
            watts = watts + app.batteryWatts[ii]
            level = level + app.batteryLevel[ii]
            kWhImport = kWhImport + parseFloat(kWhImportValue(ii))
            kWhExport = kWhExport + parseFloat(kWhExportValue(ii))
          }
        }
      }
      if (count > 1) {
        level = (level / count).toFixed(0)
      }
      battery_level_4_Text.text = level + " %"
      batteryWatts_4_Text.text = watts.toFixed(1) + " Watt"
      batteryKWHImport_4_Text.text = kWhImport.toFixed(app.batterykWhDecimals) + " kWh"
      batteryKWHExport_4_Text.text = kWhExport.toFixed(app.batterykWhDecimals) + " kWh"

    }
  }

// ---- Screen

// --------- Battery IP Setup Buttons

  YaLabel {
    id : setup_IP_0
    buttonBorderWidth : buttonborderwidth
    height : rowHeight
    width : rowHeight
    buttonActiveColor : "transparent"
    buttonHoverColor : buttonActiveColor
    buttonSelectedColor : buttonActiveColor
    hoveringEnabled : isNxt
    anchors {
      top : parent.top
      left : parent.left
      topMargin : 3 * ( rowHeight + buttonmargin)  + rowHeight / 2
      leftMargin : rowHeight
    }
    onClicked : { batterySettingsPanel.editBatterySettings(0) }
    Image {
      source : "file:///qmf/qml/apps/toonHomeWizard/drawables/battery.png"
      sourceSize.width: rowHeight
      sourceSize.height: rowHeight
    }
  }

  YaLabel {
    id : setup_IP_1
    buttonBorderWidth : buttonborderwidth
    height : rowHeight
    width : rowHeight
    buttonActiveColor : "transparent"
    buttonHoverColor : buttonActiveColor
    buttonSelectedColor : buttonActiveColor
    hoveringEnabled : isNxt
    anchors {
      top : setup_IP_0.bottom
      left : setup_IP_0.left
      topMargin : buttonmargin
    }
    onClicked : { batterySettingsPanel.editBatterySettings(1) }
    Image {
      source : "file:///qmf/qml/apps/toonHomeWizard/drawables/battery.png"
      sourceSize.width: rowHeight
      sourceSize.height: rowHeight
    }
  }

  YaLabel {
    id : setup_IP_2
    buttonBorderWidth : buttonborderwidth
    height : rowHeight
    width : rowHeight
    buttonActiveColor : "transparent"
    buttonHoverColor : buttonActiveColor
    buttonSelectedColor : buttonActiveColor
    hoveringEnabled : isNxt
    anchors {
      top : setup_IP_1.bottom
      left : setup_IP_1.left
      topMargin : buttonmargin
    }
    onClicked : { batterySettingsPanel.editBatterySettings(2) }
    Image {
      source : "file:///qmf/qml/apps/toonHomeWizard/drawables/battery.png"
      sourceSize.width: rowHeight
      sourceSize.height: rowHeight
    }
  }

  YaLabel {
    id : setup_IP_3
    buttonBorderWidth : buttonborderwidth
    height : rowHeight
    width : rowHeight
    buttonActiveColor : "transparent"
    buttonHoverColor : buttonActiveColor
    buttonSelectedColor : buttonActiveColor
    hoveringEnabled : isNxt
    anchors {
      top : setup_IP_2.bottom
      left : setup_IP_2.left
      topMargin : buttonmargin
    }
    onClicked : { batterySettingsPanel.editBatterySettings(3) }
    Image {
      source : "file:///qmf/qml/apps/toonHomeWizard/drawables/battery.png"
      sourceSize.width: rowHeight
      sourceSize.height: rowHeight
    }
  }

  YaLabel {
    id : energysocketsScreenButton
    buttonBorderWidth : buttonborderwidth
    height : rowHeight * 1.5
    width : rowHeight * 4
    buttonActiveColor : "#dcdcdc"
    buttonHoverColor : buttonActiveColor
    buttonSelectedColor : buttonActiveColor
    hoveringEnabled : isNxt
    anchors {
        bottom : parent.top
        left : parent.left
        bottomMargin : rowHeight * -0.5
        leftMargin : rowHeight * 2
    }
    onClicked : { stage.openFullscreen(app.homeWizardScreen1URL); }
    Image {
      id : energysocketScreenPicture
      source : "file:///qmf/qml/apps/toonHomeWizard/drawables/energysocket.png"
      sourceSize.width: rowHeight * 1.5
      sourceSize.height: rowHeight * 1.5
      anchors {
        verticalCenter : parent.verticalCenter
        right : parent.horizontalCenter
        rightMargin : 5
      }
    }
    Image {
      id : p1MeterScreenPicture
      source : "file:///qmf/qml/apps/toonHomeWizard/drawables/p1meter.png"
      sourceSize.width: rowHeight * 1.5
      sourceSize.height: rowHeight * 1.5
      anchors {
        verticalCenter : parent.verticalCenter
        left : parent.horizontalCenter
        leftMargin : 5
      }
    }
  }

// -------- Battery Rows

// ------------ Battery Row 0

  Rectangle {
    id : row_0
    anchors {
      verticalCenter : setup_IP_0.verticalCenter
      left : setup_IP_0.right
    }

    YaLabel {
      id : batteryName_0
      buttonBorderWidth : namebuttonborderwidth
      height : rowHeight
      width : name_width
      buttonActiveColor : "#cdcdcd"
      buttonHoverColor : buttonActiveColor
      buttonSelectedColor : buttonActiveColor
      hoveringEnabled : isNxt
      anchors {
        verticalCenter : parent.verticalCenter
        left : parent.left
        leftMargin : buttonmargin
      }
    }

    Rectangle {
      id : battery_level_0
      height : rowHeight
      width : level_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : batteryName_0.right
        leftMargin : buttonmargin
      }
      Text {
        id : battery_level_0_Text
        width : level_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "Level field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : batteryWatts_0
      height : rowHeight
      width : watts_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : battery_level_0.right
        leftMargin : buttonmargin
      }
      Text {
        id : batteryWatts_0_Text
        width : watts_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "Watts field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : batteryKWHImport_0
      height : rowHeight
      width : kWh_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : batteryWatts_0.right
        leftMargin : buttonmargin
      }
      Text {
        id : batteryKWHImport_0_Text
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "kWh field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : batteryKWHExport_0
      height : rowHeight
      width : kWh_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : batteryKWHImport_0.right
        leftMargin : buttonmargin
      }
      Text {
        id : batteryKWHExport_0_Text
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "kWh field export"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : battery_wifi_0
      height : rowHeight
      width : wifi_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : batteryKWHExport_0.right
        leftMargin : buttonmargin
      }
      Text {
        id : battery_wifi_0_Text
        width : wifi_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "WiFi field"
        lineHeight : 1.0
        color : "black"
      }
    }

  }

// ------------ Battery Row 1

  Rectangle {
    id : row_1
    anchors {
      verticalCenter : setup_IP_1.verticalCenter
      left : setup_IP_1.right
    }

    YaLabel {
      id : batteryName_1
      buttonBorderWidth : namebuttonborderwidth
      height : rowHeight
      width : name_width
      buttonActiveColor : "#cdcdcd"
      buttonHoverColor : buttonActiveColor
      buttonSelectedColor : buttonActiveColor
      hoveringEnabled : isNxt
      anchors {
        verticalCenter : parent.verticalCenter
        left : parent.left
        leftMargin : buttonmargin
      }
    }

    Rectangle {
      id : battery_level_1
      height : rowHeight
      width : level_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : batteryName_1.right
        leftMargin : buttonmargin
      }
      Text {
        id : battery_level_1_Text
        width : level_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "Level field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : batteryWatts_1
      height : rowHeight
      width : watts_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : battery_level_1.right
        leftMargin : buttonmargin
      }
      Text {
        id : batteryWatts_1_Text
        width : watts_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "Watts field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : batteryKWHImport_1
      height : rowHeight
      width : kWh_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : batteryWatts_1.right
        leftMargin : buttonmargin
      }
      Text {
        id : batteryKWHImport_1_Text
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "kWh field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : batteryKWHExport_1
      height : rowHeight
      width : kWh_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : batteryKWHImport_1.right
        leftMargin : buttonmargin
      }
      Text {
        id : batteryKWHExport_1_Text
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "kWh field export"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : battery_wifi_1
      height : rowHeight
      width : wifi_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : batteryKWHExport_1.right
        leftMargin : buttonmargin
      }
      Text {
        id : battery_wifi_1_Text
        width : wifi_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "WiFi field"
        lineHeight : 1.0
        color : "black"
      }
    }

  }

// ------------ Battery Row 2

  Rectangle {
    id : row_2
    anchors {
      verticalCenter : setup_IP_2.verticalCenter
      left : setup_IP_2.right
    }

    YaLabel {
      id : batteryName_2
      buttonBorderWidth : namebuttonborderwidth
      height : rowHeight
      width : name_width
      buttonActiveColor : "#cdcdcd"
      buttonHoverColor : buttonActiveColor
      buttonSelectedColor : buttonActiveColor
      hoveringEnabled : isNxt
      anchors {
        verticalCenter : parent.verticalCenter
        left : parent.left
        leftMargin : buttonmargin
      }
    }

    Rectangle {
      id : battery_level_2
      height : rowHeight
      width : level_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : batteryName_2.right
        leftMargin : buttonmargin
      }
      Text {
        id : battery_level_2_Text
        width : level_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "Level field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : batteryWatts_2
      height : rowHeight
      width : watts_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : battery_level_2.right
        leftMargin : buttonmargin
      }
      Text {
        id : batteryWatts_2_Text
        width : watts_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "Watts field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : batteryKWHImport_2
      height : rowHeight
      width : kWh_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : batteryWatts_2.right
        leftMargin : buttonmargin
      }
      Text {
        id : batteryKWHImport_2_Text
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "kWh field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : batteryKWHExport_2
      height : rowHeight
      width : kWh_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : batteryKWHImport_2.right
        leftMargin : buttonmargin
      }
      Text {
        id : batteryKWHExport_2_Text
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "kWh field export"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : battery_wifi_2
      height : rowHeight
      width : wifi_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : batteryKWHExport_2.right
        leftMargin : buttonmargin
      }
      Text {
        id : battery_wifi_2_Text
        width : wifi_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "WiFi field"
        lineHeight : 1.0
        color : "black"
      }
    }

  }

// ------------ Battery Row 3

  Rectangle {
    id : row_3
    anchors {
      verticalCenter : setup_IP_3.verticalCenter
      left : setup_IP_3.right
    }

    YaLabel {
      id : batteryName_3
      buttonBorderWidth : namebuttonborderwidth
      height : rowHeight
      width : name_width
      buttonActiveColor : "#cdcdcd"
      buttonHoverColor : buttonActiveColor
      buttonSelectedColor : buttonActiveColor
      hoveringEnabled : isNxt
      anchors {
        verticalCenter : parent.verticalCenter
        left : parent.left
        leftMargin : buttonmargin
      }
    }

    Rectangle {
      id : battery_level_3
      height : rowHeight
      width : level_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : batteryName_3.right
        leftMargin : buttonmargin
      }
      Text {
        id : battery_level_3_Text
        width : level_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "Level field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : batteryWatts_3
      height : rowHeight
      width : watts_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : battery_level_3.right
        leftMargin : buttonmargin
      }
      Text {
        id : batteryWatts_3_Text
        width : watts_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "Watts field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : batteryKWHImport_3
      height : rowHeight
      width : kWh_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : batteryWatts_3.right
        leftMargin : buttonmargin
      }
      Text {
        id : batteryKWHImport_3_Text
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "kWh field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : batteryKWHExport_3
      height : rowHeight
      width : kWh_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : batteryKWHImport_3.right
        leftMargin : buttonmargin
      }
      Text {
        id : batteryKWHExport_3_Text
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "kWh field export"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : battery_wifi_3
      height : rowHeight
      width : wifi_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : batteryKWHExport_3.right
        leftMargin : buttonmargin
      }
      Text {
        id : battery_wifi_3_Text
        width : wifi_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "WiFi field"
        lineHeight : 1.0
        color : "black"
      }
    }

  }

// ------------ Battery Row 4

  Rectangle {
    id : row_4
    anchors {
//      top : setup_IP_3.bottom
//      left : setup_IP_3.right
//      topMargin : rowHeight
      bottom  : setup_IP_0.top
      bottomMargin : rowHeight
      left : setup_IP_0.right
    }

    YaLabel {
      id : batteryName_4
      buttonText : "Summary"
      buttonBorderWidth : namebuttonborderwidth
      height : rowHeight
      width : name_width
      buttonActiveColor : "#cdcdcd"
      buttonHoverColor : buttonActiveColor
      buttonSelectedColor : buttonActiveColor
      hoveringEnabled : isNxt
      anchors {
        verticalCenter : parent.verticalCenter
        left : parent.left
        leftMargin : buttonmargin
      }
    }

    Rectangle {
      id : battery_level_4
      height : rowHeight
      width : level_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : batteryName_4.right
        leftMargin : buttonmargin
      }
      Text {
        id : battery_level_4_Text
        width : level_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "Level field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : batteryWatts_4
      height : rowHeight
      width : watts_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : battery_level_4.right
        leftMargin : buttonmargin
      }
      Text {
        id : batteryWatts_4_Text
        width : watts_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "Watts field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : batteryKWHImport_4
      height : rowHeight
      width : kWh_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : batteryWatts_4.right
        leftMargin : buttonmargin
      }
      Text {
        id : batteryKWHImport_4_Text
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "kWh field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : batteryKWHExport_4
      height : rowHeight
      width : kWh_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : batteryKWHImport_4.right
        leftMargin : buttonmargin
      }
      Text {
        id : batteryKWHExport_4_Text
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "kWh field export"
        lineHeight : 1.0
        color : "black"
      }
    }

  }


// ------------ APP Setup screen

// ------------ APP Setup screen Button

  YaLabel {
    id : toggleAppSetupScreen
    buttonBorderWidth : buttonborderwidth
    height : rowHeight
    width : rowHeight
    buttonActiveColor : "transparent"
    buttonHoverColor : buttonActiveColor
    buttonSelectedColor : buttonActiveColor
    hoveringEnabled : isNxt
    anchors {
      bottom : parent.bottom
      right : parent.right
      rightMargin : rowHeight
      bottomMargin : rowHeight / 2
    }

    onClicked : {
      app.settingsActive = true // block data collection
      appSetupScreen.visible = true
      batterySettingsPanel.visible = false
      batterySettingsPanelHelp.visible = false
      var today = new Date();
      var strTime=("00"+today.getHours()).slice(-2)+":"+("00"+(today.getMinutes())).slice(-2)
      var strDate=days[today.getDay()] + " "+("00"+today.getDate()).slice(-2)+"-"+("00"+(today.getMonth()+1)).slice(-2)+"-"+today.getFullYear()
      p2OptionText.text = strTime + " " + strDate
    }
    Image {
      id : toggleAppSetupScreenPicture
      source : "file:///qmf/qml/apps/toonHomeWizard/drawables/settings.png"
    }
  }


// ------------ APP Setup screen Rectangle

  Rectangle {
    id : appSetupScreen
    visible : false

    height : parent.height

    width : parent.width - 20
    color : "#dcdcdc"
    radius : 8
    border {
      width : 2
      color : "black"
    }

    anchors {
      top : parent.top
      horizontalCenter : parent.horizontalCenter
    }

    // block clicks to all items in the back
    MouseArea {
      anchors.fill : parent
      acceptedButtons : Qt.AllButtons
      propagateComposedEvents: false
    }

// ------------ Function appSettingsSave

    function appSettingsSave() {
      debug && app.log("Screen Save APP Settings")

      if ( p0.checked ) { app.homeWizardDataOnTile = app.homeWizardDataOnTileLogo }
      if ( p1.checked ) { app.homeWizardDataOnTile = app.homeWizardDataOnTileText }
      if ( p2.checked ) { app.homeWizardDataOnTile = app.homeWizardDataOnTileNow }
      if ( p3.checked ) { app.homeWizardDataOnTile = app.homeWizardDataOnTileP1Meter }
      if ( p4.checked ) { app.homeWizardDataOnTile = app.homeWizardDataOnTileP1MeterBatteryLevel }

      if ( k1.checked ) { app.batterykWhColumn = app.kWhToday }
      if ( k2.checked ) { app.batterykWhColumn = app.kWhWeek }
      if ( k3.checked ) { app.batterykWhColumn = app.kWhMonth }
      if ( k4.checked ) { app.batterykWhColumn = app.kWhMinOffset }
      if ( k5.checked ) { app.batterykWhColumn = app.kWhTotal }

      app.batterykWhDecimals = kWhDecimalsvalue.text

      app.batterywifidBm = w1.checked

      updateScreenConfiguration()
      app.saveSettings()
      appSetupScreen.visible = false
      updateScreenConfiguration()
      updateScreenData()

    }



// ---------------- Radio buttons data on Tile

    Rectangle {
      id : radioHomeWizardDataOnTile
      width : 300
      height : isNxt ? 175 : 140
      border.width : 0
      color : "#dcdcdc"
      anchors{
        left : appSetupScreen.left
        top : appSetupScreen.top
        leftMargin : rowHeight
        topMargin : rowHeight / 2
      }

      Column {

        spacing : 5

        Text {
          text : "Tile Data:"
          height : isNxt ? 35 : 28
          font.underline : true
        }

// ---- Radio 0

        Item {
          id : p0
          width : 150
          height : isNxt ? 35 : 28

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_p0
              width : 26
              height : 26
              radius : 13
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors{
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : p0.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "Logo"
              anchors.verticalCenter : rect_p0.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              p0.checked = true
              p1.checked = false
              p2.checked = false
              p3.checked = false
              p4.checked = false
            }
          }
        }

// ---- Radio 1

        Item {
          id : p1
          width : 150
          height : isNxt ? 35 : 28

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_p1
              width : 26
              height : 26
              radius : 13
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors{
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : p1.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "'HomeWizard'"
              anchors.verticalCenter : rect_p1.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              p0.checked = false
              p1.checked = true
              p2.checked = false
              p3.checked = false
              p4.checked = false
            }
          }
        }

// ---- Radio 2

        Item {
          id : p2
          width : 150
          height : isNxt ? 35 : 28

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_p2
              width : 26
              height : 26
              radius : 13
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors{
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : p2.checked ? "black" : "transparent"
              }
            }

            Text {
              id : p2OptionText
              text : "00:00: 99-99-9999"
              anchors.verticalCenter : rect_p2.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              p0.checked = false
              p1.checked = false
              p2.checked = true
              p3.checked = false
              p4.checked = false
            }
          }

        }

// ---- Radio 3

        Item {
          id : p3
          width : 150
          height : isNxt ? 35 : 28

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_p3
              width : 26
              height : 26
              radius : 13
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors {
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : p3.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "P1 Meter Watt"
              anchors.verticalCenter : rect_p3.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              p0.checked = false
              p1.checked = false
              p2.checked = false
              p3.checked = true
              p4.checked = false
            }
          }

        } // end radio

// ---- Radio 4

        Item {
          id : p4
          width : 150
          height : isNxt ? 35 : 28

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_p4
              width : 26
              height : 26
              radius : 13
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors {
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : p4.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "P1 Meter Watt, Batterij % & Watt"
              anchors.verticalCenter : rect_p4.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              p0.checked = false
              p1.checked = false
              p2.checked = false
              p3.checked = false
              p4.checked = true
            }
          }

        } // end radio

      }   // end column

    }     // end item

// ---------------- Radio buttons kWhColumn

    Rectangle {
      id : kWhColumnRadioButtons

      width : 300
      height : isNxt ? 250 : 200
      border.width : 0
      color : "#dcdcdc"
      anchors.left : parent.horizontalCenter
      anchors.top : radioHomeWizardDataOnTile.top

      Column {

        spacing : isNxt ? 5 : 4
        Text {
          text : "kWh:"
          height : isNxt ? 35 : 28
          font.underline : true
        }

// ---- Radio 1

        Item {
          id : k1
          width : 150
          height : isNxt ? 35 : 28

          property bool checked : false

          Row {
            spacing: 6

            Rectangle {
              id : rect_k1
              width : 26
              height : 26
              radius : 13
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors{
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : k1.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "kWh Dag"
              anchors.verticalCenter : rect_k1.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              k1.checked = true
              k2.checked = false
              k3.checked = false
              k4.checked = false
              k5.checked = false
            }
          }
        }

// ---- Radio 2

        Item {
          id : k2
          width : 150
          height : isNxt ? 35 : 28

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_k2
              width : 26
              height : 26
              radius : 13
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors{
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : k2.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "kWh Week"
              anchors.verticalCenter : rect_k2.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              k1.checked = false
              k2.checked = true
              k3.checked = false
              k4.checked = false
              k5.checked = false
            }
          }
        }

// ---- Radio 3

        Item {
          id : k3
          width : 150
          height : isNxt ? 35 : 28

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_k3
              width : 26
              height : 26
              radius : 13
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors{
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : k3.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "kWh Maand"
              anchors.verticalCenter : rect_k3.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              k1.checked = false
              k2.checked = false
              k3.checked = true
              k4.checked = false
              k5.checked = false
            }
          }
        }

// ---- Radio 4

        Item {
          id : k4
          width : 150
          height : isNxt ? 35 : 28

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_k4
              width : 26
              height : 26
              radius : 13
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors {
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : k4.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "kWh Start"
              anchors.verticalCenter : rect_k4.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              k1.checked = false
              k2.checked = false
              k3.checked = false
              k4.checked = true
              k5.checked = false
            }
          }
        }

// ---- Radio 5

        Item {
          id : k5
          width : 150
          height : isNxt ? 35 : 28

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_k5
              width : 26
              height : 26
              radius : 13
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors {
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : k5.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "kWh Totaal"
              anchors.verticalCenter : rect_k5.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              k1.checked = false
              k2.checked = false
              k3.checked = false
              k4.checked = false
              k5.checked = true
            }
          }
        } // end radio

      }   // end column

    }     // end item

// ---------------- kWhDecimals

    Rectangle {
      id : kWhDecimalsRectangle
      width : 300
      height : rowHeight
      border.width : 0
      color : "#dcdcdc"
      anchors {
        top : kWhColumnRadioButtons.bottom
        left : kWhColumnRadioButtons.left
//        topMargin : rowHeight / 2
      }
      Text {
        id : kWhDecimalsRectangleText
        text : "kWh Decimalen:"
        height : isNxt ? 35 : 28
        font.underline : true
      }

      Rectangle {
        id : kWhDecimalsMin
        width : rowHeight * 0.8
        height : width
        color : "#ababab"
        radius : 5
        border.width : 1
        anchors {
          left : kWhDecimalsRectangleText.right
          leftMargin : isNxt ? 20 : 16
        }
        Text {
          anchors {
            horizontalCenter : parent.horizontalCenter
            bottom : parent.bottom
            bottomMargin :  ( rowHeight / 3 )
          }
          text : "_"
          font.pixelSize : isNxt ? 40 : 32
        }
        MouseArea {
          anchors.fill : parent
          onClicked : {
            if ( kWhDecimalsvalue.text > 0 ) { kWhDecimalsvalue.text = kWhDecimalsvalue.text - 1}
          }
        }
      }

      Text {
        id : kWhDecimalsvalue
        height : isNxt ? 35 : 28
        anchors {
          left : kWhDecimalsMin.right
          leftMargin : isNxt ? 20 : 16
          bottom : kWhDecimalsMin.bottom
          bottomMargin : isNxt ? 5 : 4
        }
        text : "3"
        font.pixelSize : isNxt ? 40 : 32
      }

      Rectangle {
        id : kWhDecimalsPlus
        width : rowHeight  * 0.8
        height : width
        color : "#ababab"
        radius : 5
        border.width : 1
        anchors {
          left : kWhDecimalsvalue.right
          leftMargin : isNxt ? 20 : 16
        }
        Text {
          anchors {
            horizontalCenter : parent.horizontalCenter
            bottom : parent.bottom
            bottomMargin :  -0.1 * rowHeight
          }
          text : "+"
          font.pixelSize : isNxt ? 40 : 32
        }
        MouseArea {
          anchors.fill : parent
          onClicked : {
            if ( kWhDecimalsvalue.text < 3 ) { kWhDecimalsvalue.text = ( kWhDecimalsvalue.text * 1) + 1}
          }
        }
      }

    }

// ---------------- Radio buttons wifi dBm or

    Rectangle {
      id : wifidBmRadioButtons
      width : 300
      height : isNxt ? 130 : 104
      border.width : 0
      color : "#dcdcdc"
      anchors {
        left : kWhDecimalsRectangle.left
        top : kWhDecimalsRectangle.bottom
        topMargin : isNxt ? 10 : 8
      }
      Column {

        spacing : isNxt ? 5 : 4
        Text {
          text : "WiFi:"
          height : isNxt ? 35 : 28
          font.underline : true
        }

// ---- Radio 1

        Item {
          id : w1
          width : 150
          height : isNxt ? 35 : 28

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_w1
              width : 26
              height : 26
              radius : 13
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors{
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : w1.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "WiFi in dBm"
              anchors.verticalCenter : rect_w1.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              w1.checked = true
              w2.checked = false
            }
          }
        }

// ---- Radio 2

        Item {
          id : w2
          width : 150
          height : isNxt ? 35 : 28

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_w2
              width : 26
              height : 26
              radius : 13
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors {
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : w2.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "WiFi in %"
              anchors.verticalCenter : rect_w2.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              w1.checked = false
              w2.checked = true
            }
          }
        }
      }
    }

// ------------ appSetupScreen Quit, Save and Help ? Buttons

    Rectangle {
      id : saveButtonDP
      height : rowHeight
      width : buttonWidth
      radius : 8
      border {
        width : 2
        color : "black"
      }
      color : "green"
      anchors {
        right : helpButtonDP.left
        top : helpButtonDP.top
        rightMargin : 50
      }
      Text { anchors.centerIn : parent ; text : "Save" }

      MouseArea {
        anchors.fill : parent
        onClicked : {
          app.settingsActive = false
          appSetupScreen.appSettingsSave()
        }
      }
    }

    Rectangle {
      id : quitButtonDP
      height : rowHeight
      width : buttonWidth
      radius : 8
      border {
        width : 2
        color : "black"
      }
      color : "green"
      anchors {
        top : saveButtonDP.top
        right : saveButtonDP.left
        rightMargin : 50
      }
      Text { anchors.centerIn : parent ; text : "Quit" }

      MouseArea {
        anchors.fill : parent
        onClicked : {
          app.settingsActive = false
          updateScreenConfiguration()
          appSetupScreen.visible = false
        }
      }
    }

    Rectangle {
      id : helpButtonDP
      height : rowHeight
      width : rowHeight
      radius : 8
      border {
        width : 2
        color : "black"
      }
      color : "blue"
      anchors {
        right : parent.right
        top : parent.top
        topMargin : isNxt ? 5 : 4
        rightMargin : isNxt ? 5 : 4
      }
      Text { anchors.centerIn : parent ; text : "?" }

      MouseArea {
        anchors.fill : parent
        onClicked : {
          Qt.inputMethod.hide()
          batterySettingsPanelHelp.visible = true
        }
      }
    }

  }


// ---- batterySettingsPanel

  Rectangle {
    id : batterySettingsPanel

    visible : false

    property int batteryIndex : 0

    anchors {
      top : parent.top
      horizontalCenter : parent.horizontalCenter
    }
    height : isNxt ? 290 : 232
    width : parent.width -20
    color : "#dcdcdc"
    radius : 8
    border {
      width : 2
      color : "black"
    }

    // block clicks to all items in the back
    MouseArea {
      anchors.fill : parent
      acceptedButtons : Qt.AllButtons
      propagateComposedEvents: false
    }


// -------- batterySettingsPanel Functions

// ------------ Function editBatterySettings

    function editBatterySettings(index) {
      if ( ! batterySettingsPanel.visible ) {
        app.settingsActive = true // block data collection
        batterySettingsPanel.batteryIndex = index
        inputIP.color = "black"
        textBatteryTokenValue.color = "black"
        inputKWHOffset.color = "black"
        inputKWHOffset2.color = "black"

        batterySettingsPanel.visible = true
      }
    }

// ------------ Function onVisibleChanged

    onVisibleChanged: {

      if (activeMe) {
        if (visible) {
          batterySettingsPanel.loadBatterySettingsPanelData()
        }
      }
    }

// ------------ Function loadBatterySettingsPanelData

    function loadBatterySettingsPanelData() {

      batterySettingsPanelTitle.text = "Thuisbatterij " + (batteryIndex + 1) + " Settings"

      deleteButton.color = "red"

      deleteButton.visible = ( app.batteryIP[batteryIndex] != "0.0.0.0" )

      loginText.text = ""

      checkLoginSaveBatteryButtonText.text = "Save"
      checkLoginSaveBatteryButton.color = "green"

      inputIP.text = app.batteryIP[batteryIndex]
      inputName.text = app.batteryName[batteryIndex]

      textBatteryTokenValue.text = app.batteryToken[batteryIndex]

      inputKWHOffset.text = app.batteryKWHImportOffset[batteryIndex]
      inputKWHOffset2.text = app.batteryKWHExportOffset[batteryIndex]

      batteryActive.font.strikeout = ! app.batteryActive[batteryIndex]
      batteryVisible.font.strikeout = ! app.batteryVisible[batteryIndex]

      rectangleBatteryVisible.visible = ! batteryActive.font.strikeout

      resetDayWeekCountersResetText.font.strikeout = true

    }

// ------------ Function batterySettingsCheckLoginSave

    Timer {
      id: batterySettingsCheckTokenTimer
      interval: 2000 // syncIntervalms
      running: false // Tile not installed -> do not run -> no CPU waste
      repeat: true
      triggeredOnStart: false
      onTriggered: {
        checkLoginSaveBatteryButtonText.text = checkLoginSaveBatteryButtonText.text + "."
        var checkResult = app.controlToonHomeWizardBatteriesProcess("CheckResult")
        if ( checkResult != "File Not Found") {
          batterySettingsCheckTokenTimer.stop()
          debug && app.log("batterySettingsCheckTokenTimer stopped")
          debug && app.log("checkResult: "+checkResult)

          checkLoginSaveBatteryButtonText.text = "Save"
          checkLoginSaveBatteryButton.color = "green"

          switch (checkResult ) {
          case "invalidIP":
            inputIP.color = "red"
            break
          case "unauthorized":
            textBatteryTokenValue.color = "red"
            checkLoginSaveBatteryButtonText.text = "Log In"
            checkLoginSaveBatteryButton.color = "yellow"
            loginText.text = "Klik op 'Log In'"
            break
          default:
            debug && app.log("Deze is goed: "+checkResult)
            textBatteryTokenValue.text = checkResult
            app.batteryIP[batterySettingsPanel.batteryIndex] = inputIP.text
            app.batteryOke[batterySettingsPanel.batteryIndex] = true
            app.batteryToken[batterySettingsPanel.batteryIndex] = checkResult
            // also correct token in other batteries with same IP
            var ii = 0
            for (ii = 0; ii < 4; ii++) {
              if (app.batteryIP[ii] == inputIP.text) {
                app.batteryToken[ii] = checkResult
                app.batteryOke[ii] = true
              }
            }
            batterySettingsPanel.batterySettingsCheckLoginSave("Save")
          }
        }
      }
    }

    Timer {
      id: batterySettingsLogInTimer
      interval: 2000 // syncIntervalms
      running: false // Tile not installed -> do not run -> no CPU waste
      repeat: true
      triggeredOnStart: false
      onTriggered: {
        if (loginText.text == "Klik nu op je batterij" ) {
          loginText.text = ""
        } else {
          checkLoginSaveBatteryButtonText.text = checkLoginSaveBatteryButtonText.text + "."
        }
        var tokenResult = app.controlToonHomeWizardBatteriesProcess("TokenResult")

        debug && app.log("batterySettingsLogInTimer: "+tokenResult)
        if ( tokenResult != "File Not Found") {
          batterySettingsLogInTimer.stop()
          debug && app.log("batterySettingsLogInTimer stopped")
          debug && app.log("tokenResult: "+tokenResult)

          checkLoginSaveBatteryButtonText.text = "Save"
          checkLoginSaveBatteryButton.color = "green"

          switch (tokenResult ) {
          case "No TOKEN in file":
            debug && app.log("tokenResult: niet goed "+tokenResult)
            break
          default:
            debug && app.log("Deze is goed: "+tokenResult)
            // correct token in other batteries with same IP
            var ii = 0
            for (ii = 0; ii < 4; ii++) {
              if (app.batteryIP[ii] == inputIP.text) {
                app.batteryToken[ii] = tokenResult
                app.batteryOke[ii] = true
              }
            }
            if (app.batteryTokenHistory.indexOf(tokenResult) == -1 ) {
              app.batteryTokenHistory.push(tokenResult)
            }
            textBatteryTokenValue.text = tokenResult
            app.batteryIP[batterySettingsPanel.batteryIndex] = inputIP.text
            app.batteryOke[batterySettingsPanel.batteryIndex] = true
            app.batteryToken[batterySettingsPanel.batteryIndex] = textBatteryTokenValue.text
            batterySettingsPanel.batterySettingsCheckLoginSave("Save")
          }
        }
      }
    }

    function batterySettingsCheckLoginSave() {

      loginText.text = ""

      Qt.inputMethod.hide()

      switch ( checkLoginSaveBatteryButtonText.text) {
      case "Save":
        var validInput = true
        // Validate IP address input

        inputIP.color = "black"
        textBatteryTokenValue.color = "black"
        if (/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(inputIP.text))  {
          // Valid IP address

          if ( (app.batteryIP[batteryIndex] != inputIP.text) || ( ! app.batteryOke[batteryIndex] ) ) {
            checkLoginSaveBatteryButtonText.text="."
            app.controlToonHomeWizardBatteriesProcess("Check_"+inputIP.text+"_"+textBatteryTokenValue.text)
            batterySettingsCheckTokenTimer.start()
            validInput = false
          }
        } else {
          validInput = false
          inputIP.color = "red"
        }

        // Validate kWh Offset input

        inputKWHOffset.color = "black"
        if (/^[+-]?\d+(\.\d+)?$/.test(inputKWHOffset.text)) {
          app.batteryKWHImportOffset[batteryIndex] = inputKWHOffset.text * 1
        } else {
          validInput = false
          inputKWHOffset.color = "red"
        }

        // Validate kWh Offset output

        inputKWHOffset2.color = "black"
        if (/^[+-]?\d+(\.\d+)?$/.test(inputKWHOffset2.text)) {
          app.batteryKWHExportOffset[batteryIndex] = inputKWHOffset2.text * 1
        } else {
          validInput = false
          inputKWHOffset2.color = "red"
        }

        if (validInput) { // Save settings

          app.batteryName[batteryIndex] = inputName.text

          app.batteryActive[batteryIndex] = ! batteryActive.font.strikeout

          if ( ! app.batteryActive[batteryIndex] ) { app.batteryOke[batteryIndex] = true}

          app.batteryVisible[batteryIndex] = ! batteryVisible.font.strikeout

          if ( ! resetDayWeekCountersResetText.font.strikeout ) {
            // reset Day, Week and Month counters by setting them to current values

            app.batteryKWHImportYesterday[batteryIndex] = app.batteryKWHImport[batteryIndex]
            app.batteryKWHImportLastWeek[batteryIndex] =  app.batteryKWHImport[batteryIndex]
            app.batteryKWHImportLastMonth[batteryIndex] =  app.batteryKWHImport[batteryIndex]

            app.batteryKWHExportYesterday[batteryIndex] = app.batteryKWHExport[batteryIndex]
            app.batteryKWHExportLastWeek[batteryIndex] =  app.batteryKWHExport[batteryIndex]
            app.batteryKWHExportLastMonth[batteryIndex] =  app.batteryKWHExport[batteryIndex]

          }

          debug && app.log("Screen Save Battery Settings")
          app.saveSettings()
          app.controlToonHomeWizardBatteriesProcess("List")

          visible = false
          updateScreenConfiguration()
          updateScreenData()
        }
        break
/*
      case "Check":
        checkLoginSaveBatteryButtonText.text="."
        app.controlToonHomeWizardBatteriesProcess("Check_"+inputIP.text+"_"+textBatteryTokenValue.text)
        batterySettingsCheckTokenTimer.start()
        break
*/
      case "Log In":
        loginText.text = "Klik nu op je batterij"
        checkLoginSaveBatteryButtonText.text = "."
        app.controlToonHomeWizardBatteriesProcess("LogIn_"+inputIP.text)
        batterySettingsLogInTimer.start()
        break
      }
    }

// -------- batterySettingsPanel Title

    Text {
      id : batterySettingsPanelTitle
      anchors {
        top : parent.top
        topMargin : isNxt ? 15 : 12
        left :  rectangleInputIP.left
      }
      text : "batterySettingsPanelTitle"
      font.italic : true
    }

// ------------ batterySettingsPanel IP

    Text {
      id : textIPAddress
      height : rowHeight
      text : "IP Adres: "
      anchors {
        top : batterySettingsPanelTitle.bottom
        left : parent.left
        topMargin : isNxt ? 15 : 12
        leftMargin : isNxt ? 20 : 16
      }
    }

    Rectangle {
      id : rectangleInputIP
      height : rowHeight
      width : isNxt ? 220 : 176
      anchors {
        top : textIPAddress.top
        left : textIPAddress.right
        leftMargin : isNxt ? 5 : 4
      }
      radius : 8
      border {
        width : 2
        color : "black"
      }
      Rectangle {
        height : parent.height - 4
        width : parent.width - 10
        anchors.centerIn : parent
        TextInput {
          id : inputIP
          width : parent.width
          anchors.centerIn : parent
          text : "inputIP"
        }
      }
    }

// ------------ batterySettingsPanel Name

    Text {
      id : textName
      height : rowHeight
      text : "Naam: "
      anchors {
        top : textIPAddress.bottom
        left : textIPAddress.left
        topMargin : 10
      }
    }

    Rectangle {
      id : rectangleInputName
      height : rowHeight
      width : isNxt ? 220 : 176
      anchors {
        top : textName.top
        left : rectangleInputIP.left
      }
      radius : 8
      border {
        width : 2
        color : "black"
      }
      Rectangle {
        height : parent.height - 4
        width : parent.width - 10
        anchors.centerIn : parent
        TextInput {
          id : inputName
          width : parent.width
          anchors.centerIn : parent
          text : "inputName"
        }
      }
    }

// ------------ batterySettingsPanel Active and Visible

    Text {
      id : textBatteryActiveAndVisible
      height : rowHeight
      text : "Batterij:"
      anchors {
        top : textName.bottom
        left : textName.left
        topMargin : 10
      }
    }

    Rectangle {
      id : rectangleBatteryActive
      height : rowHeight
      width : buttonWidth
      color : "#ababab"
      anchors {
        top : textBatteryActiveAndVisible.top
        left : rectangleInputName.left
      }
      radius : 8
      border {
        width : 2
        color : "black"
      }
      Text {
        id : batteryActive
        anchors.centerIn : parent
        text : "Active"
      }
      MouseArea {
        anchors.fill : parent
        onClicked : {
          batteryActive.font.strikeout = ! batteryActive.font.strikeout
          rectangleBatteryVisible.visible = ! batteryActive.font.strikeout
        }
      }
    }

    Rectangle {
      id : rectangleBatteryVisible
      height : rowHeight
      width : buttonWidth
      color : "#ababab"
      anchors {
        top : textBatteryActiveAndVisible.top
        left : rectangleBatteryActive.right
        leftMargin : isNxt ? 5 : 4
      }
      radius : 8
      border {
        width : 2
        color : "black"
      }
      Text {
        id : batteryVisible
        anchors.centerIn : parent
        text : "Visible"
      }
      MouseArea {
        anchors.fill : parent
        onClicked : {
          batteryVisible.font.strikeout = ! batteryVisible.font.strikeout
        }
      }
    }

// ------------ batterySettingsPanel Active and Visible

    Text {
      id : textBatteryToken
      height : rowHeight
      text : "Token:"
      anchors {
        top : textBatteryActiveAndVisible.bottom
        left : textName.left
        topMargin : 10
      }
    }

    Text {
      id : textBatteryTokenValue
      height : rowHeight
      text : "textBatteryToken"
      anchors {
        top : textBatteryToken.top
        left : rectangleBatteryActive.left
      }
    }

// ------------ batterySettingsPanel Start kWh

    Text {
      id : textkWhStart
      height : rowHeight
      text : "kWh Start:"
      anchors {
        top : textIPAddress.top
        left : rectangleInputIP.right
        leftMargin : rowHeight
      }
    }

    Rectangle {
      id : rectangleInputKWHOffset
      height : rowHeight
      width : isNxt ? 170 : 136
      anchors {
        top : textkWhStart.top
        left : resetDayWeekCountersText.right
        leftMargin : isNxt ? 10 : 8
      }
      radius : 8
      border {
        width : 2
        color : "black"
      }
      Rectangle {
        height : parent.height - 4
        width : parent.width - 10
        anchors.centerIn : parent
        TextInput {
          id : inputKWHOffset
          width : parent.width
          anchors.centerIn : parent
          text : "inputKWHOffset"
        }
      }
    }

    Rectangle {
      id : rectangleInputKWHOffset2
      height : rowHeight
      width : 170
      anchors {
        top : rectangleInputKWHOffset.top
        left : rectangleInputKWHOffset.right
        leftMargin : isNxt ? 5 : 4
      }
      radius : 8
      border {
        width : 2
        color : "black"
      }
      Rectangle {
        height : parent.height - 4
        width : parent.width - 10
        anchors.centerIn : parent
        TextInput {
          id : inputKWHOffset2
          width : parent.width
          anchors.centerIn : parent
          text : "inputKWHOffset"
        }
      }
    }

// ------------ batterySettingsPanel Start kWh Presets

    Text {
      id : textKWHOffsetPreset0
      height : rowHeight
      text : "kWh Start Preset:"
      anchors {
        top : textkWhStart.bottom
        left : textkWhStart.left
        topMargin : 10
      }
    }

    Rectangle {
      id : kWhOffsetPresetsHomeZero
      height : rowHeight
      width : buttonWidth
      color : "#ababab"
      anchors {
        top : textKWHOffsetPreset0.top
        left : rectangleInputKWHOffset.left
      }
      radius : 8
      border {
        width : 2
        color : "black"
      }
      Text {
        anchors.centerIn : parent
        text : "0 0"
      }
      MouseArea {
        anchors.fill : parent
        onClicked : {
          inputKWHOffset.text = 0.0
          inputKWHOffset2.text = 0.0
        }
      }
    }

    Rectangle {
      id : kWhOffsetPresetsHomeWizard
      height : rowHeight
      width : buttonWidth
      color : "#ababab"
      anchors {
        top : kWhOffsetPresetsHomeZero.top
        left : kWhOffsetPresetsHomeZero.right
        leftMargin : isNxt ? 5 : 4
      }
      radius : 8
      border {
        width : 2
        color : "black"
      }
      Text {
        anchors.centerIn : parent
        text : "2 Totals"
      }
      MouseArea {
        anchors.fill : parent
        onClicked : {
          inputKWHOffset.text = app.batteryKWHImport[batterySettingsPanel.batteryIndex]
          inputKWHOffset2.text = app.batteryKWHExport[batterySettingsPanel.batteryIndex]
        }
      }
    }

    Text {
      id : resetDayWeekCountersText
      height : rowHeight
      text : "Dag-Week-Maand:"
      anchors {
        top : textKWHOffsetPreset0.bottom
        left : textKWHOffsetPreset0.left
        topMargin : 10
      }
    }

    Rectangle {
      id : resetDayWeekCounters
      height : rowHeight
      width : buttonWidth
      color : "#ababab"
      anchors {
        top : resetDayWeekCountersText.top
        left : kWhOffsetPresetsHomeZero.left
      }
      radius : 8
      border {
        width : 2
        color : "black"
      }
      Text {
        id : resetDayWeekCountersResetText
        anchors.centerIn : parent
        text : "Reset"
        font.strikeout : true
      }
      MouseArea {
        anchors.fill : parent
        onClicked : { resetDayWeekCountersResetText.font.strikeout = ! resetDayWeekCountersResetText.font.strikeout }
      }
    }

    Text {
      id : loginText
      anchors {
        top : textBatteryTokenValue.top
        left : resetDayWeekCounters.horizontalCenter
      }
      text : "Klik 'Log In', dan op de batterij"
    }

// ------------ batterySettingsPanel Quit, Save and Help ? Buttons

    Rectangle {
      id : helpButton
      height : rowHeight
      width : rowHeight
      radius : 8
      border {
        width : 2
        color : "black"
      }
      color : "blue"
      anchors {
        right : parent.right
        top : parent.top
        topMargin : isNxt ? 5 : 4
        rightMargin : isNxt ? 5 : 4
      }
      Text { anchors.centerIn : parent ; text : "?" }

      MouseArea {
        anchors.fill : parent
        onClicked : {
          Qt.inputMethod.hide()
          batterySettingsPanelHelp.visible = true
        }
      }
    }

    Rectangle {
      id : checkLoginSaveBatteryButton
      height : rowHeight
      width : buttonWidth
      radius : 8
      border {
        width : 2
        color : "black"
      }
      color : "green"
      anchors {
        right : helpButton.left
        top : helpButton.top
        rightMargin : 50
      }
      Text {
        id : checkLoginSaveBatteryButtonText
        anchors.centerIn : parent ;
        text : "Save/Check/Log-In"
      }

      MouseArea {
        anchors.fill : parent
        onClicked : {
          app.settingsActive = false
          batterySettingsPanel.batterySettingsCheckLoginSave()
        }
      }
    }

    Rectangle {
      id : quitButton
      height : rowHeight
      width : buttonWidth
      radius : 8
      border {
        width : 2
        color : "black"
      }
      color : "green"
      anchors {
        top : checkLoginSaveBatteryButton.top
        right : checkLoginSaveBatteryButton.left
        rightMargin : 50
      }
      Text { anchors.centerIn : parent ; text : "Quit" }

      MouseArea {
        anchors.fill : parent
        onClicked : {
          app.settingsActive = false
          Qt.inputMethod.hide()
          batterySettingsPanel.visible = false
        }
      }
    }

    Rectangle {
      id : deleteButton
      height : rowHeight
      width : buttonWidth
      radius : 8
      border {
        width : 2
        color : "black"
      }
      color : "green"
      anchors {
        top : quitButton.top
        right : quitButton.left
        rightMargin : 50
      }
      Text { anchors.centerIn : parent ; text : "Delete" }

      MouseArea {
        anchors.fill : parent
        onClicked : {
          if (deleteButton.color == "#ff0000" ) { // "red"
            deleteButton.color = "yellow"
          } else {

            // Token removal from history
            var index = app.batteryTokenHistory.indexOf(app.batteryToken[batterySettingsPanel.batteryIndex]);
            if (index !== -1) {
              var count = 0;
              for (var i = 0; i < 4; i++) {
                  if (app.batteryToken[i] == app.batteryToken[batterySettingsPanel.batteryIndex])
                      count++;
              }
              if (count == 1) {
                // this is the last battery with this token so delete token from history and delete account from the physical battery
                app.batteryTokenHistory.splice(index, 1); // remove 1 element at index
                app.controlToonHomeWizardBatteriesProcess("LogOut_"+app.batteryIP[batterySettingsPanel.batteryIndex]+"_"+app.batteryToken[batterySettingsPanel.batteryIndex])
              }
            }

            // set default values for this battery and save the settings

            app.batteryToken[batterySettingsPanel.batteryIndex] = "0123456789ABCDEF0123456789ABCDEF"

            app.batteryIP[batterySettingsPanel.batteryIndex] = "0.0.0.0"
            app.batteryName[batterySettingsPanel.batteryIndex] = "Battery "  + ( batterySettingsPanel.batteryIndex + 1)

            app.batteryKWHImportYesterday[batterySettingsPanel.batteryIndex] = 0
            app.batteryKWHImportLastWeek[batterySettingsPanel.batteryIndex] = 0
            app.batteryKWHImportLastMonth[batterySettingsPanel.batteryIndex] = 0
            app.batteryKWHImportOffset[batterySettingsPanel.batteryIndex] = 0

            app.batteryKWHExportYesterday[batterySettingsPanel.batteryIndex] = 0
            app.batteryKWHExportLastWeek[batterySettingsPanel.batteryIndex] = 0
            app.batteryKWHExportLastMonth[batterySettingsPanel.batteryIndex] = 0
            app.batteryKWHExportOffset[batterySettingsPanel.batteryIndex] = 0

            app.batteryActive[batterySettingsPanel.batteryIndex] = false
            app.batteryVisible[batterySettingsPanel.batteryIndex] = false
            app.batteryOke[batterySettingsPanel.batteryIndex] =  true
            app.batteryWatts[batterySettingsPanel.batteryIndex] = 0
            app.battery_wifi[batterySettingsPanel.batteryIndex] = 0

            app.settingsActive = false
            Qt.inputMethod.hide()
            batterySettingsPanel.visible = false

            app.saveSettings()
            updateScreenConfiguration()
            updateScreenData()

          }
        }
      }
    }

  }

// -------- batterySettingsPanel Help / Info screen

  Rectangle {
    id : batterySettingsPanelHelp
    visible : false

    anchors {
      top : batterySettingsPanel.visible ? batterySettingsPanel.bottom : parent.top
      horizontalCenter : parent.horizontalCenter
      topMargin : batterySettingsPanel.visible ? 5 : 0
    }
    height : batterySettingsPanel.visible ? (parent.height - batterySettingsPanel.height ) : parent.height
    width : parent.width - 20
    color : "#dcdcdc"
    radius : 8
    border {
      width : 2
      color : "black"
    }

    // block clicks to all items in the back
    MouseArea {
      anchors.fill : parent
      acceptedButtons : Qt.AllButtons
      propagateComposedEvents : false
    }

// ------------ batterySettingsPanel Help / Info text

    Flickable {
      id : flick
      anchors.fill : parent
      contentWidth : width
      contentHeight : textItem.height + rowHeight
      clip : true

      Text {
        id : textItem
        anchors{
          top : parent.top
          left : parent.left
          topMargin : rowHeight / 2
          leftMargin : rowHeight
        }
        font.pixelSize : isNxt ? 20 : 16
        font.bold : true
        text :
          "<b><font color='#0000ff'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Tot 4 HomeWizard Thuisbatterijen uitlezen.</font></b>"
        + "<br>"
        + "<br>Een Thuisbatterij voeg je anders toe dan een Energy Socket of P1 Meter."
        + "<br>"
        + "<br>Er moet een 'Log In' account worden gemaakt in de batterij."
        + "<br>Dat is heel eenvoudig met de onderstaande stappen."
        + "<br>"
        + "<br><font color='#009900'><b>Ga eerst even naar de Thuisbatterij die je wilt koppelen:</b></font>"
        + "<br>&nbsp;&nbsp;- zoek de ronde knop boven de verticale leds zodat je weet waar die knop zit"
        + "<br>&nbsp;&nbsp;- raak hem even aan dan hoor je een piep, dit doe je straks ook om te koppelen"
        + "<br>"
        + "<br><font color='#0000ff'><b>In de HomeWizard APP op je telefoon/tablet:</b></font>"
        + "<br>&nbsp;&nbsp;- zoek in de settings naar je Thuisbatterij en doe het volgende"
        + "<br>&nbsp;&nbsp;- ga naar {...} en vind iets lager een IP-adres"
        + "<br>&nbsp;&nbsp;- dat IP-adres als '192.168.2.123' heb je nodig in de volgende stappen"
        + "<br>&nbsp;&nbsp;- de Koppelingsknop eronder moet uit, naar links dus, zodat hij niet groen is"
        + "<br>"
        + "<br><font color='#0000ff'><b>In deze APP op je Toon:</b></font>"
        + "<br>&nbsp;&nbsp;- verlaat dit scherm (knop rechtsboven), klik op een Thuisbatterij en..."
        + "<br>&nbsp;&nbsp;- met het vraagteken rechtsboven kun je dit informatie scherm weer oproepen"
        + "<br>&nbsp;&nbsp;- vul het IP-adres in bij 'IP Adres' en wijzig de naam bij 'Naam'"
        + "<br>&nbsp;&nbsp;- klik op 'Active' om de doorhaling te verwijderen en de verbinding te maken"
        + "<br>&nbsp;&nbsp;- klik op 'Visible' om het apparaat op je scherm te tonen of te verbergen"
        + "<br>&nbsp;&nbsp;- klik op 'Save' en er verschijnt een rij met puntjes die langer wordt..."
        + "<br>&nbsp;&nbsp;- wacht tot de knop geel is en verandert in 'Log In' en druk op de knop"
        + "<br>&nbsp;&nbsp;- raak na 5 seconden de knop op de Thuisbatterij aan, hij piept even"
        + "<br>&nbsp;&nbsp;- nu wordt de 'Log In' gemaakt en komt de koppeling tot stand"
        + "<br>&nbsp;&nbsp;- even geduld, het overzichtscherm komt terug en je bent klaar"
        + "<br>"
        + "<br>Waarschijnlijk heeft je Thuisbatterij na koppelen nog even een rood randje."
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;Je hebt een koppeling gemaakt maar er is nog geen data. Even geduld..."
        + "<br>"
        + "<br>Zonder 'Active' wordt geen data verzameld en zie je het niet op je scherm."
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;Het nut ? Mijn plan...."
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;Bij opladen en ontladen gaat er altijd energie verloren."
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;Ook in de winter werken batterijen vaak tegelijkertijd."
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;Ik zie lage laad-Watts bij het laden en relatief grote verschillen in laad"
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;en ontlaad kWh's bij dag, week en maand overzichten."
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;Ik ben van plan om in die periode elke laatste zondag van de maand een andere"
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; batterij in opslag te zetten. Dit bespaart verlies en oplaad-ontlaad cycli."
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;Vanaf de laatste zondag want dan lopen de dag, week en maand tellers snel goed."
        + "<br>"
        + "<br>Zonder 'Visible' wordt wel data verzameld maar zie je het niet op je scherm."
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;Het nut ? Stel je wilt alleen de geconsolideerde regel."
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;Dan zet je bij al je batterijen 'Visible' uit."
        + "<br>"
        + "<br>Wil je in de Toon HomeWizard APP de kWh's zien sinds een bepaalde Start?"
        + "<br>Vul dan de velden 'kWh Start' in."
        + "<br>De Presets knoppen vullen of '0 0' of de huidige totalen in."
        + "<br>"
        + "<br>Nieuw apparaat aangesloten? Dan wil je de dag, week en maand tellers resetten."
        + "<br>Deze beginnen op 0 na een reset en na het begin van een dag, week of maand."
        + "<br>Deze tellers zijn dus pas correct na het begin van een nieuwe dag, week of maand."
        + "<br>"
        + "<br>Op het APP scherm staat rechtsonder een knop voor algemene APP settings."
        + "<br>Kies daar weergave settings voor het tegeltje en de kWh en WiFi signaalsterkte."
        + "<br>"
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color='#ff3333'><b>&gt;&gt;&gt; <i>LET OP !</i> &lt;&lt;&lt; </b></font>"
        + "<br>"
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;Als een Thuisbatterij niet kan worden uitlezen wordt de ring op het tegeltje rood."
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;Op het APP scherm krijgt het apparaat met het probleem een rood randje."
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;Vaak lost het zich binnen een minuut op. Duurt het langer?"
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;Klopt het IP adres nog of is dat gewijzigd? Pas het eventueel aan in je Toon app."
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;Als je het IP adres in de Toon app wijzigt wordt er geen nieuwe 'Log In' gemaakt."
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;Is het IP adres in de Toon app goed en toch geen communicatie?"
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;Dan is er iets mis met WiFi of met de 'Log In'."
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;Heeft je Toon WiFi en zie je de Thuisbatterij in de HomeWizard APP?"
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;Dan is het niet de WiFi maar de 'Log In' en koppel je als volgt opnieuw..."
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;Druk op 'Save' en als er echt geen communicatie is verschijnen de puntjes weer."
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;De gele 'Log In' knop komt, druk er op zoals je eerder hebt gedaan"
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;en raak daarna na 5 seconden de knop van je Thuisbatterij aan."
        + "<br>"
        + "<br>&nbsp;&nbsp;&nbsp;&nbsp;Je kunt meerdere Toons met elke Thuisbatterij koppelen want elke login is uniek."
        + "<br><br><br><br>"
      }
    }

    ScrollBar {
      id : scrollbar
      container : flick
      laneColor : "#00FF00"
      alwaysShow : false

      property int scrollSkip : 75   // 75 pixels per click

      onNext :     flick.contentY = Math.min(flick.contentY + scrollSkip,
                                                flick.contentHeight - flick.height)

      onPrevious : flick.contentY = Math.max(flick.contentY - scrollSkip, 0)

      anchors {
        top : parent.top
        bottom : parent.bottom
        left : flick.left
      }
    }

// ------------ batterySettingsPanel Help / Info Back Button

    Rectangle {
      height : rowHeight
      width : rowHeight
      radius : 8
      border {
        width : 2
        color : "black"
      }
      color : "blue"
      anchors {
        right : parent.right
        top : parent.top
        topMargin : isNxt ? 5 : 4
        rightMargin : isNxt ? 5 : 4
      }
      Text { anchors.centerIn : parent ; text : ">>" }
      MouseArea {
        anchors.fill : parent
        onClicked : {
          batterySettingsPanelHelp.visible = false
        }
      }
    }

  }
}
