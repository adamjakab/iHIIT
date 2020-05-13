using Toybox.Application as App;
using Toybox.Lang as Lang;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class saveWorkoutView extends Ui.View
{
	private var app;

	// Strings
	private var str_activity_saving, str_activity_saved;

    public function initialize() {
    	View.initialize();
    	app = App.getApp();
    }

    // Set up the layout
    public function onLayout(dc)
    {
        // Strings
        str_activity_saving = Ui.loadResource(Rez.Strings.activity_saving);
    	str_activity_saved = Ui.loadResource(Rez.Strings.activity_saved);
    }

    // Update the view
    function onUpdate(dc) {
    	var workout = app.getController().getCurrentWorkout();
        var txt, color;
        var width = dc.getWidth();
        var height = dc.getHeight();
        var text_height = 34;
        var y = (height - text_height) / 2;

        if (workout.isSaved()) {
        	txt = str_activity_saved;
        	color = Gfx.COLOR_WHITE;
        } else {
        	txt = str_activity_saving;
        	color = Gfx.COLOR_LT_GRAY;
        }

        //** clear screen
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();

        // Text
        dc.setColor(color, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width/2, y, Gfx.FONT_SYSTEM_LARGE, txt, Gfx.TEXT_JUSTIFY_CENTER);
    }
}
