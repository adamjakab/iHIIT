using Toybox.Application as App;
using Toybox.Lang as Lang;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class selectWorkoutView extends Ui.View
{
	private var app_icon;

	public var select_workout_prompt;

	private var screen_width;
	private var screen_height;
	private var centerX;
	private var centerY;

	private var l1;


    function initialize() {
    	View.initialize();
    	select_workout_prompt = Ui.loadResource(Rez.Strings.select_workout_prompt);


    }

    // Load your resources here
    function onLayout(dc) {
    	screen_width = dc.getWidth();
    	screen_height = dc.getHeight();
    	centerX = screen_width / 2;
        centerY = screen_height / 2;

    	setLayout( Rez.Layouts.LayoutSelectWorkout(dc));

    	l1 = View.findDrawableById("label_1");


    	app_icon = new Ui.Bitmap({
    		:rezId => Rez.Drawables.LauncherIcon,
    		:locX => centerX,
    		:locY => centerY,
    		:width => 40,
    		:height => 40
    	});
    }

    // Update the view
    function onUpdate(dc)
    {
    //** clear screen
		//dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_LT_GRAY);
        //dc.clear();


		var myText = new WatchUi.Text({
            :text=>"Hello World!",
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_LARGE
        });


		Sys.println("L1: " + l1);
        l1.setColor(Gfx.COLOR_ORANGE);
        l1.setText("FIIIICO!");



		View.onUpdate( dc );
    }


    function onUpdateOld(dc)
    {
        var app = App.getApp();
        var workout = app.getController().getCurrentWorkout();
        var txt, x, y;

        //** clear screen
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();

        // App icon
        app_icon.setLocation(centerX - 20, 10);
        app_icon.draw(dc);

        y = centerY - 32;
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, y, Gfx.FONT_TINY, select_workout_prompt, Gfx.TEXT_JUSTIFY_CENTER);

        txt = workout.getTitle();
        y = centerY - 12;
        dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, y, Gfx.FONT_MEDIUM, txt, Gfx.TEXT_JUSTIFY_CENTER);

        txt = "Exercises: " + workout.getExerciseCount();
        y = centerY + 20;
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, y, Gfx.FONT_SMALL, txt, Gfx.TEXT_JUSTIFY_CENTER);


        txt = "WRK: " + workout.getExerciseDuration() + "s - RST: " + workout.getRestDuration() + "s";
        y = centerY + 40;
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, y, Gfx.FONT_SMALL, txt, Gfx.TEXT_JUSTIFY_CENTER);

        txt = "Duration: " + workout.getFormattedWorkoutDuration();
        y = centerY + 60;
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, y, Gfx.FONT_SMALL, txt, Gfx.TEXT_JUSTIFY_CENTER);
    }
}
