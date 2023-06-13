using Toybox.Application as App;
using Toybox.Lang as Lang;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class selectWorkoutView extends Ui.View
{
	private var app;

	// Strings
	private var str_exercises, str_work, str_rest, str_duration;

	// Layout elements
	private var labelName;
	private var labelExercises;
	private var labelWrkRst;
	private var labelDuration;


    public function initialize() {
    	View.initialize();
    	app = App.getApp();
    }

    // Set up the layout
    public function onLayout(dc)
    {
        // Strings
        str_exercises = Ui.loadResource(Rez.Strings.sel_exercises);
        str_work = Ui.loadResource(Rez.Strings.sel_work);
        str_rest = Ui.loadResource(Rez.Strings.sel_rest);
        str_duration = Ui.loadResource(Rez.Strings.sel_duration);

		// Layout
    	setLayout( Rez.Layouts.LayoutSelectWorkout(dc));

		// Labels
    	labelName = View.findDrawableById("labelName");
    	labelExercises = View.findDrawableById("labelExercises");
		labelWrkRst = View.findDrawableById("labelWrkRst");
		labelDuration = View.findDrawableById("labelDuration");
    }

    // Update the view
    public function onUpdate(dc)
    {
        var workout = app.getController().getCurrentWorkout();
        var txt;

		txt = workout.getTitle();
        labelName.setText(txt);

		// Exercises: 15
        txt = str_exercises + ": " + workout.getExerciseCount();
		labelExercises.setText(txt);

		// WORK: 40s | REST: 20s
		txt = str_work + ": " + workout.getExerciseDuration() + "s" + " | " + str_rest + ": " + workout.getRestDuration() + "s";
		labelWrkRst.setText(txt);

		// Duration: 2:40
		txt = str_duration + ": " + workout.getFormattedWorkoutDuration();
		labelDuration.setText(txt);

		View.onUpdate(dc);
		//ApeTools.AppHelper.drawScreenGuides(dc);
    }
}
