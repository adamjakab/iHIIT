using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class discardConfirmationDelegate extends Ui.BehaviorDelegate
{
	
    //Init
    public function initialize() {
        BehaviorDelegate.initialize();
    }
    
    //Key events
    public function onKey( keyEvent )
    {
    	var c = App.getApp().getController();
    	
    	var k = keyEvent.getKey();
    	if(k == Ui.KEY_DOWN) {
    		setNextOption();
    		Sys.println("SEL>: " + c.discardConfirmationSelection);
    	} else if (k == Ui.KEY_UP) {
    		setPreviousOption();
    		Sys.println("SEL<: " + c.discardConfirmationSelection);
    	} else if (k == Ui.KEY_ENTER) {
    		if(c.discardConfirmationSelection == 0)
    		{
    			c.discard_cancelled();
    		} else {
    			c.discard_confirmed();
    		}
    	}
    	Ui.requestUpdate();
    }
    
    private function setNextOption()
    {
    	var c = App.getApp().getController();
    	c.discardConfirmationSelection++;
    	if(c.discardConfirmationSelection > 1)
    	{
    		c.discardConfirmationSelection = 0;
    	}
    }
    
    private function setPreviousOption()
    {
    	var c = App.getApp().getController();
    	c.discardConfirmationSelection--;
    	if(c.discardConfirmationSelection < 0)
    	{
    		c.discardConfirmationSelection = 1;
    	}
    }

	//Menu handling
    public function onMenu() {
        return false;
    }
}
