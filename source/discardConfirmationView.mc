using Toybox.Application as App;
using Toybox.Lang as Lang;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class discardConfirmationView extends Ui.View {
	var select_prompt;
	var select_items = [2];
	
    function initialize() {
    	View.initialize();
    	
    	select_prompt = Ui.loadResource(Rez.Strings.discard_workout_confirmation_prompt);
    	
    	select_items = [
    		Ui.loadResource(Rez.Strings.no),
    		Ui.loadResource(Rez.Strings.yes),
    	];
    }
    
     function onShow()
     {
     	//Reset to "no"
     	var c = App.getApp().getController();
    	c.discardConfirmationSelection = 0;
     }

    // Update the view
    function onUpdate(dc)
    {
    	var txt, text_height, x, y;
    	
    	var c = App.getApp().getController();
    	var index = c.discardConfirmationSelection;
    	
    	Sys.println("UPDATE: " + index);
    	
    	var width = dc.getWidth();
        var height = dc.getHeight();
        
        //** clear screen
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        
        // PROMPT
        y = (height/2) - 54;
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);        
        dc.drawText(width/2, y, Gfx.FONT_TINY, select_prompt, Gfx.TEXT_JUSTIFY_CENTER);
        
        //CURRENT MENU ITEM
        txt = select_items[index];
        text_height = 34;
        y = (height - text_height) / 2;
        dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width/2, y, Gfx.FONT_SYSTEM_LARGE, txt, Gfx.TEXT_JUSTIFY_CENTER);
        
  		//CENTRAL LINES
        y = (height - text_height - 10) / 2;
        dc.drawLine(0, y, width, y);
        y = (height + text_height + 10) / 2;
        dc.drawLine(0, y, width, y);
    }
}

