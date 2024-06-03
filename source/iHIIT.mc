using Toybox.Application as App;
using Toybox.System as Sys;

/**
 * ENTRY POINT
 */
class iHIIT extends App.AppBase {
  protected var controller;

  public function initialize() {
    AppBase.initialize();
    controller = new $.iHIITController();
  }

  // Return the initial view of your application here
  public function getInitialView() {
    return [new selectWorkoutView(), new selectWorkoutDelegate()];

    //TEMPORARY - SKIP workout selection
    //controller.beginCurrentWorkout();
    //return [ new doWorkoutView(), new doWorkoutDelegate() ];

    //TEMPORARY - SKIP workout
    //return [ new finishWorkoutView(), new finishWorkoutDelegate() ];
  }

  public function getController() {
    return controller;
  }

  // Hook called on application start up
  public function onStart(state) {
    Sys.println("App:::START");
  }

  // Hook called on application stop
  public function onStop(state) {
    Sys.println("App:::STOP");
  }
}
