using Toybox.Application as App;

/**
* ENTRY POINT
*/
class iHIIT extends App.AppBase
{
	//@todo: Make sure to set this to false when creating a release
	private var debug_mode = true;

	protected var controller;


    public function initialize() {
        AppBase.initialize();
        controller = new $.iHIITController(3);
    }

    // onStart() is called on application start up
    //public function onStart(state){}

    // onStop() is called when your application is exiting
    //public function onStop(state){}

    // Return the initial view of your application here
    public function getInitialView()
    {
        return [new selectWorkoutView(), new selectWorkoutDelegate()];

        //TEMPORARY - SKIP workout selection
        //controller.beginCurrentWorkout();
        //return [ new doWorkoutView(), new doWorkoutDelegate() ];

        //TEMPORARY - SKIP workout
        //return [ new finishWorkoutView(), new finishWorkoutDelegate() ];
    }

    public function getController()
    {
    	return controller;
    }

    public function isDebugMode()
    {
    	return debug_mode;
    }
}
