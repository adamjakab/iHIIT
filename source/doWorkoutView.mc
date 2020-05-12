using Toybox.Application as App;
using Toybox.Lang as Lang;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Timer as Timer;
using Toybox.Graphics as Gfx;

class doWorkoutView extends Ui.View
{
	private var app;
	private var currentWorkout;

	private var currentLayout;

	private var screen_width;
	private var screen_height;
	private var centerX;
	private var centerY;

	// Strings
	private var str_total_time;

	// Layout elements
	private var labelHeartRateValue;
	private var labelExerciseName;
	private var labelTimeRemaining;
	private var labelTimeTotal;


    public function initialize() {
        View.initialize();
        app = App.getApp();
        currentLayout = null;

        // Strings
        str_total_time = Ui.loadResource(Rez.Strings.do_workout_done_total_time);

        Sys.println("DO-WORKOUT-VIEW - INIT");
    }


    // 215x180
    public function onLayout(dc) {
		screen_width = dc.getWidth();
    	screen_height = dc.getHeight();
    	centerX = screen_width / 2;
        centerY = screen_height / 2;
    }

    // Update the view - update is requested (Ui.requestUpdate()) by the workout model
    public function onUpdate(dc)
    {
    	currentWorkout = app.getController().getCurrentWorkout();
    	updateCurrentLayout(dc);
    	View.onUpdate(dc);
    	_drawGuides(dc);
    }

    // Update the view with the current layout
    protected function updateCurrentLayout(dc) {
    	if (currentWorkout.isTerminated())
    	{
    		updateLayoutTerminated(dc);
    	} else if (currentWorkout.isRunning())
    	{
    		var currentExercise = currentWorkout.getCurrentExercise();
    		if(currentExercise.isItRestTime())
    		{
    			updateLayoutResting(dc);
    		} else {
    			updateLayoutWorking(dc);
    		}
    	} else {
    		Sys.println("Invalid workout state: " + currentWorkout.getState());
    	}
    }

    protected function updateLayoutResting(dc)
    {
    	if (self.currentLayout != "RST")
    	{
    		Sys.println("Layout changed to: RST");
    		self.currentLayout = "RST";
	    	setLayout( Rez.Layouts.LayoutDoWorkoutRest(dc));

	    	//Layout elements
	    	labelHeartRateValue = View.findDrawableById("labelHeartRateValue");
	    	labelExerciseName = View.findDrawableById("labelExerciseName");
	    	labelTimeRemaining = View.findDrawableById("labelTimeRemaining");
    	}

        var txt;
        var currentExercise = currentWorkout.getCurrentExercise();

        // HR
        txt = currentWorkout.getCurrentHeartRate().toString();
        labelHeartRateValue.setText(txt);

		// NEXT EXERCISE
		txt = currentExercise.getTitle();
		labelExerciseName.setText(txt);

        // REMAINING TIME
        txt = currentExercise.getRestRemainingSeconds().toString();
        labelTimeRemaining.setText(txt);
    }

    protected function updateLayoutWorking(dc)
    {
    	if (self.currentLayout != "WRK")
    	{
    		Sys.println("Layout changed to: WRK");
	    	self.currentLayout = "WRK";
	    	setLayout( Rez.Layouts.LayoutDoWorkoutWork(dc));


	    	//Layout elements
	    	labelHeartRateValue = View.findDrawableById("labelHeartRateValue");
	    	labelExerciseName = View.findDrawableById("labelExerciseName");
	    	labelTimeRemaining = View.findDrawableById("labelTimeRemaining");
    	}

        var txt;
        var currentExercise = currentWorkout.getCurrentExercise();

		// HR
        txt = currentWorkout.getCurrentHeartRate().toString();
        labelHeartRateValue.setText(txt);

		// NEXT EXERCISE
		txt = currentExercise.getTitle();
		labelExerciseName.setText(txt);

        // REMAINING TIME
        txt = currentExercise.getExerciseRemainingSeconds().toString();
        labelTimeRemaining.setText(txt);
    }


    protected function updateLayoutTerminated(dc)
    {
    	if (self.currentLayout != "TRM")
    	{
    		Sys.println("Layout changed to: TRM");
	    	self.currentLayout = "TRM";
	    	setLayout( Rez.Layouts.LayoutDoWorkoutDone(dc));

	    	//Layout elements
	    	labelTimeTotal = View.findDrawableById("labelTimeTotal");
    	}

        var txt = Lang.format(str_total_time, [currentWorkout.getElapsedSeconds(true)]);
        labelTimeTotal.setText(txt);
    }

    private function _drawGuides(dc)
    {
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
    	//HORIZONTAL line
        dc.drawLine(0, centerY, screen_width, centerY);
        //VERTICAL line
        dc.drawLine(centerX, 0, centerX, screen_height);
    }
}