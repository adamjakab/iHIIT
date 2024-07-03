using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
import Toybox.Lang;

/**
 * ENTRY POINT
 */
class iHIIT extends App.AppBase {
  //@todo: Make sure to set these to false when creating a release
  private var debug_mode as Boolean = false;

  // The controller
  protected var controller as $.iHIITController;

  public function initialize() {
    AppBase.initialize();
    controller = new $.iHIITController(1);
  }

  // Return the initial view of the application
  public function getInitialView() {
    return controller.getInitialApplicationView();
    // return controller.getInitialApplicationTestView();
  }

  // Hook called on application start up
  public function onStart(state) as Void {
    Sys.println("App:::START");
  }

  // Hook called on application stop
  public function onStop(state) as Void {
    Sys.println("App:::STOP");
  }

  public function getController() as $.iHIITController {
    return controller;
  }

  // Debug mode will produce more verbose console output
  public function isDebugMode() as Boolean {
    return debug_mode;
  }
}
