import Toybox.Lang;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

// @TODO: this needs a layout
/**
 ** OmniMenuView - Generic class to visualize menu items
 **/
class OmniMenuView extends Ui.View {
  private var ctrl;
  private var defaultChoices as Dictionary = {};
  private var currentChoiceIndex as Number = 0;

  // Strings
  private var txtActionName as String?;

  // Layout elements
  private var labelActionName;
  private var labelOptionTop, labelOptionCenter, labelOptionBottom;

  function initialize(default_choices as Dictionary, default_index as Number, question as String?) {
    ctrl = App.getApp().getController();

    defaultChoices = default_choices;
    if (default_index >= defaultChoices.size() or default_index < 0) {
      default_index = 0;
    }
    currentChoiceIndex = default_index;
    txtActionName = question;

    Ui.View.initialize();
    Sys.println("OmniMenu: Initialized");
  }

  // Set up the layout
  public function onLayout(dc) {
    // Strings
    if (txtActionName == null) {
      txtActionName = Ui.loadResource(Rez.Strings.omni_menu_default_question);
    }

    // Layout
    setLayout(Rez.Layouts.LayoutOmniMenu(dc));

    // Labels
    labelActionName = View.findDrawableById("action_name");
    labelOptionTop = View.findDrawableById("option_top");
    labelOptionCenter = View.findDrawableById("option_center");
    labelOptionBottom = View.findDrawableById("option_bottom");
  }

  public function onShow() {
    Sys.println("OmniMenu: Show (index: " + currentChoiceIndex + ")");
    ctrl.omniMenuChoices = defaultChoices;
    ctrl.omniMenuSelectedIndex = currentChoiceIndex;
  }

  public function onHide() {
    Sys.println("OmniMenu: Hide");
  }

  // Update the view
  public function onUpdate(dc) {
    var choices = self.getDisplayChoices();

    var index, txt;

    // Action Name
    txt = txtActionName;
    labelActionName.setText(txt);

    // ITEM TOP
    index = 0;
    txt = choices.get(index);
    labelOptionTop.setText(txt);

    // CENTRAL ITEM
    index = 1;
    txt = choices.get(index);
    labelOptionCenter.setText(txt);

    // ITEM BOTTOM
    index = 2;
    txt = choices.get(index);
    labelOptionBottom.setText(txt);

    // Update current index stored in the controller in this instance
    // So next time the OnShow is called we can restore it (necessary for concatenated OmniMenu displays)
    currentChoiceIndex = ctrl.omniMenuSelectedIndex;

    View.onUpdate(dc);
    // AppHelper.drawScreenGuides(dc);
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
