using Toybox.Application as App;
using Toybox.System as Sys;

/**
 * ENTRY POINT
 */
class iHIIT extends App.AppBase {
  //@todo: Make sure to set this to false when creating a release
  private var debug_mode = false;

  protected var controller;

  public function initialize() {
    AppBase.initialize();
    controller = new $.iHIITController(1);
  }

  // Return the initial view of your application here
  public function getInitialView() {
    return [new SelectWorkoutView(), new SelectWorkoutDelegate()];

    //TEMPORARY - SKIP workout selection
    // controller.beginCurrentWorkout();
    // return [new DoWorkoutView(), new DoWorkoutDelegate()];

    //TEMPORARY - TEST OmniMenu
    //return controller.testOmniMenu();
  }

  // Hook called on application start up
  public function onStart(state) {
    Sys.println("App:::START");
  }

  // Hook called on application stop
  public function onStop(state) {
    Sys.println("App:::STOP");
  }

  public function getController() as $.iHIITController {
    return controller;
  }

  public function isDebugMode() {
    return debug_mode;
  }
}
