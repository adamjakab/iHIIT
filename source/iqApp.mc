using Toybox.Application as App;

/**
 * ENTRY POINT
**/
class iqApp extends App.AppBase
{
	var controller;
	var model;
	
    function initialize() {
        AppBase.initialize();        
        controller = new $.iqController();
        model = new $.iqModel();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new selectWorkoutView(), new selectWorkoutDelegate() ];
    }
}
