using Toybox.Application as App;
using Toybox.Lang as Lang;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class TestModeView extends Ui.View {
  private var app;

  // Strings
  private var str_testing;

  public function initialize() {
    View.initialize();
    app = App.getApp();
  }

  // Set up the layout
  public function onLayout(dc) {
    // Strings
  }

  // Update the view
  function onUpdate(dc) {
    var workout = app.getController().getCurrentWorkout();
    var txt, color;
    var width = dc.getWidth();
    var height = dc.getHeight();
    var text_height = 34;
    var center_y = (height - text_height) / 2;

    //** clear screen
    dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    dc.clear();

    // Text
    txt = "TESTING";
    dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
    dc.drawText(width / 2, 5, Gfx.FONT_SYSTEM_LARGE, txt, Gfx.TEXT_JUSTIFY_CENTER);

    // Device Shape
    var ds = System.getDeviceSettings();
    txt = "Unknown #" + ds.screenShape;
    if (ds.screenShape == Sys.SCREEN_SHAPE_ROUND) {
      txt = "Round";
    } else if (ds.screenShape == Sys.SCREEN_SHAPE_SEMI_ROUND) {
      txt = "Semi-Round";
    } else if (ds.screenShape == Sys.SCREEN_SHAPE_RECTANGLE) {
      txt = "Rectangle";
    }
    dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
    dc.drawText(width / 2, 35, Gfx.FONT_SYSTEM_XTINY, txt, Gfx.TEXT_JUSTIFY_CENTER);

    // Device Size
    txt = "" + width + "x" + height;
    dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
    dc.drawText(width / 2, 50, Gfx.FONT_SYSTEM_XTINY, txt, Gfx.TEXT_JUSTIFY_CENTER);

    AppHelper.drawScreenGuides(dc);
  }
}
