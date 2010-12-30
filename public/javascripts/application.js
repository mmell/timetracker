// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var current_minutes;
var activity_timer_obj;
var activity_timer_delay = 60000;

function StartTimer(start_minutes)
{
  current_minutes = start_minutes;
  // alert('starting timer with ' + start_minutes);
  $('activity_timer_minutes').innerHTML = current_minutes;
  activity_timer_obj = self.setTimeout("IncrementTimer()", activity_timer_delay);
}

function IncrementTimer()
{
  current_minutes = current_minutes + 1;
  $('activity_timer_minutes').innerHTML = current_minutes.toFixed(0).toString();;
  new Effect.Highlight('activity_timer_minutes', { startcolor: '#ffbbbb', endcolor: '#ffffff' } );
  activity_timer_obj = self.setTimeout("IncrementTimer()", activity_timer_delay);
}
