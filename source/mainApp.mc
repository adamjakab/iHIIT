//using Toybox.System as Sys;
using Toybox.Application as App;

/**
* ENTRY POINT
*/
class mainApp extends App.AppBase
{
	protected var controller;

    public function initialize() {
        AppBase.initialize();
        controller = new $.mainAppController();
    }

    // onStart() is called on application start up
    public function onStart(state)
    {
    }

    // onStop() is called when your application is exiting
    public function onStop(state)
    {
    }

    // Return the initial view of your application here
    public function getInitialView()
    {
        return [new selectWorkoutView(), new selectWorkoutDelegate()];

        //TEMPORARY SHORTCUT
        //controller.beginCurrentWorkout();
        //return [ new doWorkoutView(), new doWorkoutDelegate() ];
    }

    public function getController()
    {
    	return controller;
    }
}
