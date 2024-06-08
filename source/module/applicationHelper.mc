// using Toybox.System as Sys;
// using Toybox.Lang as Lang;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

module AppHelper {
  var discard_options = {
    0 => Ui.loadResource(Rez.Strings.finish_workout_prompt_resume),
    1 => Ui.loadResource(Rez.Strings.finish_workout_prompt_save_and_exit),
    2 => Ui.loadResource(Rez.Strings.finish_workout_prompt_discard_and_exit),
  };

  public function getDiscardOptions(is_workout_terminated) {
    var options = {};
    var val;
    var i = 0;
    var max = discard_options.size();

    //duplicate
    for (i = 0; i < max; i++) {
      options.put(i, discard_options.get(i));
    }

    if (is_workout_terminated) {
      options.remove(0);
    }

    if (!is_workout_terminated) {
      options.remove(1);
    }

    return options;
  }

  public function drawScreenGuides(dc) {
    var screen_width = dc.getWidth();
    var screen_height = dc.getHeight();
    var centerX = screen_width / 2;
    var centerY = screen_height / 2;

    dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);

    //HORIZONTAL line
    dc.drawLine(0, centerY, screen_width, centerY);

    //VERTICAL line
    dc.drawLine(centerX, 0, centerX, screen_height);
  }
}
