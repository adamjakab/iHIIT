using Toybox.Application as App;
import Toybox.Lang;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class OmniMenuView extends Ui.View {
  private var ctrl;
  private var display_choices as Dictionary = {};

  function initialize(defaultChoices as Dictionary, defaultIndex as Number) {
    View.initialize();
    ctrl = App.getApp().getController();
    ctrl.omniMenuChoices = defaultChoices;
    if (defaultIndex >= ctrl.omniMenuChoices.size() or defaultIndex < 0) {
      defaultIndex = 0;
    }
    ctrl.omniMenuSelectedIndex = defaultIndex;
    Sys.println("SFO:::inited");
  }

  // Update the view
  public function onUpdate(dc) {
    self.updateDisplayChoices();

    var index, txt, text_height, y;

    var width = dc.getWidth();
    var height = dc.getHeight();

    // Clear screen
    dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    dc.clear();

    // CENTRAL ITEM
    index = 1;
    txt = display_choices.get(index);
    text_height = 34;
    y = (height - text_height) / 2;
    dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
    dc.drawText(width / 2, y, Gfx.FONT_SYSTEM_LARGE, txt, Gfx.TEXT_JUSTIFY_CENTER);

    // ITEM TOP
    index = 0;
    txt = display_choices.get(index);
    text_height = 17;
    y = (height - text_height) / 2 - 52;
    dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
    dc.drawText(width / 2, y, Gfx.FONT_SYSTEM_MEDIUM, txt, Gfx.TEXT_JUSTIFY_CENTER);

    // ITEM TOP
    index = 2;
    txt = display_choices.get(index);
    text_height = 17;
    y = (height - text_height) / 2 + 52;
    dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
    dc.drawText(width / 2, y, Gfx.FONT_SYSTEM_MEDIUM, txt, Gfx.TEXT_JUSTIFY_CENTER);

    // View.onUpdate(dc);
    Sys.println("SFO:::updated");
  }

  private function updateDisplayChoices() {
    var i;

    // Previous Item
    i = ctrl.omniMenuSelectedIndex - 1;
    if (i < 0) {
      i = ctrl.omniMenuChoices.size() - 1;
    }
    display_choices.put(0, self.getChoiceLabelAtIndex(i));

    // Selected (Central) Item
    i = ctrl.omniMenuSelectedIndex;
    display_choices.put(1, self.getChoiceLabelAtIndex(i));

    // Last Item
    i = ctrl.omniMenuSelectedIndex + 1;
    if (i >= ctrl.omniMenuChoices.size()) {
      i = 0;
    }
    display_choices.put(2, self.getChoiceLabelAtIndex(i));
  }

  private function getChoiceLabelAtIndex(index as Number) as String {
    var choice = ctrl.omniMenuChoices.get(index) as Dictionary;
    return choice.get("label") as String;
  }
}
