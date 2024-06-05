using Toybox.Application as App;
using Toybox.Lang as Lang;
using Toybox.System as Sys;

module PropertyHelper {
  function getProperty(property_id, default_value) {
    var property_value = App.getApp().getProperty(property_id);

    if (property_value == null || (property_value instanceof Lang.String && property_value.length() == 0)) {
      property_value = default_value;
    }
    //Sys.println("Got property(" + property_id + ") value: " + property_value);

    return property_value;
  }
}
