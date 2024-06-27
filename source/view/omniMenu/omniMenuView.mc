import Toybox.Lang;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

/**
 ** OmniMenuView - Generic class to visualize menu items
 **/
class OmniMenuView extends Ui.View {
  private var ctrl;
  private var defaultChoices as Dictionary = {};
  private var currentChoiceIndex as Number = 0;

  function initialize(default_choices as Dictionary, default_index as Number) {
    ctrl = App.getApp().getController();

    defaultChoices = default_choices;
    if (default_index >= defaultChoices.size() or default_index < 0) {
      default_index = 0;
    }
    currentChoiceIndex = default_index;

    Ui.View.initialize();
    Sys.println("OmniMenu: Initialized");
  }

  public function onShow() {
    Sys.println("OmniMenu: Show");
    ctrl.omniMenuChoices = defaultChoices;
    ctrl.omniMenuSelectedIndex = currentChoiceIndex;
  }

  public function onHide() {
    Sys.println("OmniMenu: Hide");
  }

  // Update the view
  public function onUpdate(dc) {
    var choices = self.getDisplayChoices();

    var index, txt, text_height, y;

    var width = dc.getWidth();
    var height = dc.getHeight();

    // Clear screen
    dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    dc.clear();

    // CENTRAL ITEM
    index = 1;
    txt = choices.get(index);
    text_height = 34;
    y = (height - text_height) / 2;
    dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
    dc.drawText(width / 2, y, Gfx.FONT_SYSTEM_LARGE, txt, Gfx.TEXT_JUSTIFY_CENTER);

    // ITEM TOP
    index = 0;
    txt = choices.get(index);
    text_height = 17;
    y = (height - text_height) / 2 - 52;
    dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
    dc.drawText(width / 2, y, Gfx.FONT_SYSTEM_MEDIUM, txt, Gfx.TEXT_JUSTIFY_CENTER);

    // ITEM TOP
    index = 2;
    txt = choices.get(index);
    text_height = 17;
    y = (height - text_height) / 2 + 52;
    dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
    dc.drawText(width / 2, y, Gfx.FONT_SYSTEM_MEDIUM, txt, Gfx.TEXT_JUSTIFY_CENTER);

    // View.onUpdate(dc);
    Sys.println("OmniMenu:::updated");
  }

  private function getDisplayChoices() as Dictionary {
    var choices = {};
    var i;

    // Previous Item
    i = ctrl.omniMenuSelectedIndex - 1;
    if (i < 0) {
      i = ctrl.omniMenuChoices.size() - 1;
    }
    choices.put(0, self.getChoiceLabelAtIndex(i));

    // Selected (Central) Item
    i = ctrl.omniMenuSelectedIndex;
    choices.put(1, self.getChoiceLabelAtIndex(i));

    // Last Item
    i = ctrl.omniMenuSelectedIndex + 1;
    if (i >= ctrl.omniMenuChoices.size()) {
      i = 0;
    }
    choices.put(2, self.getChoiceLabelAtIndex(i));

    return choices;
  }

  private function getChoiceLabelAtIndex(index as Number) as String {
    var choice = ctrl.omniMenuChoices.get(index) as Dictionary;
    return choice.get("label") as String;
  }
}
