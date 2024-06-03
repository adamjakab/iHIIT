using Toybox.Application as App;

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

  // hook called on application start up
  public function onStart(state) {
    return true;
  }

  // hook called when your application is exiting
  public function onStop(state) {
    return true;
  }
}
